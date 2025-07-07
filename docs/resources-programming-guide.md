# Swiftlet Resources & Storage Programming Guide

This guide explains how to use resources and storage in your swiftlets for reading configuration files, storing user data, and managing application state.

## Table of Contents
- [Overview](#overview)
- [Resources (.res/)](#resources-res)
- [Storage (var/)](#storage-var)
- [Common Patterns](#common-patterns)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Overview

Swiftlets have two distinct systems for working with files:

1. **Resources** - Read-only files in `.res/` directories (config, templates, data)
2. **Storage** - Read-write files in `var/` directories (uploads, cache, databases)

## Resources (.res/)

Resources are read-only files that your swiftlet needs at runtime. They live in `.res/` directories and support hierarchical lookup (like CSS inheritance).

### Basic Usage

```swift
// In your swiftlet
let context = DefaultSwiftletContext(from: request.context!)

// Read a resource file
let configData = try context.resources.read(named: "config.json")
let config = try configData.json(as: Config.self)

// Read text file
let templateData = try context.resources.read(named: "email-template.txt")
let template = try templateData.string()
```

### File Organization

```
sites/my-site/
├── src/
│   ├── .res/                    # Global resources
│   │   ├── config.json         # Site-wide config
│   │   ├── theme.json          # Default theme
│   │   └── api-keys.txt        # API credentials
│   │
│   ├── blog/
│   │   ├── .res/               # Blog-specific resources
│   │   │   ├── theme.json      # Overrides global theme
│   │   │   └── authors.csv     # Blog author data
│   │   ├── index.swift
│   │   │
│   │   └── admin/
│   │       ├── .res/           # Admin-specific resources
│   │       │   └── permissions.json
│   │       └── index.swift
```

### Hierarchical Lookup

Resources use automatic fallback - searches from most specific to least specific:

```swift
// In blog/admin/index.swift
let theme = try context.resources.read(named: "theme.json")

// Lookup order:
// 1. src/blog/admin/.res/theme.json    ❌ Not found
// 2. src/blog/.res/theme.json          ✅ Found! Uses blog theme
// 3. src/.res/theme.json               (Would check here if not found above)
```

### Common Resource Types

#### Configuration Files
```swift
struct SiteConfig: Codable {
    let siteName: String
    let features: Features
    let apiEndpoints: [String: String]
}

let configData = try context.resources.read(named: "config.json")
let config = try configData.json(as: SiteConfig.self)
```

#### CSV Data
```swift
let authorsData = try context.resources.read(named: "authors.csv")
let csv = try authorsData.string()
let rows = csv.split(separator: "\n").map { 
    $0.split(separator: ",").map(String.init) 
}
```

#### API Keys (Secure Storage)
```swift
let apiKeyData = try context.resources.read(named: "api-key.txt")
let apiKey = try apiKeyData.string().trimmingCharacters(in: .whitespacesAndNewlines)
```

#### Localization
```swift
let locale = request.headers["Accept-Language"] ?? "en"
let stringsData = try context.resources.read(named: "strings/\(locale).json")
let strings = try stringsData.json(as: [String: String].self)
let welcomeText = strings["welcome"] ?? "Welcome"
```

## Storage (var/)

Storage provides read-write access for dynamic content. The working directory is automatically set to your route's var directory.

### Basic Usage

```swift
// Save data
let userData = try JSONEncoder().encode(user)
try context.storage.write(userData, to: "users/\(userId).json")

// Read data
let savedData = try context.storage.read(from: "users/\(userId).json")
let user = try JSONDecoder().decode(User.self, from: savedData)

// Delete data
try context.storage.delete("users/\(userId).json")

// Check existence
if context.storage.exists("cache/data.json") {
    // Use cached data
}
```

### Directory Structure

Storage automatically mirrors your route structure:

```
sites/my-site/
├── var/
│   ├── visitors.txt         # Storage for index.swift (root route)
│   │
│   ├── blog/                # Storage for blog/index.swift
│   │   ├── posts/
│   │   ├── comments.db
│   │   └── cache/
│   │
│   └── blog/admin/          # Storage for blog/admin/index.swift
│       ├── uploads/
│       └── audit.log
```

### Common Storage Patterns

#### User Uploads
```swift
// Handle file upload
if let imageData = request.body {
    let fileName = "\(UUID()).jpg"
    try context.storage.write(imageData, to: "uploads/\(fileName)")
    
    // Save metadata
    let metadata = ImageMetadata(
        fileName: fileName,
        uploadedAt: Date(),
        size: imageData.count
    )
    let metadataData = try JSONEncoder().encode(metadata)
    try context.storage.write(metadataData, to: "uploads/\(fileName).meta")
}
```

#### Caching
```swift
func getCachedData(key: String) throws -> Data? {
    let cachePath = "cache/\(key).json"
    
    // Check if cache exists and is fresh
    if context.storage.exists(cachePath) {
        let data = try context.storage.read(from: cachePath)
        // Check timestamp, return if fresh
        return data
    }
    
    return nil
}

func setCachedData(key: String, data: Data) throws {
    try context.storage.createDirectory(at: "cache")
    try context.storage.write(data, to: "cache/\(key).json")
}
```

#### SQLite Database
```swift
// Open or create database
let dbPath = "app.db"
if !context.storage.exists(dbPath) {
    // Initialize database
    // Note: Actual SQLite usage would require SQLite library
}

// In practice, you'd use a SQLite wrapper
// This is just to show the path handling
```

#### Session Management
```swift
struct Session: Codable {
    let id: String
    let userId: String
    let createdAt: Date
    let data: [String: String]
}

// Save session
let session = Session(id: sessionId, userId: userId, createdAt: Date(), data: [:])
let sessionData = try JSONEncoder().encode(session)
try context.storage.write(sessionData, to: "sessions/\(sessionId).json")

// Load session
func loadSession(id: String) throws -> Session? {
    let path = "sessions/\(id).json"
    guard context.storage.exists(path) else { return nil }
    
    let data = try context.storage.read(from: path)
    return try JSONDecoder().decode(Session.self, from: data)
}
```

#### Directory Operations
```swift
// Create directories
try context.storage.createDirectory(at: "exports/2024/06")

// List files
let uploads = try context.storage.contentsOfDirectory(at: "uploads")
for file in uploads {
    print("Found upload: \(file)")
}

// Clean old files
let tempFiles = try context.storage.contentsOfDirectory(at: "temp")
for file in tempFiles {
    // Check age and delete if old
    try context.storage.delete("temp/\(file)")
}
```

## Common Patterns

### Resource + Storage Combination
```swift
// Read config from resources
let configData = try context.resources.read(named: "export-config.json")
let exportConfig = try configData.json(as: ExportConfig.self)

// Generate export using config
let exportData = generateExport(using: exportConfig)

// Save to storage
let fileName = "export-\(Date().timeIntervalSince1970).csv"
try context.storage.write(exportData, to: "exports/\(fileName)")
```

### Fallback to Defaults
```swift
// Try to read user preferences from storage, fall back to resources
func getUserTheme(userId: String) throws -> Theme {
    let userThemePath = "users/\(userId)/theme.json"
    
    if context.storage.exists(userThemePath) {
        // User has custom theme
        let data = try context.storage.read(from: userThemePath)
        return try JSONDecoder().decode(Theme.self, from: data)
    } else {
        // Use default from resources
        let data = try context.resources.read(named: "theme.json")
        return try data.json(as: Theme.self)
    }
}
```

### Atomic Updates
```swift
// Write to temporary file first, then move
func saveDataAtomically(data: Data, to path: String) throws {
    let tempPath = "\(path).tmp"
    
    // Write to temp file
    try context.storage.write(data, to: tempPath)
    
    // Delete old file if exists
    if context.storage.exists(path) {
        try context.storage.delete(path)
    }
    
    // Rename temp to final (would need to implement rename)
    // For now, just write again
    try context.storage.write(data, to: path)
    try context.storage.delete(tempPath)
}
```

## Best Practices

### Resources
1. **Never put secrets in web/** - Use `.res/` for API keys and credentials
2. **Use JSON for config** - Easy to parse and validate
3. **Version your schemas** - Include version field in JSON configs
4. **Keep resources small** - Large files impact swiftlet startup time
5. **Document resource dependencies** - List required resources in comments

### Storage
1. **Always validate paths** - Prevent directory traversal attacks
2. **Use UUIDs for user content** - Avoid filename collisions
3. **Implement cleanup** - Don't let storage grow unbounded
4. **Consider permissions** - Some files may need restricted access
5. **Plan for backup** - var/ directories contain user data

### Error Handling
```swift
do {
    let config = try context.resources.read(named: "config.json")
    // Use config
} catch ResourceError.notFound(let name) {
    // Handle missing resource
    print("Required resource not found: \(name)")
    // Use defaults or fail gracefully
} catch {
    // Handle other errors
    print("Resource error: \(error)")
}
```

## Troubleshooting

### Resources Not Found
- Check file exists in `.res/` directory
- Verify filename case (Linux is case-sensitive)
- Use exact path from `.res/` directory
- Check hierarchical lookup order

### Storage Permission Errors
- Ensure var directory exists
- Check file permissions
- Verify disk space available
- Check path doesn't escape var directory

### Working Directory Issues
- Storage paths are relative to var/{route}/
- Don't use absolute paths
- Don't use `../` to escape the directory

### Large Files
- Consider streaming for large files
- Implement chunked uploads
- Use external storage for very large files
- Monitor disk usage

## Examples Repository

For complete working examples, see:
- `/sites/test/resource-example/` - Basic resource and storage usage
- `/sites/swiftlets-site/` - Official site with shared components and resources
- Future examples planned for blog and API demonstration sites

Remember: Resources (.res/) are for configuration and static data, Storage (var/) is for dynamic user content!