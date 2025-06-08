# Swiftlet Resources Proposal

## Overview

This proposal outlines a system for giving swiftlets access to file-like resources such as templates, data files, configuration, and other assets that are needed at runtime but should not be exposed as web routes. Additionally, it proposes a writable storage area for swiftlet-generated data.

The architecture is designed to enable future security hardening where the entire site could be deployed as read-only except for the `var/` directory (targeted for v2.0).

### Development Philosophy

This proposal follows an iterative development approach:
- **Phase 1**: Get basic functionality working with simple, clear APIs
- **Phase 2**: Add optimizations based on real-world usage
- **v2.0**: Performance improvements, caching, advanced security

"Ship something that works, then improve based on actual needs."

## Current Limitations

Currently, swiftlets are standalone executables that:
- Can only access data passed via stdin (Request)
- Have no standardized way to read templates, JSON data, or other resources
- Must hard-code any static data directly in the Swift source
- Cannot persist data between requests

## Use Cases

### Read-Only Resources (.res/)
1. **Configuration Files**: JSON, YAML, PLIST for settings
2. **API Credentials**: Safely stored keys and tokens (api-key.txt, credentials.json)
3. **Data Files**: CSV, TSV, or JSON data for content
4. **Localization**: Translation files (strings.json, messages.yaml)
5. **Metadata**: SEO data, author info, category definitions
6. **Theme Configuration**: Colors, fonts, spacing values (theme.json)
7. **Database Schemas**: SQL files, migration scripts

**Note**: Static binary files (images, PDFs, fonts) should be placed in the `web/` directory where they can be served directly by the web server. The `.res/` directories are for data files that swiftlets need to read and process.

### Storage (var/)
1. **User uploads**: Images, documents, files
2. **Cache data**: Computed results, API responses
3. **SQLite databases**: Local data storage
4. **Session files**: User session data
5. **Logs**: Application-specific logs
6. **Generated content**: PDFs, processed images

## Storage Concept

The `/var` directory name comes from Unix, meaning "variable" data (data that changes during operation, as opposed to static program files). 

For Swiftlets, we use **"Storage"** as the conceptual name for the `/var` directory:
- Simple and clear terminology
- Natural in API usage: `context.storage`
- Generic enough for all use cases (uploads, databases, cache)
- Commonly understood across frameworks

## Proposed Solution: Hierarchical Resources with .res/ Directories

### Core Concept

Each directory under `src/` can have a `.res/` subdirectory containing resources specific to that route and its children. The dot prefix prevents naming collisions with actual routes.

```
sites/my-site/
├── src/
│   ├── .res/                 # Global resources
│   │   ├── theme.json
│   │   ├── api-key.txt      # Safely stored API credentials
│   │   └── config.yaml
│   ├── index.swift
│   ├── blog/
│   │   ├── .res/            # Blog-specific resources
│   │   │   ├── theme.json   # Overrides global theme
│   │   │   ├── authors.csv  # Blog author data
│   │   │   └── settings.plist    
│   │   ├── index.swift
│   │   └── tutorial/
│   │       ├── .res/        # Tutorial-specific resources
│   │       │   └── metadata.json
│   │       └── index.swift
│   └── api/
│       └── users.swift
├── storage/                  # Writable storage
│   ├── blog/
│   │   ├── uploads/
│   │   └── cache.db
│   └── sessions/
├── web/
└── bin/
```

### Resource Resolution (Hierarchical Lookup)

Swiftlets access resources using a Bundle-like API with automatic fallback:

```swift
// In blog/tutorial/index.swift
let themeData = try self.resources.read(named: "theme.json")  // Returns Data
let theme = try JSONDecoder().decode(Theme.self, from: themeData)
// Lookup order:
// 1. src/blog/tutorial/.res/theme.json (not found)
// 2. src/blog/.res/theme.json (found! - uses blog theme)
// 3. src/.res/theme.json (would use global if not found in blog)

let metadataData = try self.resources.read(named: "metadata.json")  // Returns Data
let metadata = try JSONDecoder().decode(Metadata.self, from: metadataData)
// Found in src/blog/tutorial/.res/metadata.json

let apiKeyData = try self.resources.read(named: "api-key.txt")  // Returns Data
let apiKey = String(data: apiKeyData, encoding: .utf8)!
// Not in tutorial or blog, falls back to src/.res/api-key.txt
```

