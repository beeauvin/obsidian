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
    .testTarget(name: "ObsidianCoreTests", path: "Core/Tests"),
    
    .target(name: "ObsidianFoundation", path: "Foundation/Source"),
    .testTarget(name: "ObsidianFoundationTests", path: "Foundation/Tests"),

    .target(name: "ObsidianTesting", path: "Testing/Source"),
    .testTarget(name: "ObsidianTestingTests", path: "Testing/Tests"),
  ]
)
