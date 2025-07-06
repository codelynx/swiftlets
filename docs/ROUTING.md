# Swiftlets Webbin Routing System

## Overview

The webbin routing system provides a unified approach to serving both static files and dynamic content from a single directory structure. The URL structure directly maps to the filesystem, making it intuitive and easy to understand.

## How Routing Works

### 1. Request Flow

When a request comes to the server:

```
HTTP Request → SwiftletsServer → Route Resolution → Response
                                       ↓
                            Check web/ directory
                                   ↓        ↓
                          Static File?   .webbin File?
                               ↓              ↓
                         Serve directly  Execute swiftlet
```

### 2. Route Resolution Algorithm

For a request to `/api/users.json`, the server:

1. **First checks for static file**: `web/api/users.json`
   - If exists → serve it with appropriate MIME type
   
2. **Then checks for webbin file**: `web/api/users.json.webbin`
   - If exists → read executable path → execute swiftlet → return output

3. **If neither exists** → return 404

### 3. Directory Structure

```
web/                      # Root directory matching URL structure
├── index.webbin         # "/" route → executes bin/index
├── hello.webbin         # "/hello" route → executes bin/hello
├── style.css            # "/style.css" → served as static CSS
├── api/
│   ├── config.json      # "/api/config.json" → served as static JSON
│   └── users.json.webbin # "/api/users.json" → executes bin/api-users
└── Makefile             # Build configuration
```

## Webbin Files

### What is a .webbin file?

A `.webbin` file is a simple text file that contains the MD5 hash of the executable:

```bash
# Content of web/index.webbin:
eee7e849eddf2a5ede187ed729abb491

# Content of web/api/users.json.webbin:
e0c1dc3396a4da7d0ee7a5fcf9afcf2b
```

The executable path is derived from the webbin file location:
- `web/index.webbin` → `web/bin/index`
- `web/hello.webbin` → `web/bin/hello`
- `web/api/users.json.webbin` → `web/bin/api/users.json`

### Naming Convention

- **Basic route**: `hello.webbin` → responds to `/hello`
- **With extension**: `data.json.webbin` → responds to `/data.json`
- **Nested**: `api/users.json.webbin` → responds to `/api/users.json`

## Static vs Dynamic Content

### Static Files
- Any file without `.webbin` extension is served as static content
- MIME type is automatically detected based on file extension
- Examples: `.css`, `.js`, `.json`, `.html`, `.png`, etc.

### Dynamic Routes
- Marked by `.webbin` files
- Execute Swift programs that output JSON response
- Can generate HTML, JSON, or any content type

## Building Swiftlets

### Source Structure

```
project/
├── src/                # Swift source files (outside web root)
│   ├── index.swift     # Homepage swiftlet
│   ├── hello.swift     # Hello page swiftlet
│   └── users.json.swift # Users API swiftlet (named to match route)
└── web/
    └── bin/            # Compiled executables (inside web root)
        ├── index
        ├── hello
        └── api/
            └── users.json
```

Note: Source file names should match the final route name (e.g., `users.json.swift` for `/api/users.json`)

### Makefile Commands

```bash
# Build all swiftlets
cd web && make all

# Build specific swiftlet
make bin/index

# List all routes
make routes

# Clean build artifacts
make clean

# Start development server
make serve
```

## Request/Response Protocol

Swiftlets communicate with the server using JSON over stdin/stdout:

### Input (via stdin)
```json
{
  "method": "GET",
  "url": "/hello?name=World",
  "headers": {
    "User-Agent": "Mozilla/5.0",
    "Accept": "text/html"
  }
}
```

### Output (via stdout)
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "text/html"
  },
  "body": "<!DOCTYPE html><html>...</html>"
}
```

## Example Implementation

### Static Route
Place a file at `web/style.css`:
```css
body {
    font-family: system-ui, -apple-system, sans-serif;
    line-height: 1.6;
    color: #333;
}
```

Access via: `http://localhost:8080/style.css`

### Dynamic Route

1. Create source at `src/hello.swift`:
```swift
import Foundation

@main
struct HelloPage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, 
            from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head { Title("Hello") }
            Body { H1("Hello, World!") }
        }
        
        let response = Response(
            status: 200,
            headers: ["Content-Type": "text/html"],
            body: html.render()
        )
        
        print(try JSONEncoder().encode(response))
    }
}
```

2. Create webbin file at `web/hello.webbin` (empty file or placeholder)

3. Build and access:
```bash
make web/bin/hello
# This will:
# - Compile src/hello.swift to web/bin/hello
# - Generate MD5 hash and update web/hello.webbin
# Access via: http://localhost:8080/hello
```

## Advanced Features (Planned)

### Dynamic Route Parameters
Future support for parameterized routes:
```
web/posts/[slug].webbin → /posts/my-article
web/users/[id]/profile.webbin → /users/123/profile
```

### Middleware Chain
Planned support for request preprocessing:
```
web/_middleware/auth.webbin
web/_middleware/logging.webbin
```

## Benefits

1. **Intuitive Structure**: URL paths match directory structure
2. **No Configuration**: Routes are defined by file placement
3. **Mixed Content**: Static and dynamic content in same directory
4. **Fast Iteration**: Change files, rebuild, see results
5. **Type Safety**: Swift's type system for request/response handling
6. **Performance**: Compiled executables, no interpreter overhead