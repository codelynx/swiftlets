# Troubleshooting: Expression Too Complex in Result Builders

## Problem

When building Swiftlets sites, you may encounter compilation hangs or errors related to "expression too complex" when using the HTML DSL. This typically happens when:

- You have deeply nested HTML structures
- Multiple modifiers are chained together
- Large amounts of content are in a single result builder block
- Complex expressions with string interpolation and conditionals

### Symptoms

1. **Build hangs indefinitely** on a specific Swift file
2. Swift compiler error: "The compiler is unable to type-check this expression in reasonable time"
3. Very slow compilation times for certain files
4. **Build timeout after 30 seconds** with message about expression complexity

## What to Do When swiftc Hangs

When the Swift compiler hangs during the build process:

1. **The build script will automatically timeout after 30 seconds** and show:
   ```
   ✗ Build timeout after 30s
   ⚠️  Likely cause: Expression too complex for type checker
   💡 Solution: Break down complex HTML into smaller functions
   ```

2. **If you manually run swiftc and it hangs**, press `Ctrl+C` to stop it.

3. **Identify the problematic file** - it's usually the one with the most complex HTML structure.

4. **Apply the function decomposition pattern** described below to fix the issue.

## Solution: Function Decomposition

Break down complex HTML structures into smaller functions that return `some HTML`. This gives the compiler smaller chunks to type-check and significantly improves compilation performance.

### Before (Problematic)

```swift
@main
struct MyPage {
    static func main() async throws {
        let html = Html {
            Head { /* ... */ }
            Body {
                Nav {
                    Container {
                        // Complex navigation with many elements
                        HStack {
                            Link(href: "/") { H1("Title") }
                            Spacer()
                            HStack(spacing: 20) {
                                Link(href: "/docs", "Docs")
                                Link(href: "/about", "About")
                                // ... many more links
                            }
                        }
                    }
                }
                
                Container {
                    VStack(spacing: 40) {
                        // Complex content structure
                        Section {
                            H2("Overview")
                            P("Long text...")
                            Grid(columns: .count(2)) {
                                // Many grid items
                            }
                        }
                        
                        Section {
                            H2("Details")
                            // More complex nested content
                        }
                        
                        // ... many more sections
                    }
                }
                
                Footer {
                    // Complex footer
                }
            }
        }
    }
}
```

### After (Solution)

```swift
@main
struct MyPage {
    static func main() async throws {
        let html = Html {
            Head { /* ... */ }
            Body {
                navigation()
                
                Container {
                    VStack(spacing: 40) {
                        breadcrumb()
                        H1("Page Title")
                        overviewSection()
                        detailsSection()
                        additionalContent()
                    }
                }
                
                footer()
            }
        }
    }
    
    @HTMLBuilder
    static func navigation() -> some HTMLElement {
        Nav {
            Container {
                HStack {
                    Link(href: "/") { H1("Title") }
                    Spacer()
                    HStack(spacing: 20) {
                        Link(href: "/docs", "Docs")
                        Link(href: "/about", "About")
                    }
                }
            }
        }
    }
    
    @HTMLBuilder
    static func breadcrumb() -> some HTMLElement {
        HStack(spacing: 10) {
            Link(href: "/", "Home")
            Text("→")
            Text("Current Page")
        }
    }
    
    @HTMLBuilder
    static func overviewSection() -> some HTMLElement {
        Section {
            H2("Overview")
            P("Long text...")
            Grid(columns: .count(2)) {
                // Grid items
            }
        }
    }
    
    @HTMLBuilder
    static func detailsSection() -> some HTMLElement {
        Section {
            H2("Details")
            // Section content
        }
    }
    
    @HTMLBuilder
    static func footer() -> some HTMLElement {
        Footer {
            Container {
                P("© 2025 My Site")
            }
        }
    }
}
```

## Key Points

1. **Use `@HTMLBuilder` attribute** on each helper function
2. **Return type should be `some HTMLElement`** (not `some HTML`)
3. **No explicit `return` statement needed** when using `@HTMLBuilder`
4. **Break down by logical sections**: navigation, content areas, footer, etc.
5. **Keep each function focused** on a single piece of UI
6. **Use `If` helper instead of `if` statements** in HTMLBuilder contexts
7. **For custom components**, either use `.body` property or create helper functions

## Benefits

- ✅ Faster compilation
- ✅ Better code organization
- ✅ Easier to maintain and modify
- ✅ Reusable components
- ✅ Easier to test individual sections

## When to Apply This Pattern

Consider breaking down your HTML when you have:

- More than 3-4 levels of nesting
- Sections longer than 50-60 lines
- Multiple complex modifiers on elements
- Compilation taking more than a few seconds
- Build hanging on a specific file

## Example: Real-World Case

In the Swiftlets documentation site, the resources-storage.swift file was hanging during compilation. The solution was to break it down:

```swift
// Instead of one massive Body block, use:
Body {
    navigation()      // Top navigation bar
    Container {
        breadcrumb()  // Breadcrumb navigation
        overview()    // Overview section
        resources()   // Resources documentation
        storage()     // Storage documentation
        bestPractices() // Best practices grid
        footer()      // Page footer
    }
}
```

Each function handles its own section, making the code more manageable and eliminating the compilation hang.

## Common Build Errors and Fixes

### 1. Generic Parameter Inference Errors
**Error**: `error: generic parameter 'E' could not be inferred`

**Cause**: Using `if` statements in HTMLBuilder contexts
```swift
// Problematic
if showButton {
    Button("Click me")
}
```

**Fix**: Use the `If` helper
```swift
// Correct
If(showButton) {
    Button("Click me")
}
```

### 2. HTMLComponent Conformance Issues
**Error**: `error: argument type 'MyComponent' does not conform to expected type 'HTMLElement'`

**Cause**: Custom components implementing HTMLComponent aren't automatically converted

**Fix**: Either use `.body` or create helper functions
```swift
// Option 1: Use .body
NavigationBar().body

// Option 2: Create helper function
@HTMLBuilder
func navigationBar() -> some HTMLElement {
    Nav {
        // navigation content
    }
}
```

### 3. Property Wrapper Syntax
**Error**: Cookie property wrapper initialization errors

**Fix**: Use correct syntax
```swift
// Correct
@Cookie("theme", default: "light") var theme: String?
```

### 4. Method Name Issues
**Error**: `error: value of type 'Link' has no member 'attr'`

**Fix**: Use `.attribute()` instead of `.attr()`
```swift
// Correct
Link(href: "/example", "Link text")
    .attribute("target", "_blank")
```

### 5. Struct Declarations in Closures
**Error**: `error: closure containing a declaration cannot be used with result builder`

**Fix**: Move struct declarations outside of HTMLBuilder closures

## Additional Tips

1. **Start simple**: Don't over-engineer. Only break down when needed.
2. **Group related content**: Each function should represent a logical section.
3. **Consider reusability**: Extract truly reusable components to separate files.
4. **Use meaningful names**: Function names should clearly indicate what they render.
5. **Keep consistent patterns**: Use similar decomposition strategies across your site.
6. **Move non-page components to shared/**: Place reusable components in `src/shared/` directory

## Related Documentation

- [HTML DSL Reference](/docs/html-elements-reference.md)
- [SwiftUI-style Patterns in Swiftlets](/docs/html-builder-implementation-plan.md)