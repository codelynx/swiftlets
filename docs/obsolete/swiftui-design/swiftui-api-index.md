# SwiftUI-Style API Documentation Index

## Main Design Document
- **[SwiftUI-Style API Design](swiftui-api-design.md)** - Complete consolidated design (START HERE)

## Supporting Documents

### Core Concepts
- [Original Design Proposal](swiftui-style-main-design.md) - Initial design exploration
- [Separated Builders Design](swiftui-style-separated-builders.md) - HEAD/BODY separation concept
- [Environment Flow](swiftui-style-environment-flow.md) - How data flows from @main to components

### Comparisons & Analysis
- [Style Comparison](swiftui-style-comparison.md) - Side-by-side current vs SwiftUI style
- [Ignite Framework Insights](swiftui-style-ignite-insights.md) - What we learned from Ignite

### Feature-Specific Design
- [POST Request Handling](swiftui-style-post-handling.md) - Forms, JSON, file uploads
- [Implementation Details](swiftui-style-implementation.swift) - Code showing hidden boilerplate

### Proof of Concept
- [POC Implementation](swiftui-style-poc.swift) - Working example code

## Quick Summary

The SwiftUI-style API transforms this:
```swift
@main
struct HomePage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        let html = Html {
            Head { Title("Home") }
            Body { H1("Welcome") }
        }
        let response = Response(status: 200, headers: ["Content-Type": "text/html"], body: html.render())
        print(try JSONEncoder().encode(response).base64EncodedString())
    }
}
```

Into this:
```swift
@main
struct HomePage: Swiftlet {
    var head: some HeadContent {
        Title("Home")
    }
    
    var body: some BodyContent {
        H1("Welcome")
    }
}
```

## Key Innovation: Separated HEAD and BODY

Instead of mixing document structure with content, we separate concerns:
- `head` - Metadata, SEO, resources
- `body` - Visible UI content
- `HTMLComponent` - Reusable UI pieces

This provides better organization, type safety, and a more SwiftUI-like experience.