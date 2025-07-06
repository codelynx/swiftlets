# Shared Components Approaches: In-Depth Analysis

## Approach 1: Source-Level Includes (Compile Everything Together)

### How It Works
```bash
# Compile shared source files with each swiftlet
swiftc \
    Sources/Swiftlets/**/*.swift \
    sites/my-site/shared/*.swift \
    sites/my-site/src/index.swift \
    -o sites/my-site/bin/index
```

### Detailed Analysis

**Compilation Process:**
1. Swift compiler reads ALL source files
2. Parses and type-checks everything together
3. Generates a single executable with all code included

**File Organization:**
```
sites/my-site/
├── shared/
│   ├── Navigation.swift
│   ├── Footer.swift
│   └── Utils.swift
├── src/
│   ├── index.swift
│   └── about.swift
└── bin/
    ├── index (includes all shared code)
    └── about (includes all shared code)
```

**Pros:**
- ✅ **Simplest to implement** - No build system changes needed
- ✅ **No linking issues** - Everything compiled together
- ✅ **IDE friendly** - Simple file references
- ✅ **Cross-platform** - Works identically on all platforms
- ✅ **No module complexity** - Just Swift files

**Cons:**
- ❌ **Redundant compilation** - Shared code recompiled for EVERY page
- ❌ **Larger binaries** - Each executable contains all shared code
- ❌ **Slower builds** - No incremental compilation of shared components
- ❌ **No versioning** - Can't version shared components separately
- ❌ **Poor scalability** - Build time increases linearly with pages

**Performance Impact:**
- 10 pages × 5 shared files = 50 compilations of shared code
- Binary size: ~5MB per executable (vs ~1MB with proper sharing)
- Build time: O(n*m) where n=pages, m=shared files

**Best For:**
- Small sites (< 10 pages)
- Rapid prototyping
- Simple shared utilities

---

## Approach 2: Dynamic Libraries (.dylib/.so)

### How It Works
```bash
# Step 1: Build shared library
swiftc -emit-library -emit-module \
    -module-name SharedComponents \
    shared/*.swift \
    -o bin/libShared.dylib

# Step 2: Link swiftlets against library
swiftc \
    -I bin/ -L bin/ \
    -lShared \
    src/index.swift \
    -o bin/index
```

### Detailed Analysis

**Runtime Architecture:**
```
Process startup:
1. OS loads executable (bin/index)
2. Dynamic linker finds libShared.dylib
3. Loads shared library into memory
4. Resolves symbols
5. Executes main()
```

**File Organization:**
```
sites/my-site/
├── bin/
│   ├── libShared.dylib     # Shared library
│   ├── index               # Links to libShared.dylib
│   └── about               # Links to libShared.dylib
└── web/
    └── index.webbin        # Must store library path
```

**Pros:**
- ✅ **Memory efficient** - Single copy in memory for multiple processes
- ✅ **Small executables** - Only contain page-specific code
- ✅ **Fast incremental builds** - Shared code built once
- ✅ **Hot reload potential** - Can reload library without restarting
- ✅ **True sharing** - Multiple processes share same code

**Cons:**
- ❌ **Platform complexity** - Different for macOS/Linux
- ❌ **Deployment issues** - Must distribute library with executables
- ❌ **Runtime failures** - Missing library = crash
- ❌ **Path management** - DYLD_LIBRARY_PATH/LD_LIBRARY_PATH issues
- ❌ **Security concerns** - Dynamic loading vulnerabilities
- ❌ **Debugging harder** - Symbol resolution at runtime

**Platform-Specific Issues:**

**macOS:**
```bash
# Must handle:
- DYLD_LIBRARY_PATH restrictions (SIP)
- Code signing for libraries
- @rpath, @loader_path complexity
- Universal binaries (x86_64 + arm64)
```

**Linux:**
```bash
# Must handle:
- LD_LIBRARY_PATH management
- RPATH/RUNPATH in executables
- Different .so versioning schemes
- SELinux contexts
```

