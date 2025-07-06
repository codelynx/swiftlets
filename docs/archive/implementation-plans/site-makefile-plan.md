# Makefile Plan for SDK Swiftlets Site

## Overview
Create a comprehensive Makefile that:
1. Recursively builds all `*.swift` files under `src/`
2. Creates corresponding executables in `web/bin/`
3. Generates/updates `.webbin` files with MD5 hashes
4. Links against the unified Swiftlets framework
5. Includes development conveniences

## Directory Structure
```
sdk/sites/swiftlets-site/
├── src/                        # Swift source files
│   ├── index.swift
│   ├── about.swift
│   └── docs/
│       └── getting-started.swift
├── web/                        # Web root (served by server)
│   ├── bin/                    # Compiled executables (flat structure)
│   ├── *.webbin               # Route markers with MD5 hashes
│   └── styles/                # Static assets
└── Makefile                   # Build automation
```

## Key Features

### 1. Automatic Source Discovery
- Find all `*.swift` files recursively in `src/`
- Map to corresponding paths in `web/bin/`
- Example: `src/docs/api.swift` → `web/bin/docs/api`

### 2. Webbin File Management
- Auto-generate `.webbin` files if they don't exist
- Update with MD5 hash after successful build
- Location determines route: `web/api/users.json.webbin` → `/api/users.json`

### 3. Framework-Based Build
- Links against the unified `Swiftlets` framework
- Requires pre-built framework in `core/.build/release/`
- Build directly to `web/bin/` without platform subdirectories
- Clean imports with just `import Swiftlets`

### 4. Build Optimization
- Timestamp-based rebuilding (only rebuild changed files)
- Dependency tracking on SwiftletsCore/SwiftletsHTML
- Parallel builds where possible

### 5. Development Tools
- `make` - Build all swiftlets
- `make clean` - Remove all build artifacts
- `make routes` - List all available routes
- `make serve` - Build and start server
- `make watch` - Auto-rebuild on changes
- `make validate` - Check webbin integrity

## Implementation Steps

### Step 1: Core Variables
```makefile
# Paths (simple structure for site developers)
BIN_DIR := web/bin
SRC_DIR := src
CORE_DIR := ../../../core

# Build settings
SWIFT_FLAGS := -parse-as-library
LINK_FLAGS := -I $(CORE_DIR)/.build/release/Modules \
              -L $(CORE_DIR)/.build/release \
              -lSwiftlets
```

### Step 2: Source Discovery
```makefile
# Find all Swift sources recursively
SWIFT_SOURCES := $(shell find $(SRC_DIR) -name "*.swift" -type f)

# Derive binary paths from sources
BINARIES := $(patsubst $(SRC_DIR)/%.swift,$(BIN_DIR)/%,$(SWIFT_SOURCES))

# Derive webbin paths from sources
WEBBINS := $(patsubst $(SRC_DIR)/%.swift,web/%.webbin,$(SWIFT_SOURCES))
```

### Step 3: Build Rules
```makefile
# Check if core framework is built
check-core:
    @if [ ! -f $(CORE_DIR)/.build/release/libSwiftlets.dylib ] && \
       [ ! -f $(CORE_DIR)/.build/release/libSwiftlets.so ]; then \
        echo "Error: Swiftlets framework not built!"; \
        echo "Run: cd $(CORE_DIR) && swift build -c release --product Swiftlets"; \
        exit 1; \
    fi

# Build all targets
all: check-core $(BINARIES) $(WEBBINS)

# Individual binary rule
$(BIN_DIR)/%: $(SRC_DIR)/%.swift
    @mkdir -p $(dir $@)
    swiftc $(SWIFT_FLAGS) $(LINK_FLAGS) $< -o $@
    
# Webbin generation rule
web/%.webbin: $(BIN_DIR)/%
    @mkdir -p $(dir $@)
    @MD5=$$(md5 -q $< || md5sum $< | cut -d' ' -f1)
    @echo $$MD5 > $@
```

### Step 4: Utility Targets
```makefile
# List all routes
routes:
    @echo "Static files:"
    @find web -type f -not -name "*.webbin" | sed 's|^web||'
    @echo "\nDynamic routes:"
    @for webbin in $(WEBBINS); do \
        route=$${webbin#web}; \
        route=$${route%.webbin}; \
        echo "  $$route"; \
    done

# Development server
serve: all
    cd ../../.. && SWIFTLETS_SITE=sdk/sites/swiftlets-site ./run-server.sh
```

## Benefits
1. **Automatic**: No manual webbin creation or path management
2. **Scalable**: Add new Swift files anywhere in src/, they're automatically built
3. **Maintainable**: Clear mapping between source and output
4. **Efficient**: Only rebuilds changed files
5. **Developer-friendly**: Simple commands for common tasks

## Example Usage
```bash
# Build everything
make

# Add new route
echo 'print("Hello API")' > src/api/hello.swift
make  # Creates web/bin/api/hello and web/api/hello.webbin

# Check routes
make routes

# Start development
make serve
```

This Makefile will provide a complete build system for the SDK swiftlets-site, handling all aspects of the webbin compilation process automatically.