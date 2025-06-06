# Webbin Routing System Design (v2)

## Overview

A routing system where `.webbin` files act like symbolic links to executables, with a build-all command for staging/production deployment. No on-the-fly compilation in production.

## Core Philosophy

**Development/Staging**: Build all routes at once, test thoroughly, catch errors early
**Production**: Serve only pre-built executables, fast and predictable

## Key Concepts

### 1. Webbin as Symbolic Links

`.webbin` files simply point to executables:

```
web/
├── index.webbin         → ../bin/index
├── about.webbin         → ../bin/about
├── api/
│   └── users.webbin     → ../../bin/api-users
└── blog/
    ├── index.webbin     → ../../bin/blog-list
    └── [slug].webbin    → ../../bin/blog-post
```

Content of `.webbin` file:
```
bin/index
```
Or with metadata:
```
exec: bin/index
cache: 3600
middleware: auth,cors
```

### 2. Build Process

```bash
# Build all routes at once
swiftlets build

# What it does:
# 1. Scans web/ for all .webbin files
# 2. Reads source mapping from swiftlets.yaml
# 3. Compiles all executables
# 4. Reports any compilation errors
# 5. Validates all .webbin references
```

### 3. Project Structure

```
project/
├── web/                     # All web content (static + dynamic routes)
│   ├── index.webbin        # Dynamic: "bin/index"
│   ├── about.webbin        # Dynamic: "bin/about"
│   ├── style.css           # Static file
│   ├── script.js           # Static file
│   ├── logo.png            # Static file
│   ├── api/
│   │   ├── users.webbin    # Dynamic: "bin/api/users"
│   │   └── data.json       # Static API response
│   ├── reports/
│   │   ├── daily.pdf       # Static PDF
│   │   └── monthly.pdf.webbin  # Dynamic PDF generator: "bin/report-monthly"
│   └── docs/
│       ├── guide.html      # Static documentation
│       └── api.html.webbin # Dynamic API docs: "bin/api-docs"
├── src/                     # Source files
│   ├── pages/
│   │   ├── index.swift
│   │   └── about.swift
│   ├── api/
│   │   └── users.swift
│   └── generators/
│       ├── report-monthly.swift
│       └── api-docs.swift
├── bin/                     # Compiled executables
│   ├── index
│   ├── about
│   ├── api/
│   │   └── users
│   ├── report-monthly
│   └── api-docs
└── swiftlets.yaml          # Build configuration
```

### 4. Configuration File

```yaml
# swiftlets.yaml
sources:
  # Map of webbin name to source file
  index: src/pages/index.swift
  about: src/pages/about.swift
  api/users: src/api/users.swift
  blog-list: src/blog/list.swift
  blog-post: src/blog/post.swift

build:
  output: bin/
  mode: release  # or debug
  swift-flags: ["-Osize"]
  
web:
  root: web/
  timeout: 30
```

### 5. Build Command Implementation

```swift
// swiftlets build command
func buildAll() {
    let config = loadConfig("swiftlets.yaml")
    var errors: [String] = []
    
    // 1. Scan for all .webbin files
    let webbinFiles = findFiles("web/", extension: ".webbin")
    
    // 2. Build each executable
    for webbin in webbinFiles {
        let route = parseWebbinFile(webbin)
        
        guard let sourcePath = config.sources[route.exec] else {
            errors.append("No source defined for \(route.exec)")
            continue
        }
        
        let outputPath = "bin/\(route.exec)"
        
        print("Building \(route.exec)...")
        
        let result = compileSwiftlet(
            source: sourcePath,
            output: outputPath,
            mode: config.build.mode
        )
        
        if result.exitCode != 0 {
            errors.append("Failed to build \(route.exec):\n\(result.stderr)")
        }
    }
    
    // 3. Validate all .webbin references
    for webbin in webbinFiles {
        let execPath = readWebbinFile(webbin).trim()
        if !fileExists(execPath) {
            errors.append("\(webbin) references missing executable: \(execPath)")
        }
    }
    
    // 4. Report results
    if errors.isEmpty {
        print("✅ Build successful! \(webbinFiles.count) routes ready.")
    } else {
        print("❌ Build failed with \(errors.count) errors:")
        for error in errors {
            print(error)
        }
        exit(1)
    }
}
```

### 6. Server Runtime Behavior

```swift
func handleRequest(path: String) {
    // 1. Check for static file in web/ directory first
    let staticPath = "web/\(path)"
    if fileExists(staticPath) && !isDirectory(staticPath) {
        return serveStaticFile(staticPath)
    }
    
    // 2. Look for .webbin file for dynamic route
    let webbinPath = "web/\(path).webbin"
    if fileExists(webbinPath) {
        // 3. Read executable path from .webbin
        let execPath = readWebbinFile(webbinPath).trim()
        
        // 4. In production, executable MUST exist
        guard fileExists(execPath) else {
            log.error("Missing executable: \(execPath) for route: \(path)")
            return send500("Internal Server Error")
        }
        
        // 5. Execute dynamic route
        return executeSwiftlet(execPath, path: path)
    }
    
    // 3. Check for pattern-based routes (e.g., [slug])
    let patternWebbinPath = findPatternWebbinForPath(path)
    guard let foundPattern = patternWebbinPath else {
        return send404()
    }
    
    let execPath = readWebbinFile(foundPattern).trim()
    guard fileExists(execPath) else {
        log.error("Missing executable: \(execPath) for pattern route: \(path)")
        return send500("Internal Server Error")
    }
    
    return executeSwiftlet(execPath, path: path, pattern: foundPattern)
}
```

