# PageMeta as Dictionary Design

## Option 1: Simple Dictionary

```swift
protocol Swiftlet: HTMLComponent {
    var metadata: [String: String] { get }
    
    init()
}

@main
struct HomePage: Swiftlet {
    var metadata = [
        "title": "Welcome",
        "description": "Welcome to our site",
        "author": "John Doe",
        "viewport": "width=device-width, initial-scale=1.0"
    ]
    
    var body: some HTMLElement {
        H1("Welcome!")
    }
}
```

### Pros
- Very flexible
- Easy to add custom metadata
- No need to update protocol for new meta tags

### Cons
- No compile-time checking for typos
- No type safety (everything is String)
- No IDE autocomplete
- Can't handle complex metadata (like arrays for keywords)

## Option 2: Hybrid Approach

```swift
protocol PageMeta {
    var title: String { get }
    var description: String? { get }
    
    // Additional custom metadata
    var customMeta: [String: String] { get }
}

@main
struct HomePage: Swiftlet {
    var title = "Welcome"
    var description = "Welcome to our site"
    
    var customMeta = [
        "author": "John Doe",
        "theme-color": "#ff0000"
    ]
}
```

## Option 3: Typed Dictionary with Constants

```swift
enum MetaKey: String {
    case title
    case description
    case keywords
    case author
    case viewport
    // ... more standard keys
}

protocol Swiftlet: HTMLComponent {
    var metadata: [MetaKey: Any] { get }
}

@main
struct HomePage: Swiftlet {
    var metadata: [MetaKey: Any] = [
        .title: "Welcome",
        .description: "Welcome to our site",
        .keywords: ["swift", "web", "framework"],
        .viewport: "width=device-width, initial-scale=1.0"
    ]
}
```

## Option 4: Builder Pattern with Dictionary

```swift
struct PageMetadata {
    private var data: [String: String] = [:]
    private var arrays: [String: [String]] = [:]
    
    func title(_ value: String) -> PageMetadata {
        var copy = self
        copy.data["title"] = value
        return copy
    }
    
    func description(_ value: String) -> PageMetadata {
        var copy = self
        copy.data["description"] = value
        return copy
    }
    
    func keywords(_ values: [String]) -> PageMetadata {
        var copy = self
        copy.arrays["keywords"] = values
        return copy
    }
}

@main
struct HomePage: Swiftlet {
    var metadata = PageMetadata()
        .title("Welcome")
        .description("Welcome to our site")
        .keywords(["swift", "web"])
    
    var body: some HTMLElement {
        H1("Welcome!")
    }
}
```

## Comparison

| Approach | Type Safety | Flexibility | Discoverability | Complexity |
|----------|------------|-------------|-----------------|------------|
| Protocol | ✅ High | ❌ Low | ✅ High | ✅ Simple |
| Dictionary | ❌ None | ✅ High | ❌ Low | ✅ Simple |
| Hybrid | ✅ Medium | ✅ Medium | ✅ Medium | ✅ Simple |
| Typed Dict | ✅ Medium | ✅ Medium | ✅ High | ❌ Complex |
| Builder | ✅ High | ✅ High | ✅ High | ❌ Complex |

## Recommendation

**Use Hybrid Approach** - Best of both worlds:

```swift
protocol PageMeta {
    // Required common fields (type safe)
    var title: String { get }
    
    // Optional common fields (type safe)
    var description: String? { get }
    var keywords: [String]? { get }
    var stylesheets: [String]? { get }
    
    // Escape hatch for custom metadata
    var customMeta: [String: String] { get }
}

// Default implementation
extension PageMeta {
    var description: String? { nil }
    var keywords: [String]? { nil }
    var stylesheets: [String]? { nil }
    var customMeta: [String: String] { [:] }
}

// Usage
@main
struct HomePage: Swiftlet {
    var title = "Welcome"
    var keywords = ["swift", "web"]
    
    var customMeta = [
        "theme-color": "#007AFF",
        "apple-mobile-web-app-capable": "yes"
    ]
    
    var body: some HTMLElement {
        H1("Welcome!")
    }
}
```

This gives us:
- Type safety for common metadata
- IDE autocomplete
- Flexibility for custom metadata
- Clean syntax
- Easy to understand