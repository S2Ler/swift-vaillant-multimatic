import Foundation
import Combine
import VaillantMultimaticFoundation

public struct FacilitiesListResponseBody: Decodable {
  public let facilitiesList: [VaillantFacility]
}

public extension VaillantMultimaticApi {
  func facilitiesList() -> AnyPublisher<FacilitiesListResponseBody, Error> {
    dispatch(
      .facilitiesList,
      httpMethod: .get,
      successType: VaillantResponse<FacilitiesListResponseBody>.self
    )
    .map(\.body)
    .eraseToAnyPublisher()
  }
}
