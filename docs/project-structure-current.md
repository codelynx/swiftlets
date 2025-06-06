# Current Project Structure

Last Updated: June 2025

## Overview

This document describes the current structure of the Swiftlets project after the framework consolidation.

## Repository Structure

```
swiftlets/
├── core/                       # Core framework
│   ├── Package.swift
│   ├── Sources/
│   │   ├── Swiftlets/         # Unified framework
│   │   │   ├── Core/          # Core types (Request, Response, Swiftlet)
│   │   │   └── HTML/          # HTML DSL
│   │   │       ├── Builders/
│   │   │       ├── Core/
│   │   │       ├── Elements/
│   │   │       ├── Helpers/
│   │   │       ├── Layout/
│   │   │       └── Modifiers/
│   │   └── SwiftletsServer/   # HTTP server
│   └── Tests/
│       └── SwiftletsTests/    # Framework tests
│
├── sites/                     # Example sites
│   └── core/                  # Core team examples
│       ├── hello/
│       ├── showcase/
│       └── swiftlets-site/
│
├── sdk/                       # SDK for third-party developers
│   ├── sites/                 # SDK example sites
│   ├── examples/              # Example projects
│   └── templates/             # Project templates
│
├── docs/                      # Documentation
├── cli/                       # CLI tools (future)
└── examples/                  # Basic examples
```

## Core Framework Structure

### Unified Swiftlets Framework

The framework has been consolidated from two separate modules (SwiftletsCore and SwiftletsHTML) into a single unified framework:

```
Sources/Swiftlets/
├── Core/                      # Core functionality
│   ├── Request.swift         # HTTP request handling
│   ├── Response.swift        # HTTP response handling
│   └── Swiftlet.swift        # Swiftlet protocol
│
└── HTML/                      # HTML DSL
    ├── Builders/
    │   └── HTMLBuilder.swift  # Result builder for HTML
    ├── Core/
    │   ├── HTMLElement.swift  # Base protocol
    │   ├── HTMLAttributes.swift
    │   └── AnyHTMLElement.swift
    ├── Elements/              # HTML elements
    │   ├── Document.swift     # Html, Head, Body, etc.
    │   ├── Headings.swift     # H1-H6
    │   ├── Text.swift         # Text, Span
    │   ├── Paragraph.swift    # P
    │   ├── Lists.swift        # UL, OL, LI
    │   ├── Table.swift        # Table elements
    │   ├── Form.swift         # Form elements
    │   ├── Media.swift        # Img, Video, Audio
    │   └── ...                # 60+ HTML elements
    ├── Layout/
    │   └── Stack.swift        # HStack, VStack, ZStack
    ├── Helpers/
    │   ├── ForEach.swift      # Iteration
    │   ├── Conditional.swift  # If/else
    │   └── Fragment.swift     # Group elements
    └── Modifiers/
        ├── AttributeModifiers.swift
        └── StyleModifiers.swift
```

## Usage

### Importing the Framework

All functionality is now available through a single import:

```swift
import Swiftlets

@main
struct HomePage {
    static func main() async throws {
        let request = try Request.decode()
        
        let html = Html {
            Head {
                Title("My Site")
            }
            Body {
                H1("Welcome!")
                Paragraph("Built with Swiftlets")
            }
        }
        
        try Response(html: html).send()
    }
}
```

## Build System

### For Core Development
- Uses Swift Package Manager
- Build with: `swift build`
- Test with: `swift test`

### For Site Development
Sites can be built using:
1. **Package.swift** - Reference the Swiftlets framework as a dependency
2. **Direct compilation** - Include source files directly
3. **Makefile** - Use provided build automation

## Platform Support

- **macOS**: x86_64 and arm64
- **Linux**: x86_64 and arm64 (Ubuntu and others)

Sites are built to platform-specific directories during development but deployed to fixed platform targets in production.

## Key Differences from Original Design

1. **Single Framework**: Instead of separate Core and HTML modules, everything is unified under `Swiftlets`
2. **Simplified Imports**: Just `import Swiftlets` instead of multiple imports
3. **Module Organization**: Core functionality in `Core/`, HTML DSL in `HTML/`
4. **No Plugin System Yet**: The modular plugin architecture is planned for future versions

## Benefits of Current Structure

1. **Simplicity**: Single framework to import and manage
2. **Discoverability**: All APIs available through one module
3. **Maintainability**: Easier to version and distribute
4. **Developer Experience**: Cleaner imports and better IDE support