import Foundation
import Networker
import VaillantMultimaticApi

public final class VaillantMultimatic {
  private let api: VaillantMultimaticApi
  
  public init(api: VaillantMultimaticApi) {
    self.api = api
  }
}
