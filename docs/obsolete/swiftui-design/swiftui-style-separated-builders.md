# Separated HEAD and BODY Builders Design

## The Concept

Instead of mixing HEAD and BODY content in one place, separate them into focused protocols:

```swift
// Current approach - everything mixed
var body: some HTML {
    Html {
        Head { Title("Page") }  // HEAD stuff mixed with body
        Body { H1("Hello") }    // Actual content
    }
}

// Proposed approach - clear separation
var head: some HeadContent {
    Title("Page")
    Meta(charset: "utf-8")
    LinkElement(rel: "stylesheet", href: "/styles.css")
}

var body: some BodyContent {
    H1("Hello")
    P("Welcome to the page")
}
```

## Protocol Hierarchy

```swift
// Base protocols for different content types
protocol HeadContent: HTML {
    // Can only contain head-valid elements
}

protocol BodyContent: HTML {
    // Can only contain body-valid elements
}

protocol HTMLDocument {
    associatedtype Head: HeadContent
    associatedtype Body: BodyContent
    
    @HeadBuilder var head: Head { get }
    @BodyBuilder var body: Body { get }
}

// For reusable components (like SwiftUI Views)
protocol HTMLComponent {
    associatedtype Content: BodyContent
    @BodyBuilder var content: Content { get }
}

// Main Swiftlet protocol
protocol Swiftlet: HTMLDocument {
    init()
}
```

## Examples

### Simple Page

```swift
@main
struct HomePage: Swiftlet {
    var head: some HeadContent {
        Title("Welcome")
        Meta(name: "description", content: "Welcome to our site")
        LinkElement(rel: "stylesheet", href: "/styles/main.css")
    }
    
    var body: some BodyContent {
        Header {
            Nav {
                Link(href: "/", "Home")
                Link(href: "/about", "About")
            }
        }
        
        Main {
            H1("Welcome to Swiftlets")
            P("Build web apps with Swift")
        }
        
        Footer {
            P("© 2025")
        }
    }
}
```

### Reusable Components

```swift
// Define reusable components
struct NavigationBar: HTMLComponent {
    let currentPage: String
    
    var content: some BodyContent {
        Nav {
            Container {
                HStack {
                    Link(href: "/", "Home").class(currentPage == "home" ? "active" : "")
                    Link(href: "/blog", "Blog").class(currentPage == "blog" ? "active" : "")
                    Link(href: "/about", "About").class(currentPage == "about" ? "active" : "")
                }
            }
        }
    }
}

struct PageFooter: HTMLComponent {
    var content: some BodyContent {
        Footer {
            Container {
                P("© 2025 My Company")
                HStack {
                    Link(href: "/privacy", "Privacy")
                    Link(href: "/terms", "Terms")
                }
            }
        }
    }
}

// Use components in pages
@main
struct BlogPage: Swiftlet {
    @Environment(\.request) var request
    
    var head: some HeadContent {
        Title("Blog - My Site")
        Meta(name: "description", content: "Read our latest posts")
    }
    
    var body: some BodyContent {
        NavigationBar(currentPage: "blog")
        
        Main {
            Container {
                H1("Blog Posts")
                ForEach(posts) { post in
                    BlogPostCard(post: post)
                }
            }
        }
        
        PageFooter()
    }
}
```

### Dynamic HEAD Content

```swift
@main
struct ProductPage: Swiftlet {
    @Environment(\.request) var request
    
    var productId: String? {
        request.path.components.last
    }
    
    var product: Product? {
        // Load product...
    }
    
    var head: some HeadContent {
        if let product = product {
            Title("\(product.name) - Store")
            Meta(name: "description", content: product.description)
            Meta(property: "og:title", content: product.name)
            Meta(property: "og:image", content: product.imageURL)
            Meta(property: "og:price:amount", content: String(product.price))
        } else {
            Title("Product Not Found - Store")
            Meta(name: "robots", content: "noindex")
        }
    }
    
    var body: some BodyContent {
        if let product = product {
            ProductDetail(product: product)
        } else {
            NotFound()
        }
    }
}
```

## Benefits

1. **Clear Separation of Concerns**
   - HEAD content is about metadata, SEO, resources
   - BODY content is about visible UI
   - No mixing of concerns

2. **Type Safety**
   - Can't accidentally put body elements in head
   - Can't put head elements in body
   - Compiler enforces correct structure

3. **Better Reusability**
   - Components only deal with body content
   - No need to worry about HTML structure
   - Similar to SwiftUI View protocol

4. **Cleaner Code**
   - Each section has its own space
   - Easier to find and modify metadata
   - Better organization

## Framework Implementation

```swift
// The framework handles combining them
extension Swiftlet {
    public static func main() async throws {
        // ... setup code ...
        
        let instance = Self()
        
        // Framework combines head and body
        let html = Html {
            Head {
                instance.head
            }
            Body {
                instance.body
            }
        }
        
        // ... response handling ...
    }
}
```

## Advanced: Shared Layout

```swift
// Define a layout protocol
protocol Layout {
    associatedtype HeadContent: Swiftlets.HeadContent
    associatedtype BodyContent: Swiftlets.BodyContent
    
    func head(for page: any Swiftlet) -> HeadContent
    func body(wrapping content: any BodyContent) -> BodyContent
}

struct DefaultLayout: Layout {
    func head(for page: any Swiftlet) -> some HeadContent {
        // Common head elements
        Meta(charset: "utf-8")
        Meta(name: "viewport", content: "width=device-width, initial-scale=1")
        LinkElement(rel: "stylesheet", href: "/styles/main.css")
        
        // Page-specific head
        page.head
    }
    
    func body(wrapping content: any BodyContent) -> some BodyContent {
        NavigationBar()
        content
        PageFooter()
    }
}

// Pages can use layouts
@main
struct HomePage: Swiftlet {
    var layout = DefaultLayout()
    
    var head: some HeadContent {
        Title("Home")
    }
    
    var body: some BodyContent {
        H1("Welcome")
        P("This content gets wrapped by the layout")
    }
}
```

## Comparison with Current Approach

### Current (Mixed)
```swift
var body: some HTML {
    Html {
        Head {
            Title("Page")
            Meta(...)
            LinkElement(...)
        }
        Body {
            H1("Content")
            P("Text")
        }
    }
}
```

### Proposed (Separated)
```swift
var head: some HeadContent {
    Title("Page")
    Meta(...)
    LinkElement(...)
}

var body: some BodyContent {
    H1("Content")
    P("Text")
}
```

The separated approach is:
- Cleaner
- More organized
- Type-safe
- Easier to maintain
- More SwiftUI-like