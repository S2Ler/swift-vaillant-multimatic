import Foundation
import VaillantMultimaticApi
import VaillantMultimaticFoundation
import Networker
import Logging
import Preferences
import ArgumentParser
import Combine
import SE0282_Experimental

var logger = Logger(label: "vaillant-api")
logger.logLevel = .debug

struct MainCommand: ParsableCommand {
  private enum CodingKeys: String, CodingKey {
    case username
    case password
  }
  @Argument var username: String
  @Argument var password: String

  private var cancelTokens: [AnyCancellable] = []

  mutating func run() throws {
    let dispatcher = URLSessionDispatcher(
      jsonBodyEncoder: JSONEncoder(),
      plugins: [],
      logger: logger
    )
    let api = VaillantMultimaticApi(
      dispatcher,
      secureStorage: UserDefaults()
    )

    let finished = ManagedAtomic<Bool>(false)

    api
      .login(.init(username: username, password: password))
      .flatMap {
        api.facilitiesList()
      }
      .map { $0.facilitiesList[0].serialNumber }
      .flatMap { api.facilitySystemControl($0) }
      .map(\.status.outsideTemperature)
      .sink { completion in
        finished.store(true, ordering: .relaxed)
      } receiveValue: { (outsideTemperature) in
        print("Outside temperature: \(outsideTemperature)")
      }
      .store(in: &cancelTokens)

    while !finished.load(ordering: .relaxed) {
      RunLoop.current.run(mode: .common, before: Date().addingTimeInterval(2))
    }
  }
}

MainCommand.main()

