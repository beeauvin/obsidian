// Copyright © 2025 Cassidy Spring (Bee). Obsidian Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "Obsidian",
  platforms: [
    .macOS(.v13),
    .iOS(.v13),
    .tvOS(.v13),
    .visionOS(.v1),
    .watchOS(.v6),
  ],
  products: [
    .library(name: "Obsidian", targets: ["Obsidian"]),
    .library(name: "ObsidianFoundation", targets: ["ObsidianFoundation"]),
    .library(name: "ObsidianFlow", targets: ["ObsidianFlow"]),
  ],
  dependencies: [
    .package(url: "https://github.com/beeauvin/folklore.git", from: "1.0.1")
  ],
  targets: [
    .target(name: "Obsidian", dependencies: [
      .product(name: "Folklore", package: "folklore"),
      .target(name: "ObsidianFoundation"),
      .target(name: "ObsidianFlow"),
    ], path: "Sources/Obsidian"),
    .testTarget(name: "ObsidianTests", dependencies: ["Obsidian"], path: "Tests/Obsidian"),

    .target(name: "ObsidianFoundation", path: "Sources/Foundation"),
    .testTarget(name: "ObsidianFoundationTests", dependencies: ["ObsidianFoundation"], path: "Tests/Foundation"),

    .target(name: "ObsidianFlow", dependencies: [
      .product(name: "Folklore", package: "folklore"),
      .target(name: "ObsidianFoundation")
    ], path: "Sources/Flow"),
    .testTarget(name: "ObsidianFlowTests", dependencies: ["Obsidian", "ObsidianFlow"], path: "Tests/Flow"),
  ]
)
