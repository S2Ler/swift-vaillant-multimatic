import Foundation
import Networker

public struct VaillantResponseDecoder: ResponseDecoder {
  public typealias ErrorType = VaillantError
  
  public static func decode<T>(
    _ type: T.Type,
    data: Data?,
    response: URLResponse?,
    error: Error?
  ) -> Result<T, ErrorType>
  where T : Decodable
  {
    do {
      if let httpResponse = response as? HTTPURLResponse,
         (httpResponse.statusCode < 200 || httpResponse.statusCode > 299) {
        return .failure(.statusCodeError(httpResponse))
      }
      
      let decoder = VaillantJsonDecoder()
      guard var data = data else {
        return .failure(.transportError(URLError.init(.networkConnectionLost)))
      }
      if data.count == 0 {
        data = Data("{}".utf8)
      }
      let decodedValue = try decoder.decode(T.self, from: data)
      
      return .success(decodedValue)
    }
    catch let error {
      return .failure(.decodingError(error))
    }
  }
}
