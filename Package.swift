// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "Obsidian",
  products: [
    .library(name: "Obsidian", targets: ["ObsidianCore", "ObsidianFoundation"]),
    .library(name: "ObsidianCore", targets: ["ObsidianCore"]),
    .library(name: "ObsidianFoundation", targets: ["ObsidianFoundation"]),
  ],
  targets: [
    .target(name: "ObsidianCore", path: "Core/Source"),
    .testTarget(
      name: "ObsidianCoreTests",
      dependencies: ["ObsidianCore"],
      path: "Core/Tests"
    ),
    
    .target(name: "ObsidianFoundation", path: "Foundation/Source"),
    .testTarget(
      name: "ObsidianFoundationTests",
      dependencies: ["ObsidianFoundation"],
      path: "Foundation/Tests"
    ),
  ]
)
