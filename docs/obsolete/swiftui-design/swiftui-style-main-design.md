# SwiftUI-Style Main Design for Swiftlets

## Overview

This document outlines a design to refactor Swiftlets' `@main` entry point from the current static function approach to a more SwiftUI-like declarative style, where the main structure uses instance properties and computed properties rather than static functions.

## Current Approach (Too Much Boilerplate!)

```swift
@main
struct HomePage {
    static func main() async throws {
        // 😫 Boilerplate: Manual JSON decoding
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head { Title("Home") }
            Body { H1("Welcome") }
        }
        
        // 😫 Boilerplate: Manual response creation
        let response = Response(
            status: 200,
            headers: ["Content-Type": "text/html"],
            body: html.render()
        )
        
        // 😫 Boilerplate: Manual encoding and output
        print(try JSONEncoder().encode(response).base64EncodedString())
    }
}
```

**The Problem**: Developers have to write the same boilerplate in EVERY swiftlet!

## The Vision: Focus on Content, Not Plumbing

Developers should only care about:
1. **What data they need** (query params, headers, etc.)
2. **What HTML to generate** (the actual content)

They should NOT have to think about:
- How to decode JSON from stdin
- How to create Response objects
- How to encode and output base64
- Error handling for the protocol layer

## Proposed SwiftUI-Style Approach

### Option 1: Body Property Pattern

```swift
@main
struct HomePage: Swiftlet {
    var body: some HTML {
        Html {
            Head { Title("Home") }
            Body { H1("Welcome") }
        }
    }
}
```

### Option 2: Scene-like Pattern

```swift
@main
struct HomePage: SwiftletApp {
    var body: some SwiftletScene {
        Page {
            Html {
                Head { Title("Home") }
                Body { H1("Welcome") }
            }
        }
    }
}
```

### Option 3: View Protocol Pattern

```swift
@main
struct HomePage: SwiftletView {
    @Request var request
    @Context var context
    
    var body: some HTML {
        Html {
            Head { Title("Home") }
            Body {
                if let name = request.query["name"] {
                    H1("Welcome, \(name)!")
                } else {
                    H1("Welcome!")
                }
            }
        }
    }
}
```

## Implementation Details

### Protocol Definition

```swift
public protocol Swiftlet {
    associatedtype Body: HTML
    @HTMLBuilder var body: Body { get }
}

extension Swiftlet {
    public static func main() async throws {
        // Handle request parsing
        let requestData = FileHandle.standardInput.readDataToEndOfFile()
        let request = try JSONDecoder().decode(Request.self, from: requestData)
        
        // Create instance with dependency injection
        let instance = Self()
        
        // Render body
        let html = instance.body
        
        // Create and send response
        let response = Response(
            status: 200,
            headers: ["Content-Type": "text/html; charset=utf-8"],
            body: html.render()
        )
        
        print(try JSONEncoder().encode(response).base64EncodedString())
    }
}
```

### Property Wrappers for Dependencies

```swift
@propertyWrapper
public struct Request {
    private var _wrappedValue: Swiftlets.Request?
    
    public init() {}
    
    public var wrappedValue: Swiftlets.Request {
        get {
            guard let value = _wrappedValue else {
                fatalError("Request not initialized. This should be set by the framework.")
            }
            return value
        }
        set { _wrappedValue = newValue }
    }
}

@propertyWrapper
public struct Context {
    private var _wrappedValue: SwiftletContext?
    
    public init() {}
    
    public var wrappedValue: SwiftletContext {
        get {
            guard let value = _wrappedValue else {
                fatalError("Context not initialized. This should be set by the framework.")
            }
            return value
        }
        set { _wrappedValue = newValue }
    }
}
```

### Advanced Example with All Features

