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
    .package(url: "https://github.com/S2Ler/Networker.git", .branch("async_await")),
    .package(url: "https://github.com/S2Ler/Preferences.git", .upToNextMajor(from: "0.3.0")),
    .package(url: "https://github.com/apple/swift-argument-parser.git", .branch("async")),
    .package(url: "https://github.com/S2Ler/swift-httpcookie-codable.git", .upToNextMajor(from: "0.0.1")),
  ],
  targets: [
    .target(
      name: "VaillantMultimaticCli",
      dependencies: [
        "VaillantMultimaticApi",
        "VaillantMultimaticFoundation",
        .product(name: "Networker", package: "Networker"),
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ],
      swiftSettings: [
        .unsafeFlags(["-parse-as-library"]),
        .unsafeFlags([
          "-Xfrontend",
          "-enable-experimental-concurrency",
          "-Xfrontend",
          "-disable-availability-checking",
        ])
      ]
    ),
    .target(
      name: "VaillantMultimatic",
      dependencies: [
        "VaillantMultimaticApi",
        "VaillantMultimaticFoundation",
      ],
      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend",
          "-enable-experimental-concurrency",
          "-Xfrontend",
          "-disable-availability-checking",
        ])
      ]
    ),
    .target(
      name: "VaillantMultimaticApi",
      dependencies: [
        "VaillantMultimaticFoundation",
        .product(name: "Networker", package: "Networker"),
        .product(name: "Preferences", package: "Preferences"),
        .product(name: "HttpCookieCodable", package: "swift-httpcookie-codable"),
      ],
      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend",
          "-enable-experimental-concurrency",
          "-Xfrontend",
          "-disable-availability-checking",
        ])
      ]
    ),
    .target(
      name: "VaillantMultimaticFoundation",
      dependencies: [
        .product(name: "Networker", package: "Networker"),
        .product(name: "Preferences", package: "Preferences"),
      ],
      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend",
          "-enable-experimental-concurrency",
          "-Xfrontend",
          "-disable-availability-checking",
        ])
      ]
    ),
    .testTarget(
      name: "VaillantMultimaticApiTests",
      dependencies: [
        "VaillantMultimaticApi",
      ],
      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend",
          "-enable-experimental-concurrency",
          "-Xfrontend",
          "-disable-availability-checking",
        ])
      ]
    )
  ]
)
