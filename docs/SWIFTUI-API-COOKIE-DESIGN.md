# SwiftUI-Style Cookie API Design for Swiftlets

## Overview

This document explores design options for implementing cookie support in Swiftlets' declarative API. The challenge is to provide an intuitive, SwiftUI-like interface for reading and writing cookies while maintaining the declarative nature of the framework.

## The Core Challenge

In a declarative UI framework, we describe *what* the UI should look like, not *how* to build it. However, cookies are inherently imperative - they involve:
1. Reading from request headers
2. Writing to response headers
3. Managing state that persists across requests

The key challenge is reconciling these imperative operations with our declarative API.

## Design Goals

1. **Intuitive API**: Should feel natural to SwiftUI developers
2. **Type Safety**: Leverage Swift's type system for cookie values
3. **Declarative**: Maintain the declarative paradigm where possible
4. **Flexible**: Support all standard cookie attributes
5. **Performant**: Avoid unnecessary parsing or serialization

## Approach 1: Property Wrapper for Reading

### Basic Design

```swift
struct MyPage: Swiftlet {
    @Cookie("sessionId") var sessionId: String?
    @Cookie("theme") var theme: String = "light"  // With default
    
    var body: some HTML {
        Div {
            if let sessionId {
                Text("Welcome back! Session: \(sessionId)")
            } else {
                Text("New visitor")
            }
        }
    }
}
```

### Implementation Sketch

```swift
@propertyWrapper
struct Cookie<Value: Codable> {
    let name: String
    let defaultValue: Value?
    
    var wrappedValue: Value? {
        get {
            // Need access to current request context
            // This is the main challenge
        }
    }
}
```

### Pros
- Familiar to SwiftUI developers (@State, @Binding, etc.)
- Clean, declarative syntax
- Type-safe with Codable support

### Cons
- Requires request context injection
- Read-only in basic form
- Doesn't address cookie setting

## Approach 2: Environment-Based Cookie Access

### Basic Design

```swift
struct MyPage: Swiftlet {
    @Environment(\.cookies) var cookies
    
    var body: some HTML {
        Div {
            if let sessionId = cookies["sessionId"] {
                Text("Session: \(sessionId)")
            }
        }
    }
}
```

### Pros
- Aligns with SwiftUI's environment pattern
- Clear context boundary
- Could support both reading and writing

### Cons
- Less type-safe (string-based access)
- Still needs solution for setting cookies

## Approach 3: Cookie Modifier Pattern

### Basic Design

```swift
struct MyPage: Swiftlet {
    @Cookie("theme") var theme: String = "light"
    
    var body: some HTML {
        Html {
            // Page content
        }
        .setCookie("theme", value: "dark", maxAge: 3600)
        .setCookie("session", value: generateSession(), httpOnly: true)
    }
}
```

### Pros
- Familiar modifier pattern
- Clear where cookies are set
- Supports all cookie attributes

### Cons
- Side effects in modifiers feel wrong
- When are cookies actually set in the response?
- Order of operations questions

## Approach 4: Response Wrapper Pattern

### Basic Design

```swift
struct MyPage: Swiftlet {
    @Cookie("theme") var theme: String = "light"
    
    var body: some HTML {
        Response {
            Html {
                // Page content
            }
        }
        .cookie("theme", value: "dark", maxAge: 3600)
        .cookie("session", value: generateSession(), httpOnly: true)
        .header("X-Custom", value: "example")
    }
}
```

### Implementation

```swift
struct Response<Content: HTML>: HTML {
    let content: Content
    var cookies: [HTTPCookie] = []
    var headers: [String: String] = [:]
    
    init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }
    
    func cookie(_ name: String, value: String, ...) -> Response {
        var copy = self
        copy.cookies.append(HTTPCookie(...))
        return copy
    }
}
```

### Pros
- Clear separation of concerns
- Explicit about response modifications
- Extensible to other response attributes
- Natural place for headers, status codes, etc.

### Cons
- Extra wrapper layer
- Deviates from pure HTML output

## Approach 5: State-Based Cookie Management

### Basic Design

```swift
struct MyPage: Swiftlet {
    @CookieState("theme") var theme: String = "light"
    
    var body: some HTML {
        Div {
            Button("Toggle Theme")
                .onClick {
                    theme = theme == "light" ? "dark" : "light"
                }
        }
    }
}
```

