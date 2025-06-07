# Site Management in Swiftlets

## Overview

Swiftlets supports multiple sites within a single project. This document explains how to manage and run different sites from the project root.

## Quick Start with `smake`

The `smake` wrapper provides the easiest way to work with sites:

```bash
# List all available sites
./smake list

# Run a site
./smake run                                    # Run default site
./smake run sites/examples/swiftlets-site      # Run specific site
./smake run sites/tests/test-html              # Run test site

# Build a site
./smake build                                  # Build default site
./smake build sites/examples/swiftlets-site    # Build specific site

# Clean a site
./smake clean sites/examples/swiftlets-site    # Clean site artifacts

# Development mode
./smake dev sites/examples/swiftlets-site      # Run in dev mode
```

## Traditional Make Commands

The underlying Makefile has been enhanced to support site selection:

```bash
# Default site is sites/examples/swiftlets-site
make run
make site
make run-dev

# Specify a different site
make run SITE=sites/tests/test-html
make site SITE=sites/tests/test-html
make run-dev SITE=sites/examples/swiftlets-site

# List available sites
make list-sites

# Build all example sites
make sites

# Build all test sites  
make test-sites
```

## Alternative Methods

### Method 1: Direct Server Execution
```bash
# Build server first
make build-server

# Run with specific site
SWIFTLETS_SITE=sites/core/hello ./bin/darwin/arm64/swiftlets-server
```

### Method 2: From Site Directory
```bash
# Navigate to site and use its Makefile
cd sites/examples/swiftlets-site
make build
make serve  # or make run
```

### Method 3: Using CLI Tool
```bash
# Use swiftlets CLI
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

The site management system has been enhanced with:

1. **`smake` wrapper** - Simple command syntax without `SITE=` prefix
2. **`make list-sites`** - Shows all available sites across categories
3. **Default site configuration** - `SITE` variable in Makefile
4. **Support for build.sh** - Test sites using shell scripts are recognized
5. **Improved help** - `make help` shows site-specific commands

## Best Practices

1. **Development**: Work from the site directory for faster iteration
   ```bash
   cd sites/examples/my-site
   make build && make run
   ```

2. **Testing Multiple Sites**: Use environment variables
   ```bash
   SWIFTLETS_SITE=sites/core/hello make run
   ```

3. **Production**: Use explicit paths
   ```bash
   swiftlets serve --site /path/to/production/site
   ```

## Configuration Files

Each site can have its own configuration:
- `Makefile` - Build configuration
- `Package.swift` (future) - Dependencies
- `swiftlets.yml` (future) - Site settings

## Environment Variables

- `SWIFTLETS_SITE` - Site directory path
- `SWIFTLETS_WEB_ROOT` - Override web root (defaults to `$SWIFTLETS_SITE/web`)
- `SWIFTLETS_HOST` - Server host (default: 127.0.0.1)
- `SWIFTLETS_PORT` - Server port (default: 8080)

## Troubleshooting

### "No route found" Errors
- Ensure the site is built: `cd sites/your-site && make build`
- Check webbin files exist: `ls sites/your-site/web/**/*.webbin`
- Verify executable permissions: `ls -la sites/your-site/bin/`

### Wrong Site Running
- Check `SWIFTLETS_SITE` environment variable: `echo $SWIFTLETS_SITE`
- Use absolute paths to avoid confusion
- Clear any cached environment variables

### Build Errors
- Each site builds independently with its own Makefile
- Check site-specific dependencies and imports
- Ensure framework is built: `swift build` from project root