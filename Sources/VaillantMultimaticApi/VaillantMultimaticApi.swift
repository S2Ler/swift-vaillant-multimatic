import Foundation
import Networker
import Combine
import VaillantMultimaticFoundation
import Preferences

public final actor VaillantMultimaticApi {
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
      try await self.authenticate(.init(
        username: params.username,
        smartphoneId: params.smartphoneId,
        authToken: authToken
      ))
    }

    loginParams = params

    if restoreCookies() == .restored {
      return
    }

    if let authToken = try? secureStorage.get(VaillantAuthToken.Key()) {
      try await authenticate(with: authToken)
    }
    else {
      let authToken = try await newToken(params).authToken
      do {
        try self.secureStorage.set(authToken, for: VaillantAuthToken.Key())
      }
      catch {
        self.dispatcher.logger?.error("Coudln't save VaillantAuthToken to secureStorage: \(error)")
      }

      return try await authenticate(with: authToken)
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
      return try await dispatcher.dispatch(request)
    }
    catch {
      if case VaillantError.statusCodeError(let response) = error,
         path != VaillantPath.authenticate,
         path != VaillantPath.newToken,
         response.statusCode == 401, // invalid auth token. Try to login again.
         let loginParams = loginParams {
        eraseCookies() // Eraze invalid cookies and try again.
        try await login(loginParams)
        return try await dispatch(path, body: body, httpMethod: httpMethod, successType: successType)
      }
      else {
        throw error
      }
    }
  }

  private enum RestoreCookiesResult {
    case restored
    case notRestored
  }
  private func restoreCookies() -> RestoreCookiesResult {
    do {
      guard let cookieContainers = try secureStorage.get(cookiesKey) else {
        dispatcher.logger?.info("Cookies are not restored because they were not saved previously.");
        return .notRestored
      }
      cookieContainers
        .map(\.cookie)
        .forEach { HTTPCookieStorage.shared.setCookie($0) }
      return .restored
    }
    catch {
      dispatcher.logger?.error("Couldn't restore cookies: \(error)")
      return .notRestored
    }
  }

  private func eraseCookies() {
    _ = try? secureStorage.set(nil, for: cookiesKey)
  }
}