```swift
@main
struct BlogPost: Swiftlet {
    @Request var request
    @Context var context
    @Query("id") var postId: String?
    @Storage var storage
    @Resources var resources
    
    var body: some HTML {
        Html {
            Head {
                Title(pageTitle)
                Meta(name: "description", content: metaDescription)
            }
            Body {
                navigation()
                
                Container {
                    if let post = loadPost() {
                        article(for: post)
                    } else {
                        notFound()
                    }
                }
                
                footer()
            }
        }
    }
    
    private var pageTitle: String {
        if let post = loadPost() {
            return "\(post.title) - My Blog"
        }
        return "Post Not Found - My Blog"
    }
    
    private var metaDescription: String {
        loadPost()?.excerpt ?? "The requested blog post could not be found."
    }
    
    private func loadPost() -> BlogPost? {
        guard let id = postId else { return nil }
        // Load from storage or resources
        return nil // Placeholder
    }
    
    @HTMLBuilder
    private func navigation() -> some HTML {
        Nav {
            // Navigation content
        }
    }
    
    @HTMLBuilder
    private func article(for post: BlogPost) -> some HTML {
        Article {
            H1(post.title)
            Time(post.date.formatted())
            Div(post.content)
        }
    }
    
    @HTMLBuilder
    private func notFound() -> some HTML {
        Div {
            H1("Post Not Found")
            P("The requested blog post could not be found.")
            Link(href: "/blog", "Return to Blog")
        }
    }
    
    @HTMLBuilder
    private func footer() -> some HTML {
        Footer {
            P("© 2025 My Blog")
        }
    }
}
```

## Benefits

1. **More Natural Swift Syntax**: Follows SwiftUI patterns that Swift developers are familiar with
2. **Better Dependency Injection**: Property wrappers provide clean access to request, context, etc.
3. **Testability**: Instance methods are easier to test than static functions
4. **Reusability**: Can create base protocols with default implementations
5. **Type Safety**: Property wrappers ensure proper types at compile time

## Migration Strategy

### Phase 1: Protocol Introduction
- Introduce `Swiftlet` protocol alongside existing approach
- Both styles work simultaneously
- No breaking changes

### Phase 2: Property Wrappers
- Add `@Request`, `@Context`, `@Query`, etc.
- Enhance developer experience
- Still backward compatible

### Phase 3: Documentation & Examples
- Update all examples to new style
- Provide migration guide
- Keep old style documented for reference

### Phase 4: Deprecation (Future)
- Mark static approach as deprecated
- Provide automated migration tool if possible
- Remove in major version update

## Example Migration

### Before:
```swift
@main
struct HomePage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        let context = DefaultSwiftletContext(from: request.context!)
        
        let html = Html {
            Head { Title("Home") }
            Body {
                H1("Welcome")
                if let name = request.query?["name"] {
                    P("Hello, \(name)!")
                }
            }
        }
        
        let response = Response(status: 200, headers: ["Content-Type": "text/html"], body: html.render())
        print(try JSONEncoder().encode(response).base64EncodedString())
    }
}
```

### After:
```swift
@main
struct HomePage: Swiftlet {
    @Request var request
    @Query("name") var name: String?
    
    var body: some HTML {
        Html {
            Head { Title("Home") }
            Body {
                H1("Welcome")
                if let name = name {
                    P("Hello, \(name)!")
                }
            }
        }
    }
}
```

## Considerations

### Performance
- Minimal overhead from instance creation
- Property wrappers are compile-time optimized
- No runtime reflection needed

### Backward Compatibility
- Must maintain existing static approach during transition
- Clear deprecation path
- Version-based feature flags if needed

### Error Handling
- Where do errors go in declarative style?
- Consider `throws` on body or error view pattern
- Property wrapper initialization errors

### Advanced Features
- Middleware support
- Lifecycle hooks (onAppear, onDisappear)
- State management for interactive features

## Next Steps

1. Implement basic `Swiftlet` protocol
2. Create property wrapper prototypes
3. Test with simple examples
4. Gather feedback on API design
5. Implement full feature set
6. Create migration tools
7. Update documentation

## Questions to Resolve

1. Should we use `body` or another property name?
2. How to handle async operations in body?
3. Should we support multiple protocols (Swiftlet, SwiftletApp, etc.)?
4. How to integrate with existing middleware concepts?
5. Error handling strategy for property wrappers?

## References

- SwiftUI App Protocol: https://developer.apple.com/documentation/swiftui/app
- SwiftUI View Protocol: https://developer.apple.com/documentation/swiftui/view
- Property Wrappers: https://docs.swift.org/swift-book/LanguageGuide/Properties.html#ID617