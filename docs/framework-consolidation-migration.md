# Framework Consolidation Migration Guide

## Overview

In June 2025, we consolidated SwiftletsCore and SwiftletsHTML into a single unified `Swiftlets` framework. This guide helps you migrate existing code to use the new structure.

## What Changed

### Before (Two Separate Frameworks)
```
SwiftletsCore/          SwiftletsHTML/
├── Request.swift       ├── Elements/
├── Response.swift      ├── Builders/
└── Swiftlet.swift      └── Modifiers/
```

### After (Unified Framework)
```
Swiftlets/
├── Core/
│   ├── Request.swift
│   ├── Response.swift
│   └── Swiftlet.swift
└── HTML/
    ├── Elements/
    ├── Builders/
    └── Modifiers/
```

## Migration Steps

### 1. Update Imports

**Before:**
```swift
import SwiftletsCore
import SwiftletsHTML
```

**After:**
```swift
import Swiftlets
```

### 2. Update Package.swift

**Before:**
```swift
dependencies: [
    .product(name: "SwiftletsCore", package: "core"),
    .product(name: "SwiftletsHTML", package: "core")
]
```

**After:**
```swift
dependencies: [
    .product(name: "Swiftlets", package: "core")
]
```

### 3. Update Build Scripts

If you have build scripts that reference the old libraries:

**Before:**
```bash
swiftc -I path/to/modules \
       -L path/to/libs \
       -lSwiftletsCore -lSwiftletsHTML \
       source.swift
```

**After:**
```bash
swiftc -I path/to/modules \
       source.swift
```

Note: The unified framework uses Swift modules, not separate library files.

### 4. Clean Build Artifacts

After updating your code:
```bash
cd core
swift package clean
swift build
```

## API Compatibility

All APIs remain the same - only the import statements have changed:

- `Request`, `Response`, `Swiftlet` protocol - unchanged
- All HTML elements (Div, Paragraph, etc.) - unchanged
- Result builders (@HTMLBuilder) - unchanged
- Modifiers and helpers - unchanged

## Benefits of Migration

1. **Simpler imports** - One line instead of two
2. **Better IDE support** - Autocomplete works better with unified module
3. **Easier distribution** - Single framework to version and distribute
4. **Cleaner builds** - No need to link multiple libraries

## Example Migration

### Before
```swift
// src/index.swift
import SwiftletsCore
import SwiftletsHTML

@main
struct HomePage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
                Title("My Site")
            }
            Body {
                H1("Welcome")
            }
        }
        
        let response = Response(html: html)
        try response.send()
    }
}
```

### After
```swift
// src/index.swift
import Swiftlets  // Only change needed!

@main
struct HomePage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
                Title("My Site")
            }
            Body {
                H1("Welcome")
            }
        }
        
        let response = Response(html: html)
        try response.send()
    }
}
```

## Troubleshooting

### "No such module 'SwiftletsCore'" or "No such module 'SwiftletsHTML'"
- Update your imports to use `import Swiftlets`
- Ensure you've updated your Package.swift dependencies

### Build errors after migration
1. Clean your build directory: `swift package clean`
2. Update Package.resolved: `swift package update`
3. Rebuild: `swift build`

### VSCode/Xcode still showing old module names
- Restart your IDE
- Clear derived data (Xcode)
- Reload window (VSCode)

## Questions?

If you encounter issues during migration, please open an issue on GitHub.