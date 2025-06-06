# Swiftlets Project Structure

## Overview

Swiftlets is designed with a modular architecture that separates core functionality from third-party extensions. This allows the framework to be extended via plugins while maintaining a stable core API.

## Repository Organization

### Main Repository (swiftlets)
Core framework and essential components only.

### Submodules for Extensions
- `swiftlets-plugins` - Official plugins repository
- `swiftlets-themes` - UI themes and templates
- `swiftlets-adapters` - Database and service adapters

## Recommended Directory Layout

```
swiftlets/                      # Main repository (core only)
├── Package.swift
├── README.md
├── LICENSE
├── CLAUDE.md
├── Sources/
│   ├── SwiftletsCore/          # Core framework (minimal, stable API)
│   │   ├── Protocols/          # Public protocols for extensions
│   │   │   ├── Component.swift
│   │   │   ├── Middleware.swift
│   │   │   ├── Plugin.swift
│   │   │   ├── Renderer.swift
│   │   │   └── Router.swift
│   │   ├── Builders/           # Core result builders
│   │   │   ├── ComponentBuilder.swift
│   │   │   ├── RouteBuilder.swift
│   │   │   └── PluginBuilder.swift
│   │   ├── Base/               # Base implementations
│   │   │   ├── Request.swift
│   │   │   ├── Response.swift
│   │   │   └── Application.swift
│   │   └── Extensions/         # Protocol extensions
│   │
│   ├── Swiftlets/              # Standard library (built on Core)
│   │   ├── Elements/           # HTML elements
│   │   │   ├── Basic/          # Text, Image, Link
│   │   │   ├── Forms/          # Input, Button, Form
│   │   │   └── Layout/         # HStack, VStack, Grid
│   │   ├── Middleware/         # Built-in middleware
│   │   │   ├── Logger.swift
│   │   │   ├── Static.swift
│   │   │   └── Session.swift
│   │   ├── Server/             # Default server implementation
│   │   │   └── HTTPServer.swift
│   │   └── Rendering/          # HTML renderer
│   │       └── HTMLRenderer.swift
│   │
│   ├── SwiftletsCLI/           # Command-line tool
│   │   └── main.swift
│   │
│   └── SwiftletsCGI/           # CGI adapter
│       └── CGIAdapter.swift
│
├── Tests/
│   ├── SwiftletsCoreTests/
│   └── SwiftletsTests/
│
├── Examples/                    # Example applications
│   └── HelloWorld/
│
└── docs/                       # Documentation
    ├── project-structure.md
    └── plugin-development.md

swiftlets-plugins/              # Separate repository (git submodule)
├── Package.swift
├── Sources/
│   ├── SwiftletsAuth/          # Authentication plugin
│   │   ├── Providers/
│   │   │   ├── OAuth.swift
│   │   │   └── JWT.swift
│   │   └── Plugin.swift
│   │
│   ├── SwiftletsDB/            # Database plugin
│   │   ├── Adapters/
│   │   │   ├── SQLite.swift
│   │   │   ├── PostgreSQL.swift
│   │   │   └── MySQL.swift
│   │   └── Plugin.swift
│   │
│   └── SwiftletsWebSocket/     # WebSocket plugin
│       └── Plugin.swift
│
└── Tests/

swiftlets-themes/               # Separate repository (git submodule)
├── Package.swift
├── Sources/
│   ├── Bootstrap/              # Bootstrap theme
│   ├── Tailwind/               # Tailwind CSS theme
│   └── Material/               # Material Design theme
│
└── Resources/

swiftlets-adapters/             # Separate repository (git submodule)
├── Package.swift
├── Sources/
│   ├── FastCGI/
│   ├── Lambda/                 # AWS Lambda adapter
│   └── Vapor/                  # Vapor integration
│
└── Tests/
```

## Core vs Extensions

### SwiftletsCore (Minimal, Stable)
Only essential protocols and base types:
- Protocol definitions for plugins
- Core result builders
- Basic request/response types
- Plugin loading system

### Swiftlets (Standard Library)
Built-in implementations using Core protocols:
- Basic HTML elements
- Default HTTP server
- Common middleware
- HTML rendering

### Third-Party Development

#### Plugin Protocol
```swift
// In SwiftletsCore/Protocols/Plugin.swift
public protocol Plugin {
    static var name: String { get }
    static var version: String { get }
    
    func configure(_ app: Application) throws
}

// In third-party plugin
public struct DatabasePlugin: Plugin {
    public static let name = "SwiftletsDB"
    public static let version = "1.0.0"
    
    public func configure(_ app: Application) throws {
        app.register(singleton: Database.self) { _ in
            PostgreSQLDatabase(config: .default)
        }
    }
}
```

#### Component Extension
```swift
// Third-party component library
import SwiftletsCore

public struct Calendar: Component {
    @Binding var selectedDate: Date
    
    public var body: some Component {
        // Implementation
    }
}
```

## Package Structure for Third-Party Developers

### Plugin Package.swift Example
```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "swiftlets-calendar",
    platforms: [.macOS(.v13), .linux],
    products: [
        .library(
            name: "SwiftletsCalendar",
            targets: ["SwiftletsCalendar"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlets/swiftlets", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "SwiftletsCalendar",
            dependencies: [
                .product(name: "SwiftletsCore", package: "swiftlets")
            ]
        )
    ]
)
```

## Using Submodules

