# Shared Components Design

## Problem
Currently, each Swiftlets page is compiled as an independent executable, making it impossible to share Swift components between pages. This leads to code duplication.

## Solution
Introduce a shared components mechanism that maintains the isolation benefits while allowing code reuse.

## Architecture

### Directory Structure
```
sites/my-site/
├── src/                    # Individual pages (swiftlets)
│   ├── index.swift
│   └── about.swift
├── shared/                 # NEW: Shared components
│   ├── Components.swift    # Shared UI components
│   ├── Layouts.swift       # Shared layouts
│   └── Utils.swift         # Shared utilities
└── bin/                    # Flat structure (platform-specific at runtime)
    ├── index
    ├── about
    └── shared/             # NEW: Compiled shared library
        └── libShared.dylib # or .so on Linux

```

### Compilation Process
1. **Phase 1**: Compile all files in `shared/` into a dynamic library
2. **Phase 2**: Compile each swiftlet, linking against the shared library
3. **Runtime**: Each swiftlet loads the shared library when executed

### Usage Example
```swift
// shared/Components.swift
import Swiftlets

public struct Navigation: HTMLElement {
    public let activePage: String
    public var attributes = HTMLAttributes()
    
    public init(activePage: String = "") {
        self.activePage = activePage
    }
    
    public func render() -> String {
        // Navigation HTML
    }
}

// src/index.swift
import Swiftlets
import Shared  // Import shared components

@main
struct HomePage: SwiftletMain {
    var body: some HTMLElement {
        Fragment {
            Navigation(activePage: "home")  // Use shared component
            // ... rest of page
        }
    }
}
```

## Implementation Steps

1. **Update build-site script**:
   - Detect shared/ directory
   - Compile shared components first
   - Pass library path to swiftlet compilation

2. **Handle imports**:
   - Generate a module map for shared components
   - Add import path during compilation

3. **Runtime considerations**:
   - Set DYLD_LIBRARY_PATH (macOS) or LD_LIBRARY_PATH (Linux)
   - Bundle library path in .webbin marker

## Benefits
- ✅ Code reuse without sacrificing isolation
- ✅ Shared components are versioned with the site
- ✅ Changes to shared components trigger rebuilds
- ✅ Each swiftlet still runs as independent process
- ✅ Compatible with existing architecture

## Challenges
- Dynamic library management across platforms
- Ensuring ABI compatibility
- Hot reload complexity increases

## Alternative Approaches Considered
1. **Static linking**: Would increase binary size significantly
2. **Source inclusion**: Would slow compilation
3. **External package**: Too complex for simple sharing