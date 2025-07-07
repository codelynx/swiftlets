# Project: Swiftlets

## Overview
This project is inspired by Paul Hudson's Ignite static site generator. While Ignite only renders static websites, this project aims to use similar result builder patterns to develop a dynamic web server and CGI-like Swift components that work on both macOS and Linux (Ubuntu).

## Architecture
Swiftlets uses a unique modular architecture where:
- The web server acts as a router to standalone executable modules ("swiftlets")
- Each route maps to an independent executable (e.g., `/getting-started` → `bin/getting-started/index`)
- Executables are built on-demand from Swift source files
- Each swiftlet is isolated and can be updated without restarting the server
- Future support for multiple languages beyond Swift

### Platform Support
- **macOS**: x86_64 (Intel) and arm64 (Apple Silicon)
- **Linux**: x86_64 and arm64 (Ubuntu and other distributions)

Core development builds executables into platform-specific paths:
- `bin/macos/x86_64/` for macOS Intel
- `bin/macos/arm64/` for macOS Apple Silicon  
- `bin/linux/x86_64/` for Linux x64
- `bin/linux/arm64/` for Linux ARM

Third-party SDKs provide pre-built executables in `sdk/{platform}/{architecture}/` format. During deployment, only the target platform binaries are used.

See `/docs/swiftlet-architecture.md` for detailed architecture documentation.

## Current Status

See `TODO.md` for the current task list and priorities.

### Latest Accomplishments (January 2025)
- **SwiftUI-Style API**: Successfully implemented a zero-boilerplate API inspired by SwiftUI
  - Property wrappers for clean data access (@Query, @FormValue, @JSONBody, @Cookie, @Environment)
  - Declarative syntax with `@main` and `body` property
  - ResponseBuilder for setting cookies and headers
  - Complete backward compatibility with existing API
  - See `/docs/SWIFTUI-API-IMPLEMENTATION.md` for complete documentation
  - See `/docs/SWIFTUI-API-MIGRATION-GUIDE.md` for migration guide
  - See `/sites/test/swiftui-api-example/` for working examples
- **Hierarchical Shared Components**: Fully implemented in the main build system
  - Components are discovered by walking up the directory tree
  - Automatic compilation with each swiftlet for code reuse
  - Example at `/sites/shared-test/` demonstrates the system
  - See `/docs/shared-components-guide.md` for documentation
- **Complete Documentation Site Modernization**: Fully modernized the official documentation website
  - All 8 main documentation pages converted to SwiftUI-style API
  - Modern responsive design with comprehensive CSS animations
  - New comprehensive troubleshooting documentation at `/docs/troubleshooting`
  - Consistent navigation and footer components across all pages
  - Updated copyright years to 2025 throughout the site
  - Eye-catching gradient designs and interactive hover effects

## Development Workflow

- Always work on the `develop` branch
- Merge to `main` manually when ready
- Don't merge automatically

## Goals
- Create a SwiftUI-like declarative syntax for building dynamic web applications
- Support server-side rendering with real-time data
- Implement CGI-like components for handling HTTP requests/responses
- Cross-platform compatibility (macOS and Linux/Ubuntu)
- Use Swift result builders similar to Ignite's architecture
- Enable hot-reload development with automatic compilation
- Support process pooling for performance
- Allow mixing of different programming languages

## Key Documentation
- `/docs/project-structure.md` - Modular structure for core and third-party development
- `/docs/swiftlet-architecture.md` - Detailed explanation of the executable module system
- `/docs/sites-organization.md` - Organization of sites for core, test, and third-party development
- `/docs/html-elements-reference.md` - Complete reference of all implemented HTML elements
- `/docs/shared-components-guide.md` - Guide to the hierarchical shared components system
- `/docs/troubleshooting-complex-expressions.md` - Solutions for Swift type-checking issues
- `/docs/SWIFTUI-API-IMPLEMENTATION.md` - SwiftUI-style API documentation
- `/docs/README.md` - Complete documentation index

## Website Documentation
- `/sites/swiftlets-site/src/docs/troubleshooting.swift` - **NEW** Comprehensive web-based troubleshooting guide
- `/sites/swiftlets-site/src/docs/` - Complete modernized documentation website with SwiftUI-style API
- `/sites/swiftlets-site/src/about.swift` - About page explaining Swiftlets philosophy and architecture

Note: Historical documentation and POCs have been moved to `/docs/archive/` for reference.

