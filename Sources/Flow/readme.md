# ObsidianFlow - Reactive Messaging Framework

ObsidianFlow provides a comprehensive foundation for building reactive, event-driven systems. It offers type-safe messaging primitives alongside reactive programming patterns for creating resilient, responsive applications. Flow prioritizes beautiful API design with natural language interfaces, handling complexity internally while presenting simplicity externally.

## Core Features

- **Type-Safe Messaging Primitives**: Full generic type support without any type erasure
- **Actor-Ready Value Types**: Designed specifically for Swift's actor system
- **Natural Language API**: Expressive, readable method names that form cohesive sentences
- **Immutable Message Design**: All operations produce new message instances
- **Comprehensive Metadata**: Rich operational context that travels with messages
- **Tracing & Causality**: Built-in support for tracing message flows and causality chains
- **Memory Safety**: Designed with proper resource lifecycle management
- **Debugging Support**: Debug-specific features to enhance visibility during development
- **Typed Message Handling**: Strongly-typed channels for processing pulses with guaranteed delivery
- **Simple Lifecycle Management**: Automatic resource cleanup through Swift's reference counting
- **Priority-Based Processing**: Task priority inheritance for appropriate message handling
- **Safe Error Handling**: Result-based error handling without throwing functions

## Type-Safe Messaging with Pulses

Flow provides immutable, strongly-typed message primitives called "pulses" that can safely traverse actor boundaries:

```swift
// Create a strongly-typed event message
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

## Fluent Builder Pattern

Flow uses a fluent builder pattern for creating and modifying pulses, providing a natural language interface that maintains immutability:

```swift
// Create an enhanced pulse with rich metadata
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

## Message Tracing & Causality

Built-in support for tracing message flows and establishing causal relationships between messages:

```swift
// Original pulse with debug enabled
let original = Pulse(StartOperation(name: "sync"))
    .debug()                 // Enable debug tracing
    .from(sync_controller)   // Set source for context

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

## Simple Channel System

Flow's Channel system provides a safe, actor-isolated mechanism for delivering strongly-typed pulse messages to registered handlers. Channels are designed for simplicity and performance:

```swift
// Create a channel with a handler function
let auth_channel = Channel { pulse in
    await process_auth_event(pulse.data)
}

// Send pulses through the channel
await auth_channel.send(login_pulse)

// Channels clean up automatically when they go out of scope
```

**Lifecycle Considerations**: Channels maintain strong references to their handlers, making them perfect for long-lived services or components with coupled lifetimes. The handler remains alive as long as the channel exists, so consider this when using temporary or one-off handlers.

## Advanced Stream System

For more complex scenarios requiring explicit lifecycle management and bidirectional awareness, Flow provides Streams:

```swift
// Create a stream with lifecycle handlers
let resource_stream = Stream(
    source_released: { released_pulse in
        // Handle source closing the stream
        await resource_service.disconnect_source()
    },
    anchor_released: { released_pulse in
        // Handle anchor closing the stream
        await resource_service.release_resources()
    },
    handler: { pulse in
        // Process data flowing through the stream
        await resource_service.process(pulse.data)
    }
)

// Send data through the stream
let result = await resource_stream.send(data_pulse)

// Explicitly release when needed
await resource_stream.release()
```

Streams are perfect when you need:
- Notification when connections close
- Explicit lifecycle control
- Error handling for connection state
- Bidirectional awareness between endpoints

## Integration Patterns

### Event-Driven Architecture

Use Flow pulses as the foundation for event-driven systems:

```swift
// Create messages that conform to Pulsable
struct UserLoggedIn: Pulsable {
    let user_id: UUID
    let timestamp: Date
}

// Create and send events
let login_pulse = Pulse(UserLoggedIn(user_id: user.id, timestamp: Date()))
    .priority(.high)
    .tagged("auth", "security")
    .from(auth_service)

await auth_channel.send(login_pulse)
```

### Actor-Based Systems

Flow is designed to work seamlessly with Swift's actor system:

```swift
actor AuthenticationService {
    private let notification_channel: Channel<AuthEvent>
    
    init(notification_channel: Channel<AuthEvent>) {
        self.notification_channel = notification_channel
    }
    
    func authenticate(credentials: Credentials) async -> AuthResult {
        // Process authentication
        let result = // ... authentication logic
        
        // Send a pulse with the result
        let auth_event = AuthenticationCompleted(success: result.success, user_id: result.user_id)
        let pulse = Pulse(auth_event)
            .priority(.high)
            .tagged("auth", "security")
            .from("AuthenticationService")
            
        await notification_channel.send(pulse)
        return result
    }
}
```

## Choosing Between Channels and Streams

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

## Usage

```swift
import ObsidianFlow

// Create a pulse
struct UserAction: Pulsable {
    let action: String
    let timestamp: Date
}

let action_pulse = Pulse(UserAction(action: "login", timestamp: Date()))
    .priority(.high)
    .tagged("user", "auth")

// Create a channel
let action_channel = Channel { pulse in
    await process_user_action(pulse.data)
}

// Send the pulse
await action_channel.send(action_pulse)
```
