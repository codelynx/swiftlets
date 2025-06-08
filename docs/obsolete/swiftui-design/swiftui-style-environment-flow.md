# How Environment Flows from @main to Pages

## Understanding Ignite's Approach

In Ignite, the Environment flows like this:

```
Site.publish() 
  → PublishingContext (singleton)
    → EnvironmentValues (stored in context)
      → withEnvironment() wrapper
        → page.body rendering
```

### Key Components

1. **PublishingContext.shared** - A singleton that holds the current environment
2. **EnvironmentValues** - A struct containing all environment data
3. **withEnvironment()** - Temporarily sets environment for a closure
4. **@Environment** - Reads from PublishingContext.shared.environment

### The Flow in Detail

```swift
// 1. Site.publish() creates PublishingContext
let context = try PublishingContext.initialize(for: self, from: file)

// 2. When rendering a page
let values = EnvironmentValues(
    sourceDirectory: sourceDirectory,
    site: site,
    allContent: allContent,
    pageMetadata: pageMetadata,
    pageContent: page
)

// 3. Render with environment
let outputString = withEnvironment(values) {
    page.layout.body.markupString()  // This is where @Environment works
}

// 4. Inside the page
@Environment(\.site) var site  // Reads from PublishingContext.shared.environment
```

## Applying to Swiftlets

For Swiftlets, we need a similar but simpler flow since we handle one request at a time:

### Option 1: Thread-Local Storage (Simple)

```swift
// SwiftletRuntime.swift
@MainActor
final class SwiftletRuntime {
    private static var _current: SwiftletRuntime?
    
    static var current: SwiftletRuntime {
        guard let runtime = _current else {
            fatalError("SwiftletRuntime not initialized")
        }
        return runtime
    }
    
    let environment: SwiftletEnvironment
    
    init(request: Request, context: SwiftletContext) {
        self.environment = SwiftletEnvironment(
            request: request,
            context: context,
            storage: context.storage,
            resources: context.resources
        )
    }
    
    static func run<S: Swiftlet>(_ swiftlet: S.Type) async throws {
        // Parse request
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        let context = DefaultSwiftletContext(from: request.context!)
        
        // Set up runtime
        let runtime = SwiftletRuntime(request: request, context: context)
        _current = runtime
        defer { _current = nil }
        
        // Create and render swiftlet
        let instance = swiftlet.init()
        let html = instance.body
        
        // Send response
        let response = Response(
            status: 200,
            headers: ["Content-Type": "text/html; charset=utf-8"],
            body: html.render()
        )
        
        print(try JSONEncoder().encode(response).base64EncodedString())
    }
}

// Environment property wrapper
@propertyWrapper
public struct Environment<Value> {
    private let keyPath: KeyPath<SwiftletEnvironment, Value>
    
    public var wrappedValue: Value {
        SwiftletRuntime.current.environment[keyPath: keyPath]
    }
    
    public init(_ keyPath: KeyPath<SwiftletEnvironment, Value>) {
        self.keyPath = keyPath
    }
}
```

### Option 2: Dependency Injection (More Testable)

```swift
// Make Swiftlet protocol aware of dependencies
public protocol Swiftlet {
    associatedtype Body: HTML
    
    init()
    func body(environment: SwiftletEnvironment) -> Body
}

// But use computed property for clean API
extension Swiftlet {
    public static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        let context = DefaultSwiftletContext(from: request.context!)
        
        let environment = SwiftletEnvironment(
            request: request,
            context: context
        )
        
        let instance = Self()
        let html = instance.body(environment: environment)
        
        // ... response handling
    }
}

// Use a stored property to make it available
private var _environment: SwiftletEnvironment?

@propertyWrapper
public struct Environment<Value> {
    private let keyPath: KeyPath<SwiftletEnvironment, Value>
    
    public var wrappedValue: Value {
        guard let env = _environment else {
            fatalError("Environment not set")
        }
        return env[keyPath: keyPath]
    }
}
```

### Option 3: Task Local Storage (Best for Async)

```swift
// Using Swift's task local storage
enum SwiftletEnvironmentKey {
    @TaskLocal static var current: SwiftletEnvironment?
}

@propertyWrapper
public struct Environment<Value> {
    private let keyPath: KeyPath<SwiftletEnvironment, Value>
    
    public var wrappedValue: Value {
        guard let env = SwiftletEnvironmentKey.current else {
            fatalError("@Environment used outside of Swiftlet context")
        }
        return env[keyPath: keyPath]
    }
    
    public init(_ keyPath: KeyPath<SwiftletEnvironment, Value>) {
        self.keyPath = keyPath
    }
}

// In Swiftlet protocol extension
extension Swiftlet {
    public static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        let context = DefaultSwiftletContext(from: request.context!)
        
        let environment = SwiftletEnvironment(
            request: request,
            context: context
        )
        
        // Run with task local value
        let html = await SwiftletEnvironmentKey.$current.withValue(environment) {
            let instance = Self()
            return instance.body
        }
        
        // ... response handling
    }
}
```

## Recommendation

For Swiftlets, I recommend **Option 3 (Task Local Storage)** because:

1. **Thread-safe** - Each request gets its own environment
2. **Async-friendly** - Works naturally with Swift concurrency
3. **Clean API** - No globals or singletons
4. **Testable** - Can inject test environments
5. **SwiftUI-like** - Similar to how SwiftUI likely handles environment

### Complete Example

```swift
@main
struct HomePage: Swiftlet {
    @Environment(\.request) var request
    @Environment(\.context) var context
    
    var userName: String? {
        request.query?["name"]
    }
    
    var body: some HTML {
        Html {
            Head { Title("Welcome") }
            Body {
                if let name = userName {
                    H1("Hello, \(name)!")
                } else {
                    H1("Hello, World!")
                }
            }
        }
    }
}
```

The environment flows from `main()` → `TaskLocal` → `@Environment` → your properties!