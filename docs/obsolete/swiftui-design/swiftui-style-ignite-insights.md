# Ignite Framework Insights for SwiftUI-Style Swiftlets

## What Ignite Does Well

### 1. Protocol-Based Architecture
- Uses `StaticPage` protocol with `body: some HTML` property
- Clean separation between configuration (Site) and content (Pages)
- Pages don't need `@main` - they're just data structures

### 2. Environment Pattern
```swift
@Environment(\.site) var site
@Environment(\.themes) var themes
```
- Similar to SwiftUI's environment
- Clean dependency injection
- Global access to common values

### 3. Declarative Page Definition
```swift
struct AboutPage: StaticPage {
    var title = "About"
    
    var body: some HTML {
        Text("About us...")
    }
}
```

## Applying to Swiftlets

### Enhanced Design Based on Ignite

#### 1. Environment-Based Property Wrappers
```swift
// More SwiftUI-like than our original design
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

// Usage
@main
struct HomePage: Swiftlet {
    @Environment(\.request) var request
    @Environment(\.context) var context
    @Environment(\.storage) var storage
    
    var body: some HTML {
        // ...
    }
}
```

#### 2. Computed Properties Pattern
Like Ignite's pages, we can use computed properties for dynamic values:

```swift
@main
struct BlogPost: Swiftlet {
    @Environment(\.request) var request
    
    var postId: String? {
        request.query["id"]
    }
    
    var post: Post? {
        guard let id = postId else { return nil }
        return loadPost(id: id)
    }
    
    var body: some HTML {
        Html {
            Head { Title(post?.title ?? "Not Found") }
            Body {
                if let post = post {
                    Article {
                        H1(post.title)
                        Div(post.content)
                    }
                } else {
                    H1("Post Not Found")
                }
            }
        }
    }
}
```

#### 3. Layout System
Ignite uses a layout system we could adapt:

```swift
protocol SwiftletLayout {
    associatedtype Body: HTML
    @HTMLBuilder func body(content: any HTML) -> Body
}

struct DefaultLayout: SwiftletLayout {
    func body(content: any HTML) -> some HTML {
        Html {
            Head {
                // Common head elements
            }
            Body {
                Nav { /* ... */ }
                content
                Footer { /* ... */ }
            }
        }
    }
}

// In Swiftlet:
@main
struct HomePage: Swiftlet {
    var layout: some SwiftletLayout = DefaultLayout()
    
    var body: some HTML {
        // This gets wrapped by layout
        H1("Welcome")
    }
}
```

#### 4. Simplified Error Handling
Instead of try/catch in body, use Result types:

```swift
@main
struct DataPage: Swiftlet {
    @Environment(\.storage) var storage
    
    var data: Result<MyData, Error> {
        Result {
            try storage.read(from: "data.json")
                .json(as: MyData.self)
        }
    }
    
    var body: some HTML {
        switch data {
        case .success(let value):
            DataView(value)
        case .failure(let error):
            ErrorView(error)
        }
    }
}
```

## How Ignite's Environment System Works

After deeper analysis, here's how Ignite passes environment from the root:

### The Flow
```
Site.publish() 
  → PublishingContext.shared (singleton)
    → EnvironmentValues (stored in context)
      → withEnvironment() wrapper
        → page.body rendering
          → @Environment reads from singleton
```

### Key Implementation Details
1. **PublishingContext.shared** - A singleton that holds the current environment
2. **EnvironmentValues** - Created fresh for each page render with all needed data
3. **withEnvironment()** - Temporarily swaps the environment on the singleton:
   ```swift
   func withEnvironment<T>(_ environment: EnvironmentValues, operation: () -> T) -> T {
       let previous = self.environment
       self.environment = environment
       defer { self.environment = previous }
       return operation()
   }
   ```
4. **@Environment** property wrapper reads from the singleton:
   ```swift
   @propertyWrapper public struct Environment<Value> {
       public var wrappedValue: Value {
           PublishingContext.shared.environment[keyPath: keyPath]
       }
   }
   ```

### Why This Works for Ignite
- **Static site generator** - Renders pages sequentially, not concurrently
- **Batch processing** - All pages rendered in one process
- **No concurrency concerns** - Single-threaded rendering

### Why Swiftlets Needs a Different Approach
- **Concurrent requests** - Multiple swiftlets run simultaneously
- **Process isolation** - Each swiftlet is a separate process
- **Thread safety** - Can't use global singletons

## Final Recommendation

The best approach combines:
1. **Ignite's environment pattern** - Clean and SwiftUI-like
2. **Task Local Storage** - Instead of singleton for thread safety
3. **Computed properties** - For derived values
4. **Result types** - For error handling without throws

### Complete Example
```swift
@main
struct ProductPage: Swiftlet {
    @Environment(\.request) var request
    @Environment(\.context) var context
    
    var productId: String? {
        request.path.components.last
    }
    
    var product: Result<Product, Error> {
        guard let id = productId else {
            return .failure(NotFoundError())
        }
        
        return Result {
            let data = try context.resources.read(named: "products/\(id).json")
            return try data.json(as: Product.self)
        }
    }
    
    var body: some HTML {
        Html {
            Head {
                Title(pageTitle)
            }
            Body {
                Container {
                    switch product {
                    case .success(let p):
                        productView(p)
                    case .failure:
                        notFoundView()
                    }
                }
            }
        }
    }
    
    private var pageTitle: String {
        switch product {
        case .success(let p): return "\(p.name) - Store"
        case .failure: return "Product Not Found - Store"
        }
    }
    
    @HTMLBuilder
    private func productView(_ product: Product) -> some HTML {
        VStack {
            H1(product.name)
            Img(src: product.imageURL)
            P(product.description)
            Button("Add to Cart")
        }
    }
    
    @HTMLBuilder
    private func notFoundView() -> some HTML {
        VStack {
            H1("Product Not Found")
            Link(href: "/products", "Browse All Products")
        }
    }
}
```

This approach:
- ✅ Feels like SwiftUI
- ✅ Minimal boilerplate
- ✅ Clean error handling
- ✅ Testable
- ✅ Uses patterns developers know from Ignite/SwiftUI