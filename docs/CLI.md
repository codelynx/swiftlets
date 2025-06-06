# Swiftlets CLI Documentation

The Swiftlets CLI provides a streamlined development experience for creating and managing Swiftlets projects.

## Installation

```bash
# From the Swiftlets repository root
./install-cli.sh

# The installer will:
# - Build the CLI in release mode
# - Install to ~/.local/bin (user) or /usr/local/bin (system)
# - Create a wrapper script with SWIFTLETS_HOME set
```

### Manual Installation

```bash
cd cli
swift build -c release
cp .build/release/swiftlets /usr/local/bin/
```

## Commands

### `swiftlets new`

Create a new Swiftlets project from a template.

```bash
swiftlets new <project-name> [options]
```

**Options:**
- `--template <name>` - Template to use (default: blank)
- `--skip-git` - Skip git repository initialization

**Examples:**
```bash
# Create a new project with default template
swiftlets new my-website

# Use a specific template
swiftlets new my-blog --template blog

# Create without git
swiftlets new my-app --skip-git
```

**Available Templates:**
- `blank` - Minimal starter template (default)
- More templates can be added to `templates/`

### `swiftlets init`

Initialize Swiftlets in an existing directory.

```bash
swiftlets init [options]
```

**Options:**
- `--force` - Overwrite existing files

**What it creates:**
- `src/` - Source directory for swiftlets
- `web/` - Web root directory
- `web/bin/` - Compiled swiftlets
- `Package.swift` - Swift package manifest
- `Makefile` - Build convenience commands
- `.gitignore` - Git ignore patterns
- `src/index.swift` - Sample swiftlet

**Example:**
```bash
cd my-existing-project
swiftlets init
```

### `swiftlets serve`

Start the development server.

```bash
swiftlets serve [path] [options]
```

**Arguments:**
- `path` - Site directory (default: current directory)

**Options:**
- `-p, --port <port>` - Port to listen on (default: 8080)
- `-h, --host <host>` - Host to bind to (default: 127.0.0.1)
- `--release` - Use release build of server
- `--quiet` - Suppress server output

**Examples:**
```bash
# Serve current directory
swiftlets serve

# Serve specific site
swiftlets serve sites/examples/swiftlets-site

# Use custom port
swiftlets serve --port 3000

# Bind to all interfaces
swiftlets serve --host 0.0.0.0
```

### `swiftlets build`

Build swiftlets for the current project.

```bash
swiftlets build [target] [options]
```

**Arguments:**
- `target` - Specific swiftlet to build (builds all if omitted)

**Options:**
- `--release` - Build in release mode with optimizations
- `--clean` - Clean build artifacts before building
- `--verbose` - Show detailed build output

**Examples:**
```bash
# Build all swiftlets
swiftlets build

# Build specific swiftlet
swiftlets build index

# Production build
swiftlets build --release --clean

# Debug build issues
swiftlets build --verbose
```

## Project Structure

The CLI expects/creates this project structure:

```
my-project/
├── Package.swift       # Swift package manifest
├── Makefile           # Convenience commands
├── .gitignore         # Git ignore patterns
├── src/               # Swiftlet source files
│   ├── index.swift    # Main page swiftlet
│   └── about.swift    # Additional swiftlets
└── web/               # Web root (served by server)
    ├── index.webbin   # Route mapping files
    ├── style.css      # Static assets
    └── bin/           # Compiled swiftlets
        ├── index      # Executable from index.swift
        └── about      # Executable from about.swift
```

## Environment Integration

The CLI automatically sets environment variables for the server:

- `SWIFTLETS_SITE` - Site directory path
- `SWIFTLETS_HOST` - Server host
- `SWIFTLETS_PORT` - Server port

## Platform Support

The CLI works on both macOS and Linux:

- **macOS**: Intel (x86_64) and Apple Silicon (arm64)
- **Linux**: x86_64 and ARM64 (aarch64)

The CLI automatically detects the platform and finds the appropriate server binary.

## Development Workflow

### Basic Workflow

```bash
# 1. Create new project
swiftlets new my-app

# 2. Navigate to project
cd my-app

# 3. Start development server
swiftlets serve

# 4. Edit src/index.swift
# 5. Build changes
swiftlets build

# 6. Refresh browser
```

### Advanced Workflow

```bash
# Initialize in existing project
cd existing-project
swiftlets init

# Build for production
swiftlets build --release --clean

# Serve on different port
swiftlets serve --port 3000

# Build specific swiftlet
swiftlets build api/users
```

## Configuration

The CLI respects these environment variables:

- `SWIFTLETS_HOME` - Path to Swiftlets repository (set by installer)
- Standard server variables (see [Configuration Guide](CONFIGURATION.md))

## Troubleshooting

### "Server not found" Error

The CLI looks for the server in these locations:
1. `bin/{os}/{arch}/swiftlets-server`
2. Platform-specific build directories
3. `/usr/local/bin/swiftlets-server`

Build the server first:
```bash
cd $SWIFTLETS_HOME/core
swift build --product swiftlets-server
```

### Template Not Found

Templates are searched in:
1. `../../templates/` (development)
2. `/usr/local/share/swiftlets/templates/` (installed)
3. Relative to CLI executable

### Permission Denied

If installed to system directories:
```bash
sudo ./install-cli.sh
```

Or install to user directory:
```bash
./install-cli.sh  # Installs to ~/.local/bin
```

## Future Enhancements

Planned features for the CLI:

1. **Auto-compilation** - `swiftlets serve --watch`
2. **Hot reload** - Automatic browser refresh
3. **Deployment** - `swiftlets deploy`
4. **Testing** - `swiftlets test`
5. **Package management** - `swiftlets add <package>`

## Contributing

The CLI source is in `cli/` directory. To contribute:

1. Make changes to `cli/Sources/SwiftletsCLI/`
2. Test with `swift run` in the cli directory
3. Build release with `swift build -c release`
4. Test the built binary