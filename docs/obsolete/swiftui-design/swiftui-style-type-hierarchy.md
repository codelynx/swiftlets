# Type Hierarchy Clarification

## The Conceptual Model

```
HTML Document
├── HEAD (metadata)
└── BODY (components)
```

## Current Confusion

We're currently using `HTML` for everything, but that's wrong:

```swift
// WRONG - HTML means complete document!
var body: some HTML {
    H1("Hello")
}
```

## Correct Type Hierarchy

```swift
// Base types
protocol HTMLElement { }  // Any HTML element
protocol HTMLComponent: HTMLElement { }  // Elements valid in <body>
protocol HTMLDocument { }  // Complete HTML document

// Specific elements
struct H1: HTMLComponent { }
struct P: HTMLComponent { }
struct Div: HTMLComponent { }

// Metadata elements (not HTMLComponent!)
struct Title: HTMLElement { }  // Only valid in <head>
struct Meta: HTMLElement { }   // Only valid in <head>

// Document
struct Html: HTMLDocument {
    let head: Head
    let body: Body
}
```

## Updated Protocol Design

```swift
// Component protocol (for body content)
protocol Component {
    associatedtype Body: HTMLComponent
    @ComponentBuilder var body: Body { get }
}

// Page metadata protocol
protocol PageMeta {
    var title: String { get }
    var description: String? { get }
    // ...
}

// Full page
protocol Swiftlet: Component, PageMeta {
    init()
}

// Usage
@main
struct HomePage: Swiftlet {
    // Metadata
    var title = "Home"
    
    // Body must return HTMLComponent, not HTML!
    var body: some HTMLComponent {
        Div {
            H1("Welcome")
            P("Hello world")
        }
    }
}
```

## Why This Matters

1. **Type Safety**: Can't put `<body>` elements in `<head>` or vice versa
2. **Clarity**: `HTML` means complete document, `HTMLComponent` means body content
3. **Correctness**: Matches actual HTML structure

## The Framework's Job

```swift
extension Swiftlet {
    static func main() async throws {
        let page = Self()
        
        // Framework builds the complete HTML document
        let document = Html {
            Head {
                Title(page.title)
                // ... other metadata converted to elements
            }
            Body {
                page.body  // This is HTMLComponent, not HTML!
            }
        }
        
        // Now we have a complete HTML document
        let rendered = document.render()
    }
}
```

## Summary

- `HTML` = Complete document
- `HTMLComponent` = Body content only
- `HTMLElement` = Any element (head or body)
- `var body: some HTMLComponent` ✓ Correct
- `var body: some HTML` ✗ Wrong!