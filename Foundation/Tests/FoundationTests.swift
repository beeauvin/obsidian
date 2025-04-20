// Copyright © 2025 Cassidy Spring (Bee). Obsidian Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import ObsidianTesting
@testable import ObsidianFoundation

@Suite("ObsidianFoundation")
struct ObsidianFoundationTests {
  /// Test presumably only compiles if it's true.
  @Test("Re-exports Foundation (simple test)")
  func re_exports_foundation() throws {
    let uuid = UUID()
    #expect(uuid == uuid)
  }
}
