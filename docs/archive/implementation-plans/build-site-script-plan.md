# Universal Build-Site Script Plan

## Overview
Create a universal `build-site` script that can build any Swiftlets site without requiring individual Makefiles. This will simplify site development and maintenance.

## Current Build Process Analysis

### How Sites Currently Build (from Makefile)
1. **Source Discovery**: Find all `.swift` files in `src/` directory
2. **Component Handling**: Skip files like `Components.swift` (shared components)
3. **Output Mapping**:
   - Source: `src/showcase/index.swift`
   - Binary: `bin/showcase/index`
   - Webbin: `web/showcase/index.webbin`
4. **Incremental Build**: Check if rebuild needed based on:
   - Source file newer than binary
   - Components.swift newer than binary
   - Framework files newer than binary
5. **Compilation**: 
   - Remove `import Swiftlets` (since files are compiled together)
   - Compile with all framework sources
   - Include shared `Components.swift` if exists
6. **MD5 Generation**: Calculate MD5 of binary and write to `.webbin` file

## Script Requirements

### Core Features
1. **Single Command**: `./build-site <site-root>`
2. **Auto-Discovery**: Find all Swift sources automatically
3. **Incremental Builds**: Only rebuild changed files
4. **Cross-Platform**: Work on macOS and Linux
5. **Error Handling**: Clear error messages and exit codes
6. **Progress Display**: Show what's being built

### Directory Structure Expected
```
site-root/
├── src/                  # Swift source files
│   ├── index.swift
│   ├── Components.swift  # Optional shared components
│   └── docs/
│       └── index.swift
├── web/                  # Static files and .webbin markers
│   ├── styles.css
│   ├── index.webbin      # Generated
│   └── docs/
│       └── index.webbin  # Generated
└── bin/                  # Compiled executables
    ├── index            # Generated
    └── docs/
        └── index        # Generated
```

## Implementation Plan

### Phase 1: Core Script
```bash
#!/bin/bash
# build-site - Universal Swiftlets site builder
```

Key components:
- Platform detection (OS, architecture, md5 command)
- Site validation (check for src/ directory)
- Swift file discovery
- Dependency tracking
- Compilation with proper flags
- MD5 generation for webbins

### Phase 2: Features
1. **Watch Mode**: `--watch` flag for auto-rebuild
2. **Clean**: `--clean` flag to remove bin/ and .webbin files (no build)
3. **Force Rebuild**: `--force` flag to rebuild all files (ignore timestamps)
4. **Verbose Mode**: `--verbose` for detailed output
5. **Parallel Builds**: Build multiple files concurrently

### Phase 3: Advanced
1. **Configuration File**: Optional `swiftlets.json` for build settings
2. **Custom Components**: Support multiple component files
3. **Build Hooks**: Pre/post build scripts
4. **Caching**: Smarter dependency tracking

## Migration Strategy

### Step 1: Create and Test Script
- Implement basic functionality
- Test with existing sites
- Ensure identical output to Makefile builds

### Step 2: Gradual Migration
- Add script to repository
- Update documentation
- Keep Makefiles temporarily for compatibility

### Step 3: Full Migration
- Remove individual site Makefiles
- Update all examples to use new script
- Update CI/CD processes

## Benefits

1. **Simplicity**: No need to copy/maintain Makefiles
2. **Consistency**: Same build process for all sites
3. **Maintainability**: Single script to update
4. **Flexibility**: Easy to add new features
5. **User-Friendly**: Simple command interface

## Usage Examples

```bash
# Build a site
./build-site sites/examples/swiftlets-site

# Build with verbose output
./build-site sites/examples/swiftlets-site --verbose

# Clean build artifacts (remove bin/ and .webbin files)
./build-site sites/examples/swiftlets-site --clean

# Force rebuild all files (ignore timestamps)
./build-site sites/examples/swiftlets-site --force

# Watch for changes
./build-site sites/examples/swiftlets-site --watch

# Clean then build with force
./build-site sites/examples/swiftlets-site --clean --force --verbose
```

## Success Criteria

1. ✅ Builds all existing sites correctly
2. ✅ Generates identical binaries to Makefile
3. ✅ Properly creates .webbin files with MD5
4. ✅ Handles incremental builds efficiently
5. ✅ Works on macOS and Linux
6. ✅ Clear error messages
7. ✅ No external dependencies beyond Swift

## Next Steps

1. Review and approve this plan
2. Implement Phase 1 (core functionality)
3. Test with existing sites
4. Iterate based on feedback
5. Proceed with Phase 2 and 3