**Performance Impact:**
- Startup overhead: ~5-10ms for library loading
- Memory usage: Shared across processes
- Binary size: ~100KB per executable + 2MB shared library

**Best For:**
- Large sites with many pages
- Memory-constrained environments
- Systems with hot-reload requirements

---

## Approach 3: Static Libraries (.a)

### How It Works
```bash
# Step 1: Build static library
swiftc -emit-library -static \
    -module-name SharedComponents \
    shared/*.swift \
    -o bin/libShared.a

# Step 2: Link statically
swiftc \
    -I bin/ -L bin/ \
    -lShared \
    src/index.swift \
    -o bin/index
```

### Detailed Analysis

**Linking Process:**
1. Compiler reads static library archive
2. Extracts only needed object files
3. Links them into final executable
4. Dead code elimination removes unused functions

**File Organization:**
```
sites/my-site/
├── bin/
│   ├── libShared.a         # Static library (not needed at runtime)
│   ├── index               # Contains needed shared code
│   └── about               # Contains needed shared code
```

**Pros:**
- ✅ **Self-contained executables** - No runtime dependencies
- ✅ **Reliable deployment** - Just copy executables
- ✅ **Better performance** - No dynamic loading overhead
- ✅ **Security** - No dynamic loading vulnerabilities
- ✅ **Cross-platform simple** - Works same everywhere

**Cons:**
- ❌ **Larger executables** - Each contains copy of used shared code
- ❌ **No memory sharing** - Each process has own copy
- ❌ **Selective linking complexity** - Need proper symbol visibility
- ❌ **No hot reload** - Must rebuild to update shared code

**Build Optimization:**
```swift
// Mark public API explicitly
public struct Navigation { ... }

// Internal helpers not included unless used
internal func helperFunction() { ... }
```

**Performance Impact:**
- Binary size: ~1.5MB per executable (only used code included)
- Build time: Fast after initial library build
- Runtime: No overhead, direct function calls

**Best For:**
- Production deployments
- Security-conscious environments
- Simple deployment scenarios

---

## Approach 4: Swift Package Manager (Hybrid)

### How It Works
```bash
# Step 1: SPM builds shared package
cd SharedComponents && swift build -c release

# Step 2: Link against SPM artifacts
swiftc \
    -I SharedComponents/.build/release \
    -L SharedComponents/.build/release \
    -lSharedComponents \
    src/index.swift \
    -o bin/index
```

### Detailed Analysis

**SPM Integration:**
```swift
// SharedComponents/Package.swift
let package = Package(
    name: "SharedComponents",
    products: [
        .library(
            name: "SharedComponents",
            type: .static, // or .dynamic
            targets: ["SharedComponents"])
    ],
    dependencies: [
        .package(path: "../../../") // Swiftlets
    ]
)
```

**Build Process:**
1. SPM resolves dependencies
2. Builds dependency graph
3. Compiles in correct order
4. Produces .swiftmodule and library
5. Swiftlets link against artifacts

**File Organization:**
```
sites/my-site/
├── SharedComponents/
│   ├── Package.swift
│   ├── Sources/
│   │   └── SharedComponents/
│   │       ├── Navigation.swift
│   │       └── Footer.swift
│   └── .build/            # SPM artifacts
│       └── release/
│           ├── SharedComponents.swiftmodule
│           └── libSharedComponents.a
├── src/
│   ├── index.swift
│   └── about.swift
└── bin/
    ├── index
    └── about
```

**Pros:**
- ✅ **Professional tooling** - Full SPM ecosystem
- ✅ **Dependency management** - Version constraints, updates
- ✅ **IDE integration** - Xcode, VSCode understand packages
- ✅ **Module system** - Proper Swift modules with access control
- ✅ **Incremental builds** - SPM tracks dependencies
- ✅ **Testing support** - SPM includes test infrastructure
- ✅ **Documentation** - DocC integration

**Cons:**
- ❌ **Complexity** - Another tool to learn
- ❌ **Build overhead** - SPM has its own build system
- ❌ **Directory constraints** - SPM expects specific structure
- ❌ **Version conflicts** - Potential dependency hell
- ❌ **Cache issues** - SPM cache can get corrupted

