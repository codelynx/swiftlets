# Type Safety Design for Swiftlets

## The Problem

Currently, we can accidentally do this:
```swift
Body {
    Title("Oops!")  // Title belongs in HEAD, not BODY!
    Meta(...)       // This too!
}
```

## Design Goal

Make it **impossible** to put HEAD elements in BODY or vice versa at compile time.

## Option 1: Separate Protocol Hierarchies

```swift
// Marker protocols
protocol HeadElement: HTMLElement { }
protocol BodyElement: HTMLElement { }

// Elements declare where they belong
struct Title: HeadElement { }
struct Meta: HeadElement { }
struct Link: HeadElement { }

struct Div: BodyElement { }
struct P: BodyElement { }
struct H1: BodyElement { }

// Builders enforce constraints
@resultBuilder
struct HeadBuilder {
    static func buildBlock<T: HeadElement>(_ components: T...) -> some HeadElement
}

@resultBuilder
struct BodyBuilder {
    static func buildBlock<T: BodyElement>(_ components: T...) -> some BodyElement
}
```

## Option 2: Phantom Types

```swift
// Phantom type tags
enum HeadContext {}
enum BodyContext {}

// Elements are generic over context
struct Element<Context, Content> {
    // ...
}

// Type aliases for clarity
typealias HeadElement<T> = Element<HeadContext, T>
typealias BodyElement<T> = Element<BodyContext, T>

// Builders work with specific contexts
@resultBuilder
struct HTMLBuilder<Context> {
    // Only accepts elements with matching context
}
```

## Option 3: Builder-Level Enforcement

```swift
// Elements don't know where they belong
struct Title: HTMLElement { }
struct Div: HTMLElement { }

// Builders have allow-lists
@resultBuilder
struct HeadBuilder {
    // Only these types allowed
    static let allowedTypes = [Title.self, Meta.self, Link.self, ...]
    
    static func buildBlock(_ components: any HTMLElement...) -> some HTMLElement {
        // Runtime check, but could be compile-time with macros
        for component in components {
            assert(allowedTypes.contains { $0 == type(of: component) })
        }
    }
}
```

## Option 4: Nested Types (Namespacing)

```swift
// Elements are namespaced
enum Head {
    struct Title: HTMLElement { }
    struct Meta: HTMLElement { }
    struct Link: HTMLElement { }
}

enum Body {
    struct Div: HTMLElement { }
    struct P: HTMLElement { }
    struct H1: HTMLElement { }
}

// Usage is clear
var head: some HTMLElement {
    Head.Title("My Page")
    Head.Meta(name: "description", content: "...")
}

var body: some HTMLElement {
    Body.Div {
        Body.H1("Welcome")
        Body.P("Hello")
    }
}
```

## Option 5: Context-Aware Elements

```swift
// Elements know multiple valid contexts
protocol HTMLElement {
    static var validContexts: [ElementContext] { get }
}

enum ElementContext {
    case head
    case body
    case both  // Like <script> can be in both
}

struct Title: HTMLElement {
    static let validContexts = [.head]
}

struct Script: HTMLElement {
    static let validContexts = [.head, .body]
}

struct Div: HTMLElement {
    static let validContexts = [.body]
}
```

## Recommendation: Hybrid Approach

Combine the best aspects:

```swift
// 1. Marker protocols for compile-time safety
protocol HeadElement: HTMLElement { }
protocol BodyElement: HTMLElement { }
protocol UniversalElement: HTMLElement { } // Can go in either

// 2. Clear organization
struct Title: HeadElement { }
struct Meta: HeadElement { }

struct Div: BodyElement { }
struct P: BodyElement { }

struct Script: UniversalElement { } // Can be in head or body

// 3. Builder constraints
@resultBuilder
struct HeadBuilder {
    static func buildBlock(_ components: any HeadElement...) -> some HeadElement
    static func buildBlock(_ components: any UniversalElement...) -> some HeadElement
}

@resultBuilder  
struct BodyBuilder {
    static func buildBlock(_ components: any BodyElement...) -> some BodyElement
    static func buildBlock(_ components: any UniversalElement...) -> some BodyElement
}

// 4. Component protocol uses BodyElement
protocol HTMLComponent {
    associatedtype Body: BodyElement
    @BodyBuilder var body: Body { get }
}
```

## Benefits

1. **Compile-time safety** - Can't mix head/body elements
2. **Clear intent** - Element protocols show where they belong
3. **Flexibility** - UniversalElement for elements valid in both
4. **Good ergonomics** - Natural to use
5. **Extensible** - Easy to add new elements

## Questions to Resolve

1. How to handle elements valid in both contexts (script, style)?
2. Should we use protocols or enums for context?
3. How does this interact with modifiers?
4. What about elements with different rules (table elements)?