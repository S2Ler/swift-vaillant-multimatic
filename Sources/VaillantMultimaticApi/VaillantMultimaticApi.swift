import Foundation
import Networker
import Combine
import VaillantMultimaticFoundation
import Preferences

public final class VaillantMultimaticApi {
  public let dispatcher: Networker.Dispatcher
  public let secureStorage: Preferences

  public init(_ dispatcher: Networker.Dispatcher,
              secureStorage: Preferences) {
    self.dispatcher = dispatcher
    self.secureStorage = secureStorage
  }

  public func login(_ params: NewTokenRequestParams) -> AnyPublisher<Void, Error> {
    func authenticate(with authToken: VaillantAuthToken) -> AnyPublisher<Void, Error> {
      self.authenticate(.init(
        username: params.username,
        smartphoneId: params.smartphoneId,
        authToken: authToken
      ))
    }

    if let authToken = try? secureStorage.get(VaillantAuthToken.Key()) {
      return authenticate(with: authToken)
    }
    else {
      return newToken(params)
        .flatMap { (newTokenResponseBody: NewTokenResponseBody) -> AnyPublisher<Void, Error> in
          let authToken = newTokenResponseBody.authToken
          do {
            try self.secureStorage.set(authToken, for: VaillantAuthToken.Key())
          }
          catch {
            self.dispatcher.logger?.error("Coudln't save VaillantAuthToken to secureStorage: \(error)")
          }

          return authenticate(with: authToken)
        }
        .eraseToAnyPublisher()
    }
  }

  public func dispatch<Success: Decodable>(
    _ path: VaillantPath,
    body: RequestBody? = nil,
    httpMethod: HttpMethod,
    successType: Success.Type
  ) -> AnyPublisher<Success, Error> {
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
    return dispatcher.dispatch(request)
  }
}
