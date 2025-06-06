# Structure Migration Guide

This guide helps migrate from the current structure to the new v2 structure.

## Current Structure

```
swiftlets/
├── core/
├── sites/
│   └── core/
│       ├── hello/
│       ├── showcase/
│       └── swiftlets-site/
├── sdk/
│   └── examples/
│       └── html-showcase/
└── examples/
    └── basic-site/
```

## Target Structure

```
swiftlets/
├── core/
│   └── sites/           # Internal test sites
├── sdk/
│   └── sites/          # User-facing examples
└── (remove examples/, sites/ from root)
```

## Migration Steps

### Step 1: Create New Directories

```bash
# Create core test sites directory
mkdir -p core/sites

# Ensure sdk/sites exists
mkdir -p sdk/sites
```

### Step 2: Move User-Facing Examples to SDK

```bash
# Move existing examples to SDK
mv sites/core/hello sdk/sites/
mv sites/core/showcase sdk/sites/
mv sites/core/swiftlets-site sdk/sites/
mv examples/basic-site sdk/sites/

# Move or merge html-showcase
# (decide whether to keep swiftlets-site or html-showcase)
```

### Step 3: Create Core Test Sites

```bash
# Create internal test sites
mkdir -p core/sites/test-routing
mkdir -p core/sites/test-html
mkdir -p core/sites/benchmark
mkdir -p core/sites/integration
```

### Step 4: Update References

Files that need updating:
- `README.md` - Update example paths
- `docs/roadmap.md` - Update structure references  
- `CLAUDE.md` - Update project structure section
- `Makefile` - Update any site references
- `cli/Sources/SwiftletsCLI/Commands/Serve.swift` - Update default paths

### Step 5: Clean Up

```bash
# Remove old directories (after verifying everything is moved)
rm -rf sites/
rm -rf examples/
```

## Sample Core Test Site

Create `core/sites/test-routing/src/index.swift`:

```swift
// Test site for routing features
import Foundation
import SwiftletsCore
import SwiftletsHTML

@main
struct RoutingTest {
    static func main() async throws {
        let request = try Request.decode()
        
        // Test various routing scenarios
        let html = Html {
            Head { Title("Routing Test") }
            Body {
                H1("Testing Route: \(request.path)")
                
                Pre {
                    Text("Query: \(request.query)")
                    Text("Method: \(request.method)")
                    Text("Headers: \(request.headers)")
                }
            }
        }
        
        Response(html: html.render()).send()
    }
}
```

## Verification Checklist

- [ ] All examples moved to `sdk/sites/`
- [ ] Core test sites created in `core/sites/`
- [ ] Documentation updated
- [ ] CLI paths updated
- [ ] Old directories removed
- [ ] README reflects new structure
- [ ] Everything builds and runs

## Benefits After Migration

1. **For Core Developers:**
   - Dedicated space for testing
   - No need to maintain "pretty" examples
   - Fast iteration on features

2. **For SDK Users:**
   - Clear location for examples
   - All examples in one place
   - Better organized learning path

3. **For Project Maintainers:**
   - Cleaner root directory
   - Logical separation
   - Easier to manage