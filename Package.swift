// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "swift-vaillant-multimatic",
  platforms: [
      .macOS(.v11),
      .iOS(.v14),
      .tvOS(.v14),
  ],
  products: [
    .executable(
      name: "VaillantMultimaticCli",
      targets: ["VaillantMultimaticCli"]
    ),
    .library(
      name: "VaillantMultimatic",
      targets: ["VaillantMultimatic"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/S2Ler/Networker.git", .branch("master")),
    .package(url: "https://github.com/S2Ler/Preferences.git", .upToNextMinor(from: "0.3.0")),
    .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "0.3.0")),
    .package(url: "https://github.com/apple/swift-se-0282-experimental.git", .branch("master")),
  ],
  targets: [
    .target(
      name: "VaillantMultimaticCli",
      dependencies: [
        "VaillantMultimaticApi",
        "VaillantMultimaticFoundation",
        .product(name: "Networker", package: "Networker"),
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "SE0282_Experimental", package: "swift-se-0282-experimental")
      ]
    ),
    .target(
      name: "VaillantMultimatic",
      dependencies: [
        "VaillantMultimaticApi",
        "VaillantMultimaticFoundation",
      ]
    ),
    .target(
      name: "VaillantMultimaticApi",
      dependencies: [
        "VaillantMultimaticFoundation",
        .product(name: "Networker", package: "Networker"),
        .product(name: "Preferences", package: "Preferences"),
      ]
    ),
    .target(
      name: "VaillantMultimaticFoundation",
      dependencies: [
        .product(name: "Networker", package: "Networker"),
        .product(name: "Preferences", package: "Preferences"),
      ]
    ),
    .testTarget(
      name: "VaillantMultimaticApiTests",
      dependencies: [
        "VaillantMultimaticApi",
      ]
    )
  ]
)
