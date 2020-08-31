import Foundation
import Combine
import Networker
import VaillantMultimaticFoundation

public struct NewTokenResponseBody: Decodable {
  public let authToken: VaillantAuthToken
}

public struct NewTokenRequestParams: Encodable {
  public let username: String
  public let password: String
  public let smartphoneId: String

  public init(username: String, password: String, smartphoneId: String = "swift-vaillant-multimatic") {
    self.username = username
    self.password = password
    self.smartphoneId = smartphoneId
  }
}

public extension VaillantMultimaticApi {
  func newToken(_ params: NewTokenRequestParams) -> AnyPublisher<NewTokenResponseBody, Error> {
    return dispatch(
      .newToken,
      body: .json(params),
      httpMethod: .post,
      successType: VaillantResponse<NewTokenResponseBody>.self
    )
    .map(\.body)
    .eraseToAnyPublisher()
  }
}