### Initial Setup
```bash
# Clone main repository
git clone https://github.com/swiftlets/swiftlets
cd swiftlets

# Add plugin submodules
git submodule add https://github.com/swiftlets/swiftlets-plugins plugins
git submodule add https://github.com/swiftlets/swiftlets-themes themes
git submodule add https://github.com/swiftlets/swiftlets-adapters adapters

# Initialize submodules
git submodule init
git submodule update
```

### Development Workflow
```bash
# Update all submodules
git submodule update --remote

# Work on a specific plugin
cd plugins
git checkout -b feature/new-auth-provider
# ... make changes ...
git commit -m "Add OAuth2 provider"
git push origin feature/new-auth-provider
```

## Benefits of This Structure

1. **Stable Core API**: Core protocols rarely change, ensuring plugin compatibility
2. **Independent Versioning**: Plugins can be versioned separately
3. **Lighter Dependencies**: Apps only import what they need
4. **Community Contributions**: Easy for third parties to create plugins
5. **Clear Boundaries**: Obvious separation between core and extensions

## Cross-Platform Support

Swiftlets supports multiple platforms and architectures:

### Supported Platforms
- **macOS**: 13+ (Intel x86_64 and Apple Silicon arm64)
- **Linux**: Ubuntu 22.04+ (x86_64 and ARM64/aarch64)

### Build System
The project includes universal build scripts that automatically detect the platform:
- `build-universal.sh` - Cross-platform build script
- `run-universal.sh` - Cross-platform run script
- `check-ubuntu-prerequisites.sh` - Ubuntu setup verification

### Platform-Specific Paths
Build artifacts are organized by platform triple:
- macOS Intel: `.build/x86_64-apple-macosx/`
- macOS ARM: `.build/arm64-apple-macosx/`
- Linux x64: `.build/x86_64-unknown-linux-gnu/`
- Linux ARM64: `.build/aarch64-unknown-linux-gnu/` (uses arm64 in binary paths)

## Core Components

### 1. Core Framework (`Sources/Swiftlets/`)

#### Core Types
- **Request**: Represents HTTP requests with headers, body, parameters
- **Response**: HTTP response with status, headers, and body
- **Middleware**: Request/response processing pipeline
- **Router**: URL routing with parameter extraction

#### Elements (HTML Components)
Similar to Ignite but with dynamic capabilities:
- Support for data binding
- Event handling for server-side actions
- Form submission handling
- WebSocket integration points

#### Builders
- **@HTMLBuilder**: For composing HTML (like Ignite)
- **@RouteBuilder**: For defining routes declaratively
- **@MiddlewareBuilder**: For composing middleware chains

#### Server
- Built-in HTTP server for development
- CGI/FastCGI support for production deployment
- WebSocket support for real-time features

### 2. CLI Tool (`Sources/SwiftletsCLI/`)
Commands for:
- Creating new projects
- Running development server
- Building for production
- Generating components

### 3. CGI Adapter (`Sources/SwiftletsCGI/`)
- Traditional CGI support
- FastCGI for better performance
- Integration with Apache/Nginx

## Example API Design

```swift
// main.swift
import Swiftlets

@main
struct MyApp: App {
    var body: some Routes {
        Route("/") {
            HomePage()
        }
        
        Route("/api/users") { request in
            UserAPI(request: request)
        }
        
        Route("/blog/:id") { request, params in
            BlogPost(id: params["id"]!)
        }
    }
    
    var middleware: some Middleware {
        Logger()
        Authentication()
        CORS()
    }
}

// HomePage.swift
struct HomePage: Component {
    @State var visitors = 0
    
    var body: some HTML {
        Html {
            Head {
                Title("Welcome to Swiftlets")
                CSS("/styles.css")
            }
            Body {
                H1("Hello, World!")
                Text("Visitors: \(visitors)")
                Button("Increment") {
                    visitors += 1
                }
            }
        }
    }
}
```

## Package.swift Structure

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "swiftlets",
    platforms: [
        .macOS(.v13),
        .linux  // Supports x86_64 and ARM64 (aarch64)
    ],
    products: [
        .library(name: "Swiftlets", targets: ["Swiftlets"]),
        .executable(name: "swiftlets", targets: ["SwiftletsCLI"]),
        .executable(name: "swiftlets-cgi", targets: ["SwiftletsCGI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-nio", from: "2.77.0"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "Swiftlets",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "Collections", package: "swift-collections")
            ]
        ),
        .executableTarget(
            name: "SwiftletsCLI",
            dependencies: [
                "Swiftlets",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .executableTarget(
            name: "SwiftletsCGI",
            dependencies: ["Swiftlets"]
        ),
        .testTarget(name: "SwiftletsTests", dependencies: ["Swiftlets"])
    ]
)
```

## Development Phases

### Phase 1: Core Foundation
1. Basic HTML elements and result builders
2. Simple HTTP request/response handling
3. Basic routing

### Phase 2: Dynamic Features
1. State management
2. Server-side event handling
3. Form processing

### Phase 3: Advanced Features
1. WebSocket support
2. Database integration
3. Session management
4. Authentication/authorization

### Phase 4: Deployment
1. CGI/FastCGI adapters
2. Performance optimization
3. Production tooling

## Key Differences from Ignite

1. **Dynamic Rendering**: Generate HTML on each request with live data
2. **Request Handling**: Process HTTP requests and form submissions
3. **State Management**: Server-side state with session support
4. **Real-time Features**: WebSocket support for live updates
5. **CGI Support**: Deploy as CGI scripts on traditional web hosts