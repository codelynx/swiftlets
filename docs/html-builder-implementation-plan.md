# HTML Component Builder Implementation Plan

## Overview

This document outlines the implementation plan for Swiftlets' HTML component system using Swift result builders, inspired by Ignite but adapted for server-side dynamic rendering.

## Core Design Principles

1. **Familiar SwiftUI-like syntax** for HTML generation
2. **Server-side focus** with dynamic data binding
3. **Type-safe** HTML construction
4. **Extensible** for custom components
5. **Performance-oriented** for request handling

## Architecture Overview

### 1. Protocol Hierarchy

```swift
// Base protocol for all HTML elements
protocol HTMLElement {
    var attributes: HTMLAttributes { get set }
    func render() -> String
}

// Elements that can contain other elements
protocol HTMLContainer: HTMLElement {
    associatedtype Content: HTMLElement
    @HTMLBuilder var content: Content { get }
}

// Inline elements (text, spans, links)
protocol HTMLInline: HTMLElement { }

// Page-level component protocol
protocol Component {
    associatedtype Body: HTMLElement
    @HTMLBuilder var body: Body { get }
}
```

### 2. Core Types

```swift
// Attribute storage
struct HTMLAttributes {
    var id: String?
    var classes: Set<String> = []
    var styles: [String: String] = [:]
    var data: [String: String] = [:]
    var events: [String: String] = []
    var custom: [(String, String)] = []
}

// Type-erasing wrapper
struct AnyHTMLElement: HTMLElement {
    private let wrapped: any HTMLElement
    var attributes: HTMLAttributes
    
    func render() -> String {
        // Merge attributes and render
    }
}

// Collection type for multiple elements
struct HTMLGroup: HTMLElement {
    let elements: [any HTMLElement]
    var attributes = HTMLAttributes()
    
    func render() -> String {
        elements.map { $0.render() }.joined()
    }
}
```

### 3. Result Builder

```swift
@resultBuilder
struct HTMLBuilder {
    // Single element
    static func buildBlock<E: HTMLElement>(_ element: E) -> E {
        element
    }
    
    // Multiple elements
    static func buildBlock(_ elements: any HTMLElement...) -> HTMLGroup {
        HTMLGroup(elements: elements)
    }
    
    // Conditionals
    static func buildIf<E: HTMLElement>(_ element: E?) -> AnyHTMLElement {
        if let element {
            return AnyHTMLElement(wrapped: element)
        } else {
            return AnyHTMLElement(wrapped: EmptyHTML())
        }
    }
    
    // Arrays
    static func buildArray<E: HTMLElement>(_ elements: [E]) -> HTMLGroup {
        HTMLGroup(elements: elements)
    }
    
    // Either branches
    static func buildEither<T: HTMLElement, F: HTMLElement>(first: T) -> AnyHTMLElement {
        AnyHTMLElement(wrapped: first)
    }
    
    static func buildEither<T: HTMLElement, F: HTMLElement>(second: F) -> AnyHTMLElement {
        AnyHTMLElement(wrapped: second)
    }
}
```

### 4. Basic HTML Elements

```swift
// Text element
struct Text: HTMLInline {
    let content: String
    var attributes = HTMLAttributes()
    
    init(_ content: String) {
        self.content = content
    }
    
    func render() -> String {
        "<span\(attributes.render())>\(content.escaped())</span>"
    }
}

// Div container
struct Div: HTMLContainer {
    var attributes = HTMLAttributes()
    let content: () -> any HTMLElement
    
    init(@HTMLBuilder content: @escaping () -> any HTMLElement) {
        self.content = content
    }
    
    @HTMLBuilder
    var content: some HTMLElement {
        content()
    }
    
    func render() -> String {
        "<div\(attributes.render())>\(content.render())</div>"
    }
}

// Heading elements
struct H1: HTMLContainer {
    var attributes = HTMLAttributes()
    let content: () -> any HTMLElement
    
    init(@HTMLBuilder content: @escaping () -> any HTMLElement) {
        self.content = content
    }
    
    func render() -> String {
        "<h1\(attributes.render())>\(content().render())</h1>"
    }
}
```

### 5. Modifier System

```swift
extension HTMLElement {
    // CSS classes
    func `class`(_ className: String) -> some HTMLElement {
        var copy = self
        copy.attributes.classes.insert(className)
        return AnyHTMLElement(wrapped: copy)
    }
    
    // Inline styles
    func style(_ key: String, _ value: String) -> some HTMLElement {
        var copy = self
        copy.attributes.styles[key] = value
        return AnyHTMLElement(wrapped: copy)
    }
    
    // ID
    func id(_ id: String) -> some HTMLElement {
        var copy = self
        copy.attributes.id = id
        return AnyHTMLElement(wrapped: copy)
    }
    
    // Data attributes
    func data(_ key: String, _ value: String) -> some HTMLElement {
        var copy = self
        copy.attributes.data[key] = value
        return AnyHTMLElement(wrapped: copy)
    }
}

// Convenience modifiers
extension HTMLElement {
    func padding(_ value: Int) -> some HTMLElement {
        style("padding", "\(value)px")
    }
    
    func background(_ color: String) -> some HTMLElement {
        style("background-color", color)
    }
    
    func hidden(_ isHidden: Bool = true) -> some HTMLElement {
        isHidden ? style("display", "none") : self
    }
}
```

