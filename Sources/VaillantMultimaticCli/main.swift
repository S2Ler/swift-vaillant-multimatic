import Foundation
import VaillantMultimaticApi
import VaillantMultimaticFoundation
import Networker
import Logging
import Preferences
import ArgumentParser

@main
struct MainCommand: ParsableCommand {
  @Argument var username: String
  @Argument var password: String

  mutating func run() async throws {
    var logger = Logger(label: "vaillant-api")
    logger.logLevel = .debug

    let dispatcher = URLSessionDispatcher(jsonBodyEncoder: JSONEncoder(),
                                          plugins: [],
                                          logger: logger)
    let api = VaillantMultimaticApi(dispatcher, secureStorage: UserDefaults())
    let username = self.username
    let password = self.password

    do {
      try await api.login(.init(username: username, password: password))
      let facilitiesListResponse = try await api.facilitiesList()
      let serialNumber = facilitiesListResponse.facilitiesList[0].serialNumber
      let systemControl = try await api.facilitySystemControl(serialNumber)
      print(systemControl.zones)
      print(systemControl.status.outsideTemperature)
    }
    catch {
      print("An eror happened: \(error)")
    }
  }
}
