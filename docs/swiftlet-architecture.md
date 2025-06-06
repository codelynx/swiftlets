# Swiftlet Architecture: Modular Executable Components

## Overview

Swiftlets uses a unique architecture where the web server acts as a router to standalone executable modules called "swiftlets". Each route maps to an independent executable that handles the request, similar to CGI but with modern tooling and automatic compilation.

## Core Concept

```
HTTP Request → Web Server → Route Mapping → Swiftlet Executable → Response
```

Unlike traditional web frameworks where all routes are compiled into a single application, each swiftlet is:
- A standalone executable
- Compiled on-demand if needed
- Isolated from other swiftlets
- Language-agnostic (Swift initially, but extensible)

## Architecture Components

### 1. Web Server (Router)
The main server that:
- Listens for HTTP requests
- Maps URLs to swiftlet executables
- Spawns/manages swiftlet processes
- Handles process pooling and lifecycle
- Manages the build queue

### 2. Swiftlets (Executable Modules)
Individual programs that:
- Receive request data via stdin or environment variables
- Process the request
- Return HTML/JSON/data via stdout
- Are stateless (state managed by server or external services)

### 3. Build System
Automatic compilation system that:
- Detects missing or outdated executables
- Queues build requests
- Compiles swiftlets in parallel
- Caches compiled binaries

## Platform Support

Swiftlets supports multiple platforms and architectures:
- **macOS**: x86_64 (Intel) and arm64 (Apple Silicon)
- **Linux**: x86_64 and arm64 (Ubuntu and other distributions)

## Directory Structure

```
swiftlets/
├── server/                     # Core web server
│   ├── Sources/
│   │   ├── Router.swift        # URL to executable mapping
│   │   ├── ProcessManager.swift # Swiftlet process management
│   │   ├── BuildQueue.swift    # Compilation queue
│   │   └── main.swift
│   └── Package.swift
│
├── src/                        # Swiftlet source code
│   ├── getting-started/
│   │   ├── index.swift         # Platform-independent source
│   │   ├── about.swift         
│   │   └── Package.swift       
│   │
│   ├── api/
│   │   ├── users/
│   │   │   ├── list.swift      
│   │   │   └── detail.swift    
│   │   └── Package.swift
│   │
│   └── shared/                 # Shared libraries for swiftlets
│       ├── SwiftletCore/       # Core protocols and helpers
│       └── Package.swift
│
├── bin/                        # Compiled swiftlet executables (multi-platform)
│   ├── macos/                  # macOS
│   │   ├── x86_64/
│   │   │   ├── getting-started/
│   │   │   │   ├── index
│   │   │   │   └── about
│   │   │   └── api/users/
│   │   │       ├── list
│   │   │       └── detail
│   │   └── arm64/
│   │       ├── getting-started/
│   │       │   ├── index
│   │       │   └── about
│   │       └── api/users/
│   │           ├── list
│   │           └── detail
│   │
│   └── linux/                  # Linux
│       ├── x86_64/
│       │   └── [same structure as macos]
│       └── arm64/
│           └── [same structure as macos]
│
├── sdk/                        # Third-party pre-built executables
│   ├── macos/
│   │   ├── x86_64/
│   │   │   └── vendor/
│   │   │       └── analytics/
│   │   │           └── tracker
│   │   └── arm64/
│   │       └── vendor/
│   │           └── analytics/
│   │               └── tracker
│   └── linux/
│       ├── x86_64/
│       │   └── [same structure]
│       └── arm64/
│           └── [same structure]
│
├── cache/                      # Runtime cache
│   └── processes/              # Process pool
│
└── config/
    ├── routes.yaml             # Route configuration
    └── build.yaml              # Build settings
```

## Route Mapping

### Configuration (routes.yaml)
```yaml
routes:
  # Static mapping
  - path: /getting-started
    swiftlet: getting-started/index
    
  - path: /getting-started/about
    swiftlet: getting-started/about
    
  # Dynamic segments
  - path: /api/users
    swiftlet: api/users/list
    
  - path: /api/users/:id
    swiftlet: api/users/detail
    
  # Wildcard
  - path: /blog/*
    swiftlet: blog/handler

# Default swiftlet for 404
default: errors/not-found
```

### URL to Executable Resolution

The server automatically selects the correct platform/architecture binary:

```
URL Path                    → Swiftlet Path           → Executable (runtime resolution)
/getting-started           → getting-started/index   → bin/{platform}/{arch}/getting-started/index
/api/users/123            → api/users/detail        → bin/{platform}/{arch}/api/users/detail
/blog/2024/my-post        → blog/handler            → bin/{platform}/{arch}/blog/handler
```

Platform detection at runtime:
- macOS Intel: `bin/macos/x86_64/getting-started/index`
- macOS M1/M2: `bin/macos/arm64/getting-started/index`
- Linux x64: `bin/linux/x86_64/getting-started/index`
- Linux ARM: `bin/linux/arm64/getting-started/index`

## Request/Response Protocol

### Request Data Transfer
Swiftlets receive request data through:

1. **Environment Variables**
```bash
REQUEST_METHOD=GET
REQUEST_PATH=/api/users/123
REQUEST_QUERY=sort=name&limit=10
REQUEST_HEADERS='{"Content-Type": "application/json"}'
PATH_PARAMS='{"id": "123"}'
```

2. **Standard Input** (for POST/PUT data)
```json
{
  "method": "POST",
  "path": "/api/users",
  "headers": {...},
  "body": "{\"name\": \"John\"}",
  "params": {}
}
```

### Response Format
Swiftlets output to stdout:
```
Status: 200
Content-Type: text/html
X-Custom-Header: value

<!DOCTYPE html>
<html>...
```

## Swiftlet Implementation

