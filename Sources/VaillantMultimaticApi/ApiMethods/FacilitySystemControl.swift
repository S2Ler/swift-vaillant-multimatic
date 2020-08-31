import Foundation
import VaillantMultimaticFoundation
import Combine

public struct FacilitySystemControlResponseBody: Decodable {
  public let status: VaillantFacilityStatus
}

public extension VaillantMultimaticApi {
  func facilitySystemControl(
    _ facilitySerialNumber: VaillantFacility.SerialNumber
  ) -> AnyPublisher<FacilitySystemControlResponseBody, Error> {
    dispatch(
      .facilities(serialNumber: facilitySerialNumber),
      httpMethod: .get,
      successType: VaillantResponse<FacilitySystemControlResponseBody>.self
    )
    .map(\.body)
    .eraseToAnyPublisher()
  }
}
