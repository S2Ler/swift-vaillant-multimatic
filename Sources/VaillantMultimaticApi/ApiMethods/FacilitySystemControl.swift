import Foundation
import VaillantMultimaticFoundation
import Combine

public struct FacilitySystemControlResponseBody: Decodable {
  public let status: FacilityStatus
  public let zones: [FacilityZone]
}

public extension VaillantMultimaticApi {
  func facilitySystemControl(
    _ facilitySerialNumber: Facility.SerialNumber
  ) async throws -> FacilitySystemControlResponseBody {
    let response = try await dispatch(.facilities(serialNumber: facilitySerialNumber),
                                      httpMethod: .get,
                                      successType: VaillantResponse<FacilitySystemControlResponseBody>.self)
    return response.body
  }
}