### Pros
- Most SwiftUI-like
- Bidirectional binding
- Automatic persistence

### Cons
- Complex implementation
- Requires JavaScript for client-side updates
- May be over-engineered for server-side rendering

## Approach 6: Hybrid Context + Modifier

### Basic Design

```swift
struct MyPage: Swiftlet {
    var body: some HTML {
        Html {
            // Content
        }
        .onAppear { context in
            if let theme = context.cookies["theme"] {
                // Use theme
            }
        }
        .onResponse { context in
            context.setCookie("theme", value: "dark")
            context.setHeader("X-Custom", value: "test")
        }
    }
}
```

### Pros
- Clear lifecycle hooks
- Explicit context access
- Flexible and powerful

### Cons
- More imperative
- Breaks declarative flow

## Recommended Approach: Combined Pattern

Based on the analysis, I recommend a combination of approaches:

### 1. Property Wrapper for Reading (Simple & Type-Safe)

```swift
struct MyPage: Swiftlet {
    @Cookie("userId") var userId: Int?
    @Cookie("theme") var theme = Theme.light
    
    var body: some HTML {
        // Use userId and theme directly
    }
}
```

### 2. Response Wrapper for Writing (Explicit & Flexible)

```swift
struct MyPage: Swiftlet {
    @Cookie("theme") var currentTheme = "light"
    
    var body: some HTML {
        Response {
            Html {
                // Page content using currentTheme
            }
        }
        .cookie("theme", value: "dark", 
                maxAge: 86400,
                httpOnly: false,
                secure: true,
                sameSite: .strict)
        .status(.ok)
        .header("Cache-Control", value: "no-cache")
    }
}
```

### 3. Environment for Advanced Use Cases

```swift
struct MyPage: Swiftlet {
    @Environment(\.request) var request
    @Environment(\.cookies) var cookies
    
    var body: some HTML {
        Response {
            // Complex cookie logic if needed
        }
    }
}
```

## Implementation Considerations

### Context Injection

The property wrapper needs access to the current request:

```swift
protocol SwiftletContext {
    var request: Request { get }
    var cookies: CookieJar { get }
}

@propertyWrapper
struct Cookie<Value: Codable> {
    static subscript<EnclosingSelf: Swiftlet>(
        _enclosingInstance instance: EnclosingSelf,
        wrapped wrappedKeyPath: KeyPath<EnclosingSelf, Value?>,
        storage storageKeyPath: KeyPath<EnclosingSelf, Self>
    ) -> Value? {
        // Access context through instance
        // This requires Swiftlet protocol to provide context
    }
}
```

### Cookie Attributes

```swift
enum SameSite {
    case strict, lax, none
}

struct CookieOptions {
    var maxAge: TimeInterval?
    var expires: Date?
    var domain: String?
    var path: String = "/"
    var secure: Bool = false
    var httpOnly: Bool = false
    var sameSite: SameSite = .lax
}
```

### Response Evolution

Current Response structure needs to evolve:

```swift
struct Response {
    var status: HTTPStatus = .ok
    var headers: [String: String] = [:]
    var cookies: [HTTPCookie] = []
    var body: String
    
    // Builder methods
    mutating func setCookie(_ cookie: HTTPCookie) {
        cookies.append(cookie)
    }
    
    mutating func setHeader(_ name: String, value: String) {
        headers[name] = value
    }
}
```

## Migration Path

1. **Phase 1**: Implement basic @Cookie property wrapper for reading
2. **Phase 2**: Add Response wrapper with cookie/header modifiers
3. **Phase 3**: Enhance with environment support
4. **Phase 4**: Add advanced features (signed cookies, encryption)

## Open Questions

1. **Cookie Parsing**: When/where do we parse cookies from request headers?
2. **Serialization**: How do we handle complex types in cookies?
3. **Security**: Should we provide signed/encrypted cookies by default?
4. **Middleware**: How do cookies interact with future middleware?
5. **Testing**: How do we test cookie behavior in unit tests?

## Conclusion

The recommended approach balances SwiftUI familiarity with the practical needs of web development. By combining property wrappers for reading with a Response wrapper for writing, we maintain a declarative feel while providing explicit control over HTTP responses.

This design allows for future expansion while keeping the simple cases simple - a key principle of SwiftUI that we should maintain in Swiftlets.