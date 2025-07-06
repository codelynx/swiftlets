# SwiftUI-Style API for Swiftlets - Final Design

## Overview

Transform Swiftlets from boilerplate-heavy static functions to a clean, SwiftUI-inspired API where developers focus only on their content.

## Core Design Decisions

### 1. Zero Boilerplate
Developers write NO:
- JSON decoding
- Response creation
- Base64 encoding
- Protocol handling

### 2. Clean Separation
- **HTML header** (title, meta tags) as simple properties
- **Body content** as HTMLElement with a `body` property
- Just like SwiftUI separates App, Scene, and View

### 3. Type Safety
- Separate types for HEAD and BODY elements
- Compile-time prevention of mixing contexts
- Clear protocol hierarchy

## The API

### Core Protocols

```swift
// Component protocol (like SwiftUI View)
protocol HTMLComponent {
    associatedtype Body: HTMLElement
    @HTMLBuilder var body: Body { get }
}

// HTML Header protocol - defines what goes in <head>
protocol HTMLHeader {
    var title: String { get }  // Only mandatory field
    var meta: [String: String] { get }  // All other metadata
}

// Default implementation
extension HTMLHeader {
    var meta: [String: String] { [:] }
}

// Full page = header + component
protocol Swiftlet: HTMLComponent, HTMLHeader {
    init()
}
```

### Simple Example

```swift
@main
struct HomePage: Swiftlet {
    @Query("name") var userName: String?
    
    // Simple metadata
    var title = "Welcome"
    var meta = [
        "description": "Welcome to our site",
        "viewport": "width=device-width, initial-scale=1.0"
    ]
    
    // HTMLComponent body
    var body: some HTMLElement {
        Container {
            H1("Hello, \(userName ?? "World")!")
            P("Welcome to Swiftlets")
        }
    }
}
```

### Property Wrappers

```swift
// Query parameters
@Query("id") var productId: String?
@Query("page", default: "1") var pageNumber: String

// Form data
@FormValue("email") var email: String?
@FormValue("password") var password: String?

// Request body with automatic parsing
@Body var userData: Result<UserData, Error>

// Environment access
@Environment(\.request) var request
@Environment(\.context) var context
@Environment(\.storage) var storage
@Environment(\.resources) var resources
```

### Reusable Components

```swift
struct NavigationBar: HTMLComponent {
    let currentPage: String
    
    var body: some HTMLElement {
        Nav {
            Link(href: "/", "Home")
                .class(currentPage == "home" ? "active" : "")
            Link(href: "/about", "About")
                .class(currentPage == "about" ? "active" : "")
        }
    }
}

// Use in pages
@main
struct AboutPage: Swiftlet {
    var title = "About Us"
    var meta = ["description": "Learn more about our company"]
    
    var body: some HTMLElement {
        NavigationBar(currentPage: "about")
        Main {
            H1("About Us")
            P("We build great software")
        }
    }
}
```

### POST Request Handling

```swift
@main
struct ContactForm: Swiftlet {
    @Environment(\.request) var request
    @FormValue("name") var name: String?
    @FormValue("message") var message: String?
    
    var title = "Contact Us"
    var meta = ["description": "Get in touch with our team"]
    
    var body: some HTMLElement {
        Container {
            if request.method == .post {
                handleSubmission()
            } else {
                showForm()
            }
        }
    }
    
    @BodyBuilder
    func handleSubmission() -> some HTMLElement {
        if let name = name, let message = message {
            VStack {
                H1("Thank you, \(name)!")
                P("We received your message.")
            }
        } else {
            ErrorMessage("Please fill all fields")
        }
    }
    
    @BodyBuilder
    func showForm() -> some HTMLElement {
        Form(action: "/contact", method: "post") {
            Label("Name:")
            Input(type: "text", name: "name").required()
            
            Label("Message:")
            TextArea(name: "message").required()
            
            Button(type: "submit", "Send")
        }
    }
}
```

### Dynamic Metadata

```swift
@main
struct BlogPost: Swiftlet {
    @Environment(\.request) var request
    
    var post: Post? {
        // Load from storage/database
    }
    
    // Dynamic metadata
    var title: String {
        post?.title ?? "Post Not Found"
    }
    
    var meta: [String: String] {
        guard let post = post else {
            return ["robots": "noindex"]
        }
        
        return [
            "description": post.excerpt,
            "author": post.author,
            "keywords": post.tags.joined(separator: ","),
            "og:title": post.title,
            "og:description": post.excerpt,
            "og:image": post.imageURL,
            "og:type": "article",
            "article:published_time": post.date.ISO8601Format()
        ]
    }
    
    var body: some HTMLElement {
        if let post = post {
            Article {
                H1(post.title)
                Time(post.date.formatted())
                Div(post.content)
            }
        } else {
            NotFound()
        }
    }
}
```

## How HEAD Content Works

HEAD content is just a **dictionary of metadata**:

```swift
@main
struct BlogPost: Swiftlet {
    // Required title
    var title = "My Blog Post"
    
    // Everything else is optional key-value pairs
    var meta = [
        "description": "An interesting article",
        "keywords": "swift,web,development",
        "author": "Jane Doe",
        "viewport": "width=device-width, initial-scale=1.0",
        
        // Open Graph
        "og:title": "My Blog Post",
        "og:description": "An interesting article", 
        "og:image": "/images/blog-hero.jpg",
        "og:type": "article",
        
        // Twitter Card
        "twitter:card": "summary_large_image",
        "twitter:title": "My Blog Post"
    ]
    
    // Body has actual HTML elements
    var body: some HTMLElement {
        Article {
            H1("My Blog Post")
            P("Content goes here...")
        }
    }
}
```

The framework converts the dictionary to HTML:
```html
<head>
    <title>My Blog Post</title>
    <meta name="description" content="An interesting article">
    <meta name="keywords" content="swift,web,development">
    <meta name="author" content="Jane Doe">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta property="og:title" content="My Blog Post">
    <meta property="og:description" content="An interesting article">
    <meta property="og:image" content="/images/blog-hero.jpg">
    <meta property="og:type" content="article">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="My Blog Post">
</head>
```

Simple and flexible!

## Environment System

Using Swift's Task Local Storage for thread-safe environment:

```swift
@TaskLocal
static var current: SwiftletEnvironment?

// Property wrapper implementation
@propertyWrapper
struct Environment<Value> {
    let keyPath: KeyPath<SwiftletEnvironment, Value>
    
    var wrappedValue: Value {
        SwiftletEnvironment.current![keyPath: keyPath]
    }
}
```

## Benefits

1. **Zero boilerplate** - Focus only on content
2. **Type safe** - Can't mix HEAD/BODY elements
3. **Familiar** - Just like SwiftUI
4. **Testable** - Easy to test components
5. **Composable** - Build complex UIs from simple parts

## What Developers Write vs What They Don't

### They Write ✅
```swift
var title = "My Page"
var body: some HTMLElement {
    H1("Hello World")
}
```

### They DON'T Write ❌
```swift
let request = try JSONDecoder().decode(...)
let response = Response(status: 200, ...)
print(try JSONEncoder().encode(...))
```

The framework handles ALL the plumbing!