**Advanced Features:**
```swift
// Conditional compilation
#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

// Resources
let bundle = Bundle.module
let data = bundle.url(forResource: "template", withExtension: "html")
```

**Performance Impact:**
- First build: Slower due to SPM resolution
- Incremental: Very fast, only rebuilds changes
- Binary size: Optimal with static linking

**Best For:**
- Large projects with complex dependencies
- Teams needing professional tooling
- Projects requiring versioning

---

## Approach 5: Hierarchical Shared Components

### How It Works
```bash
# For src/japan/tokyo/shibuya/page.swift
# Build order:
1. Build global SharedComponents
2. Build japan/_shared
3. Build tokyo/_shared  
4. Build shibuya/_shared
5. Build page.swift linking all applicable libraries
```

### Detailed Analysis

**Discovery Algorithm:**
```python
def find_shared_components(file_path):
    components = []
    
    # Global components
    if exists("SharedComponents/"):
        components.append("SharedComponents")
    
    # Walk up directory tree
    path = dirname(file_path)
    while path != "src":
        shared_dir = join(path, "_shared")
        if exists(shared_dir):
            components.append(shared_dir)
        path = dirname(path)
    
    return reversed(components)  # Global to local order
```

**Dependency Hierarchy:**
```
SharedComponents (global)
    ↑
JapanShared (can use global)
    ↑
TokyoShared (can use global + japan)
    ↑
ShibuyaShared (can use all above)
```

**Pros:**
- ✅ **Natural scoping** - Components available where needed
- ✅ **Clean separation** - No pollution across sections
- ✅ **Optimal binary size** - Only link what's needed
- ✅ **Clear ownership** - Who maintains what
- ✅ **Gradual adoption** - Add shared components as needed

**Cons:**
- ❌ **Build complexity** - Multiple packages to manage
- ❌ **Dependency tracking** - Complex dependency graph
- ❌ **Learning curve** - Developers must understand hierarchy
- ❌ **Potential duplication** - Similar components at different levels
- ❌ **Refactoring difficulty** - Moving components between levels

**Real-World Example:**
```
E-commerce site:
├── SharedComponents/        # Brand, layout, common UI
├── src/
│   ├── products/
│   │   ├── _shared/        # Product card, price formatter
│   │   ├── electronics/
│   │   │   ├── _shared/    # Tech specs component
│   │   │   └── phones/
│   │   │       └── _shared/ # Phone comparison widget
│   │   └── clothing/
│   │       └── _shared/    # Size chart component
```

**Performance Impact:**
- Build time: O(depth * components) but parallelizable
- Binary size: Optimal - only needed components
- Runtime: Same as static linking

**Best For:**
- Large multi-section sites
- Multi-tenant applications
- Sites with clear hierarchical structure

---

## Recommendation Matrix

| Approach | Build Speed | Binary Size | Complexity | Deployment | Best Use Case |
|----------|-------------|-------------|------------|------------|---------------|
| Source Include | Slow | Large | Low | Easy | < 10 pages |
| Dynamic Library | Fast | Small | High | Complex | Memory-constrained |
| Static Library | Medium | Medium | Medium | Easy | Production sites |
| SPM Hybrid | Medium | Optimal | Medium | Easy | Professional projects |
| Hierarchical | Slow | Optimal | High | Medium | Large structured sites |

## Decision Factors

1. **Site Size**
   - < 10 pages: Source include
   - 10-50 pages: Static library or SPM
   - 50+ pages: Hierarchical

2. **Team Size**
   - Solo: Source include or static
   - Small team: SPM hybrid
   - Large team: Hierarchical

3. **Performance Requirements**
   - Fast builds: Dynamic library
   - Small binaries: Dynamic library
   - Fast runtime: Static library
   - Memory efficiency: Dynamic library

4. **Deployment Environment**
   - Simple hosting: Static library
   - Containerized: Any approach
   - Serverless: Static library
   - Embedded: Source include