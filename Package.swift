// swift-tools-version: 6.1

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
    .library(name: "ObsidianCore", targets: ["ObsidianCore"]),
    .library(name: "ObsidianFoundation", targets: ["ObsidianFoundation"]),
    .library(name: "ObsidianFlow", targets: ["ObsidianFlow"]),
  ],
  targets: [
    .target(name: "Obsidian", dependencies: [
      .target(name: "ObsidianCore"),
      .target(name: "ObsidianFoundation"),
    ], path: "Sources/Obsidian"),
    .testTarget(name: "ObsidianTests", dependencies: ["Obsidian"], path: "Tests/Obsidian"),

    .target(name: "ObsidianCore", path: "Sources/Core"),
    .testTarget(name: "ObsidianCoreTests", dependencies: ["ObsidianCore"], path: "Tests/Core"),
    
    .target(name: "ObsidianFoundation", dependencies: ["ObsidianCore"], path: "Sources/Foundation"),
    .testTarget(name: "ObsidianFoundationTests", dependencies: ["ObsidianFoundation"], path: "Tests/Foundation"),

    .target(name: "ObsidianFlow", dependencies: ["ObsidianCore", "ObsidianFoundation"], path: "Sources/Flow"),
    .testTarget(name: "ObsidianFlowTests", dependencies: ["Obsidian", "ObsidianFlow"], path: "Tests/Flow"),
  ]
)
