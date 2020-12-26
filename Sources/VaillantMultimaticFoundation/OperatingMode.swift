import Foundation

public enum OperatingMode: String, Codable {
  case auto = "AUTO"
  case day = "DAY"
  case night = "NIGHT"
  case on = "ON"
  case off = "OFF"
  case manual = "MANUAL"
  case quickVeto = "QUICK_VETO"
}
