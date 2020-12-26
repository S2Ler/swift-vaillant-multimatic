import Foundation
import VaillantMultimaticApi
import VaillantMultimaticFoundation
import Networker
import Logging
import Preferences
import ArgumentParser

var logger = Logger(label: "vaillant-api")
logger.logLevel = .debug

struct MainCommand: ParsableCommand {
  @Argument var username: String
  @Argument var password: String

  mutating func run() throws {

    let dispatcher = URLSessionDispatcher(jsonBodyEncoder: JSONEncoder(),
                                          plugins: [],
                                          logger: logger)
    let api = VaillantMultimaticApi(dispatcher, secureStorage: UserDefaults())
    let username = self.username
    let password = self.password

    runAsyncAndBlock {
      do {
        await try api.login(.init(username: username, password: password))
        let facilitiesListResponse = await try api.facilitiesList()
        let serialNumber = facilitiesListResponse.facilitiesList[0].serialNumber
        let systemControl = await try api.facilitySystemControl(serialNumber)
        print(systemControl.zones)
        print(systemControl.status.outsideTemperature)
      }
      catch {
        print("An eror happened: \(error)")
      }
    }
  }
}

MainCommand.main()

