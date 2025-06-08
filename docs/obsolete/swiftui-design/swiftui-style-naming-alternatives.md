# Naming Alternatives for SwiftletMetadata

## Current Name: SwiftletMetadata

Yes, this represents what goes in the HTML `<head>` tag, but "metadata" might be too generic.

## Alternative Names to Consider

### Option 1: PageHeader
```swift
protocol PageHeader {
    var title: String { get }
    var description: String? { get }
    var keywords: [String]? { get }
}

@main
struct HomePage: Swiftlet, PageHeader {
    var title = "Welcome"
    var body: some HTML { ... }
}
```

### Option 2: HTMLHead
```swift
protocol HTMLHead {
    var title: String { get }
    var description: String? { get }
}

@main
struct HomePage: Swiftlet, HTMLHead {
    var title = "Welcome"
    var body: some HTML { ... }
}
```

### Option 3: HeadMetadata
```swift
protocol HeadMetadata {
    var title: String { get }
    var description: String? { get }
}
```

### Option 4: PageMeta
```swift
protocol PageMeta {
    var title: String { get }
    var description: String? { get }
}
```

### Option 5: DocumentHead
```swift
protocol DocumentHead {
    var title: String { get }
    var description: String? { get }
}
```

## Analysis

| Name | Pros | Cons |
|------|------|------|
| SwiftletMetadata | Clear it's metadata | Not clear it's for HEAD |
| PageHeader | Clear and simple | "Header" might confuse with page header |
| HTMLHead | Very clear what it is | Mixes HTML concept with data |
| HeadMetadata | Best of both | A bit long |
| PageMeta | Short and clear | Maybe too abbreviated |
| DocumentHead | Professional | Might be verbose |

## Recommendation

I think **`PageMeta`** or **`DocumentHead`** work best because:
- Clear they represent the `<head>` section
- Don't confuse with visual headers
- Indicate it's data, not HTML structure

```swift
// With PageMeta
protocol PageMeta {
    var title: String { get }
    var description: String? { get }
    var keywords: [String]? { get }
    var author: String? { get }
    var stylesheets: [String]? { get }
    var scripts: [String]? { get }
}

protocol Swiftlet: HTMLComponent, PageMeta {
    init()
}

@main
struct BlogPost: Swiftlet {
    // PageMeta properties
    var title = "My Blog Post"
    var description = "An interesting article"
    var keywords = ["swift", "web", "development"]
    
    // HTMLComponent body
    var body: some HTML {
        Article {
            H1("My Blog Post")
            P("Content here...")
        }
    }
}
```

This makes it crystal clear:
- `PageMeta` = stuff that goes in `<head>`
- `body` = stuff that goes in `<body>`