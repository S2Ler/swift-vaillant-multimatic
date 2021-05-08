import Foundation
import Combine
import Networker
import VaillantMultimaticFoundation
import Preferences

public struct NewTokenResponseBody: Decodable {
  public let authToken: VaillantAuthToken
}

public struct NewTokenRequestParams: Codable {
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
  func newToken(_ params: NewTokenRequestParams) async throws -> NewTokenResponseBody {
    try await dispatch(.newToken,
                       body: .json(params),
                       httpMethod: .post,
                       successType: VaillantResponse<NewTokenResponseBody>.self).body
  }
}
