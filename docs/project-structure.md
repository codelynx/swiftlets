# Swiftlets Project Structure

## Overview

Swiftlets uses a unified directory structure designed for clarity, cross-platform support, and standard package distribution. All source code lives under a single `Sources/` directory, with platform-specific binaries organized by OS and architecture.

## Directory Layout

```
swiftlets/
├── Sources/                    # All source code
│   ├── Swiftlets/             # Framework library
│   │   ├── Core/              # Core types (Request, Response, Swiftlet)
│   │   └── HTML/              # HTML DSL
│   │       ├── Builders/      # Result builders (@HTMLBuilder)
│   │       ├── Core/          # Base HTML types
│   │       ├── Elements/      # HTML elements (Div, H1, P, etc.)
│   │       ├── Helpers/       # ForEach, If, Fragment
│   │       ├── Layout/        # HStack, VStack, Grid, Container
│   │       └── Modifiers/     # Style and attribute modifiers
│   │
│   ├── SwiftletsServer/       # Web server executable
│   │   └── main.swift         # Server implementation
│   │
│   └── SwiftletsCLI/          # Command-line interface
│       ├── SwiftletsCLI.swift # Main CLI entry point
│       └── Commands/          # CLI commands
│           ├── Build.swift    # Build command
│           ├── Init.swift     # Init command
│           ├── New.swift      # New project command
│           └── Serve.swift    # Development server command
│
├── Tests/                     # Test suite
│   └── SwiftletsTests/        # Framework tests
│       ├── BasicElementsTests.swift
│       ├── FormElementsTests.swift
│       ├── HelpersTests.swift
│       ├── LayoutTests.swift
│       └── ListsAndTablesTests.swift
│
├── bin/                       # Platform-specific binaries (gitignored)
│   ├── darwin/                # macOS
│   │   ├── x86_64/           # Intel Macs
│   │   │   ├── swiftlets
│   │   │   └── swiftlets-server
│   │   └── arm64/            # Apple Silicon
│   │       ├── swiftlets
│   │       └── swiftlets-server
│   └── linux/                 # Linux
│       ├── x86_64/           # Intel/AMD
│       │   ├── swiftlets
│       │   └── swiftlets-server
│       └── arm64/            # ARM processors
│           ├── swiftlets
│           └── swiftlets-server
│
├── sites/                     # Websites and web applications
│   ├── examples/              # Example sites for users
│   │   └── swiftlets-site/    # Official documentation site
│   │       ├── Makefile       # Build configuration
│   │       ├── src/           # Swift source files
│   │       │   ├── index.swift
│   │       │   ├── about.swift
│   │       │   ├── showcase.swift
│   │       │   └── docs/
│   │       │       └── getting-started.swift
│   │       └── web/           # Web root directory
│   │           ├── bin/       # Compiled swiftlets
│   │           ├── *.webbin   # Route markers
│   │           └── styles/    # Static assets
│   │
│   └── tests/                 # Test sites for framework development
│       ├── test-html/         # HTML DSL testing
│       ├── test-routing/      # Routing system testing
│       └── benchmark/         # Performance benchmarks
│
├── templates/                 # Project templates
│   └── blank/                 # Minimal starter template
│       ├── Makefile
│       ├── Package.swift
│       ├── src/
│       │   └── index.swift
│       └── web/
│           └── index.webbin
│
├── tools/                     # Build tools and utilities
│   ├── build.sh              # Build script
│   ├── install-cli.sh        # CLI installer
│   ├── run-server.sh         # Server runner
│   └── package/              # Platform packaging
│       ├── ubuntu/           # Debian/Ubuntu .deb
│       │   └── build-deb.sh
│       ├── macos/            # macOS installer
│       └── docker/           # Docker images
│
├── docs/                      # Documentation
├── external/                  # External dependencies
│   └── Ignite/               # Ignite framework (reference)
│
├── Package.swift             # Swift package manifest
├── Makefile                  # Main build system
├── README.md                 # Project readme
└── CLAUDE.md                 # AI context file
```

## Key Concepts

### Source Organization

All Swift source code lives under `Sources/` with three main components:

1. **Swiftlets** - The framework library providing HTML DSL and core types
2. **SwiftletsServer** - The web server that executes swiftlets
3. **SwiftletsCLI** - Command-line tools for development

### Binary Organization

Compiled binaries are organized by platform in `bin/{os}/{arch}/`:
- `darwin/x86_64` - macOS Intel
- `darwin/arm64` - macOS Apple Silicon  
- `linux/x86_64` - Linux x64
- `linux/arm64` - Linux ARM

The Makefile automatically detects your platform and builds to the correct location.

### Sites Structure

Sites are divided into two categories:

1. **examples/** - User-facing example sites and documentation
2. **tests/** - Internal test sites for framework development

Each site follows a standard structure:
```
site-name/
├── Makefile           # Site-specific build configuration
├── src/               # Swift source files
│   └── *.swift       # One file per route
└── web/              # Web root (served by server)
    ├── bin/          # Compiled executables
    ├── *.webbin      # Route markers (contain MD5 hash)
    └── static/       # CSS, images, etc.
```

### Swiftlet Architecture

Each route is an independent executable:
- Source: `src/index.swift`
- Compiled to: `web/bin/index`
- Marked by: `web/index.webbin` (contains MD5 hash)

This provides perfect isolation and enables hot-reload during development.

## Building

### Quick Start
```bash
# Build everything
make build

# Build release version
make build-release

# Run server with example site
make run
```

### Platform Detection

The build system automatically detects your OS and architecture:
```makefile
OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH := $(shell uname -m)
```

### Building Sites

Each site has its own Makefile that:
1. Compiles Swift files directly with framework sources
2. Creates executables in `web/bin/`
3. Generates `.webbin` files with MD5 hashes

```bash
cd sites/examples/swiftlets-site
make build
```

## Package Distribution

The structure supports standard package managers:

### Ubuntu/Debian
```bash
make package-ubuntu  # Creates .deb package
```

Installs to:
- `/usr/bin/` - Executables
- `/usr/lib/swiftlets/` - Framework sources
- `/usr/share/swiftlets/` - Templates and examples

### macOS
Future support for Homebrew and .pkg installers.

### Docker
Container images with pre-built binaries.

## Environment Variables

### SWIFTLETS_SITE
Specifies which site to serve:
```bash
SWIFTLETS_SITE=sites/examples/swiftlets-site ./bin/darwin/arm64/swiftlets-server
```

### SWIFTLETS_SDK_ROOT (Future)
For installed SDK packages:
```bash
export SWIFTLETS_SDK_ROOT=/usr/local/opt/swiftlets
```

## Development Workflow

1. **Edit source files** in `Sources/` or site `src/`
2. **Build** with `make build` or site-specific `make`
3. **Run** with `make run` or direct execution
4. **Test** with `make test`
5. **Package** with `make package-{platform}`

## File Types

- `.swift` - Swift source files
- `.webbin` - Route marker files (contain MD5 hash)
- `Makefile` - Build configuration
- `Package.swift` - Swift package manifest

## Benefits

1. **Unified Structure** - Single source tree, no confusing separations
2. **Platform Support** - Clear binary organization for all platforms
3. **Package Ready** - Aligns with standard OS package layouts
4. **Development Friendly** - Simple imports and clear dependencies
5. **Distribution Ready** - Easy to package for any platform