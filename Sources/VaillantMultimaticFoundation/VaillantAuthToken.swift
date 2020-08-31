import Foundation
import Preferences

public struct VaillantAuthToken: Codable {
  public struct Key: PreferenceKey {
    public typealias PreferenceValueType = VaillantAuthToken
    public var rawKey: String { "swift-vaillant-multimatic.auth-token" }
    
    public init() {}
  }

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
