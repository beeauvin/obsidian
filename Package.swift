// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "Obsidian",
  products: [
    .library(name: "Obsidian", targets: ["ObsidianCore", "ObsidianFoundation"]),
    .library(name: "ObsidianCore", targets: ["ObsidianCore"]),
    .library(name: "ObsidianFoundation", targets: ["ObsidianFoundation"]),
    .library(name: "ObsidianTesting", targets: ["ObsidianTesting"]),
  ],
  targets: [
    .target(name: "ObsidianCore", path: "Core/Source"),
    .testTarget(
      name: "ObsidianCoreTests",
      dependencies: ["ObsidianCore", "ObsidianTesting"],
      path: "Core/Tests"
    ),
    
    .target(name: "ObsidianFoundation", path: "Foundation/Source"),
    .testTarget(
      name: "ObsidianFoundationTests",
      dependencies: ["ObsidianFoundation", "ObsidianTesting"],
      path: "Foundation/Tests"
    ),

    .target(name: "ObsidianTesting", path: "Testing/Source"),
    .testTarget(
      name: "ObsidianTestingTests",
      dependencies: ["ObsidianTesting"],
      path: "Testing/Tests"
    ),
  ]
)
