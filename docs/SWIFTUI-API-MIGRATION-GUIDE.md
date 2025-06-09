# SwiftUI-Style API Migration Guide

This guide helps you migrate existing Swiftlets from the traditional API to the new SwiftUI-style API.

## Quick Comparison

### Traditional API
```swift
import Swiftlets

struct MyPage: Swiftlet {
    func handle(_ request: Request) -> Response {
        // Decode request
        let params = request.queryParameters
        
        // Build HTML
        let html = Html {
            Body {
                H1("Hello, \(params["name"] ?? "World")!")
            }
        }.render()
        
        // Create response
        return Response(
            status: 200,
            headers: ["Content-Type": "text/html"],
            body: html
        )
    }
}
```

### SwiftUI-Style API
```swift
import Swiftlets

@main
struct MyPage: SwiftletMain {
    @Query("name") var name: String?
    
    var title = "My Page"
    var meta: [String: String] = [:]
    
    var body: some HTMLElement {
        H1("Hello, \(name ?? "World")!")
    }
}
```

## Step-by-Step Migration

### 1. Change Protocol and Add @main

**Before:**
```swift
struct HomePage: Swiftlet {
    func handle(_ request: Request) -> Response {
        // ...
    }
}
```

**After:**
```swift
@main
struct HomePage: SwiftletMain {
    var title = "Home"
    var meta: [String: String] = [:]
    
    var body: some HTMLElement {
        // ...
    }
}
```

### 2. Replace Request Parameter Access

**Query Parameters**

Before: `request.queryParameters["name"]`

After: `@Query("name") var name: String?`

**Form Values**

Before:
```swift
let bodyData = Data(base64Encoded: request.body ?? "")!
let bodyString = String(data: bodyData, encoding: .utf8)!
// Parse form data manually
```

After: `@FormValue("email") var email: String?`

**JSON Body**

Before:
```swift
let bodyData = Data(base64Encoded: request.body ?? "")!
let model = try JSONDecoder().decode(MyModel.self, from: bodyData)
```

After: `@JSONBody var model: MyModel?`

**Cookies**

Before: Parse from `request.headers["Cookie"]`

After: `@Cookie("session") var sessionId: String?`

### 3. Replace HTML Building

**Before:**
```swift
let html = Html {
    Head {
        Title("My Page")
        Meta(name: "description", content: "My description")
    }
    Body {
        // content
    }
}.render()
```

**After:**
```swift
var title = "My Page"
var meta = ["description": "My description"]

var body: some HTMLElement {
    // content (Body wrapper is automatic)
}
```

### 4. Handle Response Headers and Cookies

**Setting Headers**

Before:
```swift
return Response(
    status: 200,
    headers: [
        "Content-Type": "text/html",
        "X-Custom": "value"
    ],
    body: html
)
```

After:
```swift
var body: ResponseBuilder {
    ResponseWith {
        // content
    }
    .header("X-Custom", value: "value")
}
```

**Setting Cookies**

Before: Manually construct Set-Cookie header

After:
```swift
var body: ResponseBuilder {
    ResponseWith {
        // content
    }
    .cookie("theme", value: "dark", maxAge: 86400, httpOnly: true)
}
```

## Complete Migration Example

### Traditional Implementation
```swift
import Swiftlets

struct BlogPost: Swiftlet {
    func handle(_ request: Request) -> Response {
        // Get post ID
        guard let postId = request.queryParameters["id"] else {
            return Response(status: 404, headers: [:], body: "Not found")
        }
        
        // Check for theme cookie
        var theme = "light"
        if let cookieHeader = request.headers["Cookie"] {
            // Parse cookies manually
            let cookies = cookieHeader.split(separator: ";")
            for cookie in cookies {
                let parts = cookie.split(separator: "=")
                if parts.count == 2 && parts[0].trimmingCharacters(in: .whitespaces) == "theme" {
                    theme = String(parts[1])
                }
            }
        }
        
        // Build HTML
        let html = Html {
            Head {
                Title("Blog Post \(postId)")
                Meta(name: "description", content: "Blog post")
            }
            Body {
                Div {
                    H1("Post \(postId)")
                    P("Current theme: \(theme)")
                }
                .classes("container", theme)
            }
        }.render()
        
        return Response(
            status: 200,
            headers: ["Content-Type": "text/html"],
            body: html
        )
    }
}
```

### SwiftUI-Style Implementation
```swift
import Swiftlets

@main
struct BlogPost: SwiftletMain {
    @Query("id") var postId: String?
    @Cookie("theme") var theme = "light"
    
    var title: String {
        "Blog Post \(postId ?? "Unknown")"
    }
    
    var meta = ["description": "Blog post"]
    
    var body: some HTMLElement {
        if let postId = postId {
            Div {
                H1("Post \(postId)")
                P("Current theme: \(theme)")
            }
            .classes("container", theme)
        } else {
            return Text("Not found")  // Server will return 404
        }
    }
}
```

## Migration Checklist

- [ ] Add `@main` attribute
- [ ] Change from `Swiftlet` to `SwiftletMain` protocol
- [ ] Remove `handle(_ request:)` method
- [ ] Add `title` and `meta` properties
- [ ] Add `body` property with `some HTMLElement` return type
- [ ] Replace request parameter access with property wrappers
- [ ] Remove manual JSON encoding/decoding
- [ ] Remove HTML document structure (automatic now)
- [ ] Use `ResponseBuilder` for headers/cookies if needed
- [ ] Update Package.swift executables if needed

## Gradual Migration

Both APIs can coexist! You can:
1. Keep existing swiftlets using the traditional API
2. Write new swiftlets using the SwiftUI-style API
3. Migrate swiftlets one at a time
4. The server automatically detects which API each swiftlet uses

## Common Gotchas

1. **Body Property Name**: `@JSONBody` not `@Body` (to avoid conflict with HTML Body element)
2. **Response Type**: Use `ResponseBuilder` as return type when setting cookies/headers
3. **Optional Handling**: Property wrappers return optionals, use nil-coalescing or if-let
4. **Computed Properties**: Use computed properties for dynamic title/meta values
5. **Empty Content**: Return `EmptyHTML()` for conditional empty content

## Getting Help

- See [SWIFTUI-API-IMPLEMENTATION.md](./SWIFTUI-API-IMPLEMENTATION.md) for detailed documentation
- See [SWIFTUI-API-REFERENCE.md](./SWIFTUI-API-REFERENCE.md) for API reference
- Check [examples](../sites/test/swiftui-api-example/) for working code