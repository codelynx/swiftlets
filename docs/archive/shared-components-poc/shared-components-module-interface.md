# Module Interfaces in Swift Libraries

## How Swift Modules Work (Similar to Header Files)

When you compile a Swift library (dynamic or static), Swift generates:
1. **`.swiftmodule`** - Binary module interface (like compiled header)
2. **`.swiftinterface`** - Text-based module interface (like .h file)
3. **`.swiftsourceinfo`** - Source location information

## Example: SharedComponents Library

### 1. Source Code
```swift
// shared/SharedComponents.swift
import Swiftlets

public func helloHeader(name: String = "World") -> some HTMLElement {
    Header {
        H1("Hello, \(name)!")
            .style("color", "blue")
    }
}

public struct NavigationBar: HTMLElement {
    public let activePage: String
    public var attributes = HTMLAttributes()
    
    public init(activePage: String) {
        self.activePage = activePage
    }
    
    public func render() -> String {
        // Implementation
    }
}

// This function is NOT visible to library users
internal func helperFunction() {
    // ...
}
```

### 2. Building the Library

**Dynamic Library:**
```bash
swiftc -emit-library -emit-module \
    -module-name SharedComponents \
    -emit-module-interface \
    shared/*.swift \
    -o bin/libSharedComponents.dylib
```

**Static Library:**
```bash
swiftc -emit-library -static -emit-module \
    -module-name SharedComponents \
    -emit-module-interface \
    shared/*.swift \
    -o bin/libSharedComponents.a
```

### 3. Generated Files

After compilation, you get:
```
bin/
├── libSharedComponents.dylib (or .a)     # The actual library
├── SharedComponents.swiftmodule           # Binary interface
│   ├── arm64-apple-macos.swiftmodule     # Platform-specific
│   └── arm64-apple-macos.swiftdoc        # Documentation
└── SharedComponents.swiftinterface        # Text interface (optional)
```

### 4. The Module Interface (Like a Header File)

The `.swiftinterface` file (human-readable) looks like:
```swift
// swift-interface-format-version: 1.0
// swift-module-flags: -module-name SharedComponents

import Swiftlets

@available(macOS 10.15, *)
public func helloHeader(name: Swift.String = "World") -> some Swiftlets.HTMLElement

@available(macOS 10.15, *)
public struct NavigationBar : Swiftlets.HTMLElement {
  public let activePage: Swift.String
  public var attributes: Swiftlets.HTMLAttributes
  public init(activePage: Swift.String)
  public func render() -> Swift.String
}

// Note: internal functions are NOT listed
```

### 5. Using the Library

When you compile a swiftlet that uses the library:

```swift
// src/index.swift
import Swiftlets
import SharedComponents  // Swift reads the .swiftmodule

@main
struct HomePage: SwiftletMain {
    var body: some HTMLElement {
        VStack {
            helloHeader(name: "Swift")  // Compiler knows the signature
            NavigationBar(activePage: "home")  // Knows the init parameters
            // helperFunction()  // ERROR: Cannot find in scope
        }
    }
}
```

Compile with:
```bash
swiftc \
    -I bin/  \              # Look for modules here
    -L bin/  \              # Look for libraries here
    -lSharedComponents \    # Link the library
    src/index.swift \
    -o bin/index
```

## How the Compiler Finds Functions

1. **Import Statement**: `import SharedComponents`
2. **Module Search**: Compiler looks for `SharedComponents.swiftmodule` in paths specified by `-I`
3. **Symbol Resolution**: 
   - At compile time: Verifies function signatures
   - At link time (static): Includes actual function code
   - At runtime (dynamic): Resolves function addresses

## Key Differences from C/C++

| Feature | C/C++ | Swift |
|---------|-------|-------|
| Interface File | `.h` (manual) | `.swiftmodule` (automatic) |
| Public API | Explicit in header | `public` keyword |
| Name Mangling | Simple | Complex (includes types) |
| Inline Functions | In header | Module decides |
| Templates/Generics | In header | In module interface |

## IDE Integration

Modern IDEs (Xcode, VSCode) understand `.swiftmodule` files:
- **Autocomplete**: Shows available functions with signatures
- **Documentation**: Quick help from doc comments
- **Jump to Definition**: Can show the interface
- **Type Checking**: Real-time validation

## Access Control

```swift
// Visibility levels in libraries:
public func publicAPI() { }        // ✅ Visible to library users
internal func internalAPI() { }    // ❌ Only within module
fileprivate func fileOnly() { }    // ❌ Only within file
private func privateHelper() { }   // ❌ Only within scope
```

## Best Practices for Library APIs

1. **Mark Public APIs Explicitly**:
```swift
public struct MyComponent: HTMLElement {
    public init(...) { }  // Must be public too!
    public func render() -> String { }
}
```

2. **Use Semantic Versioning**:
```swift
@available(*, deprecated, message: "Use NavigationBar instead")
public func oldNavigation() { }
```

3. **Document Public APIs**:
```swift
/// Creates a styled header with a greeting
/// - Parameter name: The name to greet (default: "World")
/// - Returns: An HTML header element
public func helloHeader(name: String = "World") -> some HTMLElement {
    // ...
}
```

## Example: Complete Library Setup

### SharedComponents/Package.swift
```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SharedComponents",
    products: [
        .library(
            name: "SharedComponents",
            type: .static,  // or .dynamic
            targets: ["SharedComponents"]),
    ],
    dependencies: [
        .package(path: "../../../")  // Swiftlets
    ],
    targets: [
        .target(
            name: "SharedComponents",
            dependencies: [
                .product(name: "Swiftlets", package: "swiftlets")
            ]),
    ]
)
```

### Build Process
```bash
# Using SPM (generates all interfaces automatically)
cd SharedComponents
swift build -c release

# Artifacts in:
# .build/release/SharedComponents.swiftmodule
# .build/release/libSharedComponents.a
```

## Troubleshooting

**"Cannot find 'helloHeader' in scope"**
- Check: Is function marked `public`?
- Check: Is `-I` path correct?
- Check: Does .swiftmodule exist?

**"Undefined symbols for architecture"**
- Check: Is `-L` path correct?
- Check: Is library name correct in `-l`?
- Check: Architecture match (arm64 vs x86_64)?

**"Module compiled with different version"**
- Rebuild library with same Swift version
- Use `.swiftinterface` for stability