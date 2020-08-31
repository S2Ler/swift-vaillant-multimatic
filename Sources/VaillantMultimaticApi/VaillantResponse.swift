import Foundation

public struct VaillantResponse<Body: Decodable>: Decodable {
  public let body: Body
}
