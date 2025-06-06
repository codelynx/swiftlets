# Webbin Routing System Design

## Overview

A new routing system that uses `.webbin` marker files to map HTTP routes to executables, with automatic compilation support when executables are missing.

## Core Concepts

### 1. Route Resolution Flow

```
HTTP Request: /hello
    ↓
Look for: site/hello.webbin (marker file)
    ↓
If found, look for: bin/hello (executable)
    ↓
If not found, look for: src/hello.swift (source)
    ↓
Compile: swift build → bin/hello
    ↓
Execute: bin/hello
```

### 2. Webbin Files

`.webbin` files serve as route markers and can contain:
- **Empty file**: Just marks that this route exists
- **MD5 hash**: Checksum of the corresponding executable for integrity/cache validation
- **Metadata** (future): Could contain route configuration, middleware settings, etc.

### 3. Directory Structure

```
project/
├── site/                    # Route definitions
│   ├── index.webbin        # Maps / to bin/index
│   ├── hello.webbin        # Maps /hello to bin/hello
│   ├── api/
│   │   └── users.webbin    # Maps /api/users to bin/api/users
│   └── static/             # Static files (no .webbin needed)
│       ├── style.css
│       └── script.js
├── src/                     # Source files
│   ├── index.swift
│   ├── hello.swift
│   └── api/
│       └── users.swift
└── bin/                     # Compiled executables
    ├── index
    ├── hello
    └── api/
        └── users
```

## Implementation Details

### 1. Request Handler Logic

```swift
func handleRequest(path: String) {
    // 1. Check for static files first
    if path.contains(".") && fileExists("site/static/\(path)") {
        return serveStaticFile("site/static/\(path)")
    }
    
    // 2. Look for .webbin marker
    let webbinPath = "site/\(path).webbin"
    if !fileExists(webbinPath) {
        return 404
    }
    
    // 3. Read .webbin file
    let webbinContent = readFile(webbinPath)
    let expectedMD5 = webbinContent.isEmpty ? nil : webbinContent.trim()
    
    // 4. Look for executable
    let execPath = "bin/\(path)"
    
    if fileExists(execPath) {
        // Verify MD5 if provided
        if let expectedMD5 = expectedMD5 {
            let actualMD5 = calculateMD5(execPath)
            if actualMD5 != expectedMD5 {
                log.warning("MD5 mismatch for \(execPath)")
                // Could trigger recompilation
            }
        }
        return executeSwiftlet(execPath)
    }
    
    // 5. Look for source file
    let sourcePath = "src/\(path).swift"
    if !fileExists(sourcePath) {
        return 404
    }
    
    // 6. Compile source
    compileSwiftlet(sourcePath, outputPath: execPath)
    
    // 7. Update .webbin with new MD5
    if webbinContent.isEmpty {
        let newMD5 = calculateMD5(execPath)
        writeFile(webbinPath, newMD5)
    }
    
    return executeSwiftlet(execPath)
}
```

### 2. Compilation System

```swift
func compileSwiftlet(sourcePath: String, outputPath: String) {
    // Create output directory if needed
    createDirectoryIfNeeded(dirname(outputPath))
    
    // Compile with dependencies
    let result = shell("""
        swiftc \(sourcePath) \
            -I .build/debug \
            -L .build/debug \
            -lSwiftletsCore \
            -lSwiftletsHTML \
            -o \(outputPath)
    """)
    
    if result.exitCode != 0 {
        throw CompilationError(result.stderr)
    }
    
    // Make executable
    chmod(outputPath, 0o755)
}
```

### 3. Benefits

1. **Clear route definition**: `.webbin` files explicitly define available routes
2. **Automatic compilation**: No manual build step needed during development
3. **Integrity checking**: MD5 ensures executables haven't been tampered with
4. **Mixed content**: Static files and dynamic routes can coexist
5. **Gitignore friendly**: Can gitignore `bin/` but track `site/*.webbin`

### 4. Advanced Features

#### Route Parameters
```
site/user/[id].webbin → Matches /user/123, /user/abc
```

#### Nested Routes
```
site/
├── api.webbin           # /api → bin/api
└── api/
    ├── users.webbin     # /api/users → bin/api/users
    └── posts.webbin     # /api/posts → bin/api/posts
```

#### Development vs Production

**Development Mode**:
- Always check source file timestamps
- Recompile if source is newer than binary
- Show compilation errors in browser

**Production Mode**:
- Skip source file checks
- Rely on MD5 validation only
- Return 500 on missing executables

### 5. Migration Path

1. Current structure can be adapted:
   - Move route definitions to `site/` with `.webbin` files
   - Keep sources in current locations or move to `src/`
   - Compiled binaries go to `bin/`

2. Backward compatibility:
   - Fall back to current behavior if no `.webbin` file found
   - Gradual migration possible

### 6. Open Questions

1. **Naming**: Is "site" the best name? Alternatives:
   - `routes/` - More explicit about purpose
   - `web/` - Short and clear
   - `app/` - Common convention

2. **Static file handling**: Should static files require special handling or just absence of `.webbin`?

3. **Compilation**: Should we use Swift Package Manager instead of direct swiftc?

4. **Caching**: Should compiled binaries be cached differently?

5. **Hot reload**: How to handle file watching for automatic recompilation?

## Next Steps

1. Prototype the basic .webbin resolution logic
2. Implement compilation system
3. Add MD5 validation
4. Integrate with existing server
5. Create migration guide

## Example Usage

```bash
# Create a new route
echo "" > site/hello.webbin
cat > src/hello.swift << 'EOF'
import SwiftletsCore
import SwiftletsHTML

let request = try readRequest()
let response = Response(html: Html {
    Body {
        H1("Hello, World!")
    }
}.render())

try writeResponse(response)
EOF

# Server automatically compiles and serves at /hello
curl http://localhost:8080/hello
```

This design provides a clean separation between route definition, source code, and compiled binaries while maintaining the flexibility of the current system.