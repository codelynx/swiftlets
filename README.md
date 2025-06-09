# Swiftlets 🚀

> A modern Swift web framework with file-based routing and declarative HTML generation

[![Swift](https://img.shields.io/badge/Swift-6.0+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-macOS%20|%20Linux-lightgray.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

> [!WARNING]
> **Development Status**: Swiftlets is under active development and is **NOT ready for production use**. APIs may change, and features may be incomplete. We welcome feedback and contributions to help shape the future of Swift on the web!

## What is Swiftlets?

Swiftlets is a lightweight, Swift-based web framework that brings the simplicity of file-based routing and the power of type-safe HTML generation to server-side Swift development. Inspired by modern web frameworks, it offers a unique approach where each route is an independent executable module.

### ✨ Key Features

- **🗂 File-Based Routing** - Your file structure defines your routes (`.webbin` files)
- **🏗 Declarative HTML DSL** - SwiftUI-like syntax for type-safe HTML generation
- **🎯 SwiftUI-Style API** - Property wrappers (`@Query`, `@Cookie`, `@Environment`) for easy data access
- **🔧 Zero Configuration** - No complex routing tables or configuration files
- **🔒 Security First** - Source files stay outside the web root, MD5 integrity checks
- **♻️ Hot Reload** - Automatic compilation and reloading during development
- **🌍 Cross-Platform** - Works on macOS (Intel/Apple Silicon) and Linux (x86_64/ARM64)

## 🚀 Getting Started

Get up and running with Swiftlets in just a few minutes. This guide will walk you through installation, creating your first project, and understanding the basics.

### 1. Clone and Build

First, ensure you have Swift installed (5.7 or later), then clone the Swiftlets repository and build the server:

```bash
# Clone the repository
git clone https://github.com/codelynx/swiftlets.git
cd swiftlets

# Build the server (one time setup)
./build-server
```

This builds the server binary and places it in the platform-specific directory (e.g., `bin/darwin/arm64/`).

### 2. Try the Showcase Site

Before creating your own project, let's explore what Swiftlets can do! The repository includes a complete example site with documentation and component showcases - all built with Swiftlets.

Build and run the example site:

```bash
# Build the site
./build-site sites/examples/swiftlets-site

# Run the site
./run-site sites/examples/swiftlets-site

# Or combine build and run
./run-site sites/examples/swiftlets-site --build
```

Visit `http://localhost:8080` and explore:
- **`/showcase`** - See all HTML components in action
- **`/docs`** - Read documentation (also built with Swiftlets!)
- **View source** - Check `sites/examples/swiftlets-site/src/` to see how it's built

> 💡 **Tip**: The entire documentation site you're reading is built with Swiftlets! Check out the source code to see real-world examples.

### 3. Understanding the Architecture

Swiftlets uses a unique architecture where each route is a standalone executable:

```
sites/examples/swiftlets-site/
├── src/              # Swift source files
│   ├── index.swift   # Homepage route
│   ├── about.swift   # About page route
│   └── docs/
│       └── index.swift  # Docs index route
├── web/              # Static files + .webbin markers
│   ├── styles/       # CSS files
│   ├── *.webbin      # Route markers (generated)
│   └── images/       # Static assets
└── bin/              # Compiled executables (generated)
    ├── index         # Executable for /
    ├── about         # Executable for /about
    └── docs/
        └── index     # Executable for /docs
```

Key concepts:
- **File-based routing:** Your file structure defines your routes
- **Independent executables:** Each route compiles to its own binary
- **No Makefiles needed:** The build-site script handles everything
- **Hot reload ready:** Executables can be rebuilt without restarting the server

### 4. Working with Sites

The build scripts make it easy to work with any site:

```bash
# Build a site (incremental - only changed files)
./build-site path/to/site

# Force rebuild all files
./build-site path/to/site --force

# Clean build artifacts
./build-site path/to/site --clean

# Run a site
./run-site path/to/site

# Run with custom port
./run-site path/to/site --port 3000

# Build and run in one command
./run-site path/to/site --build
```

> 💡 **Tip**: The scripts automatically detect your platform (macOS/Linux) and architecture (x86_64/arm64).

### Next Steps

- **[Component Showcase](/showcase)** - See all available components
- **[Study the Source](https://github.com/codelynx/swiftlets/tree/main/sites/examples/swiftlets-site)** - Learn from real examples
- **[HTML DSL Guide](/docs)** - Master the SwiftUI-like syntax

## 📝 Create Your First Page

### Traditional Approach

Create a simple page using the Swiftlets HTML DSL:

```swift
// src/index.swift
import Foundation
import Swiftlets

@main
struct HomePage {
    static func main() async throws {
        // Parse the request from stdin
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
                Title("Welcome to Swiftlets!")
                Meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
            }
            Body {
                Container(maxWidth: .large) {
                    VStack(spacing: 40) {
                        H1("Hello, Swiftlets! 👋")
                            .style("text-align", "center")
                            .style("margin-top", "3rem")
                        
                        P("Build modern web apps with Swift")
                            .style("font-size", "1.25rem")
                            .style("text-align", "center")
                            .style("color", "#6c757d")
                        
                        HStack(spacing: 20) {
                            Link(href: "/docs/getting-started", "Get Started")
                                .class("btn btn-primary")
                            Link(href: "/showcase", "See Examples")
                                .class("btn btn-outline-secondary")
                        }
                        .style("justify-content", "center")
                    }
                }
                .style("padding", "3rem 0")
            }
        }
        
        let response = Response(
            status: 200,
            headers: ["Content-Type": "text/html; charset=utf-8"],
            body: html.render()
        )
        
        print(try JSONEncoder().encode(response).base64EncodedString())
    }
}
```

### SwiftUI-Style Approach (NEW!)

Or use the new SwiftUI-inspired API with property wrappers:

```swift
// src/index.swift
import Swiftlets

@main
struct HomePage: SwiftletMain {
    @Query("name") var userName: String?
    @Cookie("theme") var theme: String?
    
    var title = "Welcome to Swiftlets!"
    var meta = ["viewport": "width=device-width, initial-scale=1.0"]
    
    var body: some HTMLElement {
        Container(maxWidth: .large) {
            VStack(spacing: 40) {
                H1("Hello, \(userName ?? "Swiftlets")! 👋")
                    .style("text-align", "center")
                    .style("margin-top", "3rem")
                
                P("Build modern web apps with Swift")
                    .style("font-size", "1.25rem")
                    .style("text-align", "center")
                    .style("color", theme == "dark" ? "#adb5bd" : "#6c757d")
                
                HStack(spacing: 20) {
                    Link(href: "/docs/getting-started", "Get Started")
                        .class("btn btn-primary")
                    Link(href: "/showcase", "See Examples")
                        .class("btn btn-outline-secondary")
                }
                .style("justify-content", "center")
            }
        }
        .style("padding", "3rem 0")
    }
}
```

Build and access your page:

```bash
# From your project directory
./build-site my-site
./run-site my-site

# Your page is now available at http://localhost:8080/
```

## 📂 Project Structure

```
my-site/
├── src/                    # Swift source files
│   ├── index.swift         # Home page (/)
│   ├── about.swift         # About page (/about)
│   └── api/
│       └── users.swift     # API endpoint (/api/users)
├── web/                    # Public web root
│   ├── *.webbin           # Route markers (generated)
│   ├── styles/            # CSS files
│   ├── scripts/           # JavaScript files
│   └── images/            # Static assets
├── bin/                    # Compiled executables (generated)
└── Components.swift       # Shared components (optional)
```

## 🎯 Core Concepts

### File-Based Routing

Your file structure automatically defines your routes:

- `src/index.swift` → `/`
- `src/about.swift` → `/about`
- `src/blog/index.swift` → `/blog`
- `src/blog/post.swift` → `/blog/post`
- `src/api/users.json.swift` → `/api/users.json`

### HTML DSL

Build HTML with Swift's type safety:

```swift
VStack(alignment: .center, spacing: .large) {
    H1("Welcome")
        .id("hero-title")
        .classes("display-1")
    
    ForEach(posts) { post in
        Article {
            H2(post.title)
            Paragraph(post.excerpt)
            Link("Read more", href: "/blog/\(post.slug)")
        }
        .classes("mb-4")
    }
}
```

### Request/Response Handling

Handle dynamic requests with ease using property wrappers:

```swift
import Swiftlets

@main
struct APIHandler: SwiftletMain {
    @Query("limit", default: "10") var limit: String?
    @Query("offset", default: "0") var offset: String?
    @JSONBody<UserFilter>() var filter: UserFilter?
    
    var title = "User API"
    
    var body: ResponseBuilder {
        let users = fetchUsers(
            limit: Int(limit ?? "10") ?? 10,
            offset: Int(offset ?? "0") ?? 0,
            filter: filter
        )
        
        return ResponseWith {
            Pre(try! JSONEncoder().encode(users).string())
        }
        .contentType("application/json")
        .header("X-Total-Count", value: "\(users.count)")
    }
}
```

Or handle cookies and form data:

```swift
@main
struct LoginHandler: SwiftletMain {
    @FormValue("username") var username: String?
    @FormValue("password") var password: String?
    @Cookie("session") var existingSession: String?
    
    var title = "Login"
    
    var body: ResponseBuilder {
        // Check existing session
        if let session = existingSession, validateSession(session) {
            return ResponseWith {
                Div { H1("Already logged in!") }
            }
        }
        
        // Handle login
        if let user = username, let pass = password {
            if authenticate(user, pass) {
                let sessionId = createSession(for: user)
                return ResponseWith {
                    Div { H1("Welcome, \(user)!") }
                }
                .cookie("session", value: sessionId, httpOnly: true)
            }
        }
        
        // Show login form
        return ResponseWith {
            Form(action: "/login", method: "POST") {
                Input(type: "text", name: "username", placeholder: "Username")
                Input(type: "password", name: "password", placeholder: "Password")
                Button("Login", type: "submit")
            }
        }
    }
}
```

## 🌍 Platform Support

### macOS
- **Requirements**: macOS 13+, Swift 6.0+
- **Architectures**: Intel (x86_64) and Apple Silicon (arm64)

### Linux
- **Distributions**: Ubuntu 22.04 LTS+
- **Architectures**: x86_64 and ARM64
- **Swift**: 5.10+ from [swift.org](https://swift.org)

### Cross-Platform Scripts

All build scripts work identically on macOS and Linux. See [Ubuntu Scripting Issue](docs/ubuntu-scripting-issue.md) for platform-specific considerations.

```bash
# Build for current platform
./build-server

# Check Ubuntu prerequisites
./check-ubuntu-prerequisites.sh

# Run the server
./run-server.sh
```

## 📚 Documentation

Visit the [showcase site](http://localhost:8080/docs) for interactive documentation, or explore these references:

### Core Documentation
- [**CLI Reference**](docs/CLI.md) - Complete CLI documentation
- [**Routing Guide**](docs/ROUTING.md) - Advanced routing patterns
- [**Configuration**](docs/CONFIGURATION.md) - Server configuration
- [**Architecture**](docs/swiftlet-architecture.md) - How Swiftlets works

### SwiftUI-Style API (NEW!)
- [**SwiftUI API Implementation**](docs/SWIFTUI-API-IMPLEMENTATION.md) - Complete guide with examples
- [**SwiftUI API Reference**](docs/SWIFTUI-API-REFERENCE.md) - All property wrappers and protocols

### HTML DSL
- [**HTML DSL Reference**](docs/html-elements-reference.md) - All HTML components
- [**SDK Distribution**](docs/sdk-distribution-plan.md) - Future SDK packaging plans

## 🧪 Examples & Showcase

### 🌟 Official Showcase Site

The best way to learn Swiftlets is by exploring our comprehensive showcase:

```bash
# Quick start with the showcase
./smake build sites/examples/swiftlets-site
./smake run sites/examples/swiftlets-site
```

The showcase includes:
- **Component Gallery** - All HTML elements with live examples
- **Layout Demos** - HStack, VStack, Grid, and responsive layouts
- **Modifiers Playground** - Styling and customization examples
- **Interactive Documentation** - Learn by doing

### Other Examples

- [**Test Sites**](sites/tests/) - Testing sites for framework development
- [**Templates**](templates/) - Project templates for quick start

### Run Any Example

```bash
# List all available sites
./smake list

# Run a specific site
./smake run sites/examples/swiftlets-site
```

## 📁 Project Structure

```
swiftlets/
├── Sources/           # Framework and server source code
├── bin/{os}/{arch}/   # Platform-specific binaries
├── sites/             # Example and test sites
├── templates/         # Project templates
├── tools/             # Build and packaging tools
└── docs/              # Documentation
```

See [Project Structure](docs/PROJECT-STRUCTURE.md) for details.

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

```bash
# Run tests
make test

# Check code style
make lint

# Build documentation
make docs
```

## 🗺 Roadmap

See our [detailed roadmap](docs/roadmap.md) for more information.

## 📄 License

Swiftlets is released under the MIT License. See [LICENSE](LICENSE) for details.

## 🔧 Troubleshooting

### Common Issues

- **Only one file builds on Linux**: This is a known bash loop issue. See [Ubuntu Scripting Issue](docs/ubuntu-scripting-issue.md) for details.
- **MD5 command not found**: The scripts automatically handle differences between macOS (md5) and Linux (md5sum).
- **Build errors**: Use `--verbose` flag for detailed output: `./build-site sites/your-site --verbose`

For more troubleshooting help, see the [documentation](docs/).

## 🙏 Acknowledgments

- Inspired by [Ignite](https://github.com/twostraws/Ignite) by Paul Hudson
- Built with Swift and ❤️

---

<p align="center">
  <a href="https://swiftlets.dev">Website</a> •
  <a href="https://github.com/yourusername/swiftlets">GitHub</a> •
  <a href="https://twitter.com/swiftlets">Twitter</a> •
  <a href="https://discord.gg/swiftlets">Discord</a>
</p>