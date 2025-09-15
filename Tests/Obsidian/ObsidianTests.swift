// Copyright © 2025 Cassidy Spring (Bee). Obsidian Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing
@testable import Obsidian

@Suite("Obsidian/Package")
struct ObsidianPackageTests {
  /// Test presumably only compiles if it's true.
  @Test("Re-exports Core (simple test)")
  func re_exports_core() throws {
    let test: Optional<String> = .none
    #expect(test.otherwise("success") == "success")
  }

  /// Test presumably only compiles if it's true.
  @Test("Re-exports Foundation (simple test)")
  func re_exports_foundation() throws {
    struct TestStruct: Uniquable { let id: UUID = UUID() }
    let test = TestStruct()
    #expect(test.id == test.id)
  }
}
