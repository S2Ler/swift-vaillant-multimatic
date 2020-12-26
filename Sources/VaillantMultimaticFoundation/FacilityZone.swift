import Foundation

public struct FacilityZone: Codable {
  public struct ID: Hashable, Codable {
    public let rawValue: String
    public init(_ rawValue: String) {
      self.rawValue = rawValue
    }

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      self.rawValue = try container.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      try container.encode(rawValue)
    }
  }
  public enum Function: String, Codable {
    case standby = "STANDBY"
    case cooling = "COOLING"
    case heating = "HEATING"
  }

  public struct Configuration: Codable {
    public let name: String
    public let isEnabled: Bool
    public let activeFunction: Function

    private enum CodingKeys: String, CodingKey {
      case name
      case isEnabled = "enabled"
      case activeFunction = "active_function"
    }
  }

  public struct Heating: Codable {
    public struct Configuration: Codable {
      public let mode: OperatingMode
      public let setbackTemperature: Double
      public let setpointTemperature: Double

      private enum CodingKeys: String, CodingKey {
        case mode
        case setbackTemperature = "setback_temperature"
        case setpointTemperature = "setpoint_temperature"
      }
    }

    public struct TimeProgram: Codable {

    }

    public let configuration: Configuration
    public let timeprogram: TimeProgram?
  }

  public let id: ID
  public let heating: Heating
  public let configuration: Configuration

  private enum CodingKeys: String, CodingKey {
    case id = "_id"
    case heating
    case configuration
  }
}


