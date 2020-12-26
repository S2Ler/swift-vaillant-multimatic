import Foundation
import VaillantMultimaticFoundation
import Combine
import Networker

private struct EmptyResponse: Decodable {}

public struct AuthenticateParams: Encodable {
  public let username: String
  public let smartphoneId: String
  public let authToken: VaillantAuthToken

  public init(username: String, smartphoneId: String = "swift-vaillant-multimatic", authToken: VaillantAuthToken) {
    self.username = username
    self.smartphoneId = smartphoneId
    self.authToken = authToken
  }
}

public extension VaillantMultimaticApi {
  func authenticate(_ params: AuthenticateParams) async throws {
    _ = await try dispatch(.authenticate, body: .json(params), httpMethod: .post, successType: EmptyResponse.self)
  }
}