**Key Benefits**:
- Natural inheritance/override pattern
- Themes and configurations cascade down
- Easy to customize specific sections
- Clear organization by feature

### Storage (var/)

A separate `var/` directory provides write access for swiftlets:

```swift
// Working directory is already var/blog/
try self.storage.write(data, to: "uploads/avatar.jpg")
// Writes to: uploads/avatar.jpg (relative to current directory)

// Access SQLite database
let db = try self.storage.database("cache.db")
// Creates/opens: var/blog/cache.db

// Write temporary file
try self.storage.temp.write(processedData, to: "report.pdf")
// Saves to: var/temp/[session]/report.pdf
```

**Key Principles**:
- No fallback/inheritance in var/ (avoids ambiguity)
- Scoped by route path for isolation
- Automatic directory creation
- Proper permissions handling


## Implementation Details

### Resource Access API

The resource system would be implemented as an extension to the swiftlet base class:

```swift
// In Swiftlets framework
public protocol SwiftletContext {
    /// Access read-only resources with hierarchical lookup
    var resources: Resources { get }
    
    /// Access writable storage (no fallback)
    var storage: Storage { get }
    
    /// Current route path (e.g., "/blog/tutorial")
    var routePath: String { get }
}

public struct Resources {
    /// Read resource with hierarchical lookup, returns raw binary data
    public func read(named name: String) throws -> Data
}

// Convenience extensions for common conversions
extension Data {
    func string(encoding: String.Encoding = .utf8) throws -> String {
        guard let string = String(data: self, encoding: encoding) else {
            throw ResourceError.invalidEncoding
        }
        return string
    }
    
    func json<T: Decodable>(as type: T.Type) throws -> T {
        return try JSONDecoder().decode(type, from: self)
    }
    
    // Could add yaml, plist, etc.
}

public struct Storage {
    // Working directory is already set to var/blog/ by server
    
    public func write(_ data: Data, to path: String) throws
    public func read(from path: String) throws -> Data
    public func delete(_ path: String) throws
    public func exists(_ path: String) -> Bool
    public func database(_ name: String) throws -> Database
    
    // Directory operations using relative paths
    // Note: FileManager works identically on Linux/macOS
    public func contentsOfDirectory(at path: String = ".") throws -> [String]
    public func createDirectory(at path: String) throws
    public func removeDirectory(at path: String) throws
    public func fileAttributes(at path: String) throws -> FileAttributes
}
```

### How Resources Are Passed to Swiftlets

Extend the Request structure to include context information:

```swift
struct Request: Codable {
    // Existing fields...
    
    // New context fields
    let context: SwiftletContextData?
}

struct SwiftletContextData: Codable {
    let routePath: String           // e.g., "/blog/tutorial"
    let resourcePaths: [String]     // Ordered paths for resource lookup
    let storagePath: String         // e.g., "var/blog/tutorial/"
}
```

### Server-Side Implementation

The server would:

1. **Determine resource paths** based on request URL
2. **Set up environment** before calling swiftlet
3. **Provide resource access** via file system or API
4. **Consider working directory** strategy

```swift
// Option A: Working directory remains at site root
// Server builds absolute paths for swiftlet
let context = SwiftletContextData(
    routePath: "/blog/tutorial",
    resourcePaths: [
        "/absolute/path/to/site/src/blog/tutorial/.res/",
        "/absolute/path/to/site/src/blog/.res/",
        "/absolute/path/to/site/src/.res/"
    ],
    storagePath: "/absolute/path/to/site/var/blog/tutorial/"
)

// Option B: Change working directory per route
// (Not recommended due to complexity)
process.chdir("/absolute/path/to/site/var/blog/tutorial/")
let context = SwiftletContextData(
    routePath: "/blog/tutorial",
    resourcePaths: [
        "../../src/blog/tutorial/.res/",
        "../../src/blog/.res/",
        "../../src/.res/"
    ],
    storagePath: "."  // Current directory
)
```

