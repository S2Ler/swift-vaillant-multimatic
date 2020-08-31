import Foundation
import XCTest
@testable import VaillantMultimaticApi
@testable import Networker
import VaillantMultimaticFoundation

class VaillantUrlTests: XCTestCase {
  func testUrl() {
    assertUrl(.baseAuthenticate,
              "/account/authentication/v1")
    assertUrl(.facilities(serialNumber: VaillantFacility.SerialNumber("1234")),
              "/facilities/1234")
  }

  private func assertUrl(_ vaillantUrl: VaillantPath, _ expectedAbsoluteString: String) {
    XCTAssertEqual(vaillantUrl.requestPath.raw, expectedAbsoluteString)

  }
}
