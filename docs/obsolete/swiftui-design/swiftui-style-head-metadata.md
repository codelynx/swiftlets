# HEAD as Metadata, Not HTML

## The Problem with Current Approach

Currently, we treat HEAD content like HTML:
```swift
Head {
    Title("My Page")
    Meta(name: "description", content: "...")
    LinkElement(rel: "stylesheet", href: "...")
}
```

But HEAD isn't really about building HTML - it's about declaring metadata!

## Better Approach: Metadata Declaration

```swift
@main
struct HomePage: Swiftlet {
    // HEAD is just metadata properties
    var title = "Welcome to My Site"
    var description = "A great website built with Swiftlets"
    var keywords = ["swift", "web", "framework"]
    var stylesheets = ["/styles/main.css", "/styles/home.css"]
    var scripts = ["/js/app.js"]
    
    // Custom metadata
    var openGraph = OpenGraphMetadata(
        title: "Welcome",
        image: "/images/hero.jpg",
        type: "website"
    )
    
    // BODY is the actual HTML content
    var body: some HTML {
        H1("Welcome!")
        P("This is the actual content")
    }
}
```

## Protocol Design

```swift
// Component protocol (like SwiftUI View)
protocol HTMLComponent {
    associatedtype Body: HTML
    @HTMLBuilder var body: Body { get }
}

// Page metadata protocol (for <head> content)
protocol PageMeta {
    var title: String { get }
    var description: String? { get }
    var keywords: [String]? { get }
    var author: String? { get }
    var viewport: String? { get }
    var charset: String? { get }
    var stylesheets: [String]? { get }
    var scripts: [HeadScript]? { get }
    var customMeta: [MetaTag]? { get }
}

// Provide sensible defaults
extension PageMeta {
    var description: String? { nil }
    var keywords: [String]? { nil }
    var author: String? { nil }
    var viewport: String? { "width=device-width, initial-scale=1.0" }
    var charset: String? { "utf-8" }
    var stylesheets: [String]? { nil }
    var scripts: [HeadScript]? { nil }
    var customMeta: [MetaTag]? { nil }
}

// Full page = component + metadata
protocol Swiftlet: HTMLComponent, PageMeta {
    init()
}
```

## Clean Examples

### Simple Page
```swift
@main
struct AboutPage: Swiftlet {
    var title = "About Us"
    var description = "Learn more about our company"
    
    var body: some HTML {
        H1("About Us")
        P("We are a great company")
    }
}
```

### Blog Post with Rich Metadata
```swift
@main
struct BlogPost: Swiftlet {
    @Environment(\.request) var request
    
    // Computed metadata based on content
    var post: Post? {
        // Load post...
    }
    
    var title: String {
        post?.title ?? "Post Not Found"
    }
    
    var description: String? {
        post?.excerpt
    }
    
    var keywords: [String]? {
        post?.tags
    }
    
    var customMeta: [MetaTag]? {
        guard let post = post else { 
            return [MetaTag(name: "robots", content: "noindex")]
        }
        
        return [
            MetaTag(property: "og:title", content: post.title),
            MetaTag(property: "og:description", content: post.excerpt),
            MetaTag(property: "og:image", content: post.imageURL),
            MetaTag(property: "article:author", content: post.author),
            MetaTag(property: "article:published_time", content: post.date.ISO8601Format())
        ]
    }
    
    var body: some HTML {
        if let post = post {
            Article {
                H1(post.title)
                Div(post.content)
            }
        } else {
            NotFound()
        }
    }
}
```

## Advanced: Structured Metadata Types

```swift
// Type-safe metadata structures
struct OpenGraphMetadata {
    let title: String
    let description: String?
    let image: String?
    let type: String
    let url: String?
}

struct TwitterCardMetadata {
    let card: TwitterCardType
    let title: String
    let description: String?
    let image: String?
    let creator: String?
}

enum TwitterCardType: String {
    case summary
    case summaryLargeImage = "summary_large_image"
    case app
    case player
}

// Rich metadata protocol
protocol RichMetadata: SwiftletMetadata {
    var openGraph: OpenGraphMetadata? { get }
    var twitterCard: TwitterCardMetadata? { get }
    var jsonLD: JSONLDSchema? { get }
}

// Usage
@main
struct ProductPage: Swiftlet, RichMetadata {
    var product: Product
    
    var title: String { product.name }
    var description: String? { product.description }
    
    var openGraph: OpenGraphMetadata? {
        OpenGraphMetadata(
            title: product.name,
            description: product.description,
            image: product.images.first,
            type: "product",
            url: "https://example.com/products/\(product.id)"
        )
    }
    
    var jsonLD: JSONLDSchema? {
        ProductSchema(
            name: product.name,
            description: product.description,
            image: product.images,
            price: PriceSpecification(
                price: product.price,
                currency: "USD"
            ),
            availability: product.inStock ? .inStock : .outOfStock
        )
    }
    
    var body: some HTML {
        ProductDetail(product: product)
    }
}
```

## Why This Is Better

1. **Semantic** - HEAD content is metadata, not HTML structure
2. **Type-safe** - Properties instead of stringly-typed elements
3. **Discoverable** - Autocomplete shows available metadata options
4. **Validatable** - Can validate required fields at compile time
5. **Transformable** - Framework can optimize/transform metadata

## Framework Implementation

The framework converts metadata to HTML:

```swift
extension Swiftlet {
    // Framework generates the HEAD element
    internal var generatedHead: String {
        var html = ""
        
        // Required elements
        html += "<title>\(escapeHTML(title))</title>"
        
        if let charset = charset {
            html += "<meta charset=\"\(charset)\">"
        }
        
        if let viewport = viewport {
            html += "<meta name=\"viewport\" content=\"\(viewport)\">"
        }
        
        if let description = description {
            html += "<meta name=\"description\" content=\"\(escapeHTML(description))\">"
        }
        
        // Stylesheets
        stylesheets?.forEach { stylesheet in
            html += "<link rel=\"stylesheet\" href=\"\(stylesheet)\">"
        }
        
        // OpenGraph
        if let og = (self as? RichMetadata)?.openGraph {
            html += generateOpenGraphTags(og)
        }
        
        return html
    }
}
```

## Comparison

### Old Way (HTML-like)
```swift
var head: some HeadContent {
    Title("My Page")
    Meta(name: "description", content: "Description")
    Meta(property: "og:title", content: "My Page")
    Meta(property: "og:image", content: "/image.jpg")
    LinkElement(rel: "stylesheet", href: "/style.css")
}
```

### New Way (Metadata)
```swift
var title = "My Page"
var description = "Description"
var stylesheets = ["/style.css"]
var openGraph = OpenGraphMetadata(
    title: "My Page",
    image: "/image.jpg",
    type: "website"
)
```

Much cleaner and more semantic!