import Foundation

public enum VaillantError: Swift.Error {
  case statusCodeError(HTTPURLResponse)
  case transportError(Swift.Error)
  case decodingError(Swift.Error)
}
