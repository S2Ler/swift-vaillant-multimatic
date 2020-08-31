import Foundation
import Networker

public struct VaillantFacility: Codable {
  public struct NetworkInfo: Codable {
    public let macAddressEthernet: String
    public let macAddressWifiAccessPoint: String
    public let macAddressWifiClient: String
  }

  public struct SerialNumber: Codable {
    public let rawValue: String

    public init(_ rawValue: String) {
      self.rawValue = rawValue
    }

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      rawValue = try container.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      try container.encode(rawValue)
    }
  }

  public let serialNumber: SerialNumber
  public let name: String
  public let responsibleCountryCode: String
  public let supportedBrand: String
  public let capabilities: [String]
  public let networkInformation: NetworkInfo
  public let firmwareVersion: String
}

extension VaillantFacility.SerialNumber: RawRequestValueConvertible {
  public var rawRequestValue: String { rawValue }
}
