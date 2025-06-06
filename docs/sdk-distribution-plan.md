# SDK Distribution Plan

## Overview

This document outlines the future plan for distributing the Swiftlets SDK as a standalone package that can be installed system-wide or in custom locations.

## Installation Locations

The SDK may be installed in various standard locations:
- `/usr/local/opt/swiftlets` (macOS with Homebrew)
- `/opt/swiftlets` (Linux standard)
- `~/swiftlets-sdk` (User-specific installation)
- Custom location specified by user

## Environment Variable: SWIFTLETS_SDK_ROOT

The `SWIFTLETS_SDK_ROOT` environment variable will define the SDK's installation directory.

### Setting the Environment Variable

```bash
# System-wide installation
export SWIFTLETS_SDK_ROOT=/usr/local/opt/swiftlets

# User-specific installation
export SWIFTLETS_SDK_ROOT=$HOME/swiftlets-sdk

# Add to shell profile for persistence
echo 'export SWIFTLETS_SDK_ROOT=/usr/local/opt/swiftlets' >> ~/.bashrc
```

## SDK Structure

When installed separately, the SDK will have this structure:

```
$SWIFTLETS_SDK_ROOT/
├── lib/
│   └── Swiftlets/          # Pre-compiled framework
│       ├── Swiftlets.swiftmodule
│       └── libSwiftlets.{a,so,dylib}
├── include/
│   └── Swiftlets/          # Header files if needed
├── bin/
│   ├── swiftlets           # CLI tool
│   └── swiftlets-server    # Server executable
├── share/
│   ├── templates/          # Project templates
│   └── examples/           # Example projects
└── Sources/                # Source files for direct compilation
    └── Swiftlets/
        ├── Core/
        ├── HTML/
        └── ...
```

## Makefile Updates

Site Makefiles will need to support both approaches:

### Direct Compilation (Current Approach)

```makefile
# Check if SDK root is defined
ifdef SWIFTLETS_SDK_ROOT
    SWIFTLETS_SOURCES := $(SWIFTLETS_SDK_ROOT)/Sources/Swiftlets
else
    # Fallback to relative path for development
    SWIFTLETS_SOURCES := ../../../core/Sources/Swiftlets
endif

# Compile with sources
swiftc -parse-as-library \
    -module-name Swiftlets \
    $(SWIFTLETS_SOURCES)/Core/*.swift \
    $(SWIFTLETS_SOURCES)/HTML/Core/*.swift \
    $(SWIFTLETS_SOURCES)/HTML/Elements/*.swift \
    $(SWIFTLETS_SOURCES)/HTML/Helpers/*.swift \
    $(SWIFTLETS_SOURCES)/HTML/Layout/*.swift \
    $(SWIFTLETS_SOURCES)/HTML/Modifiers/*.swift \
    $(SWIFTLETS_SOURCES)/HTML/Builders/*.swift \
    $$temp_file -o $$output
```

### Pre-compiled Library (Future)

```makefile
# Using pre-compiled framework
ifdef SWIFTLETS_SDK_ROOT
    SWIFTLETS_LIB := -L $(SWIFTLETS_SDK_ROOT)/lib -lSwiftlets
    SWIFTLETS_MODULE := -I $(SWIFTLETS_SDK_ROOT)/lib
else
    # Development mode
    SWIFTLETS_LIB := -L ../../../core/.build/release -lSwiftlets
    SWIFTLETS_MODULE := -I ../../../core/.build/release
endif

# Compile with library
swiftc -parse-as-library \
    $(SWIFTLETS_MODULE) \
    $(SWIFTLETS_LIB) \
    $$file -o $$output
```

## Migration Path

1. **Phase 1**: Continue with direct source compilation (current)
2. **Phase 2**: Support both source and library compilation via environment variable
3. **Phase 3**: Package SDK for distribution (Homebrew, apt, etc.)
4. **Phase 4**: Default to pre-compiled library, fallback to sources

## Benefits

1. **Faster Builds**: Pre-compiled framework reduces compilation time
2. **Version Management**: Easy to switch between SDK versions
3. **System Integration**: Standard installation paths
4. **Flexibility**: Support for custom installation locations
5. **Development Mode**: Can still use source compilation for SDK development

## Example Usage

### For SDK Users

```bash
# Install SDK (future)
brew install swiftlets-sdk

# Create new project
swiftlets new my-site
cd my-site

# Build using system SDK
make build
```

### For SDK Developers

```bash
# Clone repository
git clone https://github.com/swiftlets/swiftlets
cd swiftlets

# Set SDK root to local development
export SWIFTLETS_SDK_ROOT=$PWD

# Build and test changes
make build
```

## Compatibility

The approach ensures backward compatibility:
- Existing projects continue to work with relative paths
- New projects can use the SDK installation
- Developers can override SDK location as needed

## Future Considerations

1. **Package Managers**: Support for Homebrew, apt, Swift Package Manager
2. **Version Switching**: Tool like `swiftlets use 1.2.0`
3. **Binary Distribution**: Pre-built binaries for common platforms
4. **SDK Updates**: `swiftlets update` command
5. **Multiple Versions**: Support for multiple SDK versions side-by-side