import Foundation

public struct VaillantFacilityStatus: Codable {
  public let datetime: String
  public let outsideTemperature: Double

  private enum CodingKeys: String, CodingKey {
    case datetime
    case outsideTemperature = "outside_temperature"
  }
}
