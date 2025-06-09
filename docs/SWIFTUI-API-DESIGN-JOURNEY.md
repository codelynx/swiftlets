# SwiftUI-Style API Design Journey

## The Problem We Started With

Developers had to write tons of boilerplate in every swiftlet:
```swift
static func main() async throws {
    let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
    let html = Html { /* ... */ }
    let response = Response(status: 200, headers: ["Content-Type": "text/html"], body: html.render())
    print(try JSONEncoder().encode(response).base64EncodedString())
}
```

## Key Insights During Design

### 1. "Developers should focus on content, not plumbing"
- Hide all JSON encoding/decoding
- Hide response creation
- Hide base64 output
- Just like SwiftUI hides UIKit details

### 2. "HEAD is not HTML, it's metadata"
Initial thought:
```swift
var head: some HeadContent {
    Title("Page")  // Looks like HTML building
}
```

Better realization:
```swift
var title = "Page"  // Just data!
var description = "..."  // Metadata properties
```

### 3. "HTMLComponent vs BodyContent naming"
- Started with `BodyContent` 
- Realized `HTMLComponent` is clearer (like SwiftUI View)
- Everything that renders has a `body` property

### 4. "Type safety between HEAD and BODY"
- Can't put `<title>` in body
- Can't put `<div>` in head  
- Separate protocols: `HeadElement` vs `BodyElement`
- Compile-time safety!

### 5. "Environment pattern from Ignite"
- Studied how Ignite uses singleton + withEnvironment
- Decided on Task Local Storage for thread safety
- Property wrappers for clean access

### 6. "Separation of concerns"
Evolution:
1. Everything mixed → Confusing
2. Separate `head` and `body` properties → Better
3. Metadata properties + body → Best!

## Design Decisions Made

1. **Protocol hierarchy**
   - `HTMLComponent` - Base rendering protocol
   - `PageMeta` - Metadata properties
   - `Swiftlet` - Combines both

2. **Type safety**
   - `HeadElement` - Only valid in HEAD
   - `BodyElement` - Only valid in BODY
   - `UniversalElement` - Valid in both

3. **Property wrappers**
   - `@Query` - URL parameters
   - `@FormValue` - Form data
   - `@Body` - Request body
   - `@Environment` - System values

4. **No boilerplate**
   - Framework handles all protocol details
   - Developers just declare what they want

## What We Learned

### From Current Swiftlets
- Too much boilerplate hurts adoption
- Developers want to focus on their logic
- Type safety prevents bugs

### From SwiftUI
- Declarative is powerful
- Property wrappers are ergonomic
- Composition over inheritance

### From Ignite
- Environment pattern works well
- Separation of static vs dynamic
- Clean protocol design

## Why This Design Works

1. **Familiar** - SwiftUI developers instantly understand
2. **Safe** - Can't make HTML structure mistakes
3. **Clean** - No protocol plumbing visible
4. **Flexible** - Easy to extend with new features
5. **Testable** - Components are just data

## Evolution Example

Started with:
```swift
static func main() async throws {
    // 20+ lines of boilerplate
}
```

Evolved to:
```swift
var title = "My Page"
var body: some BodyElement {
    H1("Hello World")
}
```

## Next Steps

1. Implement core protocols
2. Build property wrappers
3. Create migration tools
4. Update documentation
5. Gather feedback

## Key Takeaway

The best API is the one developers don't have to think about. By hiding all the plumbing and providing a SwiftUI-like declarative interface, we make web development with Swift as easy as building iOS apps.