### 7. Static vs Dynamic Content Examples

This unified approach allows seamless mixing of static and dynamic content:

#### Example 1: PDF Reports
```
Request: GET /reports/monthly.pdf

Server checks:
1. web/reports/monthly.pdf (static file) → Not found
2. web/reports/monthly.pdf.webbin → Found! Contains "bin/report-generator"
3. Executes bin/report-generator to generate PDF dynamically

Request: GET /reports/daily.pdf  

Server checks:
1. web/reports/daily.pdf (static file) → Found! Serve directly
2. (No need to check .webbin)
```

#### Example 2: API Responses
```
Request: GET /api/config.json

Server checks:
1. web/api/config.json → Found static JSON file, serve directly

Request: GET /api/users.json

Server checks:  
1. web/api/users.json → Not found
2. web/api/users.json.webbin → Found! Contains "bin/api-users"
3. Executes bin/api-users to generate JSON dynamically
```

#### Example 3: Mixed Documentation
```
web/docs/
├── intro.html              # Static HTML documentation
├── api.html.webbin          # Dynamic API docs (generated from code)
├── changelog.md             # Static markdown file
└── coverage.html.webbin     # Dynamic test coverage report
```

### 8. Development Workflow

```bash
# 1. Create new route
echo "bin/contact" > web/contact.webbin

# 2. Create source file
cat > src/pages/contact.swift << 'EOF'
import SwiftletsCore
import SwiftletsHTML

@main
struct ContactPage {
    static func main() async throws {
        let request = try await readRequest()
        
        let html = Html {
            Body {
                H1("Contact Us")
                Form(action: "/contact", method: .post) {
                    // ...
                }
            }
        }
        
        try await writeResponse(Response(html: html.render()))
    }
}
EOF

# 3. Update config
echo "  contact: src/pages/contact.swift" >> swiftlets.yaml

# 4. Build all
swiftlets build

# 5. Test locally
swiftlets serve

# 6. Deploy (only bin/ and web/ needed)
rsync -av bin/ web/ production-server:/var/www/myapp/
```

### 9. Advantages

1. **Unified Content**: All web content (static + dynamic) in one place
2. **Intelligent Routing**: Static files served directly, dynamic when needed
3. **Flexible**: Same URL can be static or dynamic depending on what exists
4. **Predictable**: No surprises in production, everything pre-built
5. **Fast**: No compilation overhead, static files served instantly
6. **Testable**: Build errors caught in staging, not production
7. **Simple**: Webbin files are just pointers, easy to understand
8. **Deployable**: Only need to deploy bin/ and web/ directories

### 10. Advanced Features

#### Dynamic Route Parameters
```
web/blog/[slug].webbin → "bin/blog-post"
# Server passes slug as environment variable or argument
```

#### Route Aliases
```
web/home.webbin → "bin/index"  # Same executable as index.webbin
```

#### Middleware Chain (future)
```
# .webbin file with YAML format
exec: bin/api/users
middleware:
  - auth
  - rate-limit
  - cors
```

### 11. Migration from Current System

1. Move executables to consistent `bin/` structure
2. Create `web/` directory with `.webbin` files
3. Set up `swiftlets.yaml` with source mappings
4. Run `swiftlets build` to compile everything
5. Update server to use new routing logic

## Benefits for Webmasters

1. **Clear route visualization**: Just look at web/ directory
2. **Build once, deploy anywhere**: No compilation on production
3. **Staging confidence**: If it builds on staging, it runs in production
4. **Easy rollback**: Just redeploy previous bin/ directory
5. **Simple debugging**: Routes are just files pointing to executables

## Implementation Priority

1. Create `swiftlets build` command
2. Update server to read .webbin files
3. Add static file serving from public/
4. Implement dynamic route patterns
5. Add development server with auto-rebuild

## Key Innovation: Unified Static/Dynamic Routing

The core innovation is that **every URL can be either static or dynamic** based on what exists:

- `/hello/world.pdf` checks `web/hello/world.pdf` first (static)
- If not found, checks `web/hello/world.pdf.webbin` (dynamic generator)
- No separate public/ directory needed
- Same URL structure for both static files and dynamic routes
- Webmasters can easily switch between static and dynamic without changing URLs

This approach is much more aligned with traditional web deployment workflows while maintaining the power of compiled executables and the flexibility to mix static and dynamic content seamlessly.