**Implementation**: Server changes working directory to the swiftlet's var directory before execution:

```swift
// For route /blog/tutorial
let varPath = "/absolute/path/to/site/var/blog/tutorial"
FileManager.default.createDirectory(atPath: varPath, withIntermediateDirectories: true)

// Change working directory (cross-platform)
let success = FileManager.default.changeCurrentDirectoryPath(varPath)
if !success {
    throw ServerError.cannotChangeDirectory(varPath)
}

// Now swiftlet can use simple relative paths
try storage.write(data, to: "uploads/image.jpg")    // Writes to var/blog/tutorial/uploads/image.jpg
try storage.read(from: "cache/data.json")           // Reads from var/blog/tutorial/cache/data.json
let files = try storage.contentsOfDirectory(at: ".") // Lists var/blog/tutorial/
```

## API Design Philosophy

### Resources (.res/) - Known Names Only
Resources are accessed by **known names** without directory listing capabilities:
- Developers must know resource names at compile time
- No `contentsOfDirectory()` API for resources
- Encourages explicit, documented resource usage
- Prevents resource discovery/enumeration attacks
- Fallback mechanism works because you're looking for specific named files

```swift
// Good - explicit resource access
let config = try context.resources.read(named: "api-config.json")

// NOT supported - no directory listing
let allResources = try context.resources.list() // ❌
```

### Storage (var/) - Full Filesystem Access
Storage provides **full directory operations** for dynamic content:
- List directory contents
- Create/delete directories
- Check file attributes
- Discover uploaded files
- Clean up old cache files

```swift
// Working directory is var/blog/ - use simple relative paths
let uploads = try context.storage.contentsOfDirectory(at: "uploads/2024/")
for file in uploads {
    let data = try context.storage.read(from: "uploads/2024/\(file)")
    // Process each upload...
}

// Directory management with relative paths
try context.storage.createDirectory(at: "exports/reports/2024")
let currentFiles = try context.storage.contentsOfDirectory(at: ".")  // List current directory
```

This distinction reinforces that:
- **Resources** = Static, known assets (like Bundle resources)
- **Storage** = Dynamic, discoverable filesystem

## Security Considerations

### Future Security Enhancement (v2.0)

The var/ directory design enables a future security hardening feature where the entire site could be deployed as read-only except for var/:

```bash
# Future production deployment (v2.0)
sites/my-site/
├── src/        # Read-only (0755/0644)
├── web/        # Read-only (0755/0644)
├── bin/        # Read-only, executable (0755)
└── var/        # Read-write (0755/0644) - ONLY writable directory

# Future: File system permissions
chmod -R a-w /absolute/path/to/site     # Remove write for all
chmod -R u+w /absolute/path/to/site/var  # Add write only for var/
```

**Future Benefits (v2.0):**
- **Prevent code injection** - Attackers cannot modify source files
- **Protect executables** - bin/ directory remains immutable
- **Isolate writable data** - All writes confined to var/
- **Simple security model** - One rule: "Only var/ is writable"
- **Easy backup strategy** - var/ contains all mutable state

**Note**: This is a future enhancement. Initial implementations will have normal read-write permissions throughout the site structure.

### For .res/ directories:
- Read-only access from swiftlets
- Path validation to prevent traversal attacks
- Resources never served directly via HTTP
- Protected by filesystem read-only permissions in production

### For var/ directories:
- Only directory tree with write permissions
- Scoped write access based on route
- Quota limits to prevent disk filling
- Regular cleanup of temporary files
- No execution permissions on uploaded files
- Consider separate filesystem/partition for var/

## Example Usage

### Basic Resource Access