### Basic Swiftlet (index.swift)
```swift
import SwiftletCore

@main
struct GetStartedIndex: Swiftlet {
    func handle(_ request: Request) -> Response {
        Response {
            HTML {
                Head {
                    Title("Getting Started")
                }
                Body {
                    H1("Welcome to Swiftlets")
                    Text("Each page is a separate executable!")
                }
            }
        }
    }
}
```

### API Swiftlet (users/detail.swift)
```swift
import SwiftletCore

@main
struct UserDetail: Swiftlet {
    func handle(_ request: Request) -> Response {
        guard let userId = request.params["id"] else {
            return Response(status: 400, body: "Missing user ID")
        }
        
        // Fetch user from database
        let user = fetchUser(id: userId)
        
        return Response(json: user)
    }
}
```

## Build System

### Automatic Compilation
1. Request arrives for `/getting-started`
2. Server detects current platform/architecture (e.g., `macos/arm64`)
3. Server checks if `bin/macos/arm64/getting-started/index` exists
4. If missing or source is newer:
   - Add to build queue with target platform
   - Return "Building..." page or wait
   - Compile: `swift build -c release --product getting-started-index --triple arm64-apple-macosx`
   - Move executable to `bin/macos/arm64/getting-started/`
5. Execute the platform-specific swiftlet

### Cross-Compilation Support
For development machines that support cross-compilation:
```bash
# Build for Linux x86_64 from macOS
swift build -c release --triple x86_64-unknown-linux-gnu

# Build for Linux ARM64 from macOS
swift build -c release --triple aarch64-unknown-linux-gnu
```

### Build Metadata (index.build)
```json
{
  "source": "src/getting-started/index.swift",
  "compiled": "2024-01-15T10:30:00Z",
  "hash": "sha256:abcd1234...",
  "platform": "macos",
  "architecture": "arm64",
  "dependencies": ["SwiftletCore", "MySharedLib"],
  "swift_version": "6.0",
  "triple": "arm64-apple-macosx14.0"
}
```

## Process Management

### Process Pooling
- Keep warm processes for frequently used swiftlets
- Configurable pool size per swiftlet
- Automatic scaling based on load

### Lifecycle
```
1. Pre-spawn: Start process before request
2. Request: Send data to warm process
3. Response: Receive output
4. Recycle: Reuse for next request or terminate
```

## Advantages

1. **Isolation**: Swiftlets can't crash the server
2. **Hot Reload**: Change code without restarting server
3. **Language Flexibility**: Mix Swift, Python, Go, etc.
4. **Granular Deployment**: Update individual routes
5. **Resource Control**: Per-swiftlet memory/CPU limits
6. **Natural Code Organization**: File system mirrors URL structure

## Challenges & Solutions

### Challenge: Compilation Time
**Solution**: 
- Background compilation
- Process pooling
- Incremental builds
- Shared library caching

### Challenge: Inter-Swiftlet Communication
**Solution**:
- Shared state via Redis/database
- Message queue for async communication
- Server-managed session state

### Challenge: Performance Overhead
**Solution**:
- Process pooling
- Compiled executables (not interpreted)
- Memory-mapped communication
- HTTP/2 multiplexing

## Future Extensions

### Multi-Language Support
```yaml
routes:
  - path: /python-demo
    swiftlet: python/demo.py
    runtime: python3
    
  - path: /go-api
    swiftlet: go/api
    runtime: go
```

### Dynamic Library Loading
Instead of separate processes, load swiftlets as dynamic libraries:
```swift
// Load .dylib/.so instead of spawning process
let swiftlet = dlopen("bin/getting-started/index.dylib")
```

### WebAssembly Integration
Compile swiftlets to WASM for sandboxed execution:
```
src/feature/index.swift → bin/feature/index.wasm → WasmRuntime
```

## Configuration Examples

### build.yaml
```yaml
compiler:
  swift:
    version: "6.0"
    flags: ["-c", "release", "-Xswiftc", "-O"]
    
  python:
    version: "3.11"
    
build:
  parallel: 4
  timeout: 30s
  cache_dir: .build-cache
  
  # Platform-specific build settings
  platforms:
    macos:
      x86_64:
        triple: "x86_64-apple-macosx13.0"
        sdk: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
      arm64:
        triple: "arm64-apple-macosx13.0"
        sdk: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
    linux:
      x86_64:
        triple: "x86_64-unknown-linux-gnu"
      arm64:
        triple: "aarch64-unknown-linux-gnu"
  
pools:
  default:
    size: 2
    ttl: 300s
    
  high_traffic:
    paths: ["/api/*", "/"]
    size: 10
    ttl: 600s

# Deployment configuration
deployment:
  # Production deployment strips unnecessary architectures
  strip_platforms: true
  target_platform: "linux"
  target_arch: "x86_64"
```

### SDK Integration
For third-party pre-built executables:
```yaml
# sdk-manifest.yaml
sdk_modules:
  - name: analytics-tracker
    version: "2.1.0"
    platforms:
      macos/x86_64:
        url: "https://example.com/sdk/macos-x64/analytics-tracker"
        checksum: "sha256:..."
      macos/arm64:
        url: "https://example.com/sdk/macos-arm64/analytics-tracker"
        checksum: "sha256:..."
      linux/x86_64:
        url: "https://example.com/sdk/linux-x64/analytics-tracker"
        checksum: "sha256:..."
      linux/arm64:
        url: "https://example.com/sdk/linux-arm64/analytics-tracker"
        checksum: "sha256:..."
```

## Security Considerations

1. **Sandboxing**: Run swiftlets with limited permissions
2. **Resource Limits**: CPU, memory, file access restrictions
3. **Input Validation**: Server validates before passing to swiftlets
4. **Process Isolation**: Separate user contexts
5. **Build Security**: Verify source integrity before compilation