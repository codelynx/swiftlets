# Site Build System Update

## Overview
Simplified the build system for swiftlet sites to use a single Makefile that compiles each Swift file into a standalone executable.

## Changes Made

### 1. Consolidated Build Scripts
- **Removed 7 redundant build scripts**: `build.sh`, `build-direct.sh`, `compile-direct.sh`, `build-all.sh`, `test-build.sh`, `test-compile.sh`, `build-standalone.sh`
- **Kept only the Makefile** which handles all building needs

### 2. Updated Makefile
The Makefile now:
- Compiles each Swift file with all Swiftlets framework sources included
- Removes `import Swiftlets` line (since we compile with sources directly)
- Replaces `let request` with `let _` to fix unused variable warnings
- Builds executables to simple paths: `web/bin/` (not platform-specific)
- Updates `.webbin` files with MD5 hashes automatically
- Handles subdirectories correctly (builds them first to avoid conflicts)

### 3. Fixed Naming Conflicts
- Renamed `src/docs.swift` to `src/docs-index.swift` to avoid conflict with `docs/` directory
- Updated corresponding webbin file

### 4. Removed Unnecessary Files
- Deleted `Package.swift` and `Package.resolved` (not needed for swiftlet architecture)
- Deleted `.build` directory (temporary, recreated on build)
- Removed `sites/core/hello` and `sites/core/showcase` directories

## Build Process

### How It Works
1. Find all Swift files in `src/` recursively
2. For each file:
   - Create temporary file without `import Swiftlets` line
   - Replace `let request = try` with `let _ = try` to avoid warnings
   - Compile with all framework source files included
   - Place executable in `web/bin/`
   - Update `.webbin` file with MD5 hash

### Usage
```bash
make        # Build all swiftlets
make clean  # Remove build artifacts
make run    # Build and run server
make help   # Show help
```

## Benefits
1. **Single build tool**: Just use `make`
2. **Self-contained executables**: Each swiftlet includes all needed code
3. **No module dependencies**: Works without pre-built frameworks
4. **Clean output**: No warnings or errors
5. **Simple paths**: Executables at `web/bin/name` not `web/bin/platform/arch/name`

## Example Structure
```
sites/core/swiftlets-site/
├── Makefile            # Single build file
├── README.md          
├── src/               # Swift source files
│   ├── index.swift
│   ├── about.swift
│   └── docs/
│       └── getting-started.swift
└── web/               # Web root
    ├── bin/           # Compiled executables
    │   ├── index
    │   ├── about
    │   └── docs/
    │       └── getting-started
    └── *.webbin       # Route markers with MD5 hashes
```

This simplified structure makes it easier to understand and maintain swiftlet sites.