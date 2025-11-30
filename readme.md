# Obsidian

![license](https://img.shields.io/github/license/beeauvin/obsidian)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbeeauvin%2FObsidian%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/beeauvin/obsidian)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbeeauvin%2FObsidian%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/beeauvin/obsidian)

Obsidian is a Swift 6+ library for expressive, actor-safe messaging. It provides a reactive messaging framework (pulses, channels, streams) and a small set of foundation protocols for consistent identity, naming, and description across your domain types.

> Obsidian is now hosted on [Codeberg](https://codeberg.org/beeauvin/obsidian). GitHub is a mirror since the Swift Package Index requires a GitHub repository.

## Getting Started

Add Obsidian to your Swift package dependencies:

```swift
dependencies: [
    .package(url: "https://codeberg.org/beeauvin/obsidian.git", upToNextMinor: "0.3.1")
]
```

```swift
import Obsidian
```

## Foundation Protocols

Obsidian provides protocols that establish consistent interfaces across types for identification, naming, description, and representation.

### Uniquable

Extends `Identifiable` to specifically use `UUID` as the identifier type, ensuring standardized unique identification.

```swift
struct User: Uniquable {
    let id = UUID()
    let name: String
}
```

### Namable

Provides a consistent way to access a human-readable name for types. Includes a default implementation that returns the type name as a string.

```swift
struct Product: Namable {
    // Uses default implementation: returns "Product"
}

struct CustomProduct: Namable {
    let name: String  // Custom implementation: returns this value
}
```

### Describable

Offers a consistent way to get a human-readable description of types for logging, debugging, or user-facing displays.

```swift
struct Message: Describable {
    let sender: String
    let content: String

    var description: String {
        return "\(sender): \(content)"
    }
}
```

### Representable

Combines `Uniquable`, `Namable`, and `Describable` to provide a complete representation for an object. By default, a `Representable` object's description will be its name followed by its UUID.

```swift
struct User: Representable {
    let id = UUID()
    // Uses default implementations for name and description
}
```

## Reactive Messaging

Obsidian provides a comprehensive foundation for building reactive, event-driven systems with type-safe messaging primitives.

### Core Features

- **Type-Safe Messaging Primitives**: Full generic type support without any type erasure
- **Actor-Ready Value Types**: Designed specifically for Swift's actor system
- **Natural Language API**: Expressive, readable method names that form cohesive sentences
- **Immutable Message Design**: All operations produce new message instances
- **Comprehensive Metadata**: Rich operational context that travels with messages
- **Tracing & Causality**: Built-in support for tracing message flows and causality chains
- **Memory Safety**: Designed with proper resource lifecycle management
- **Priority-Based Processing**: Task priority inheritance for appropriate message handling

### Pulses

Pulses are immutable, strongly-typed message primitives that can safely traverse actor boundaries:

```swift
import Obsidian

struct UserLoggedIn: Pulsable {
    let user_id: UUID
    let timestamp: Date
}

let login_event = UserLoggedIn(user_id: user.id, timestamp: Date())
let pulse = Pulse(login_event)
    .priority(.high)
    .tagged("auth", "security")
    .from(auth_service)
```

Each pulse contains:
- A unique identifier
- Creation timestamp
- Strongly-typed payload data
- System metadata

### Fluent Builder Pattern

Obsidian uses a fluent builder pattern for creating and modifying pulses, providing a natural language interface that maintains immutability:

```swift
import Obsidian

let enhanced_pulse = Pulse(login_event)
    .debug()                         // Mark for debugging
    .priority(.high)                 // Set processing priority
    .tagged("auth", "security")      // Add categorization tags
    .from(auth_service)              // Identify the source component

// Create a response that maintains the causal chain
let response_pulse = Pulse.Respond(
    to: enhanced_pulse,
    with: AuthenticationCompleted(success: true)
)
```

### Message Tracing & Causality

Built-in support for tracing message flows and establishing causal relationships between messages:

```swift
import Obsidian

// Original pulse with debug enabled
let original = Pulse(StartOperation(name: "sync"))
    .debug()
    .from(sync_controller)

// First handler creates a response in the chain
let second = Pulse.Respond(
    to: original,
    with: PrepareData(items: 42),
    from: data_service
)

// Second handler continues the chain
let third = Pulse.Respond(
    to: second,
    with: UploadStarted(batch_id: UUID()),
    from: network_service
)

// All pulses share the same trace ID but form a causal chain
// original.meta.trace == second.meta.trace == third.meta.trace
// third.meta.echoes?.id == second.id
// second.meta.echoes?.id == original.id
```

### Channels

Channels provide a safe, actor-isolated mechanism for delivering strongly-typed pulse messages to registered handlers. They're designed for simplicity and performance:

```swift
import Obsidian

// Create a channel with a handler function
let auth_channel = Channel { pulse in
    await process_auth_event(pulse.data)
}

// Send pulses through the channel
await auth_channel.send(login_pulse)

// Channels clean up automatically when they go out of scope
```

**Lifecycle Considerations**: Channels maintain strong references to their handlers, making them perfect for long-lived services or components with coupled lifetimes.

### Streams

For more complex scenarios requiring explicit lifecycle management and bidirectional awareness:

```swift
import Obsidian

let resource_stream = Stream(
    source_released: { released_pulse in
        await resource_service.disconnect_source()
    },
    anchor_released: { released_pulse in
        await resource_service.release_resources()
    },
    handler: { pulse in
        await resource_service.process(pulse.data)
    }
)

// Send data through the stream
let result = await resource_stream.send(data_pulse)

// Explicitly release when needed
await resource_stream.release()
```

### Choosing Between Channels and Streams

**Use Channels when:**
- You need simple, reliable message delivery
- Components have coupled lifetimes
- You want automatic resource management
- Fire-and-forget messaging is sufficient

**Use Streams when:**
- You need explicit lifecycle control
- Components need to know when connections close
- Error handling for connection state is important
- Bidirectional awareness is valuable

## Quick Start

```swift
import Obsidian

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

Obsidian is available under the [Mozilla Public License 2.0](https://mozilla.org/MPL/2.0/).

A copy of the MPLv2 is included in the [license.md](/license.md) file for convenience.
