# Site Management in Swiftlets

## Overview

Swiftlets supports multiple sites within a single project. This document explains how to manage and run different sites using the build scripts.

## Quick Start with Build Scripts

The project provides three main scripts for working with sites:

```bash
# Build the server (one time)
./build-server

# Build a site
./build-site sites/examples/swiftlets-site

# Run a site
./run-site sites/examples/swiftlets-site

# Or combine build and run
./run-site sites/examples/swiftlets-site --build

# Clean site artifacts
./build-site sites/examples/swiftlets-site --clean

# Force rebuild
./build-site sites/examples/swiftlets-site --force
```

## Building Multiple Sites

To build multiple sites, use shell commands:

```bash
# Build all example sites
for site in sites/examples/*; do
    [ -d "$site/src" ] && ./build-site "$site"
done

# Build all test sites
for site in sites/tests/*; do
    [ -d "$site/src" ] && ./build-site "$site"
done

# List available sites
find sites -name "src" -type d | while read src; do
    echo "$(dirname "$src")"
done
```

## Alternative Methods

### Method 1: Direct Server Execution
```bash
# Build server first (if not already built)
./build-server

# Run with specific site
./bin/darwin/arm64/swiftlets-server sites/examples/swiftlets-site
```

### Method 2: From Site Directory
```bash
# Navigate to site and build/run from there
cd sites/examples/swiftlets-site
../../../build-site .
../../../run-site .
```

### Method 3: Using CLI Tool
```bash
# Use swiftlets CLI (if installed)
swiftlets serve --site sites/examples/swiftlets-site
```

## Site Organization

```
sites/
├── core/           # Core example sites
│   ├── hello/      # Minimal example
│   └── showcase/   # Feature showcase
├── examples/       # Full example sites
│   └── swiftlets-site/  # Main documentation site
└── tests/          # Test sites
    ├── test-html/  # HTML DSL tests
    └── test-routing/  # Routing tests
```

## What's New

The site management system now uses dedicated scripts:

1. **`build-site`** - Universal site builder (no Makefile needed)
2. **`run-site`** - Cross-platform server launcher
3. **No per-site Makefiles** - Sites just need `src/` and `web/` directories
4. **Incremental builds** - Only rebuilds changed files
5. **Platform detection** - Automatically uses correct binaries

## Best Practices

1. **Development**: Work from the site directory for faster iteration
   ```bash
   cd sites/examples/my-site
   ../../../build-site .
   ../../../run-site . --debug
   ```

2. **Testing Multiple Sites**: Run on different ports
   ```bash
   ./run-site sites/core/hello --port 8080 &
   ./run-site sites/core/showcase --port 8081 &
   ```

3. **Production**: Use release build and explicit host
   ```bash
   ./build-server --release
   ./build-site /path/to/production/site --force
   ./run-site /path/to/production/site --host 0.0.0.0
   ```

## Configuration Files

Each site needs only:
- `src/` - Swift source files
- `web/` - Static files and generated `.webbin` markers
- `bin/` - (Generated) Compiled executables

Future configuration options:
- `Package.swift` - Dependencies
- `swiftlets.yml` - Site settings

## Environment Variables

- `SWIFTLETS_SITE` - Site directory path
- `SWIFTLETS_WEB_ROOT` - Override web root (defaults to `$SWIFTLETS_SITE/web`)
- `SWIFTLETS_HOST` - Server host (default: 127.0.0.1)
- `SWIFTLETS_PORT` - Server port (default: 8080)

## Troubleshooting

### "No route found" Errors
- Ensure the site is built: `./build-site sites/your-site`
- Check webbin files exist: `ls sites/your-site/web/**/*.webbin`
- Verify executable permissions: `ls -la sites/your-site/bin/`

### Wrong Site Running
- Check `SWIFTLETS_SITE` environment variable: `echo $SWIFTLETS_SITE`
- Use absolute paths to avoid confusion
- Clear any cached environment variables

### Build Errors
- Check for Swift syntax errors in source files
- Ensure Components.swift is valid if present
- Use `--verbose` flag for detailed output: `./build-site sites/your-site --verbose`
- Ensure framework source files exist in `Sources/Swiftlets/`

### Platform-Specific Issues
- **Linux/Ubuntu**: If only one file builds, see [Ubuntu Scripting Issue](ubuntu-scripting-issue.md)
- **MD5 differences**: Script handles md5/md5sum automatically across platforms