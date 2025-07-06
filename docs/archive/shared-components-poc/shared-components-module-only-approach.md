# Module-Only Approach for Shared Components

## The Insight

Instead of creating libraries (.a or .dylib), we can use Swift's module system directly! The `.swiftmodule` contains all the type information needed for compilation.

## How It Would Work

### 1. Build Shared Components Module
```bash
# Compile shared components to .swiftmodule ONLY (no library)
swiftc -emit-module \
    -module-name SharedComponents \
    -emit-module-path bin/.modules/SharedComponents.swiftmodule \
    -parse-as-library \
    Sources/Swiftlets/**/*.swift \
    shared/*.swift
```

This creates:
- `SharedComponents.swiftmodule` - Module interface (has all public signatures)
- `SharedComponents.swiftdoc` - Documentation
- NO library file!

### 2. Use Module When Building Pages
```bash
# Build each page, importing the module
swiftc \
    -I bin/.modules \              # Find SharedComponents.swiftmodule here
    -parse-as-library \
    Sources/Swiftlets/**/*.swift \ # Include Swiftlets source
    shared/*.swift \               # Include shared source (key!)
    src/index.swift \
    -o bin/index
```

### 3. The Key Insight

The module provides **compile-time type checking** without linking:
- ✅ Import works: `import SharedComponents`
- ✅ Autocomplete works
- ✅ Type checking works
- ✅ But we still need source files for actual code

## Implementation Approaches

### Approach A: Module + Source Include
```bash
# Step 1: Generate module for IDE/type checking
swiftc -emit-module \
    -module-name SharedComponents \
    -emit-module-path bin/.modules/SharedComponents.swiftmodule \
    shared/*.swift

# Step 2: Build with source files
swiftc \
    -I bin/.modules \           # For import to work
    shared/*.swift \            # Actual implementations
    src/index.swift \
    -o bin/index
```

**Pros:**
- Simple build process
- Good IDE support
- No linking complexity

**Cons:**
- Still recompiles shared code
- Larger binaries

### Approach B: Module + Incremental Objects
```bash
# Step 1: Compile shared to .o files + module
swiftc -emit-module -emit-object \
    -module-name SharedComponents \
    -emit-module-path bin/.modules/SharedComponents.swiftmodule \
    -o bin/.objects/SharedComponents.o \
    shared/*.swift

# Step 2: Link with object files
swiftc \
    -I bin/.modules \
    bin/.objects/SharedComponents.o \
    src/index.swift \
    -o bin/index
```

**Pros:**
- Faster builds (shared compiled once)
- Still get module benefits

**Cons:**
- More complex than pure source
- Platform-specific object files

### Approach C: Module-Only with Swift Package Manager
```swift
// Package.swift for SharedComponents
let package = Package(
    name: "SharedComponents",
    products: [
        // No library product, just targets!
    ],
    targets: [
        .target(name: "SharedComponents")
    ]
)
```

Then use SPM's module generation:
```bash
swift build --target SharedComponents
# Creates .build/debug/SharedComponents.swiftmodule
```

## Revolutionary Idea: Distributed Modules

What if we could distribute JUST modules?

```
SharedComponentsPackage/
├── SharedComponents.swiftmodule
├── SharedComponents.swiftinterface  # For ABI stability
├── Sources/                          # Include source for building
│   └── SharedComponents/
│       └── *.swift
└── Package.swift
```

Users could:
1. Import for type checking/IDE
2. Include sources when building
3. Or link pre-built library if provided

## Practical Build Script

```bash
#!/bin/bash
# build-with-modules.sh

SITE_ROOT="$1"

# Step 1: Build all modules
echo "Building modules..."
for module_dir in "$SITE_ROOT"/modules/*/; do
    module_name=$(basename "$module_dir")
    swiftc -emit-module \
        -module-name "$module_name" \
        -emit-module-path "$SITE_ROOT/bin/.modules/$module_name.swiftmodule" \
        -parse-as-library \
        "$module_dir"/*.swift
done

# Step 2: Build pages with modules
echo "Building pages..."
MODULE_IMPORTS=""
MODULE_SOURCES=""

# Collect all module paths and sources
for module_dir in "$SITE_ROOT"/modules/*/; do
    MODULE_SOURCES="$MODULE_SOURCES $module_dir/*.swift"
done

# Build each page
find "$SITE_ROOT/src" -name "*.swift" | while read page; do
    output="$SITE_ROOT/bin/$(basename "$page" .swift)"
    swiftc \
        -I "$SITE_ROOT/bin/.modules" \
        $MODULE_SOURCES \
        "$page" \
        -o "$output"
done
```

## Benefits of Module-First Approach

1. **Separation of Interface from Implementation**
   - Modules define the contract
   - Implementation can vary (source, static, dynamic)

2. **Progressive Enhancement**
   - Start with source inclusion
   - Move to libraries when needed
   - Interface stays the same

3. **Better Tooling**
   - IDEs understand modules
   - Documentation generation works
   - Type checking without building

4. **Flexible Distribution**
   - Share just modules for type checking
   - Include sources for transparency
   - Provide libraries for performance

## Example: Hybrid Module System

```
sites/my-site/
├── modules/
│   ├── SharedUI/
│   │   ├── Package.swift
│   │   ├── SharedUI.swiftmodule    # Pre-built for IDE
│   │   └── Sources/
│   │       └── SharedUI/
│   │           └── Navigation.swift
│   └── SharedUtils/
│       ├── Package.swift
│       ├── SharedUtils.swiftmodule
│       └── Sources/
│           └── SharedUtils/
│               └── Formatters.swift
├── src/
│   └── index.swift
└── bin/
    ├── .modules/                    # Module interfaces
    │   ├── SharedUI.swiftmodule
    │   └── SharedUtils.swiftmodule
    └── index                        # Final executable
```

## The Ultimate Flexibility

```swift
// src/index.swift
import Swiftlets
import SharedUI      // Module provides interface
import SharedUtils   // Module provides interface

@main
struct HomePage: SwiftletMain {
    var body: some HTMLElement {
        NavigationBar(activePage: "home")  // Type-checked!
    }
}
```

Build options:
```bash
# Option 1: Include sources
swiftc -I bin/.modules shared/*/*.swift src/index.swift -o bin/index

# Option 2: Link libraries
swiftc -I bin/.modules -L bin -lSharedUI -lSharedUtils src/index.swift -o bin/index

# Option 3: Mix and match!
swiftc -I bin/.modules shared/SharedUI/*.swift -L bin -lSharedUtils src/index.swift -o bin/index
```

## Conclusion

Using modules as the primary abstraction gives us:
- ✅ Type safety and IDE support
- ✅ Flexibility in implementation
- ✅ Progressive enhancement path
- ✅ Clean separation of concerns
- ✅ Future-proof architecture

This could be the key to making shared components work elegantly in Swiftlets!