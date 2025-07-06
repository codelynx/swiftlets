# Swiftlets Routing Internals

This document explains how Swiftlets routes HTTP requests to executables and returns HTML content.

## Overview

Swiftlets uses a unique file-based routing system where each route maps to an independent executable. When a request arrives, the server finds the corresponding executable, passes the request data via JSON, and returns the response to the client.

## Request Flow

Let's trace through what happens when a user visits `http://localhost:8080/sample/path/to/`:

### 1. Server Receives Request

The `swiftlets-server` process listens on the configured port (default 8080) and receives the incoming HTTP request. The server is implemented in `Sources/SwiftletsServer/main.swift`.

### 2. Route Resolution

The server resolves the URL path to a `.webbin` file:

- **URL Path**: `/sample/path/to/`
- **Looks for**: `web/sample/path/to/index.webbin`
- **Fallback**: If the path ends with `/`, it automatically looks for `index.webbin`

The `.webbin` file is a marker file containing the MD5 hash of the corresponding executable.

### 3. Executable Lookup

If the `.webbin` file exists:

1. Reads the MD5 hash from the `.webbin` file
2. Constructs the executable path: `bin/sample/path/to/index`
3. Verifies the executable exists and its MD5 matches the `.webbin` hash
4. This verification prevents executing tampered binaries

### 4. Request Serialization

The server creates a `Request` object containing:

```swift
struct Request: Codable {
    let method: String      // GET, POST, etc.
    let path: String        // /sample/path/to/
    let headers: [String: String]
    let queryItems: [String: String]
    let body: String?
}
```

This request is serialized to JSON and will be passed to the executable.

### 5. Execute Swiftlet

The server executes the binary as a subprocess:

1. Launches the executable at `bin/sample/path/to/index`
2. Passes the JSON-encoded request via stdin
3. Captures stdout for the response
4. Sets a timeout to prevent hanging processes

### 6. Swiftlet Processing

Inside the executable (compiled from `src/sample/path/to/index.swift`):

```swift
import Swiftlets

@main
struct MyPage: SwiftletMain {
    // Property wrappers for request data
    @Query("name") var userName: String?
    @Cookie("theme") var theme: String?
    
    // Page metadata
    var title = "Sample Page"
    var meta = ["viewport": "width=device-width, initial-scale=1.0"]
    
    // Page content
    var body: some HTML {
        VStack {
            H1("Welcome, \(userName ?? "Guest")")
            P("You're viewing: /sample/path/to/")
            
            if theme == "dark" {
                P("Dark mode is enabled")
                    .style("color", "#ccc")
            }
        }
    }
}
```

The `SwiftletMain` protocol provides a default `main()` implementation that:

1. Reads the JSON request from stdin
2. Decodes it into a `Request` object
3. Creates a `SwiftletContext` with the request data
4. Instantiates the swiftlet struct
5. Evaluates the `body` property to generate HTML
6. Wraps the content in a complete HTML document:
   ```html
   <!DOCTYPE html>
   <html>
   <head>
       <meta charset="UTF-8">
       <title>Sample Page</title>
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
   </head>
   <body>
       <!-- Generated content here -->
   </body>
   </html>
   ```
7. Creates a `Response` object with the HTML
8. Serializes the response to JSON and prints to stdout

### 7. Response Handling

The server:

1. Captures the JSON output from the executable
2. Decodes the `Response` object:
   ```swift
   struct Response: Codable {
       let status: Int
       let headers: [String: String]
       let body: String
   }
   ```
3. Sends the HTTP response to the client

## File Structure

For a route like `/sample/path/to/`, the file structure would be:

```
site-root/
├── src/
│   └── sample/
│       └── path/
│           └── to/
│               └── index.swift    # Source code
├── bin/
│   └── sample/
│       └── path/
│           └── to/
│               └── index         # Compiled executable
└── web/
    └── sample/
        └── path/
            └── to/
                └── index.webbin  # MD5 hash marker
```

