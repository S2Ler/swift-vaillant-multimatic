import Foundation
import Networker
import VaillantMultimaticFoundation

public extension URL {
  static let vaillantBase: URL = URL(string: "https://smart.vaillant.com/mobile/api/v4")!
}

public enum VaillantPath {
  case baseAuthenticate
  case authenticate
  case newToken
  case facilitiesList
  case facilities(serialNumber: VaillantFacility.SerialNumber)

  public var requestPath: RequestPath {
    func combine(_ vaillantPath: VaillantPath, _ requestPath: RequestPath) -> RequestPath {
      try! vaillantPath.requestPath.appendingPathComponent(requestPath)
    }

    switch self {
    case .baseAuthenticate:
      return "/account/authentication/v1"
    case .authenticate:
      return combine(.baseAuthenticate, "/authenticate")
    case .newToken:
      return combine(.baseAuthenticate, "/token/new")
    case .facilitiesList:
      return "/facilities"
    case .facilities(let serialNumber):
      return combine(.facilitiesList, RequestPath(pattern: "/{serialNumber}/systemcontrol/v1",
                                                  parameters: ["serialNumber": serialNumber]))
    }
  }
}

public extension RequestPath {
  static func vaillant(_ vaillantPath: VaillantPath) -> RequestPath {
    vaillantPath.requestPath
  }
}