## Latest Development
- **Unified Swiftlets Framework**: Consolidated SwiftletsCore and SwiftletsHTML into a single `Swiftlets` framework
- Implemented comprehensive HTML DSL with Ignite-inspired syntax
- **60+ HTML elements** covering all common HTML5 tags:
  - Document structure: Html, Head, Body, Title, Meta, Script, Style, Link
  - Text elements: Headings (H1-H6), Paragraph, Text, Span
  - Lists: UL, OL, LI, DL, DT, DD
  - Tables: Table, THead, TBody, TFoot, TR, TH, TD, Caption (defined but not exported)
  - Forms: Form, Input (all types), TextArea, Select, Option, Button, Label, FieldSet
  - Semantic: Header, Footer, Nav, Main, Article, Section, Aside, Figure
  - Media: Img, Picture, Video, Audio, IFrame (defined but not exported)
  - Inline: Strong, Em, Code, Pre, BlockQuote, Small, Mark
  - And many more...
- **Layout Components** with SwiftUI-like syntax:
  - HStack/VStack with alignment and spacing
  - ZStack for layered layouts
  - Grid with flexible column/row definitions
  - Container with responsive breakpoints
  - Spacer for flexible spacing
- **Helpers** for dynamic content:
  - ForEach with index support
  - If for conditional rendering
  - Fragment/Group for multiple elements
- **Modifiers** system: classes, styles, padding, margin, colors, width, height, etc.
- **Type-safe** HTML generation with proper escaping
- Result builder (@HTMLBuilder) for composable UI
- Request/Response now support JSON encoding/decoding
- Server updated to parse JSON responses from swiftlets
- **HTML Showcase**: Comprehensive examples site at `/showcase/` demonstrating:
  - Basic elements (headings, paragraphs, text)
  - Text formatting (strong, em, code, etc.)
  - Lists (ordered, unordered, definition)
  - Forms (all input types, validation)
  - Media elements (images, picture, video, audio, iframe)
- **Single import**: Just `import Swiftlets` for all functionality
- **Resources & Storage** (in development):
  - SwiftletContext API for accessing resources (.res/) and storage (var/)
  - Hierarchical resource lookup system
  - See `/docs/resources-programming-guide.md` for detailed documentation
  - Currently disabled in showcase due to build complexity issues

## Known Issues
- Missing elements: Br, S, Dfn, Ruby, Wbr, ColGroup, Col, OptGroup
- Naming conflicts: Files can't be named after framework modules (e.g., `lists.swift` conflicts with `Lists.swift`, `media.swift` conflicts with `Media.swift`)
- **Expression complexity**: Complex HTML structures can cause "expression too complex" compiler errors or build hangs. See `/docs/troubleshooting-complex-expressions.md` for solutions.
- **Build issues with certain swiftlets**:
  - `resources-demo.swift` and `resources-storage.swift` have been temporarily disabled (renamed to `.bak`) due to compilation hangs
  - These files demonstrate the new Resources & Storage APIs but exceed Swift's type-checking complexity limits
  - The APIs themselves work correctly; only the showcase examples are affected

## Common Build Fixes (January 2025)
When encountering build errors:
1. **Generic parameter inference**: Use `If(condition)` helper instead of `if` statements in HTMLBuilder contexts
2. **HTMLComponent conformance**: Use `.body` property or create helper functions for custom components
3. **Property wrapper syntax**: Cookie requires `@Cookie("name", default: "value") var name: String?`
4. **Method names**: Use `.attribute()` not `.attr()` on HTML elements
5. **Struct declarations**: Cannot declare structs inside @HTMLBuilder closures
6. **Shared components**: Place reusable components in `src/shared/` directory

## Troubleshooting

### Build Hangs or "Expression Too Complex" Errors
When building sites with complex HTML structures, you may encounter compilation hangs. The solution is to break down complex views into smaller functions:

```swift
// Use @HTMLBuilder functions that return `some HTML`
@HTMLBuilder
static func navigation() -> some HTML {
    Nav { /* ... */ }
}

// Then use in main body
Body {
    navigation()
    content()
    footer()
}
```

**What to do when swiftc hangs:**
1. The `build-site` script will automatically timeout after 30 seconds and show:
   ```
   ✗ Build timeout after 30s
   ⚠️  Likely cause: Expression too complex for type checker
   💡 Solution: Break down complex HTML into smaller functions
   ```
2. If running swiftc manually and it hangs, press `Ctrl+C` to stop it
3. Identify the problematic file (usually the one with the most complex HTML)
4. Apply function decomposition to break the HTML into smaller pieces

See `/docs/troubleshooting-complex-expressions.md` for detailed patterns and examples.

## Sites
- `/sites/swiftlets-site/` - **Official documentation and showcase site** (FULLY MODERNIZED)
  - Complete documentation with modern design and SwiftUI-style API
  - Comprehensive troubleshooting guide
  - Interactive showcase demonstrating all HTML elements
  - About page explaining project philosophy and architecture
- `/sites/shared-test/` - Demonstrates hierarchical shared components system
- `/sites/test/` - Test sites for framework development
- `/sites/templates/` - Third-party site templates

Run with: `./build-site sites/swiftlets-site && ./run-site sites/swiftlets-site`

## References
- Ignite framework (in `/external/Ignite/`) - MIT Licensed static site generator by Paul Hudson