# Shared Components with Swift Package Manager

## Design Decision

After analyzing options, we recommend a **hybrid approach** that preserves Swiftlets' architecture while leveraging SPM for shared components.

## Architecture

```
sites/my-site/
├── src/                    # Individual swiftlets (simple .swift files)
│   ├── index.swift        # import SharedComponents
│   └── about.swift        # import SharedComponents
│
├── SharedComponents/       # SPM package for shared code
│   ├── Package.swift
│   └── Sources/
│       └── SharedComponents/
│           ├── Navigation.swift
│           ├── Footer.swift
│           └── Layouts.swift
│
├── bin/                    # Compiled executables (flat structure)
│   ├── index
│   ├── about
│   └── .shared/           # Hidden directory for shared artifacts
│       └── libSharedComponents.a
│
└── web/
    ├── index.webbin
    └── about.webbin
```

## How It Works

### 1. Build Process

The `build-site` script will:

```bash
# Step 1: Build shared components package (if exists)
if [ -d "$SITE_ROOT/SharedComponents" ]; then
    cd "$SITE_ROOT/SharedComponents"
    swift build -c release
    # Copy build artifacts to bin/.shared/
fi

# Step 2: Build each swiftlet
for swift_file in src/*.swift; do
    swiftc \
        -I "$SITE_ROOT/SharedComponents/.build/release" \
        -L "$SITE_ROOT/SharedComponents/.build/release" \
        -lSharedComponents \
        $swift_file \
        -o "bin/$(basename $swift_file .swift)"
done
```

### 2. SharedComponents Package.swift

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SharedComponents",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "SharedComponents",
            type: .static,  // Static linking for simplicity
            targets: ["SharedComponents"]
        ),
    ],
    dependencies: [
        // Reference to main Swiftlets package
        .package(path: "../../../")
    ],
    targets: [
        .target(
            name: "SharedComponents",
            dependencies: [
                .product(name: "Swiftlets", package: "swiftlets")
            ]
        ),
    ]
)
```

### 3. Using Shared Components

```swift
// src/index.swift
import Swiftlets
import SharedComponents

@main
struct HomePage: SwiftletMain {
    var body: some HTMLElement {
        PageLayout(activePage: "home") {
            H1("Welcome")
            // ... page specific content
        }
    }
}
```

## Benefits

1. **Preserves Swiftlets Architecture**: Each route is still an independent executable
2. **Leverages SPM**: For dependency management and building shared code
3. **Type Safety**: Full Swift type checking across shared components
4. **IDE Support**: SPM packages have excellent IDE integration
5. **Incremental Builds**: SPM handles dependency tracking
6. **No Runtime Dependencies**: Static linking means executables are self-contained

## Alternatives Considered

### 1. Source-Level Includes
```bash
swiftc src/index.swift shared/*.swift -o bin/index
```
- ❌ Recompiles shared code for each page
- ❌ No dependency management
- ❌ Poor IDE support

### 2. Dynamic Libraries
```bash
swiftc -emit-library shared/*.swift -o bin/libShared.dylib
```
- ❌ Complex runtime library loading
- ❌ Platform-specific issues (DYLD_LIBRARY_PATH, etc.)
- ❌ Deployment complications

### 3. Full SPM Integration
Making the entire site an SPM package:
- ❌ Conflicts with file-based routing
- ❌ Can't easily create individual executables
- ❌ Loses the simplicity of Swiftlets

## Implementation Plan

1. Update `build-site` script to detect and build SharedComponents package
2. Modify compilation to link against SharedComponents
3. Create example site demonstrating the pattern
4. Document the approach in user guides

## Open Questions

1. Should we support multiple shared packages per site?
2. How to handle versioning of shared components?
3. Should shared components be publishable as separate packages?