# How Ignite Renders HTML Using Result Builders

## Overview

Ignite leverages Swift's result builder feature to create a SwiftUI-like declarative syntax for building HTML. This document explains the architecture and implementation details of how Swift code gets transformed into HTML strings.

## Architecture Overview

```
Swift Code → Result Builder → HTML Protocol → Type Erasure → Markup → HTML String
```

## Core Components

### 1. Result Builders

Ignite defines several result builders for different contexts:

#### @HTMLBuilder
The primary result builder for constructing HTML element hierarchies.

```swift
@resultBuilder
public struct HTMLBuilder {
    // Handles single elements
    public static func buildBlock<T: HTML>(_ element: T) -> T
    
    // Handles collections of elements
    public static func buildBlock(_ elements: any HTML...) -> HTMLCollection
    
    // Handles conditionals
    public static func buildOptional(_ wrapped: (any HTML)?) -> AnyHTML
    
    // Handles if-else branches
    public static func buildEither(first component: any HTML) -> AnyHTML
    public static func buildEither(second component: any HTML) -> AnyHTML
    
    // Handles loops
    public static func buildArray(_ components: [any HTML]) -> HTMLCollection
    
    // Sequential combination using buildPartialBlock
    public static func buildPartialBlock(first: any HTML) -> AnyHTML
    public static func buildPartialBlock(accumulated: any HTML, next: any HTML) -> AnyHTML
}
```

#### Other Specialized Builders
- **@InlineElementBuilder**: For inline elements like text, spans, and links
- **@ElementBuilder<T>**: Generic builder for arrays of specific element types
- **@DocumentElementBuilder**: For building document structure (Head + Body)

### 2. Core Protocols

#### MarkupElement Protocol
The base protocol that all HTML elements must conform to:

```swift
public protocol MarkupElement {
    var attributes: CoreAttributes { get set }
    func markup() -> Markup
}
```

#### HTML Protocol
Main protocol for body elements:

```swift
public protocol HTML: BodyElement {
    associatedtype Body: HTML
    @HTMLBuilder var body: Body { get }
}
```

#### Protocol Hierarchy
```
MarkupElement
    ├── HeadElement (elements in <head>)
    ├── BodyElement (elements in <body>)
    │   └── HTML (has body property)
    └── InlineElement (inline text elements)
```

### 3. Type Erasure System

To handle heterogeneous collections of HTML elements, Ignite uses type erasure:

#### AnyHTML
Wraps any HTML element to provide a uniform type:

```swift
public struct AnyHTML: HTML {
    private let wrapped: any HTML
    
    public var body: some HTML {
        wrapped
    }
    
    public func markup() -> Markup {
        wrapped.markup()
    }
}
```

#### HTMLCollection
Represents multiple HTML elements:

```swift
public struct HTMLCollection: HTML {
    private let elements: [any HTML]
    
    public func markup() -> Markup {
        elements.map { $0.markup() }.joined()
    }
}
```

### 4. The Rendering Pipeline

#### Step 1: Result Builder Collection
When you write code like:

```swift
VStack {
    Text("Hello")
    Link("World", target: "/")
}
```

The `@HTMLBuilder` collects these elements.

#### Step 2: Type Resolution
- Single elements remain as their specific type
- Multiple elements are wrapped in `HTMLCollection`
- Conditionals and loops are wrapped in `AnyHTML`

#### Step 3: Markup Generation
Each element implements `markup()` to generate its HTML:

```swift
// Example from Text element
public struct Text: InlineElement {
    let content: String
    let font: Font
    var attributes = CoreAttributes()
    
    public func markup() -> Markup {
        Markup(
            "<\(font.rawValue)\(attributes)>" +
            content.markupString() +
            "</\(font.rawValue)>"
        )
    }
}
```

#### Step 4: Attribute Rendering
`CoreAttributes` manages all HTML attributes:

```swift
public struct CoreAttributes {
    var classes: [String] = []
    var styles: [String: String] = [:]
    var data: [String: String] = [:]
    var customAttributes: [(String, String)] = []
    var events: [String: String] = [:]
    
    // Renders to HTML attribute string
    // Example: class="btn primary" style="color: red;" data-id="123"
}
```

### 5. Modifier Pattern

Modifiers create modified copies of elements:

```swift
extension HTML {
    public func font(_ newFont: Font) -> some HTML {
        var copy = self
        copy.attributes.classes.append(newFont.className)
        return copy
    }
    
    public func foregroundStyle(_ color: Color) -> some HTML {
        var copy = self
        copy.attributes.styles["color"] = color.hexValue
        return copy
    }
}
```

### 6. Complete Example

Here's how a complex structure gets rendered:

```swift
// Swift Code
Card {
    Text("Welcome")
        .font(.title1)
        .foregroundStyle(.blue)
    
    if showDetails {
        Text("Details here")
    }
}
.padding(20)

// Result Builder Output
Card(
    body: AnyHTML(
        HTMLCollection([
            AnyHTML(Text("Welcome")
                .font(.title1)
                .foregroundStyle(.blue)),
            AnyHTML(Text("Details here"))
        ])
    )
)
.padding(20)

// Final HTML
<div class="card p-4">
    <h1 style="color: #0000FF;">Welcome</h1>
    <p>Details here</p>
</div>
```

## Key Design Decisions

### 1. Protocol-Oriented Design
Using protocols allows for flexible element types while maintaining type safety.

### 2. Value Semantics
All elements are structs, making them lightweight and allowing for safe copying during modifier application.

### 3. Lazy Rendering
HTML is only generated when `markup()` is called, allowing for efficient composition.

### 4. SwiftUI-like API
Familiar patterns for Swift developers, reducing the learning curve.

### 5. Type Erasure
Enables heterogeneous collections while maintaining the benefits of Swift's type system.

## Performance Considerations

1. **String Concatenation**: The rendering uses efficient string building
2. **Copy-on-Write**: Swift's struct semantics minimize unnecessary copying
3. **Lazy Evaluation**: HTML generation happens only when needed
4. **Static Dispatch**: Where possible, uses concrete types for performance

## Conclusion

Ignite's result builder system provides a powerful, type-safe way to generate HTML using familiar Swift patterns. The architecture cleanly separates the declarative API from the HTML generation logic, making it both maintainable and extensible.