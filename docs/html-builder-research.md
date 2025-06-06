# HTML Builder Research Summary

## Ignite's Approach

Based on analysis of Ignite's implementation, here are the key patterns:

### 1. Protocol-Based Architecture
- `MarkupElement` as base protocol with `attributes` and `markup()` method
- `HTML` protocol for body elements with `@HTMLBuilder var body`
- Separate protocols for different contexts (InlineElement, HeadElement)

### 2. Type Erasure Strategy
- `AnyHTML` wrapper to handle heterogeneous collections
- Automatic attribute extraction and merging
- Prevents double-wrapping of already wrapped elements

### 3. Attributes System
- Centralized `CoreAttributes` struct
- Uses `OrderedSet` for classes to maintain order
- Dictionary for styles and data attributes
- Clean rendering via `CustomStringConvertible`

### 4. Result Builder Pattern
```swift
@resultBuilder
struct HTMLBuilder {
    // Handles single elements, arrays, conditionals, loops
    // Uses buildPartialBlock for sequential combination
    // Returns appropriate wrappers (AnyHTML, HTMLCollection)
}
```

### 5. Modifier Design
- Extensions on protocols return opaque types
- Creates copies with modified attributes
- Handles primitive vs non-primitive elements differently
- Lazy wrapping in Section/Span when needed

## Swiftlets Adaptation

### Key Differences from Ignite

1. **Dynamic vs Static**: Swiftlets renders per-request, not static files
2. **State Management**: Need server-side state handling
3. **Request Context**: Components need access to request data
4. **Performance Focus**: Optimize for request/response cycle

### Proposed Architecture

1. **Simplified Protocol Hierarchy**
   ```swift
   HTMLElement → HTMLContainer → Component
   ```

2. **Explicit Render Method**
   - `render() -> String` instead of `markup() -> Markup`
   - Direct string generation for performance

3. **Request-Aware Components**
   ```swift
   protocol Swiftlet {
       func body(request: Request) -> any Component
   }
   ```

4. **Server-Side Features**
   - Form handling
   - Session state
   - Dynamic data binding
   - Event handlers (for form actions)

### Implementation Strategy

1. **Phase 1**: Core protocols and result builder
2. **Phase 2**: Basic HTML elements
3. **Phase 3**: Form elements
4. **Phase 4**: Layout components (HStack, VStack, Grid)
5. **Phase 5**: Modifiers and styling
6. **Phase 6**: Dynamic features (state, conditionals)
7. **Phase 7**: Integration with Swiftlets
8. **Phase 8**: Advanced features

### POC Results

The proof of concept demonstrates:
- ✅ SwiftUI-like syntax works well
- ✅ Result builders provide clean composition
- ✅ Type-safe HTML generation
- ✅ Modifier chaining is intuitive
- ✅ Conditional rendering is seamless

### Performance Considerations

1. **String Building**: Use `String` directly vs StringBuilder
2. **Attribute Merging**: Minimize copying
3. **Type Erasure**: Balance flexibility vs performance
4. **Caching**: Consider rendered fragment caching

### Next Steps

1. Implement core HTML builder in SwiftletsHTML package
2. Update swiftlet examples to use new syntax
3. Benchmark performance vs string concatenation
4. Add form handling and state management
5. Create comprehensive component library