```swift
// In blog/post.swift
@main
struct BlogPost {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        let context = SwiftletContext(from: request.context!)
        
        // Access resources with automatic fallback (returns Data)
        let themeData = try context.resources.read(named: "theme.json")
        let theme = try themeData.json(as: Theme.self)
        
        let authorsData = try context.resources.read(named: "authors.csv")
        let authors = try authorsData.string()
        
        // Write user upload
        if let uploadData = request.body?.data(using: .utf8) {
            try context.storage.write(uploadData, to: "uploads/\(UUID()).jpg")
        }
        
        // Access database
        let db = try context.storage.database("posts.db")
        let posts = try db.query("SELECT * FROM posts ORDER BY date DESC")
        
        // Render response...
    }
}
```

### Theme Override Example

```
src/
├── .res/
│   └── theme.json         # {"primary": "blue", "font": "Arial"}
└── blog/
    ├── .res/
    │   └── theme.json     # {"primary": "green"}  // Inherits font from parent
    └── post.swift
```

### Practical Examples

```swift
// Localization with fallback
let stringsData = try context.resources.read(named: "strings/\(locale).json")
let strings = try stringsData.json(as: [String: String].self)
let welcomeText = strings["welcome"] ?? "Welcome"

// Load API configuration
let apiKeyData = try context.resources.read(named: "api-key.txt")
let apiKey = try apiKeyData.string().trimmingCharacters(in: .whitespacesAndNewlines)

let endpointsData = try context.resources.read(named: "endpoints.json")
let endpoints = try endpointsData.json(as: [String: String].self)
let apiEndpoint = endpoints["users"]!

// Cache API response
let cachedData = try? context.storage.read(from: "cache/api-response.json")
if cachedData == nil {
    let freshData = try fetchFromAPI()
    try context.storage.write(freshData, to: "cache/api-response.json")
}
```

## Resource Access Implementation

### Decision: File Paths for Simplicity

We use file paths (strings) throughout the API for consistency and simplicity:

**For Resources (.res/)**:
```swift
// Simple name-based lookup, returns Data
let configData = try context.resources.read(named: "config.json")
// Server handles path resolution and fallback internally
```

**For Storage (var/)**:
```swift
// Working directory is already set to var/blog/
try context.storage.write(data, to: "uploads/avatar.jpg")  // Simple relative path
let data = try context.storage.read(from: "cache/data.json")
```

**Benefits of this approach**:
- Consistent API across resources and storage
- Simple and intuitive for developers
- No URL construction overhead
- Direct mapping to filesystem operations
- Working directory makes storage paths trivial

**Platform considerations**:
- Always use forward slashes (`/`) for cross-platform compatibility
- Server handles any platform-specific path conversions internally
- Developers work with simple, familiar path strings


## Questions for Discussion

1. **Resource Access Method**: Should swiftlets get direct file paths or only data through an API?
   - Direct paths are simpler but less secure
   - API approach provides better abstraction and security

2. **Resource Formats**: Which formats should have built-in support?
   - JSON, YAML, TOML, Plist
   - Markdown with front matter
   - HTML templates (which engine?)

3. **Caching Strategy**: How should resources be cached?
   - In-memory cache per request
   - Persistent cache with file watching
   - No caching (always read fresh)

4. **var/ Directory Structure**: Should it mirror src/ structure automatically?
   - Auto-create directories as needed
   - Require explicit directory creation
   - Hybrid approach

5. **Resource Naming**: Should we enforce naming conventions?
   - Allow any names (current proposal)
   - Require prefixes (e.g., `tpl.header.html`, `data.config.json`)
   - Support namespacing (e.g., `templates/header.html`)

6. **Error Handling**: What happens when resources are missing?
   - Throw error (current proposal)
   - Return nil/optional
   - Provide default values

## Naming Considerations for Writable Directory

Several names could work for the writable storage directory:

### Option 1: `var/` (Unix convention)
- **Meaning**: "variable" - data that changes during operation (vs static program files)
- **Pros**: Familiar to Unix/Linux users, standard for variable/changing data
- **Cons**: Might be unclear to developers from other backgrounds
- **Examples**: `/var/log` (logs), `/var/cache` (temporary files), `/var/lib` (persistent state), `/var/www` (web files)

