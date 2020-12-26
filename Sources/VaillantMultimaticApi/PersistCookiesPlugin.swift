import Foundation
import Networker
import Preferences
import HttpCookieCodable

struct PersistCookiesPlugin: DispatcherPlugin {
  struct CookiesKey: PreferenceKey {
    typealias PreferenceValueType = [CodableHttpCookieContainer]
    var rawKey: String { "swift-vaillant-multimatic.cookies"}
  }

  private let storage: Preferences
  private let onError: ((Error) -> Void)?
  let saveKey: CookiesKey = .init()

  init(storage: Preferences,
       onError: ((Error) -> Void)? = nil) {
    self.storage = storage
    self.onError = onError
  }

  func didSendRequest<Success, ErrorType>(_ urlRequest: URLRequest, result: Result<Success, ErrorType>)
  where Success: Decodable,
        ErrorType: Swift.Error {
    do {
      guard let cookies = HTTPCookieStorage.shared.cookies else {
        try storage.set(nil, for: CookiesKey()); return
      }

      let codableCookies = cookies.map(CodableHttpCookieContainer.init(_:))
      try storage.set(codableCookies, for: CookiesKey())
    }
    catch {
      onError?(error)
    }
  }
}
