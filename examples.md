# Obsidian Examples

This document provides comprehensive examples showing how to use Obsidian's modules together in real-world scenarios.

## Combining Flow with Utility Extensions

Real-world example showing user authentication with error handling and events:

```swift
// Define message types for the Flow framework
struct AuthenticationRequest: Pulsable {
    let credentials: Credentials
    let timestamp: Date
}

struct AuthenticationResult: Pulsable {
    let success: Bool
    let user: User?
    let error: AuthError?
}

actor AuthenticationService: Representable {
    let id = UUID()
    private let result_channel: Channel<AuthenticationResult>
    
    init(result_channel: Channel<AuthenticationResult>) {
        self.result_channel = result_channel
    }
    
    func authenticate(credentials: Credentials) async -> User? {
        // Use Result extensions for robust error handling
        let auth_result = await Result<User, AuthError>.Catching {
            try await validate_credentials(credentials)
        }.recover { error in
            // Try cached authentication
            return cached_user_for(credentials).transmute(as: AuthError.no_cached_user)
        }.when(
            success: { user in
                // Send success event through Flow
                let result_pulse = Pulse(AuthenticationResult(success: true, user: user, error: nil))
                    .priority(.high)
                    .tagged("auth", "success")
                    .from(self)
                await result_channel.send(result_pulse)
            },
            failure: { error in
                // Send failure event through Flow
                let result_pulse = Pulse(AuthenticationResult(success: false, user: nil, error: error))
                    .priority(.high)
                    .tagged("auth", "failure")
                    .from(self)
                await result_channel.send(result_pulse)
            }
        )
        
        // Use Optional extensions for clean return value handling
        return auth_result.transmute()  // Convert Result to Optional
    }
}
```

## Combining Optional Extensions

Examples showing how to chain Optional extensions for powerful data flow patterns:

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

## Comprehensive Error Handling with Result

Complete error handling pipeline using Result extensions:

```swift
let result = await Result<Data, Error>.Catching {
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

## Event-Driven Architecture with Flow

Complete event-driven system using Flow messaging:

```swift
// Define event types
struct UserLoggedIn: Pulsable {
    let user_id: UUID
    let timestamp: Date
}

struct DataSyncRequired: Pulsable {
    let user_id: UUID
    let sync_types: [SyncType]
}

actor UserEventCoordinator: Representable {
    let id = UUID()
    private let analytics_channel: Channel<UserLoggedIn>
    private let sync_channel: Channel<DataSyncRequired>
    
    init(analytics_channel: Channel<UserLoggedIn>, sync_channel: Channel<DataSyncRequired>) {
        self.analytics_channel = analytics_channel
        self.sync_channel = sync_channel
    }
    
    func handle_user_login(user: User) async {
        // Create and send analytics event
        let login_event = UserLoggedIn(user_id: user.id, timestamp: Date())
        let analytics_pulse = Pulse(login_event)
            .priority(.high)
            .tagged("analytics", "user_event")
            .from(self)
        
        await analytics_channel.send(analytics_pulse)
        
        // Create follow-up sync event with causal relationship
        let sync_event = DataSyncRequired(user_id: user.id, sync_types: [.profile, .preferences])
        let sync_pulse = Pulse.Respond(
            to: analytics_pulse,  // Establish causal relationship
            with: sync_event,
            from: self
        ).tagged("sync", "user_data")
        
        await sync_channel.send(sync_pulse)
    }
}
```

## Using Foundation Protocols

Example showing how to use the Foundation protocols together:

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

## Data Processing Pipeline

Example showing a complete data processing pipeline using multiple Obsidian features:

```swift
struct DataProcessor: Representable {
    let id = UUID()
    private let result_channel: Channel<ProcessingResult>
    
