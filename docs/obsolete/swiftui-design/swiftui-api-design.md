# SwiftUI-Style API Design for Swiftlets

## Executive Summary

Transform Swiftlets from boilerplate-heavy static functions to a clean, SwiftUI-inspired declarative API where developers focus only on content.

## Core Design Principles

### 1. No Boilerplate
Developers should NEVER write:
- JSON decoding from stdin
- Response object creation  
- Base64 encoding
- Print statements

### 2. Separation of Concerns
```swift
// Clear separation
var title = "Page Title"              // Metadata (not HTML!)
var body: some HTMLElement { }        // Body content (like SwiftUI View)
```

### 3. Property Wrappers for Data Access
```swift
@Query("name") var userName: String?
@FormValue("email") var email: String?
@Environment(\.request) var request
@Body var userData: Result<UserData, Error>
```

## The Complete API Design

### Protocol Hierarchy

```swift
// Base protocol for any HTML component (like SwiftUI View)
protocol HTMLComponent {
    associatedtype Body: HTMLElement  // Elements that go in <body>
    @HTMLBuilder var body: Body { get }
}

// Page metadata protocol (represents HTML <head> content)
protocol PageMeta {
    var title: String { get }
    var description: String? { get }
    var keywords: [String]? { get }
    var stylesheets: [String]? { get }
    // ... other <head> properties
}

// Full pages = metadata + component
protocol Swiftlet: HTMLComponent, PageMeta {
    init()
}
```

### Simple Example

```swift
@main
struct HomePage: Swiftlet {
    @Query("name") var userName: String?
    
    // Metadata as properties
    var title = "Welcome"
    var description = "Welcome to our homepage"
    var stylesheets = ["/styles/main.css"]
    
    // Body is just like SwiftUI View
    var body: some HTMLElement {
        H1("Hello, \(userName ?? "World")!")
        P("Welcome to Swiftlets")
    }
}
```

### Reusable Components

```swift
// Just like SwiftUI View!
struct NavigationBar: HTMLComponent {
    let currentPage: String
    
    var body: some HTML {
        Nav {
            Link(href: "/", "Home").class(currentPage == "home" ? "active" : "")
            Link(href: "/about", "About").class(currentPage == "about" ? "active" : "")
        }
    }
}

// Use in a page
@main
struct AboutPage: Swiftlet {
    // Metadata
    var title = "About Us"
    var description = "Learn more about our company"
    
    // Component body
    var body: some HTML {
        NavigationBar(currentPage: "about")
        
        Main {
            H1("About Us")
            P("We build great things")
        }
    }
}
```

## Property Wrappers

### Query Parameters
```swift
@Query("id") var productId: String?
@Query("page", default: "1") var pageNumber: String
```

### Form Data
```swift
@FormValue("email") var email: String?
@FormValue("password") var password: String?
```

### Request Body
```swift
// Automatic parsing based on Content-Type
@Body var userData: Result<UserData, Error>
```

### Environment
```swift
@Environment(\.request) var request
@Environment(\.context) var context
@Environment(\.storage) var storage
```

## POST Request Handling

```swift
@main
struct ContactForm: Swiftlet {
    @Environment(\.request) var request
    @FormValue("name") var name: String?
    @FormValue("message") var message: String?
    
    // Metadata
    var title = "Contact Us"
    var description = "Get in touch with our team"
    
    // Component body
    var body: some HTML {
        if request.method == .post {
            // Handle form submission
            if let name = name, let message = message {
                H1("Thank you, \(name)!")
                P("We received your message")
            } else {
                ErrorMessage("Please fill all fields")
            }
        } else {
            // Show form
            Form(action: "/contact", method: "post") {
                Input(type: "text", name: "name", placeholder: "Your name")
                TextArea(name: "message", placeholder: "Your message")
                Button(type: "submit", "Send")
            }
        }
    }
}
```

## Advanced Features

### Dynamic Metadata
```swift
@main
struct BlogPost: Swiftlet {
    @Environment(\.request) var request
    
    var post: BlogPost? {
        // Load based on URL...
    }
    
    // Metadata computed from content
    var title: String {
        post?.title ?? "Post Not Found"
    }
    
    var description: String? {
        post?.excerpt
    }
    
    var openGraph: OpenGraphMetadata? {
        guard let post = post else { return nil }
        return OpenGraphMetadata(
            title: post.title,
            description: post.excerpt,
            image: post.imageURL
        )
    }
    
    var body: some HTML {
        // Body content...
    }
}
```

### Layout System
```swift
protocol Layout {
    func metadata(extending base: any PageMeta) -> any PageMeta
    func body(wrapping content: any HTMLComponent) -> any HTMLComponent
}

@main
struct HomePage: Swiftlet {
    let layout = DefaultLayout()
    
    // Your content gets wrapped by layout
}
```

## Implementation Details

### Environment Flow
Using Swift's Task Local Storage for thread-safe environment passing:

```swift
@TaskLocal 
static var current: SwiftletEnvironment?

// Framework sets up environment before calling your code
SwiftletEnvironment.$current.withValue(environment) {
    let page = MyPage()
    render(page.head, page.body)
}
```

### Framework Handles Everything
```swift
extension Swiftlet {
    static func main() async throws {
        // 1. Parse request (hidden)
        // 2. Set up environment (hidden)
        // 3. Create instance
        let page = Self()
        // 4. Render HTML
        let html = Html {
            Head { page.head }
            Body { page.body }
        }
        // 5. Send response (hidden)
    }
}
```

## Benefits Over Current Approach

1. **Zero Boilerplate** - Focus only on content
2. **Type Safety** - Can't mix head/body elements
3. **Reusability** - Components work like SwiftUI views
4. **Testability** - Easy to test without protocol details
5. **Familiar** - SwiftUI developers feel at home

## Migration Path

### Phase 1: Add New API
- Implement protocols alongside existing API
- No breaking changes

### Phase 2: Migration Tools
- Automated migration scripts
- Documentation and examples

### Phase 3: Deprecate Old API
- Mark old API as deprecated
- Remove in next major version

## Next Steps

1. Implement core protocols
2. Build property wrappers
3. Create proof of concept
4. Gather feedback
5. Refine API
6. Build migration tools