### Option 2: `storage/`
- **Pros**: Clear purpose, self-documenting
- **Cons**: Generic, doesn't indicate it's writable vs read-only
- **Usage**: `storage/blog/uploads/`, `storage/cache/`

### Option 3: `data/`
- **Pros**: Simple, commonly used in web frameworks
- **Cons**: Could be confused with read-only data resources
- **Usage**: `data/uploads/`, `data/sessions/`

### Option 4: `content/`
- **Pros**: Suggests user-generated content
- **Cons**: Might imply only media/documents, not databases
- **Usage**: `content/blog/posts/`, `content/media/`

### Option 5: `.data/` (dot-prefixed)
- **Pros**: Hidden by default, consistent with `.res/`
- **Cons**: Harder to access/debug, tools might ignore it
- **Usage**: `.data/cache/`, `.data/uploads/`

### Recommendation: `storage/`
Most descriptive and framework-agnostic. Makes it clear this is for persistent storage.

```
sites/my-site/
├── src/          # Source code
├── storage/      # Writable persistent storage
├── web/          # Public web root
└── bin/          # Compiled executables
```

## Cross-Platform Considerations

### Linux/Ubuntu Compatibility

The resource and storage system is designed to work identically on macOS and Linux:

1. **Path Separators**: Always use forward slashes (`/`) which work on both platforms
2. **File Permissions**: 
   - macOS: Standard Unix permissions
   - Linux: Same permissions, may need to consider SELinux contexts
3. **Working Directory Changes**:
   ```swift
   // Cross-platform working directory change using FileManager
   import Foundation
   
   // FileManager.default.changeCurrentDirectoryPath works on both platforms
   let success = FileManager.default.changeCurrentDirectoryPath(varPath)
   if !success {
       throw StorageError.cannotChangeDirectory(varPath)
   }
   ```
4. **Case Sensitivity**:
   - macOS: Usually case-insensitive (APFS/HFS+)
   - Linux: Always case-sensitive
   - **Best Practice**: Always use exact case in resource names

5. **Hidden Files**: `.res/` directories work the same (dot-prefixed = hidden)

### Testing on Ubuntu

```bash
# Ensure Swift is installed
swift --version

# Test file operations
cd /absolute/path/to/site/var/blog
echo "test" > test.txt
ls -la  # Should show hidden .res/ directories

# Check permissions
stat -c "%a %n" *  # Linux
# vs
stat -f "%p %N" *  # macOS
```

## Implementation Phases

### Phase 1: Basic Implementation
- Implement .res/ directory structure
- Add resource lookup with fallback
- Basic file reading (text, data)
- Simple var/ directory write access

### Phase 2: Enhanced Features
- JSON/YAML parsing helpers
- Basic template support
- SQLite database wrapper
- File upload handling

### Phase 3: Advanced Features
- Resource caching system
- File watching for development
- Template engine integration
- Resource bundling for production

## Next Steps

1. Finalize the API design
2. Implement Phase 1 in Swiftlets framework
3. Update server to pass context information
4. Create example site using resources
5. Document patterns and best practices

## Summary of Key Decisions

### API Design
- **Consistent API**: Both resources and storage use `.read()` method
  - `context.resources.read(named: "config.json")` → Data
  - `context.storage.read(from: "cache/data.json")` → Data
- **Simple paths**: No URLs, just file paths as strings
- **Working directory**: Set to `var/{route}` for simple relative paths in storage

### Architecture
- **Resources**: `.res/` directories with hierarchical fallback lookup
- **Storage**: `var/` directory with route-based isolation
- **Binary files**: Served from `web/` directory, not through resources
- **Security**: Read-only deployment is a future goal (v2.0)

### Implementation Strategy
- **Phase 1**: Basic functionality with clear APIs
- **Phase 2**: Real-world improvements based on usage
- **v2.0**: Advanced features (caching, security hardening)

"Make it work, make it right, make it fast" - in that order.