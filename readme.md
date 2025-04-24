# 🔮 Obsidian

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbeeauvin%2FObsidian%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/beeauvin/Obsidian)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbeeauvin%2FObsidian%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/beeauvin/Obsidian)
[![tests](https://github.com/beeauvin/Obsidian/actions/workflows/tests.yml/badge.svg)](https://github.com/beeauvin/Obsidian/actions/workflows/tests.yml)
[![codecov](https://codecov.io/gh/beeauvin/Obsidian/graph/badge.svg?token=lh06ObzlsO)](https://codecov.io/gh/beeauvin/Obsidian)

🔮 Obsidian is a Swift 6+ utility library designed around the principle that code should be both
functional and beautiful. It transforms Swift's foundation types through natural language interfaces
that replace cryptic symbols with expressive methods, creating code that reads like prose rather
than technical commands.

## Core Essence & Design Philosophy

Obsidian emerged from a belief that code can be more than functional - it can be beautiful. The way
we interact with our code shapes our thinking, and expressive interfaces allow intent to flow
naturally from thought to implementation.

### Natural Language Over Symbols

Obsidian replaces cryptic symbolic operations with expressive, readable methods that reveal intent.
By using methods like `otherwise` instead of `??`, the code becomes more approachable and
self-documenting.

### Accessibility-Driven Design

The library's use of snake_case and language-oriented interfaces aims to reduce cognitive load,
making code more accessible for developers with diverse processing styles. This approach creates an
environment where intention flows effortlessly from thought to implementation.

### Expression Over Convention

When established patterns conflict with readability or ergonomics, Obsidian prioritizes the
developer experience. This isn't about rejecting convention for its own sake, but about thoughtfully
choosing approaches that enhance clarity and reduce friction.

### Technical Approach

Obsidian maintains strong type safety throughout, avoiding type erasure entirely. Built for Swift's
actor system and structured concurrency model, its APIs are designed for multi-threaded environments
with proper isolation patterns.

Obsidian intentionally breaks from some Swift community conventions, but these departures aren't
arbitrary. Each divergence serves a purpose: enhancing readability, reducing cognitive friction,
or enabling more expressive code.

## Features

### Optional Extensions

Obsidian provides a suite of natural language extensions for Swift's Optional type that make working
with optionals more expressive and readable.

#### `otherwise` - A natural language alternative to nil-coalescing (`??`)

```swift
// Instead of:
let display_name = username ?? "Guest"

// Use:
let display_name = username.otherwise("Guest")
```

Three variants are available:

```swift
// With a direct default value
let result = optional_value.otherwise(defaultValue)

// With a closure for lazy evaluation
let result = optional_value.otherwise {
    perform_expensive_computation()
}

// With an async closure (fully supports actors)
let result = await optional_value.otherwise {
    await perform_async_operation()
}
```

#### `transform` - A natural language alternative to map/flatMap

```swift
// Instead of:
let name_length = username.map { $0.count }

// Use:
let name_length = username.transform { name in
    name.count
}

// For transformations that might return nil (flatMap):
let number = numeric_string.transform { string in
    Int(string)  // Returns Int? (might be nil if string isn't numeric)
}

// With async support:
let user_profile = await user_id.transform { id in
    await user_service.fetch_profile(for: id)
}
```

#### `when` - Conditional execution based on optional presence

```swift
// Execute code when optional contains a value:
user.when(something: { person in
    analytics.log_user_visit(person.id)
})

// Execute code when optional is nil:
user.when(nothing: {
    analytics.log_anonymous_visit()
})

// Handle both cases with a single method:
user.when(
    something: { person in
        analytics.log_user_visit(person.id)
    },
    nothing: {
        analytics.log_anonymous_visit()
    }
)

// With async support:
await user.when(
    something: { person in
        await analytics.log_user_visit_async(person.id)
    },
    nothing: {
        await analytics.log_anonymous_visit_async()
    }
)
```

#### `optionally` - Chaining multiple optionals

```swift
// Instead of:
let result = primary_value ?? backup_value ?? "Default"

// Use:
let result = primary_value.optionally(backup_value).otherwise("Default")

// With lazy evaluation:
let result = cached_result.optionally {
    compute_expensive_fallback()  // Returns another optional
}.otherwise("Default")

// With async support:
let value = await local_value.optionally {
    await remote_service.fetch_optional_value()
}.otherwise("Default")
```

### Result Extensions

Obsidian provides a suite of natural language extensions for Swift's Result type that make error
handling more expressive and readable.

#### `otherwise` - Extracting values with fallbacks

```swift
// Extract the success value or use a default:
let computation_result: Result<Int, Error> = perform_risky_computation()
let value = computation_result.otherwise(0)

// With a lazy-evaluated fallback:
let result = computation_result.otherwise {
    perform_fallback_computation()
}

// With access to the error:
let profile = api_result.otherwise { error in
    // Create a fallback profile using error information
    logger.log("Using default profile due to error: \(error)")
    return default_profile
}

// With async support:
let data = await network_result.otherwise {
    await download_from_backup_server()
}
```

#### `transform` - Transforming success values

```swift
// Transform success values while preserving errors:
let string_result: Result<String, Error> = .success("Hello")
let length_result = string_result.transform { string in
    string.count
}

// For transformations that might fail (flatMap equivalent):
let file_contents_result = file_path_result.transform { path in
    read_file(at: path)  // Returns Result<String, Error>
}

// With async support:
let profile_result = await user_id_result.transform { id in
    await user_service.fetch_profile(for: id)
}
```

#### `when` - Handling success and failure cases

```swift
// Execute code only on success:
user_result.when(success: { user in
    display_user_profile(user)
})

// Execute code only on failure:
user_result.when(failure: { error in
    log_error(error)
})

// Handle both cases in one call:
user_result.when(
    success: { user in
        display_user_profile(user)
    },
    failure: { error in
        display_error_message(for: error)
    }
)

// With method chaining (all `when` methods return self):
user_result
    .when(success: { user in log_user_found(user) })
    .when(failure: { error in log_error(error) })

// With async support:
await user_result.when(
    success: { user in
        await user_service.process_user_async(user)
    },
    failure: { error in
        await error_service.handle_error_async(error)
    }
)
```

#### `recover` - Attempting to recover from failures

```swift
// Try to recover from failures by providing an alternative success:
let data_result: Result<Data, NetworkError> = api.fetch_data()
let recovered_result = data_result.recover { error in
    if cache.has_valid_data_for(request) {
        return cache.get_data_for(request)
    } else {
        return nil  // Unable to recover, will maintain failure
    }
}

// Recover with a different error type:
let data_result: Result<Data, ServiceAError> = service_a.fetch_data()
let recovered_result = data_result.recover { error in
    return service_b.fetch_data()  // Returns Result<Data, ServiceBError>
}

// With async support:
let recovered_result = await data_result.recover { error in
    return await backup_service.try_fetch_data()
}
```

#### `reframe` - Transforming error values

```swift
// Transform error types while preserving success values:
let network_result: Result<Data, NetworkError> = .failure(.connectionLost)
let app_result = network_result.reframe { network_error in
    AppError.network(underlying: network_error)
}

// Complex error handling that might produce a success:
let final_result = network_result.reframe { error in
    if error == .notFound {
        // Return a success with default data
        return .success(default_data)
    } else {
        // Return a new error type
        return .failure(AppError.network(underlying: error))
    }
}

// With async support:
let domain_result = await api_result.reframe { api_error in
    await error_processor.convert_to_domain_error(api_error)
}
```

#### `catching` - Creating results from throwing functions

```swift
// Convert a throwing function call into a Result:
let result = Result<Data, Error>.catching {
    try file_manager.contents(atPath: path)
}

// Chain with other Result extensions:
let text = Result<Data, Error>.catching {
    try file_manager.contents(atPath: path)
}.transform { data in
    String(data: data, encoding: .utf8)
}.otherwise("Empty file")

// With async support:
let result = await Result<Data, Error>.catching {
    try await network_service.fetch_data(from: url)
}
```

### Transmutation Between Result and Optional

Obsidian provides seamless conversion between Result and Optional types with
natural language methods.

#### `transmute` - Converting between Result and Optional

```swift
// Convert an Optional to a Result with a specific error:
let username: String? = get_username_from_database()
let result: Result<String, UserError> = username.transmute(as: UserError.missing_username)

// Convert a Result to an Optional (keeping success value):
let user_result: Result<User, APIError> = api.fetch_user(id: user_id)
let user_optional: User? = user_result.transmute()

// Convert a Result to an Optional (keeping error value):
let error_optional: APIError? = user_result.transmute(.error)
```

### Protocols

Obsidian includes several protocols that provide consistent interfaces across types:

#### `Uniquable` - Unique identification with UUID

```swift
struct User: Uniquable {
    let id = UUID()
    let name: String
}
```

The `Uniquable` protocol extends `Identifiable` to specifically use `UUID` as the identifier type,
ensuring standardized unique identification across your application.

#### `Namable` - Consistent naming convention

```swift
struct Product: Namable {
    // Uses default implementation: returns "Product"
}

struct CustomProduct: Namable {
    let name: String  // Custom implementation: returns this value

    init(name: String) {
        self.name = name
    }
}
```

The `Namable` protocol provides a consistent way to access a human-readable name for types. It
includes a default implementation that returns the type name as a string.

#### `Describable` - Textual descriptions

```swift
struct Message: Describable {
    let sender: String
    let content: String

    var description: String {
        return "\(sender): \(content)"
    }
}
```

The `Describable` protocol offers a consistent way to get a human-readable description of types for
logging, debugging, or user-facing displays.

#### `Representable` - Combined representation

```swift
struct User: Representable {
    let id = UUID()
    // Uses default implementations for name and description
}
```

The `Representable` protocol combines `Uniquable`, `Namable`, and `Describable` to provide a
complete representation for an object. By default, a `Representable` object's description will be
its name followed by its UUID.

## Getting Started

### Installation

Add Obsidian to your Swift package dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/beeauvin/Obsidian.git", from: "0.2.0")
]
```

### Basic Usage

Import the Obsidian module:

```swift
import Obsidian  // Also imports Foundation
```

## Examples

### Combining Optional Extensions

```swift
// Using transform, optionally, and otherwise together
let user_id: UUID? = get_current_user_id()
let profile = await user_id
    .transform { id in await user_service.fetch_profile(for: id) }
    .optionally { await user_service.fetch_cached_profile() }
    .otherwise { DefaultProfile() }

// Using when for conditional logic with async code
let cached_data: Data? = cache.retrieve(key)
await cached_data.when(
    something: { data in
        await process_and_update(data)
    },
    nothing: {
        await fetch_and_cache(key)
    }
)
```

### Comprehensive Error Handling with Result

```swift
// Complete error handling pipeline using Result extensions
let result = await Result<Data, Error>.catching {
    try await network.fetch(from: url)
}.transform { data in
    try JSONDecoder().decode(User.self, from: data)
}.recover { error in
    if let cached_user = cache.get_user() {
        return cached_user
    }
    return nil  // Unable to recover
}.reframe { error in
    UserError.fetch(underlying: error)
}.when(
    success: { user in
        await analytics.log_successful_fetch(user.id)
        display_user(user)
    },
    failure: { error in
        await error_reporter.report(error)
        display_error(error)
    }
)
```

### Using Protocols Together

```swift
// A type that provides identity, name, and description
struct Product: Representable {
    let id = UUID()
    let name: String
    let price: Decimal
    
    init(name: String, price: Decimal) {
        self.name = name
        self.price = price
    }
    
    // Override the default description
    var description: String {
        return "\(name) ($\(price))"
    }
}

let product = Product(name: "Deluxe Widget", price: 29.99)
print(product.id)          // UUID
print(product.name)        // "Deluxe Widget"
print(product.description) // "Deluxe Widget ($29.99)"
```

## Contributing

While I do not have a formal process for this in place at the moment, contributions are welcome. I
intend to adopt the [Contributor Covenant](https://www.contributor-covenant.org) so those standards
are the expectation.

The key consideration for contributions is alignment with Obsidian's core
philosophy and design goals. Technical improvements, documentation, and testing
are all valuable areas for contribution.

See the working [contributing](/contributing.md) document for some guidelines.

## License

🔮 Obsidian is available under the [Mozilla Public License 2.0](https://mozilla.org/MPL/2.0/).

A copy of the MPLv2 is included in the [license.md](/license.md) file for convenience.