### 6. Layout Components

```swift
// Horizontal stack
struct HStack: HTMLContainer {
    var attributes = HTMLAttributes()
    let spacing: Int
    let alignment: VerticalAlignment
    let content: () -> any HTMLElement
    
    init(
        spacing: Int = 0,
        alignment: VerticalAlignment = .center,
        @HTMLBuilder content: @escaping () -> any HTMLElement
    ) {
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
        
        // Add flexbox styles
        attributes.styles["display"] = "flex"
        attributes.styles["gap"] = "\(spacing)px"
        attributes.styles["align-items"] = alignment.cssValue
    }
    
    func render() -> String {
        "<div\(attributes.render())>\(content().render())</div>"
    }
}

// Vertical stack
struct VStack: HTMLContainer {
    // Similar to HStack but with flex-direction: column
}

// Grid
struct Grid: HTMLContainer {
    let columns: Int
    let gap: Int
    // Implementation...
}
```

### 7. Dynamic Features (Swiftlets-specific)

```swift
// State management for server-side rendering
@propertyWrapper
struct State<Value> {
    let key: String
    var wrappedValue: Value
    
    init(wrappedValue: Value, key: String) {
        self.wrappedValue = wrappedValue
        self.key = key
    }
}

// Form handling
struct Form: HTMLContainer {
    let action: String
    let method: String
    var attributes = HTMLAttributes()
    let content: () -> any HTMLElement
    
    func render() -> String {
        """
        <form action="\(action)" method="\(method)"\(attributes.render())>
        \(content().render())
        </form>
        """
    }
}

// Dynamic list rendering
struct ForEach<Data: Collection>: HTMLElement {
    let data: Data
    let content: (Data.Element) -> any HTMLElement
    var attributes = HTMLAttributes()
    
    func render() -> String {
        data.map { content($0).render() }.joined()
    }
}
```

### 8. Integration with Swiftlets

```swift
// Updated Swiftlet protocol
protocol Swiftlet {
    associatedtype Body: Component
    func body(request: Request) -> Body
}

// Example usage
struct HomePage: Component {
    let name: String
    
    var body: some HTMLElement {
        Html {
            Head {
                Title("Welcome")
                Meta(charset: "utf-8")
            }
            Body {
                VStack(spacing: 20) {
                    H1 { Text("Hello, \(name)!") }
                    
                    if name.isEmpty {
                        Text("Please enter your name")
                    } else {
                        Text("Welcome to Swiftlets")
                    }
                    
                    Form(action: "/submit", method: "POST") {
                        Input(type: "text", name: "name")
                            .placeholder("Your name")
                        
                        Button("Submit")
                            .class("btn-primary")
                    }
                }
                .padding(40)
            }
        }
    }
}
```

## Implementation Phases

### Phase 1: Core Foundation (Week 1)
- [ ] Implement base protocols (`HTMLElement`, `HTMLContainer`, `Component`)
- [ ] Create `HTMLAttributes` with proper rendering
- [ ] Implement `@HTMLBuilder` result builder
- [ ] Add type-erasing wrappers (`AnyHTMLElement`, `HTMLGroup`)

### Phase 2: Basic Elements (Week 2)
- [ ] Text elements (`Text`, `RawHTML`)
- [ ] Container elements (`Div`, `Section`, `Article`)
- [ ] Headings (`H1`-`H6`)
- [ ] Lists (`UL`, `OL`, `LI`)
- [ ] Links (`A`, `Link`)

### Phase 3: Form Elements (Week 3)
- [ ] Form container
- [ ] Input types (text, email, password, etc.)
- [ ] Textarea, Select, Button
- [ ] Form validation helpers

### Phase 4: Layout Components (Week 4)
- [ ] HStack, VStack
- [ ] Grid system
- [ ] Spacer, Divider
- [ ] Container with max-width

### Phase 5: Modifiers & Styling (Week 5)
- [ ] CSS class modifiers
- [ ] Inline style modifiers
- [ ] Responsive modifiers
- [ ] Animation/transition support

### Phase 6: Dynamic Features (Week 6)
- [ ] State management
- [ ] Conditional rendering
- [ ] Loop rendering (ForEach)
- [ ] Event handling preparation

### Phase 7: Integration (Week 7)
- [ ] Update Swiftlet protocol
- [ ] Response rendering
- [ ] Performance optimization
- [ ] Documentation

### Phase 8: Advanced Features (Week 8)
- [ ] Custom components
- [ ] Template inheritance
- [ ] Partial rendering
- [ ] Client-side hydration prep

## Testing Strategy

1. **Unit Tests**: Each element and modifier
2. **Integration Tests**: Complex component compositions
3. **Performance Tests**: Rendering speed benchmarks
4. **HTML Validation**: Output validation against W3C standards

## Key Differences from Ignite

1. **Server-side focus**: No static generation, dynamic rendering
2. **Request context**: Access to request data in components
3. **State management**: Server-side state handling
4. **Form handling**: Built-in form processing
5. **Performance**: Optimized for request/response cycle

## Success Metrics

- Clean, SwiftUI-like syntax
- Type-safe HTML generation
- Performance: < 1ms render time for typical pages
- Extensible for custom components
- Easy to learn for Swift developers