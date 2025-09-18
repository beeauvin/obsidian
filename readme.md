# 🔮 Obsidian

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbeeauvin%2FObsidian%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/beeauvin/obsidian)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbeeauvin%2FObsidian%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/beeauvin/obsidian)
[![tests](https://github.com/beeauvin/obsidian/actions/workflows/tests.yml/badge.svg)](https://github.com/beeauvin/obsidian/actions/workflows/tests.yml)
[![codecov](https://codecov.io/gh/beeauvin/obsidian/graph/badge.svg?token=lh06ObzlsO)](https://codecov.io/gh/beeauvin/obsidian)

🔮 Obsidian is a comprehensive Swift 6+ utility library designed around the principle that code should be both
functional and beautiful. It provides natural language interfaces for Swift's foundation types alongside
a complete reactive messaging framework. From elegant Optional and Result extensions to thread-safe
event-driven systems, Obsidian transforms how you write Swift code - making it read like prose while
delivering powerful, type-safe functionality.

## Modules

Obsidian is organized into focused modules, each addressing specific aspects of Swift development:

### [**ObsidianCore**](Sources/Core/readme.md)
Natural language extensions for Optional and Result types with seamless conversion between them. Transform how you work with Swift's fundamental types using expressive, readable methods like `otherwise`, `transform`, `when`, and `transmute`.

### [**ObsidianFoundation**](Sources/Foundation/readme.md)
Protocols for consistent interfaces across types: `Uniquable` for UUID-based identification, `Namable` for consistent naming, `Describable` for textual descriptions, and `Representable` for combined representation.

### [**ObsidianFlow**](Sources/Flow/readme.md)
A comprehensive reactive messaging framework providing type-safe messaging primitives with Pulses, Channels, and Streams. Built for Swift's actor system with natural language APIs and immutable message design.

### **Obsidian** (Umbrella Module)
The main module that imports and exposes Core, Foundation, and Flow modules. Import `Obsidian` to access all Obsidian features: utilities, protocols, and reactive messaging.

## Getting Started

### Installation

Add Obsidian to your Swift package dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/beeauvin/obsidian.git", upToNextMinor: "0.3.0")
]
```

### Basic Usage

Import Obsidian to access all features:

```swift
import Obsidian  // Imports Foundation utilities and Flow framework
```

For Flow-specific functionality, you can also import individual modules:

```swift
import ObsidianFlow  // Just the reactive messaging framework
import ObsidianCore  // Just the utility extensions
```

## Quick Start

```swift
import Obsidian

// Use natural language Optional extensions
let username: String? = get_username()
let display_name = username.otherwise("Guest")

// Chain Result operations for robust error handling
let user_data = await Result<Data, Error>.Catching {
    try await api.fetch_user_data()
}.transform { data in
    try JSONDecoder().decode(User.self, from: data)
}.otherwise { DefaultUser() }

// Create reactive message flows
struct UserAction: Pulsable {
    let action: String
    let timestamp: Date
}

let action_channel = Channel { pulse in
    await process_user_action(pulse.data)
}

let action_pulse = Pulse(UserAction(action: "login", timestamp: Date()))
    .priority(.high)
    .tagged("user", "auth")

await action_channel.send(action_pulse)
```

For comprehensive examples and real-world usage patterns, see [examples.md](examples.md).

## Documentation

- **[Design Philosophy](design-philosophy.md)** - Core principles and intentional design decisions
- **[Examples](examples.md)** - Comprehensive real-world usage examples
- **[Contributing](contributing.md)** - Guidelines for contributing to the project

## Contributing

Contributions are welcome! Please read our [design philosophy](design-philosophy.md) to understand Obsidian's core principles and intentional design decisions. The key consideration for contributions is alignment with these principles while enhancing the developer experience.

See the [contributing guide](contributing.md) for detailed guidelines.

## License

🔮 Obsidian is available under the [Mozilla Public License 2.0](https://mozilla.org/MPL/2.0/).

A copy of the MPLv2 is included in the [license.md](/license.md) file for convenience.
