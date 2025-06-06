# Unified Project Structure (Current)

## Overview

As of 2025-06-06, Swiftlets has been reorganized into a unified structure that merges the previous `core` and `sdk` directories. This document describes the current project layout.

## Directory Structure

```
swiftlets/
├── Sources/                    # All source code (unified)
│   ├── Swiftlets/             # Framework library
│   │   ├── Core/              # Core types (Request, Response)
│   │   └── HTML/              # HTML DSL
│   │       ├── Builders/      # Result builders
│   │       ├── Core/          # Base HTML types
│   │       ├── Elements/      # HTML elements
│   │       ├── Helpers/       # ForEach, If, etc.
│   │       ├── Layout/        # HStack, VStack, etc.
│   │       └── Modifiers/     # Style and attribute modifiers
│   ├── SwiftletsServer/       # Web server implementation
│   └── SwiftletsCLI/          # Command-line interface
│       └── Commands/          # CLI commands (build, serve, etc.)
│
├── Tests/                     # Test suite
│   └── SwiftletsTests/        # Framework tests
│
├── bin/                       # Platform-specific binaries
│   ├── darwin/                # macOS
│   │   ├── x86_64/           # Intel
│   │   └── arm64/            # Apple Silicon
│   └── linux/                 # Linux
│       ├── x86_64/           # Intel/AMD
│       └── arm64/            # ARM
│
├── sites/                     # All websites
│   ├── examples/              # Example sites
│   │   └── swiftlets-site/    # Official documentation site
│   └── tests/                 # Test sites for framework development
│       ├── test-html/         # HTML DSL testing
│       ├── test-routing/      # Routing testing
│       └── benchmark/         # Performance benchmarks
│
├── templates/                 # Project templates
│   └── blank/                 # Basic template
│
├── tools/                     # Build tools and scripts
│   ├── package/               # Platform packaging scripts
│   │   ├── ubuntu/           # Debian package builder
│   │   ├── macos/            # macOS installer
│   │   └── docker/           # Docker images
│   ├── build.sh              # Build script
│   ├── install-cli.sh        # CLI installer
│   └── run-server.sh         # Server runner
│
├── docs/                      # Documentation
├── Package.swift              # Root Swift package
├── Makefile                  # Main build system
└── README.md                 # Project readme
```

## Key Changes from Previous Structure

1. **Unified Sources**: All source code now lives under `Sources/` at the root
2. **Platform Binaries**: Executables are organized by OS and architecture in `bin/`
3. **Simplified Sites**: Sites are categorized as either examples or tests
4. **Centralized Tools**: All scripts and tools are in the `tools/` directory

## Building

```bash
# Build everything
make build

# Build release versions
make build-release

# Build specific component
swift build --product swiftlets-server
swift build --product swiftlets
```

## Binary Locations

After building, binaries are placed in platform-specific directories:

- macOS Intel: `bin/darwin/x86_64/`
- macOS Apple Silicon: `bin/darwin/arm64/`
- Linux x86_64: `bin/linux/x86_64/`
- Linux ARM64: `bin/linux/arm64/`

## Running

```bash
# Using make (recommended)
make run

# Direct execution
SWIFTLETS_SITE=sites/examples/swiftlets-site ./bin/darwin/arm64/swiftlets-server

# From site directory
cd sites/examples/swiftlets-site
make serve
```

## Benefits

1. **Simpler Structure**: Single source tree, easier navigation
2. **Platform Support**: Clear binary organization for cross-platform builds
3. **Package Ready**: Structure aligns with standard packaging conventions
4. **Development Friendly**: Unified imports and dependencies
5. **Distribution Ready**: Prepared for various package managers

## Migration from Old Structure

If you have an existing checkout:

1. Pull the latest changes
2. Clean build artifacts: `make clean`
3. Rebuild: `make build`
4. Update any custom scripts to use new paths

### Path Changes

- `core/Sources/` → `Sources/`
- `cli/Sources/SwiftletsCLI/` → `Sources/SwiftletsCLI/`
- `sdk/sites/` → `sites/examples/`
- `core/sites/` → `sites/tests/`
- `sdk/templates/` → `templates/`
- Build scripts → `tools/`
- `.build/release/swiftlets-server` → `bin/{os}/{arch}/swiftlets-server`