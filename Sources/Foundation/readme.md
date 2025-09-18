# ObsidianFoundation

ObsidianFoundation provides a set of protocols that establish consistent interfaces across types for identification, naming, description, and representation.

## Protocols

### `Uniquable` - Unique identification with UUID

The `Uniquable` protocol extends `Identifiable` to specifically use `UUID` as the identifier type, ensuring standardized unique identification across your application.

```swift
struct User: Uniquable {
    let id = UUID()
    let name: String
}
```

### `Namable` - Consistent naming convention

The `Namable` protocol provides a consistent way to access a human-readable name for types. It includes a default implementation that returns the type name as a string.

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

### `Describable` - Textual descriptions

The `Describable` protocol offers a consistent way to get a human-readable description of types for logging, debugging, or user-facing displays.

```swift
struct Message: Describable {
    let sender: String
    let content: String

    var description: String {
        return "\(sender): \(content)"
    }
}
```

### `Representable` - Combined representation

The `Representable` protocol combines `Uniquable`, `Namable`, and `Describable` to provide a complete representation for an object. By default, a `Representable` object's description will be its name followed by its UUID.

```swift
struct User: Representable {
    let id = UUID()
    // Uses default implementations for name and description
}
```

## Usage Example

```swift
import ObsidianFoundation

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
