# Hierarchical Shared Components Design

## Problem
Sites often have hierarchical structures where components need different scopes:
- Global components (used everywhere)
- Section-specific components (used within a section)
- Local components (used within a subsection)

Example: `japan/tokyo/shibuya/page.swift`
- Global: Site-wide navigation, footer
- Japan-level: Japanese language components, currency formatters
- Tokyo-level: Tokyo-specific maps, transit info
- Shibuya-level: Local business directory components

## Proposed Solution: Hierarchical Component Discovery

### Directory Structure
```
sites/travel-site/
├── SharedComponents/           # Global shared components
│   ├── Package.swift
│   └── Sources/
│       └── SharedComponents/
│           ├── Navigation.swift
│           └── Footer.swift
│
├── src/
│   ├── index.swift
│   ├── about.swift
│   │
│   └── japan/
│       ├── _shared/           # Japan-specific components
│       │   ├── Package.swift
│       │   └── Sources/
│       │       └── JapanShared/
│       │           ├── CurrencyFormatter.swift
│       │           └── LanguageSelector.swift
│       │
│       ├── index.swift
│       ├── culture.swift
│       │
│       └── tokyo/
│           ├── _shared/       # Tokyo-specific components
│           │   ├── Package.swift
│           │   └── Sources/
│           │       └── TokyoShared/
│           │           ├── TrainMap.swift
│           │           └── WeatherWidget.swift
│           │
│           ├── index.swift
│           ├── attractions.swift
│           │
│           └── shibuya/
│               ├── _shared/   # Shibuya-specific components
│               │   ├── Package.swift
│               │   └── Sources/
│               │       └── ShibuyaShared/
│               │           └── LocalBusinesses.swift
│               │
│               ├── index.swift
│               ├── shopping.swift
│               └── restaurants.swift
│
└── bin/
    ├── index
    ├── about
    ├── japan/
    │   ├── index
    │   └── tokyo/
    │       └── shibuya/
    │           ├── shopping
    │           └── restaurants
    └── .shared/              # Compiled shared libraries
        ├── libSharedComponents.a
        ├── japan/
        │   ├── libJapanShared.a
        │   └── tokyo/
        │       ├── libTokyoShared.a
        │       └── shibuya/
        │           └── libShibuyaShared.a
```

## Build Process

### 1. Component Discovery
The build script walks up the directory tree to find all applicable shared components:

```bash
# For src/japan/tokyo/shibuya/shopping.swift
# Discovers:
# 1. SharedComponents/ (global)
# 2. src/japan/_shared/
# 3. src/japan/tokyo/_shared/
# 4. src/japan/tokyo/shibuya/_shared/
```

### 2. Build Order
Build shared components from global to local:
```bash
1. Build SharedComponents → bin/.shared/libSharedComponents.a
2. Build japan/_shared → bin/.shared/japan/libJapanShared.a
3. Build tokyo/_shared → bin/.shared/japan/tokyo/libTokyoShared.a
4. Build shibuya/_shared → bin/.shared/japan/tokyo/shibuya/libShibuyaShared.a
```

### 3. Compilation
Each swiftlet links against all applicable shared libraries:

```bash
# Building src/japan/tokyo/shibuya/shopping.swift
swiftc \
    -I SharedComponents/.build/release \
    -I src/japan/_shared/.build/release \
    -I src/japan/tokyo/_shared/.build/release \
    -I src/japan/tokyo/shibuya/_shared/.build/release \
    -L bin/.shared \
    -L bin/.shared/japan \
    -L bin/.shared/japan/tokyo \
    -L bin/.shared/japan/tokyo/shibuya \
    -lSharedComponents \
    -lJapanShared \
    -lTokyoShared \
    -lShibuyaShared \
    src/japan/tokyo/shibuya/shopping.swift \
    -o bin/japan/tokyo/shibuya/shopping
```

## Usage Example

```swift
// src/japan/tokyo/shibuya/shopping.swift
import Swiftlets
import SharedComponents      // Global
import JapanShared          // Japan-level
import TokyoShared          // Tokyo-level
import ShibuyaShared        // Shibuya-level

@main
struct ShoppingPage: SwiftletMain {
    var body: some HTMLElement {
        PageLayout(activePage: "shopping") {        // From SharedComponents
            VStack {
                LanguageSelector(current: .japanese)  // From JapanShared
                TrainMap(station: "Shibuya")        // From TokyoShared
                LocalBusinessList(category: .shopping) // From ShibuyaShared
                
                H1("Shopping in Shibuya")
                // ... page content
            }
        }
    }
}
```

## Package Dependencies

Each shared package can depend on its parent packages:

```swift
// src/japan/tokyo/_shared/Package.swift
let package = Package(
    name: "TokyoShared",
    dependencies: [
        .package(path: "../../../../"),           // Swiftlets
        .package(path: "../../../../SharedComponents"), // Global shared
        .package(path: "../_shared")              // JapanShared
    ],
    targets: [
        .target(
            name: "TokyoShared",
            dependencies: [
                .product(name: "Swiftlets", package: "swiftlets"),
                .product(name: "SharedComponents", package: "SharedComponents"),
                .product(name: "JapanShared", package: "JapanShared")
            ]
        )
    ]
)
```

## Benefits

1. **Natural Scoping**: Components are available exactly where needed
2. **No Global Pollution**: Shibuya-specific components don't affect other areas
3. **Dependency Management**: Child components can use parent components
4. **Performance**: Only link necessary libraries for each page
5. **Maintainability**: Clear ownership and organization

## Alternative: Single Package with Modules

Instead of multiple packages, use one package with multiple modules:

```
SharedComponents/
├── Package.swift
└── Sources/
    ├── SharedComponents/    # Global
    ├── JapanShared/        # Japan-specific
    ├── TokyoShared/        # Tokyo-specific
    └── ShibuyaShared/      # Shibuya-specific
```

**Pros:**
- Simpler build process
- Easier dependency management

**Cons:**
- All pages link against all modules (larger binaries)
- Less clear scoping
- Harder to enforce access control

## Recommendation

Use hierarchical packages with `_shared/` directories. This provides:
- Clear scope boundaries
- Optimal binary sizes
- Natural organization
- Flexibility for future growth

The `_` prefix ensures shared directories appear first in listings and clearly indicates they're special directories, not content directories.