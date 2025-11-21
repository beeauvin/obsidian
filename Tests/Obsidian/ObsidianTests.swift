// Copyright © 2025 Cassidy Spring (Bee). Obsidian Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing
@testable import Obsidian

@Suite("Obsidian/Package")
struct ObsidianPackageTests {
  /// Test presumably only compiles if it's true.
  @Test("Re-exports Foundation (simple test)")
  func re_exports_foundation() throws {
    struct TestStruct: Uniquable { let id: UUID = UUID() }
    let test = TestStruct()
    #expect(test.id == test.id)
  }

  /// Test presumably only compiles if it's true.
  @Test("Re-exports Flow (simple test)")
  func re_exports_flow() throws {
    struct TestPulse: Pulsable { var id: UUID = UUID() }
    let pulse = Pulse(TestPulse())
    #expect(pulse.id == pulse.id)
  }
}
