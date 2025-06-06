# Framework Consolidation Plan: Swiftlets

## Overview
Combine SwiftletsCore and SwiftletsHTML into a single `Swiftlets` framework that can be built and distributed as a unified library for SDK sites.

## Benefits
1. **Simplified imports**: `import Swiftlets` instead of `import SwiftletsCore` and `import SwiftletsHTML`
2. **Easier distribution**: One framework to build, package, and version
3. **Better developer experience**: SDK developers only need to link one library
4. **Cleaner build commands**: Simpler compilation flags

## Structure

### Current Structure
```
core/Sources/
├── SwiftletsCore/
│   ├── Request.swift
│   ├── Response.swift
│   └── Swiftlet.swift
└── SwiftletsHTML/
    ├── Builders/
    ├── Core/
    ├── Elements/
    ├── Helpers/
    ├── Layout/
    └── Modifiers/
```

### New Structure
```
core/Sources/
└── Swiftlets/
    ├── Core/           # Former SwiftletsCore
    │   ├── Request.swift
    │   ├── Response.swift
    │   └── Swiftlet.swift
    └── HTML/           # Former SwiftletsHTML
        ├── Builders/
        ├── Core/
        ├── Elements/
        ├── Helpers/
        ├── Layout/
        └── Modifiers/
```

## Implementation Steps

### Step 1: Restructure Sources
1. Create new `Sources/Swiftlets/` directory
2. Move `SwiftletsCore/*` → `Swiftlets/Core/`
3. Move `SwiftletsHTML/*` → `Swiftlets/HTML/`
4. Update all internal imports

### Step 2: Update Package.swift
```swift
// core/Package.swift
let package = Package(
    name: "Swiftlets",
    products: [
        .library(
            name: "Swiftlets",
            targets: ["Swiftlets"]),
        .executable(
            name: "swiftlets-server",
            targets: ["SwiftletsServer"])
    ],
    targets: [
        .target(
            name: "Swiftlets",
            dependencies: []),
        .target(
            name: "SwiftletsServer",
            dependencies: ["Swiftlets"])
    ]
)
```

### Step 3: Build Framework
```bash
# Build the framework
cd core
swift build -c release --product Swiftlets

# Framework will be available at:
# .build/release/libSwiftlets.dylib (macOS)
# .build/release/libSwiftlets.so (Linux)
# .build/release/Modules/Swiftlets.swiftmodule
```

### Step 4: Update SDK Sites
SDK sites can now use the simplified import and build:

```swift
// Before
import SwiftletsCore
import SwiftletsHTML

// After
import Swiftlets
```

Build command becomes:
```bash
swiftc -parse-as-library \
    -I ../../../core/.build/release/Modules \
    -L ../../../core/.build/release \
    -lSwiftlets \
    src/index.swift -o web/bin/index
```

### Step 5: Update Site Makefile
The SDK site Makefile becomes much cleaner:

```makefile
# Paths
BIN_DIR := web/bin
SRC_DIR := src
CORE_DIR := ../../../core

# Build settings
SWIFT_FLAGS := -parse-as-library
LINK_FLAGS := -I $(CORE_DIR)/.build/release/Modules \
              -L $(CORE_DIR)/.build/release \
              -lSwiftlets

# Individual binary rule
$(BIN_DIR)/%: $(SRC_DIR)/%.swift
    @mkdir -p $(dir $@)
    swiftc $(SWIFT_FLAGS) $(LINK_FLAGS) $< -o $@
```

## Migration Guide

### For Core Development
1. Update all imports from `SwiftletsCore`/`SwiftletsHTML` to `Swiftlets`
2. Update server dependencies in Package.swift
3. Rebuild the framework

### For SDK Sites
1. Update imports in all Swift files
2. Update Makefile to use single framework
3. Ensure core framework is built before compiling sites

## Advantages for SDK Developers
- **Single import**: Just `import Swiftlets`
- **Simpler builds**: One library to link
- **Better tooling**: IDE autocomplete works better with unified framework
- **Easier distribution**: Can ship pre-built framework binaries

## Timeline
1. **Phase 1**: Restructure and create unified framework
2. **Phase 2**: Update all core sites and examples
3. **Phase 3**: Update SDK sites and documentation
4. **Phase 4**: Create pre-built framework releases for different platforms