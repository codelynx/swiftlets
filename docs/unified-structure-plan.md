# Unified Directory Structure Reorganization Plan

## Overview

This document proposes unifying the `core` and `sdk` directories into a single cohesive structure, implementing platform-specific binary organization, and preparing for package-based distribution on Ubuntu and other systems.

## Goals

1. **Simplify Structure**: Merge `core` and `sdk` into a unified layout
2. **Platform Binaries**: Organize executables in `bin/{os}/{arch}/` format
3. **Package Ready**: Prepare for Ubuntu `.deb` packages and other installers
4. **Clear Separation**: Distinguish between framework, tools, and sites
5. **Development Friendly**: Maintain ease of development workflow

## Current Structure

```
swiftlets/
├── core/                     # Framework and server
│   ├── Sources/
│   │   ├── Swiftlets/       # Framework code
│   │   └── SwiftletsServer/ # Server code
│   └── sites/               # Test sites
├── sdk/                     # SDK distribution
│   ├── sites/               # Example sites
│   ├── templates/           # Project templates
│   └── tools/               # CLI tools
├── cli/                     # CLI source
├── docs/                    # Documentation
└── obsolete/               # Deprecated items
```

## Proposed Structure

```
swiftlets/
├── Sources/                 # All source code
│   ├── Swiftlets/          # Framework library
│   │   ├── Core/
│   │   └── HTML/
│   ├── SwiftletsServer/    # Web server
│   └── SwiftletsCLI/       # CLI tool
│
├── bin/                    # Platform-specific binaries
│   ├── darwin/
│   │   ├── x86_64/
│   │   │   ├── swiftlets-server
│   │   │   └── swiftlets
│   │   └── arm64/
│   │       ├── swiftlets-server
│   │       └── swiftlets
│   └── linux/
│       ├── x86_64/
│       │   ├── swiftlets-server
│       │   └── swiftlets
│       └── arm64/
│           ├── swiftlets-server
│           └── swiftlets
│
├── lib/                    # Compiled libraries (future)
│   └── {platform}/
│       └── {arch}/
│           └── libSwiftlets.{so,dylib}
│
├── sites/                  # All sites
│   ├── examples/           # Example sites
│   │   ├── swiftlets-site/
│   │   └── showcase/
│   └── tests/              # Test sites
│       ├── test-html/
│       ├── test-routing/
│       └── benchmark/
│
├── templates/              # Project templates
│   ├── blank/
│   ├── blog/
│   └── api/
│
├── tools/                  # Build tools and scripts
│   ├── build.sh
│   ├── install.sh
│   └── package/            # Packaging scripts
│       ├── ubuntu/
│       ├── macos/
│       └── docker/
│
├── Package.swift           # Root package definition
├── Makefile               # Main build system
└── docs/                  # Documentation
```

## Migration Steps

### Phase 1: Restructure Sources
1. Move `core/Sources/*` → `Sources/*`
2. Move `cli/Sources/SwiftletsCLI/*` → `Sources/SwiftletsCLI/*`
3. Update all imports and Package.swift files

### Phase 2: Organize Sites
1. Move `sdk/sites/*` → `sites/examples/*`
2. Move `core/sites/*` → `sites/tests/*`
3. Update all references in documentation

### Phase 3: Setup Binary Organization
1. Create `bin/{os}/{arch}` directory structure
2. Update build scripts to output to correct locations
3. Implement OS/arch detection in build system

### Phase 4: Prepare for Packaging
1. Create packaging scripts for each platform
2. Define installation paths following platform conventions
3. Create package metadata files

## Platform-Specific Paths

### Ubuntu/Debian Package Structure
```
/usr/bin/                   # Executables
├── swiftlets
└── swiftlets-server

/usr/lib/swiftlets/         # Libraries and resources
├── lib/
└── templates/

/usr/share/swiftlets/       # Shared data
├── examples/
└── docs/

/etc/swiftlets/             # Configuration
└── config.json
```

### macOS Homebrew Structure
```
/usr/local/opt/swiftlets/
├── bin/
├── lib/
├── share/
└── etc/
```

## Build System Updates

### Makefile Changes
```makefile
# Detect OS and architecture
OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH := $(shell uname -m)

# Normalize OS names
ifeq ($(OS),Darwin)
    OS := darwin
endif

# Binary output directory
BIN_DIR := bin/$(OS)/$(ARCH)

# Build targets
build:
    @mkdir -p $(BIN_DIR)
    swift build -c release
    cp .build/release/swiftlets-server $(BIN_DIR)/
    cp .build/release/swiftlets $(BIN_DIR)/

# Package targets
package-ubuntu:
    ./tools/package/ubuntu/build-deb.sh

package-macos:
    ./tools/package/macos/build-pkg.sh
```

## Package Management

### Ubuntu .deb Package
- Use `dpkg-deb` to create packages
- Include systemd service files
- Define dependencies (Swift runtime, etc.)
- Post-install scripts for setup

### macOS Distribution
- Homebrew formula
- .pkg installer for direct installation
- Code signing for distribution

### Docker Images
- Multi-stage builds
- Minimal runtime images
- Pre-compiled binaries

## Benefits

1. **Unified Structure**: Single source tree, easier to navigate
2. **Platform Support**: Clear binary organization for cross-platform
3. **Package Ready**: Standard paths for system packages
4. **Development**: Simpler imports and dependencies
5. **Distribution**: Ready for various package managers

## Considerations

1. **Backward Compatibility**: Update all documentation and examples
2. **CI/CD**: Update build pipelines for new structure
3. **Developer Experience**: Ensure build commands remain simple
4. **Migration Path**: Provide clear upgrade instructions

## Implementation Timeline

1. **Week 1**: Restructure sources and update imports
2. **Week 2**: Implement binary organization in build system
3. **Week 3**: Create packaging scripts for Ubuntu
4. **Week 4**: Test and document installation process

## Questions to Discuss

1. Should we keep `Sources` at root or use `src`?
2. Do we need separate `lib` directory or include in `bin`?
3. Should examples be in `sites/examples` or just `examples`?
4. What about config files - where should defaults live?
5. Do we need version numbers in binary paths?

## Next Steps

1. Review and approve structure
2. Create migration scripts
3. Update all build files
4. Test on multiple platforms
5. Update documentation
6. Create first packages