    func process_user_data(raw_data: Data?) async -> ProcessedData? {
        return await raw_data
            // Use Optional extensions for safe unwrapping
            .transform { data in
                // Use Result extensions for error handling
                Result<ProcessedData, ProcessingError>.Catching {
                    try decode_and_validate(data)
                }
            }
            // Handle the Result
            .otherwise { 
                // Fallback to cached data if processing fails
                Result<ProcessedData, ProcessingError>.Catching {
                    try load_cached_data()
                }
            }
            // Send processing events through Flow
            .when(
                success: { processed_data in
                    let success_pulse = Pulse(ProcessingResult.success(processed_data))
                        .priority(.normal)
                        .tagged("processing", "success")
                        .from(self)
                    await result_channel.send(success_pulse)
                },
                failure: { error in
                    let failure_pulse = Pulse(ProcessingResult.failure(error))
                        .priority(.high)
                        .tagged("processing", "failure")
                        .from(self)
                    await result_channel.send(failure_pulse)
                }
            )
            // Convert Result back to Optional for return
            .transmute()
    }
}
```

## Advanced Stream Usage

Example showing advanced Stream usage with lifecycle management:

```swift
actor DataStreamProcessor: Representable {
    let id = UUID()
    private var active_streams: [UUID: Stream<DataChunk>] = [:]
    
    func create_data_stream(for client_id: UUID) async -> Stream<DataChunk> {
        let stream = Stream<DataChunk>(
            source_released: { released_pulse in
                // Handle client disconnection
                await self.cleanup_client_resources(client_id)
                print("Client \(client_id) disconnected")
            },
            anchor_released: { released_pulse in
                // Handle server-side stream closure
                await self.notify_client_of_closure(client_id)
                print("Server closed stream for \(client_id)")
            },
            handler: { pulse in
                // Process incoming data
                await self.process_data_chunk(pulse.data, for: client_id)
            }
        )
        
        active_streams[client_id] = stream
        return stream
    }
    
    func broadcast_to_all_clients(_ data: DataChunk) async {
        let broadcast_pulse = Pulse(data)
            .priority(.normal)
            .tagged("broadcast")
            .from(self)
        
        // Send to all active streams
        for stream in active_streams.values {
            await stream.send(broadcast_pulse)
        }
    }
    
    private func cleanup_client_resources(_ client_id: UUID) async {
        active_streams.removeValue(forKey: client_id)
        // Additional cleanup logic
    }
    
    private func notify_client_of_closure(_ client_id: UUID) async {
        // Send closure notification through other channels
    }
    
    private func process_data_chunk(_ chunk: DataChunk, for client_id: UUID) async {
        // Process the data chunk
    }
}
```

## Testing with Obsidian

Example showing how to test code that uses Obsidian features:

```swift
@Test("Optional chaining with fallbacks")
func test_optional_chaining_with_fallbacks() async throws {
    // Given
    let primary_data: String? = nil
    let backup_data: String? = "backup"
    let default_data = "default"
    
    // When
    let result = primary_data
        .optionally(backup_data)
        .otherwise(default_data)
    
    // Then
    #expect(result == "backup")
}

@Test("Result error handling pipeline")
func test_result_error_handling_pipeline() async throws {
    // Given
    let failing_operation = Result<String, TestError>.failure(.network)
    let recovery_data = "recovered"
    
    // When
    let result = failing_operation
        .recover { error in
            if error == .network {
                return recovery_data
            }
            return nil
        }
        .otherwise("default")
    
    // Then
    #expect(result == "recovered")
}

@Test("Flow message causality")
func test_flow_message_causality() async throws {
    // Given
    let original_message = TestMessage(content: "start")
    let original_pulse = Pulse(original_message)
        .debug()
        .from("test_source")
    
    // When
    let response_pulse = Pulse.Respond(
        to: original_pulse,
        with: TestMessage(content: "response"),
        from: "test_responder"
    )
    
    // Then
    #expect(response_pulse.meta.trace == original_pulse.meta.trace)
    #expect(response_pulse.meta.echoes?.id == original_pulse.id)
}
```

These examples demonstrate how Obsidian's modules work together to create expressive, safe, and maintainable Swift code. The natural language interfaces make the code self-documenting while maintaining full type safety and Swift 6 compatibility.
