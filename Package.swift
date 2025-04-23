// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "Obsidian",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .visionOS(.v1),
    .watchOS(.v6),
  ],
  products: [
    .library(name: "Obsidian", targets: ["Obsidian"]),
  ],
  targets: [
    .target(name: "Obsidian", path: "Sources"),
    .testTarget(name: "ObsidianTests", dependencies: ["Obsidian"], path: "Tests"),
  ]
)