## Routing Rules

### URL to File Mapping

| URL | Source File | Executable | Webbin |
|-----|------------|------------|---------|
| `/` | `src/index.swift` | `bin/index` | `web/index.webbin` |
| `/about` | `src/about.swift` | `bin/about` | `web/about.webbin` |
| `/blog/` | `src/blog/index.swift` | `bin/blog/index` | `web/blog/index.webbin` |
| `/api/users` | `src/api/users.swift` | `bin/api/users` | `web/api/users.webbin` |

### Special Cases

1. **Directory URLs**: URLs ending with `/` automatically look for `index`
2. **File Extensions**: The `.swift` extension is removed when building
3. **Static Files**: Files without `.webbin` markers are served as static assets

## Security Features

### MD5 Verification

Each `.webbin` file contains the MD5 hash of its corresponding executable:

1. Prevents execution of modified binaries
2. Ensures the executable matches what was built
3. Provides integrity checking without code signing

### Process Isolation

Each request runs in a separate process:

1. No shared memory between requests
2. Crashes in one swiftlet don't affect others
3. Resource limits can be applied per process
4. Clean environment for each request

## Communication Protocol

### Request Format (stdin)

```json
{
  "method": "GET",
  "url": "/sample/path/to/?name=John&page=2",
  "headers": {
    "Host": "localhost:8080",
    "User-Agent": "Mozilla/5.0...",
    "Accept": "text/html"
  },
  "body": null
}
```

### Response Format (stdout)

```json
{
  "status": 200,
  "headers": {
    "Content-Type": "text/html; charset=utf-8",
    "X-Custom-Header": "value"
  },
  "body": "<!DOCTYPE html><html>...</html>"
}
```

## Build Process

When you run `./build-site`:

1. Scans `src/` directory for `.swift` files
2. For each file:
   - Compiles with Swift compiler
   - Links with Swiftlets framework
   - Outputs executable to `bin/`
   - Calculates MD5 hash
   - Creates `.webbin` file with hash

## Advanced Features

### Property Wrappers

Swiftlets provides property wrappers for easy access to request data:

- `@Query`: Access URL query parameters
- `@FormValue`: Access form POST data
- `@Cookie`: Read cookie values
- `@Header`: Access HTTP headers
- `@JSONBody`: Decode JSON request bodies
- `@Environment`: Access request context

### Response Builders

For non-HTML responses or custom headers:

```swift
var body: ResponseBuilder {
    ResponseWith {
        Pre(jsonData)
    }
    .contentType("application/json")
    .header("X-API-Version", "1.0")
    .cookie("session", value: sessionId)
}
```

## Benefits of This Architecture

1. **Hot Reloading**: Rebuild individual routes without restarting the server
2. **Language Agnostic**: Future support for Python, Ruby, etc. swiftlets
3. **Deployment Simplicity**: Just copy executables, no runtime dependencies
4. **Security**: Process isolation and hash verification
5. **Scalability**: Each request is independent, easy to parallelize
6. **Debugging**: Each swiftlet can be tested standalone

## Troubleshooting

### Common Issues

1. **404 Not Found**: Check if `.webbin` file exists
2. **Executable Not Found**: Ensure the binary was built
3. **MD5 Mismatch**: Rebuild the site to regenerate hashes
4. **Timeout**: Complex expressions may cause slow builds

### Debug Mode

Run the server with `--debug` to see detailed routing information:

```bash
./run-site sites/mysite --debug
```

This will show:
- Which `.webbin` files are found
- Executable paths being checked
- MD5 verification results
- Process execution details

## See Also

- [ROUTING.md](ROUTING.md) - User-facing routing documentation
- [swiftlet-architecture.md](swiftlet-architecture.md) - Overall architecture
- [SWIFTUI-API-IMPLEMENTATION.md](SWIFTUI-API-IMPLEMENTATION.md) - SwiftUI-style API details