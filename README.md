# Swiftlets

A Swift-based web framework for building server-side applications with a unique file-based routing system.

## Quick Start

### Using the CLI (Recommended)

```bash
# Install the Swiftlets CLI
./install-cli.sh

# Create a new project
swiftlets new my-app
cd my-app

# Start the development server
swiftlets serve

# Build your swiftlets
swiftlets build
```

### Manual Setup

```bash
# Build everything
./build.sh

# Run the server
./run-server.sh
# Server runs at http://localhost:8080

# Or use Make for more options
make help    # Show all available commands
make dev     # Build and run in one command
```

## Project Structure

```
swiftlets/
├── core/               # Framework source code
├── sdk/                # SDK for developers
│   ├── examples/       # Example projects
│   ├── templates/      # Project templates
│   └── tools/          # CLI tools
├── examples/           # Core development examples
│   └── basic-site/     # Working example with webbin routing
└── docs/               # Documentation
```

## Key Features

- **Webbin Routing**: File-based routing with `.webbin` files
- **SwiftletsHTML DSL**: Type-safe HTML generation
- **Zero Configuration**: Routes defined by file structure
- **Security First**: Source and build files outside web root
- **MD5 Integrity**: Webbin files contain executable hashes

## CLI Commands

The Swiftlets CLI provides convenient commands for development:

```bash
# Create a new project from template
swiftlets new <project-name> [--template <name>]

# Initialize Swiftlets in existing directory
swiftlets init [--force]

# Start development server
swiftlets serve [<path>] [--port <port>] [--host <host>]

# Build swiftlets
swiftlets build [<target>] [--release] [--clean]
```

## Documentation

- [CLI Guide](docs/CLI.md) - Command-line interface documentation
- [Configuration Guide](docs/CONFIGURATION.md) - Server configuration options
- [Routing Guide](docs/ROUTING.md) - How routing works
- [Project Structure](docs/project-structure.md) - Architecture overview
- [Project Status](PROJECT_STATUS.md) - Current implementation status

## Development

### Using Make

```bash
make server          # Run the development server
make test           # Run all tests
make example        # Build and run basic-site example
make clean          # Clean all build artifacts
```

### Creating a New Project

```bash
# Using the SDK tool
sdk/tools/swiftlets-init my-project

# Or use Make
make init NAME=my-project
```

## Example

See the [basic-site example](examples/basic-site/) for a working implementation:

```bash
cd examples/basic-site
make serve
```

## Platform Support

### macOS
- macOS 13+ (Intel and Apple Silicon)
- Swift 6.0+
- Xcode recommended

### Linux (Ubuntu)
- Ubuntu 22.04 LTS or newer
- Supports x86_64 and ARM64 (aarch64)
- Swift 5.10+ from swift.org

## Cross-Platform Build

We provide universal build scripts that work on both macOS and Linux:

```bash
# Universal build script (recommended)
./build-universal.sh

# Universal run script
./run-universal.sh

# Check Ubuntu prerequisites
./check-ubuntu-prerequisites.sh
```

### Ubuntu ARM64 Setup

```bash
# Check prerequisites
./check-ubuntu-prerequisites.sh

# Install Swift (example for 5.10.1)
wget https://download.swift.org/swift-5.10.1-release/ubuntu2204-aarch64/swift-5.10.1-RELEASE/swift-5.10.1-RELEASE-ubuntu22.04-aarch64.tar.gz
tar xzf swift-5.10.1-RELEASE-ubuntu22.04-aarch64.tar.gz
sudo mv swift-5.10.1-RELEASE-ubuntu22.04-aarch64 /usr/local/swift
echo 'export PATH=/usr/local/swift/usr/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Build and run
./build-universal.sh
./run-universal.sh
```

## License

[Add your license here]