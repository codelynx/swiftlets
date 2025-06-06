# Security: Executable Binary Directory Location

## Overview

This document describes an important security consideration for Swiftlets sites regarding the location of compiled executables.

## The Issue

Initially, site Makefiles were configured to place compiled executables in `web/bin/`, which would make them accessible via HTTP requests. This is a significant security risk as it would allow anyone to download the compiled binaries.

## The Solution

Executables must be placed OUTSIDE the web root directory to prevent HTTP access.

### Correct Structure

```
site-directory/
├── src/                    # Source files
├── bin/                    # Executables (OUTSIDE web root)
│   └── [executables]
└── web/                    # Web root (public files only)
    ├── *.webbin           # Route markers
    └── static/            # CSS, images, etc.
```

### Incorrect Structure (Security Risk)

```
site-directory/
├── src/                    # Source files
└── web/                    # Web root
    ├── bin/               # ❌ WRONG: Executables exposed to HTTP
    ├── *.webbin
    └── static/
```

## Implementation

### 1. Makefile Configuration

Set the binary directory outside web root:
```makefile
# Binary directory (OUTSIDE web root for security)
BIN_DIR := bin
```

### 2. Server Configuration

The server was updated to look for executables in the correct location:
```swift
// sites/examples/swiftlets-site/web/hello.webbin 
// -> sites/examples/swiftlets-site/bin/hello
let siteRoot = URL(fileURLWithPath: webRoot).deletingLastPathComponent().path
let executablePath = "\(siteRoot)/bin/\(relativePath)/\(filename)"
```

## Verification

To verify your site is secure:

1. Check that `bin/` is at the site root level, not under `web/`
2. Try accessing `http://yoursite/bin/` - it should return 404
3. Ensure `.gitignore` includes the `bin/` directory

## Migration

If you have an existing site with executables in `web/bin/`:

1. Update your Makefile: `BIN_DIR := bin`
2. Clean: `make clean`
3. Rebuild: `make build`
4. Remove old directory: `rm -rf web/bin`

## Server Routing Logic

The server's routing logic was updated to handle this structure:
- Webbin files remain in the web directory for route discovery
- When a `.webbin` file is found, the server calculates the executable path
- The executable path is derived by going up from web/ to the site root, then into bin/

This ensures executables are never exposed via HTTP while maintaining the routing functionality.