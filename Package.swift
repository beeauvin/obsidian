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
    .library(name: "Obsidian", targets: ["Obsidian"])
  ],
  dependencies: [
    .package(url: "https://codeberg.org/beeauvin/folklore.git", from: "1.0.2")
  ],
  targets: [
    .target(
      name: "Obsidian",
      dependencies: [
        .product(name: "Folklore", package: "folklore")
      ],
      path: "Source"
    ),
    .testTarget(
      name: "ObsidianTests",
      dependencies: ["Obsidian"],
      path: "Tests"
    ),
  ]
)
