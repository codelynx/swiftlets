# Swiftlets Scripts Workflow

This document describes the cross-platform build and run workflow using the provided scripts.

## Scripts Overview

### 1. `build-server` - Build the Swiftlets server
Builds the server binary and installs to `bin/{os}/{arch}/` for your platform.

```bash
# Debug build
./build-server

# Release build (optimized)
./build-server --release

# Clean and rebuild
./build-server --clean --release
```

### 2. `build-site` - Build a Swiftlets site
Compiles Swift source files from `src/` to executables in `bin/` and creates `.webbin` routing markers.

```bash
# Build a site
./build-site sites/examples/swiftlets-site

# Verbose output
./build-site sites/examples/swiftlets-site --verbose

# Force rebuild all files
./build-site sites/examples/swiftlets-site --force

# Clean build artifacts
./build-site sites/examples/swiftlets-site --clean

# Clean and force rebuild
./build-site sites/examples/swiftlets-site --clean --force --verbose
```

### 3. `run-site` - Launch server with a site
Starts the Swiftlets server with the specified site. Automatically finds or builds the server binary.

```bash
# Run with default settings (localhost:8080)
./run-site sites/examples/swiftlets-site

# Custom port
./run-site sites/examples/swiftlets-site --port 3000

# Custom host and port
./run-site sites/examples/swiftlets-site --host 0.0.0.0 --port 8080

# Build site before running
./run-site sites/examples/swiftlets-site --build

# Enable debug logging
./run-site sites/examples/swiftlets-site --debug
```


## Typical Workflows

### Quick Start (First Time)
```bash
# 1. Build the server (installs to bin/{os}/{arch}/)
./build-server --release

# 2. Build your site
./build-site sites/examples/swiftlets-site

# 3. Run the site
./run-site sites/examples/swiftlets-site
```

### Development Workflow
```bash
# Build and run with one command
./run-site sites/examples/swiftlets-site --build

# Or separately for more control
./build-site sites/examples/swiftlets-site --verbose
./run-site sites/examples/swiftlets-site --debug
```

### Production Build
```bash
# Build optimized server
./build-server --release

# Force rebuild site
./build-site sites/examples/swiftlets-site --clean --force

# Run on all interfaces
./run-site sites/examples/swiftlets-site --host 0.0.0.0 --port 80
```

### Building Multiple Sites
```bash
# Build specific sites
./build-site sites/examples/swiftlets-site
./build-site sites/examples/another-site

# Or use shell to build multiple
for site in sites/examples/*; do
    [ -d "$site/src" ] && ./build-site "$site"
done
```

### Clean Everything
```bash
# Clean server build
swift package clean

# Clean site build
./build-site sites/examples/swiftlets-site --clean

# Or manually
rm -rf sites/examples/swiftlets-site/bin
find sites/examples/swiftlets-site/web -name "*.webbin" -delete
```

## Platform Support

All scripts automatically detect your platform:
- **macOS**: darwin/x86_64 or darwin/arm64
- **Linux**: linux/x86_64 or linux/arm64

The scripts handle platform differences like:
- `md5` vs `md5sum` for checksum generation
- Binary paths for platform-specific builds

## Benefits Over Makefiles

1. **No per-site Makefiles needed** - Just `src/` and `web/` directories
2. **Cross-platform** - Same scripts work on macOS and Linux
3. **Smart defaults** - Automatically finds or builds what's needed
4. **Clear workflow** - Separate concerns for server, site, and running
5. **Flexible options** - Debug, release, custom ports, etc.

## Directory Structure

```
swiftlets/
├── build-server        # Build server binary
├── build-site          # Build a site
├── run-site           # Launch server with site
├── bin/
│   ├── darwin/
│   │   ├── x86_64/    # macOS Intel binaries
│   │   └── arm64/     # macOS Apple Silicon binaries
│   └── linux/
│       ├── x86_64/    # Linux x64 binaries
│       └── arm64/     # Linux ARM binaries
└── sites/
    └── example-site/
        ├── src/       # Swift source files
        ├── web/       # Static files + .webbin markers
        └── bin/       # Compiled executables
```