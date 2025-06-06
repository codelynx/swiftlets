# Swiftlets 🚀

> A modern Swift web framework with file-based routing and declarative HTML generation

[![Swift](https://img.shields.io/badge/Swift-6.0+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-macOS%20|%20Linux-lightgray.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## What is Swiftlets?

Swiftlets is a lightweight, Swift-based web framework that brings the simplicity of file-based routing and the power of type-safe HTML generation to server-side Swift development. Inspired by modern web frameworks, it offers a unique approach where each route is an independent executable module.

### ✨ Key Features

- **🗂 File-Based Routing** - Your file structure defines your routes (`.webbin` files)
- **🏗 Declarative HTML DSL** - SwiftUI-like syntax for type-safe HTML generation
- **🔧 Zero Configuration** - No complex routing tables or configuration files
- **🔒 Security First** - Source files stay outside the web root, MD5 integrity checks
- **♻️ Hot Reload** - Automatic compilation and reloading during development
- **🌍 Cross-Platform** - Works on macOS (Intel/Apple Silicon) and Linux (x86_64/ARM64)

## 🚀 Quick Start

### Install the CLI (Recommended)

```bash
# Install Swiftlets CLI
./install-cli.sh

# Create a new project
swiftlets new my-awesome-app
cd my-awesome-app

# Start developing
swiftlets serve
```

Visit `http://localhost:8080` to see your app running!

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/swiftlets.git
cd swiftlets

# Build everything
./build.sh

# Run the server
./run-server.sh
```

## 📝 Your First Swiftlet

Create a simple page using the Swiftlets HTML DSL:

```swift
// src/index.swift
import Swiftlets

@main
struct HomePage {
    static func main() {
        let html = Html {
            Head {
                Title("Welcome to Swiftlets!")
                Meta(.charset("UTF-8"))
                Meta(.viewport("width=device-width, initial-scale=1.0"))
            }
            Body {
                Container {
                    H1("Hello, Swiftlets! 👋")
                        .classes("text-center", "mt-5")
                    
                    Paragraph("Build modern web apps with Swift")
                        .classes("lead", "text-muted")
                    
                    HStack(spacing: .medium) {
                        Button("Get Started")
                            .classes("btn", "btn-primary")
                        Button("Learn More")
                            .classes("btn", "btn-outline-secondary")
                    }
                    .classes("mt-4")
                }
            }
        }
        
        print(html.render())
    }
}
```

Build and access your page:

```bash
swiftlets build
# Your page is now available at http://localhost:8080/
```

## 📂 Project Structure

```
my-app/
├── src/                    # Swift source files
│   ├── index.swift         # Home page (/)
│   ├── about.swift         # About page (/about)
│   └── api/
│       └── users.swift     # API endpoint (/api/users)
├── web/                    # Public web root
│   ├── *.webbin           # Compiled route files
│   ├── styles/            # CSS files
│   ├── scripts/           # JavaScript files
│   └── images/            # Static assets
├── bin/                    # Compiled executables
└── Package.swift          # Swift package manifest
```

## 🛠 CLI Commands

| Command | Description |
|---------|-------------|
| `swiftlets new <name>` | Create a new project |
| `swiftlets init` | Initialize in current directory |
| `swiftlets serve` | Start development server |
| `swiftlets build` | Build all swiftlets |
| `swiftlets build <target>` | Build specific swiftlet |

### Examples

```bash
# Create project with template
swiftlets new blog --template blog

# Serve on different port
swiftlets serve --port 3000

# Production build
swiftlets build --release

# Clean and rebuild
swiftlets build --clean
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

Handle dynamic requests with ease:

```swift
import Swiftlets

@main
struct APIHandler {
    static func main() {
        let request = Request.parse()
        
        let users = [
            ["id": 1, "name": "Alice"],
            ["id": 2, "name": "Bob"]
        ]
        
        let response = Response(
            statusCode: 200,
            headers: ["Content-Type": "application/json"],
            body: users
        )
        
        response.send()
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

```bash
# Build for current platform
./build.sh

# Check Ubuntu prerequisites
./check-ubuntu-prerequisites.sh

# Run the server
./run-server.sh
```

## 📚 Documentation

- [**Getting Started**](docs/getting-started.md) - Step-by-step tutorial
- [**CLI Reference**](docs/CLI.md) - Complete CLI documentation
- [**Routing Guide**](docs/ROUTING.md) - Advanced routing patterns
- [**HTML DSL Reference**](docs/html-elements-reference.md) - All HTML components
- [**Configuration**](docs/CONFIGURATION.md) - Server configuration
- [**Architecture**](docs/swiftlet-architecture.md) - How Swiftlets works
- [**SDK Distribution**](docs/sdk-distribution-plan.md) - Future SDK packaging plans

## 🧪 Examples

Explore working examples:

- [**Swiftlets Site**](sdk/sites/swiftlets-site/) - Official documentation site
- [**Test Sites**](core/sites/) - Testing sites for framework development
- [**Showcase**](sdk/sites/showcase/) - Layout examples

Run the documentation site:

```bash
cd sdk/sites/swiftlets-site
make serve
```

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