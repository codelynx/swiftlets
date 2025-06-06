# Migration Guide: Unified Structure

## Overview

This guide helps you migrate from the old separated `core`/`sdk` structure to the new unified structure implemented on 2025-06-06.

## What Changed

### Directory Structure

**Old Structure:**
```
swiftlets/
├── core/
│   ├── Sources/
│   ├── Tests/
│   └── sites/
├── sdk/
│   ├── sites/
│   └── templates/
├── cli/
│   └── Sources/
```

**New Structure:**
```
swiftlets/
├── Sources/          # All source code (unified)
├── Tests/           # All tests
├── bin/{os}/{arch}/ # Platform-specific binaries
├── sites/
│   ├── examples/    # User-facing examples
│   └── tests/       # Framework test sites
├── templates/       # Project templates
└── tools/           # Scripts and utilities
```

## Migration Steps

### 1. Update Your Local Repository

```bash
git pull origin main
```

### 2. Clean Build Artifacts

```bash
# Remove old build directories
rm -rf .build
rm -rf core/.build
rm -rf cli/.build
rm -rf */bin

# Clean using make
make clean
```

### 3. Update Import Paths

If you have custom code importing Swiftlets:
- No change needed - still `import Swiftlets`

### 4. Update Build Scripts

Replace old build commands:

**Old:**
```bash
cd core && swift build
./build.sh
./run-server.sh
```

**New:**
```bash
make build
make run
```

### 5. Update Binary Paths

**Old binary locations:**
- `core/.build/release/swiftlets-server`
- `cli/.build/release/swiftlets`

**New binary locations:**
- `bin/darwin/arm64/swiftlets-server` (macOS Apple Silicon)
- `bin/darwin/x86_64/swiftlets-server` (macOS Intel)
- `bin/linux/arm64/swiftlets-server` (Linux ARM)
- `bin/linux/x86_64/swiftlets-server` (Linux x86)

### 6. Update Site References

**Old paths:**
- `sdk/sites/swiftlets-site` → `sites/examples/swiftlets-site`
- `core/sites/test-html` → `sites/tests/test-html`
- `sdk/templates/blank` → `templates/blank`

### 7. Update Environment Variables

```bash
# Old
SWIFTLETS_SITE=sdk/sites/swiftlets-site

# New
SWIFTLETS_SITE=sites/examples/swiftlets-site
```

## Common Issues

### "No such module 'Swiftlets'"

Run `make build` from the root directory to build the framework.

### "swiftlets-server: command not found"

The server binary is now in `bin/{os}/{arch}/`. Use:
```bash
./bin/darwin/arm64/swiftlets-server
# or
make run
```

### Site not found

Update your SWIFTLETS_SITE path:
```bash
# Old
SWIFTLETS_SITE=sdk/sites/swiftlets-site

# New  
SWIFTLETS_SITE=sites/examples/swiftlets-site
```

## Benefits of New Structure

1. **Simpler** - Single source tree, no core/sdk separation
2. **Clearer** - Obvious where everything lives
3. **Cross-platform** - Binaries organized by OS/architecture
4. **Package Ready** - Structure aligns with standard packaging

## Need Help?

- Check [Project Structure](project-structure-unified.md) for details
- Review the [Makefile](../Makefile) for available commands
- Open an issue on GitHub for support