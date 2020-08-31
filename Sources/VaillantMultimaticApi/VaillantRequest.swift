import Foundation
import Networker

public typealias VaillantRequest<Success: Decodable> = Request<Success, VaillantResponseDecoder>
