# POC: Simple Swiftlets Server

## Overview

This document describes the proof-of-concept implementation of Swiftlets - a web server that routes HTTP requests to standalone Swift executables. This POC demonstrates the core architecture without using result builders.

## What We Built

### 1. SwiftNIO-based Web Server

A simple HTTP server using SwiftNIO that:
- Listens for HTTP requests on port 8080
- Maps URL paths to executable files
- Spawns swiftlet processes for each request
- Passes request data via environment variables
- Captures swiftlet output and sends it as HTTP response

**Key Components:**
- `Sources/SwiftletsServer/main.swift` - The main server implementation
- Uses `Process` API to execute swiftlets
- Parses simple HTTP response format from swiftlet output

### 2. Core Types

Basic request/response types without any fancy features:
- `Sources/SwiftletsCore/Request.swift` - Request data structure
- `Sources/SwiftletsCore/Response.swift` - Response data structure  
- `Sources/SwiftletsCore/Swiftlet.swift` - Swiftlet protocol (for future use)

### 3. Hello Swiftlet

A standalone Swift executable that generates HTML:
- `src/hello/index.swift` - Simple Swift program
- Reads request info from environment variables
- Outputs HTTP response format to stdout
- No dependencies, no result builders

## How It Works

### Request Flow

1. **Client Request**: `GET http://localhost:8080/hello`

2. **Server Routing**:
   ```swift
   // In SwiftletHTTPHandler
   if path == "/" || path == "/hello" {
       swiftletPath = "hello/index"
   }
   ```

3. **Process Execution**:
   ```swift
   let executablePath = "bin/macos/arm64/hello/index"
   let process = Process()
   process.executableURL = URL(fileURLWithPath: executablePath)
   ```

4. **Environment Variables**:
   ```swift
   environment["REQUEST_METHOD"] = "GET"
   environment["REQUEST_PATH"] = "/hello"
   environment["REQUEST_HEADERS"] = "{...}"
   ```

5. **Swiftlet Output**:
   ```
   Status: 200
   Content-Type: text/html; charset=utf-8
   X-Swiftlet: hello/index
   
   <!DOCTYPE html>
   <html>...
   ```

### Swiftlet Format

Swiftlets output a simple HTTP-like format:
- Headers (one per line)
- Empty line
- Body content

Example:
```
Status: 200
Content-Type: text/html; charset=utf-8

<html>...</html>
```

## Building and Running

### 1. Build the Swiftlet

```bash
cd src/hello
swift build -c release
cp .build/release/index ../../bin/macos/arm64/hello/index
```

### 2. Build the Server

```bash
cd ../..
swift build -c release
```

### 3. Run the Server

```bash
.build/release/swiftlets-server
```

### 4. Test It

```bash
curl http://localhost:8080/hello
```

## What We Learned

### Successes

1. **Process Isolation Works**: Each request runs in its own process
2. **Simple Protocol**: Environment variables + stdout is sufficient
3. **Fast Enough**: Swift executables start quickly (~10-20ms)
4. **Hot Reload**: Can update swiftlets without restarting server

### Challenges Encountered

1. **Process Overhead**: Creating a new process for each request has overhead
2. **Error Handling**: Need better error reporting from swiftlets
3. **Binary Management**: Need automated build system for swiftlets

### Performance Observations

- Process spawn time: ~10-20ms on macOS M1
- Memory per process: ~3-5MB
- Suitable for moderate traffic sites
- Would benefit from process pooling for high traffic

## Next Steps

### Immediate Improvements

1. **Process Pooling**: Keep warm processes ready
2. **Build System**: Auto-compile swiftlets on first request
3. **Error Pages**: Better error handling and reporting
4. **Routing Config**: YAML/JSON based route configuration

### Future Features

1. **Result Builders**: Add SwiftUI-like syntax for HTML
2. **Request Parsing**: Better handling of POST data, JSON, etc.
3. **Session Management**: Server-side session support
4. **Multi-platform**: Test on Linux, add cross-compilation

### Architecture Validation

This POC validates the core architecture:
- ✅ Executable-per-route model works
- ✅ Environment variable passing is sufficient
- ✅ Swift executables are fast enough
- ✅ Process isolation provides safety

## Code Structure

```
swiftlets/
├── Package.swift                 # Server package
├── Sources/
│   ├── SwiftletsCore/           # Shared types
│   └── SwiftletsServer/         # HTTP server
├── sites/                       # All sites organized here
│   ├── core/                    # Official examples
│   │   ├── hello/              # Basic example
│   │   └── showcase/           # Feature showcase
│   ├── test/                   # Test sites
│   └── templates/              # Third-party templates
└── bin/                        # Compiled executables (git ignored)
    └── macos/
        └── arm64/
            ├── hello/          # Hello site executables
            │   └── index
            └── showcase/       # Showcase site executables
                ├── index
                ├── elements
                └── api-data
```

## Sites Organization

The POC now supports multiple sites via the `SWIFTLETS_SITE` environment variable:

```bash
# Run hello site
SWIFTLETS_SITE=sites/core/hello .build/release/swiftlets-server

# Run showcase site  
SWIFTLETS_SITE=sites/core/showcase .build/release/swiftlets-server
```

Each site can have:
- Multiple swiftlets (executables)
- Its own `site.yaml` configuration
- Independent dependencies
- Documentation

## Key Insights

1. **Simplicity**: No complex frameworks needed - just processes and pipes
2. **Flexibility**: Each swiftlet can use different Swift versions/dependencies
3. **Debugging**: Easy to test swiftlets standalone
4. **Deployment**: Can update individual routes without full redeploy

## Conclusion

This POC successfully demonstrates that the Swiftlets architecture is viable. The next step is to add developer conveniences like result builders and automatic compilation while maintaining the simplicity of the core model.