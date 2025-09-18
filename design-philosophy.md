# Obsidian Design Philosophy

Obsidian emerged from a belief that code can be more than functional - it can be beautiful. The way we interact with our code shapes our thinking, and expressive interfaces allow intent to flow naturally from thought to implementation.

## Core Principles

### Natural Language Over Symbols

Obsidian replaces cryptic symbolic operations with expressive, readable methods that reveal intent. By using methods like `otherwise` instead of `??`, the code becomes more approachable and self-documenting.

**Example:**
```swift
// Traditional approach
let display_name = username ?? "Guest"

// Obsidian approach
let display_name = username.otherwise("Guest")
```

The natural language approach makes code more accessible and eliminates the need to remember symbolic meanings.

### Accessibility-Driven Design

The library's use of snake_case and language-oriented interfaces aims to reduce cognitive load, making code more accessible for developers with diverse processing styles. This approach creates an environment where intention flows effortlessly from thought to implementation.

This design choice recognizes that:
- Not everyone processes symbolic operators the same way
- Natural language interfaces reduce cognitive overhead
- Readable code is maintainable code
- Accessibility benefits all developers, not just those with specific needs

### Expression Over Convention

When established patterns conflict with readability or ergonomics, Obsidian prioritizes the developer experience. This isn't about rejecting convention for its own sake, but about thoughtfully choosing approaches that enhance clarity and reduce friction.

**Key considerations:**
- Developer experience takes precedence over arbitrary conventions
- Readability is valued over brevity when they conflict
- Consistency within the library is more important than conforming to external patterns
- Changes are made deliberately, with clear reasoning

### Technical Approach

Obsidian maintains strong type safety throughout, avoiding type erasure entirely. Built for Swift's actor system and structured concurrency model, its APIs are designed for multi-threaded environments with proper isolation patterns.

**Technical commitments:**
- Full generic type support without type erasure
- Actor-ready value types designed for Swift's concurrency model
- Immutable message design for thread safety
- Result-based error handling without throwing functions
- Comprehensive metadata and tracing support

## Philosophy in Practice

### Natural Language API Design

Every method name is chosen to read like natural language when chained together:

```swift
user_id
    .transform { id in await fetch_profile(for: id) }
    .optionally { await fetch_cached_profile() }
    .otherwise { DefaultProfile() }
```

This creates code that tells a story about what it's doing, making it self-documenting.

### Immutability and Safety

All operations produce new instances rather than mutating existing ones. This ensures thread safety and predictable behavior in concurrent environments:

```swift
let enhanced_pulse = original_pulse
    .priority(.high)
    .tagged("important")
    .from(service)
// original_pulse remains unchanged
```

### Progressive Enhancement

Obsidian provides simple interfaces that can be progressively enhanced with more sophisticated features:

```swift
// Simple usage
let result = optional_value.otherwise("default")

// Enhanced with lazy evaluation
let result = optional_value.otherwise {
    perform_expensive_computation()
}

// Enhanced with async support
let result = await optional_value.otherwise {
    await perform_async_operation()
}
```

## Intentional Departures from Convention

Obsidian intentionally breaks from some Swift community conventions, but these departures aren't arbitrary. Each divergence serves a specific purpose:

### snake_case Instead of camelCase

**Reasoning:** 
- Reduces cognitive load for developers with processing differences
- Aligns with natural language reading patterns
- Consistent with the natural language philosophy

### Natural Language Methods Over Operators

**Reasoning:**
- Makes code more accessible to newcomers
- Eliminates need to memorize symbolic meanings
- Creates self-documenting code
- Reduces cognitive overhead in complex expressions

### Explicit Lifecycle Management Options

**Reasoning:**
- Provides choice between automatic and manual resource management
- Supports different architectural patterns
- Enables fine-grained control when needed
- Maintains simplicity for common cases

## Contributing to the Philosophy

When contributing to Obsidian, consider:

1. **Does this enhance readability?** Changes should make code more expressive and easier to understand.

2. **Does this reduce cognitive load?** Prefer solutions that are immediately comprehensible over clever ones.

3. **Does this maintain type safety?** Obsidian never sacrifices type safety for convenience.

4. **Does this support diverse thinking styles?** Consider how the change affects developers with different processing patterns.

5. **Is this change intentional?** Departures from convention should have clear, articulated reasons.

The goal is not to be different for the sake of being different, but to create interfaces that genuinely improve the developer experience while maintaining technical excellence.
