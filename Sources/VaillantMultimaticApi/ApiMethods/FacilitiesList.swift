import Foundation
import Combine
import VaillantMultimaticFoundation

public struct FacilitiesListResponseBody: Decodable {
  public let facilitiesList: [Facility]
}

public extension VaillantMultimaticApi {
  func facilitiesList() async throws -> FacilitiesListResponseBody {
    let response = await try dispatch(.facilitiesList,
                                      httpMethod: .get,
                                      successType: VaillantResponse<FacilitiesListResponseBody>.self)
    return response.body
  }
}
