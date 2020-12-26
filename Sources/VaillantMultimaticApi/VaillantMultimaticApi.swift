import Foundation
import Networker
import Combine
import VaillantMultimaticFoundation
import Preferences

public final actor class VaillantMultimaticApi {
  private let cookiesKey: PersistCookiesPlugin.CookiesKey

  public let dispatcher: Networker.Dispatcher
  public let secureStorage: Preferences
  private var loginParams: NewTokenRequestParams?

  public init(_ dispatcher: Networker.Dispatcher,
              secureStorage: Preferences) {
    let cookiesPlugin = PersistCookiesPlugin(storage: secureStorage,
                                             onError: { [logger = dispatcher.logger] (error) in
                                               logger?.error("Unable to save cookies: \(error)")
                                             })
    dispatcher.add(cookiesPlugin)
    self.dispatcher = dispatcher
    self.secureStorage = secureStorage
    self.cookiesKey = cookiesPlugin.saveKey
  }

  public func login(_ params: NewTokenRequestParams) async throws {
    func authenticate(with authToken: VaillantAuthToken) async throws {
      await try self.authenticate(.init(
        username: params.username,
        smartphoneId: params.smartphoneId,
        authToken: authToken
      ))
    }

    loginParams = params

    if restoreCookies() {
      return
    }

    if let authToken = try? secureStorage.get(VaillantAuthToken.Key()) {
      await try authenticate(with: authToken)
    }
    else {
      let authToken = await try newToken(params).authToken
      do {
        try self.secureStorage.set(authToken, for: VaillantAuthToken.Key())
      }
      catch {
        self.dispatcher.logger?.error("Coudln't save VaillantAuthToken to secureStorage: \(error)")
      }

      return await try authenticate(with: authToken)
    }
  }

  public func dispatch<Success: Decodable>(_ path: VaillantPath,
                                           body: RequestBody? = nil,
                                           httpMethod: HttpMethod,
                                           successType: Success.Type) async throws -> Success {
    let request = VaillantRequest<Success>(
      baseUrl: .vaillantBase,
      path: path.requestPath,
      urlParams: nil,
      httpMethod: httpMethod,
      body: body,
      headers: ["content-type": "application/json"],
      timeout: 10,
      cachePolicy: .useProtocolCachePolicy
    )
    do {
      return await try dispatcher.dispatch(request)
    }
    catch {
      if case VaillantError.statusCodeError(let response) = error,
         path != VaillantPath.authenticate,
         path != VaillantPath.newToken,
         response.statusCode == 401, // invalid auth token. Try to login again.
         let loginParams = loginParams {
        eraseCookies() // Eraze invalid cookies and try again.
        await try login(loginParams)
        return await try dispatch(path, body: body, httpMethod: httpMethod, successType: successType)
      }
      else {
        throw error
      }
    }
  }

  private func restoreCookies() -> Bool {
    do {
      guard let cookieContainers = try secureStorage.get(cookiesKey) else {
        dispatcher.logger?.info("Cookies are not restored because they were not saved previously.");
        return false
      }
      cookieContainers
        .map(\.cookie)
        .forEach { HTTPCookieStorage.shared.setCookie($0) }
      return true
    }
    catch {
      dispatcher.logger?.error("Couldn't restore cookies: \(error)")
      return false
    }
  }

  private func eraseCookies() {
    _ = try? secureStorage.set(nil, for: cookiesKey)
  }
}
