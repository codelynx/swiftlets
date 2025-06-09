# Build Troubleshooting Guide

This guide helps resolve common build issues with Swiftlets sites.

## Common Issues

### 1. Build Hangs During Compilation

**Symptoms:**
- Build process stops at "Building filename.swift"
- No error output
- High CPU usage by swiftc process

**Causes:**
- Complex nested HTML structures
- Deeply nested result builders
- Large inline string literals

**Solutions:**

#### Kill Stuck Processes
```bash
# Kill all swiftc processes
pkill -f swiftc

# Clean build artifacts
./build-site sites/your-site --clean
```

#### Simplify Complex HTML
Break down complex views into smaller functions:

```swift
// ❌ BAD: Complex nested structure
var body: some HTMLElement {
    Div {
        Container {
            Grid {
                Row {
                    Column {
                        // 50+ lines of nested content
                    }
                }
            }
        }
    }
}

// ✅ GOOD: Decomposed structure
var body: some HTMLElement {
    Fragment {
        header()
        mainContent()
        footer()
    }
}

@HTMLBuilder
func header() -> some HTMLElement {
    // Header content
}

@HTMLBuilder
func mainContent() -> some HTMLElement {
    // Main content
}
```

#### Move Large Strings to Properties
```swift
// ❌ BAD: Large inline string
Pre {
    Code("""
    // 100+ lines of code
    """)
}

// ✅ GOOD: String as property
let codeExample = """
// 100+ lines of code
"""

Pre {
    Code(codeExample)
}
```

### 2. Missing Component Errors

**Symptoms:**
- "Cannot find 'Container' in scope"
- "Cannot find 'Grid' in scope"
- Similar errors for Row, Column, Card

**Cause:**
These components are not yet implemented in Swiftlets.

**Workaround:**
Replace with basic HTML elements:

```swift
// Instead of Container
Div {
    // content
}
.style("max-width", "1024px")
.style("margin", "0 auto")
.style("padding", "0 20px")

// Instead of Grid
Div {
    // content
}
.style("display", "grid")
.style("grid-template-columns", "repeat(auto-fit, minmax(300px, 1fr))")
.style("gap", "2rem")
```

### 3. SwiftletMain Compilation Issues

**Symptoms:**
- Slow compilation of @main structs
- Memory usage spikes during compilation

**Solutions:**

1. **Keep body simple:**
```swift
var body: some HTMLElement {
    Fragment {
        component1()
        component2()
        component3()
    }
}
```

2. **Use explicit return types:**
```swift
@HTMLBuilder
func navigation() -> some HTMLElement {
    // Navigation content
}
```

3. **Avoid complex expressions:**
```swift
// ❌ BAD
.style("color", isDark ? (isActive ? "#fff" : "#ccc") : (isActive ? "#000" : "#666"))

// ✅ GOOD
.style("color", getColor())

func getColor() -> String {
    if isDark {
        return isActive ? "#fff" : "#ccc"
    } else {
        return isActive ? "#000" : "#666"
    }
}
```

### 4. Build Script Issues

**Issue:** build-site script hangs or fails

**Debug Steps:**

1. **Run with verbose output:**
```bash
./build-site sites/your-site --verbose
```

2. **Build individual files:**
```bash
# Build just one file to isolate issues
swiftc -parse-as-library \
    -module-name Swiftlets \
    Sources/Swiftlets/**/*.swift \
    sites/your-site/src/problematic-file.swift
```

3. **Check for syntax errors:**
```bash
# Parse without building
swiftc -parse sites/your-site/src/file.swift
```

### 5. Server Startup Issues

**"Address already in use" Error:**
```bash
# Find and kill existing server
pkill -f swiftlets-server

# Or find specific process
lsof -i :8080
kill -9 <PID>
```

**Missing executables:**
```bash
# Ensure executables are built
./build-site sites/your-site

# Check bin directory
ls -la sites/your-site/bin/
```

## Prevention Tips

1. **Test incrementally**: Build after each major change
2. **Use clean builds**: Run with --clean when switching between major changes
3. **Monitor complexity**: Keep functions under 50 lines
4. **Use components**: Create reusable components instead of inline HTML
5. **Profile builds**: Use `time ./build-site` to track build performance

## Getting Help

If you encounter issues not covered here:

1. Check existing issues: https://github.com/swiftlets/swiftlets/issues
2. Enable verbose logging: `export SWIFTLETS_DEBUG=1`
3. Collect diagnostic info:
   - Swift version: `swift --version`
   - Platform: `uname -a`
   - Build output with --verbose flag
   - Minimal reproduction case

## Related Documentation

- [Troubleshooting Complex Expressions](troubleshooting-complex-expressions.md)
- [SwiftUI API Migration Guide](SWIFTUI-API-MIGRATION-GUIDE.md)
- [Architecture Overview](swiftlet-architecture.md)