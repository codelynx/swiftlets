# File-Based Shared Components for Swiftlets

## Your Example Structure
```
sites/my-site/src/
├── japan/
│   ├── tokyo/
│   │   ├── shibuya/
│   │   │   └── bluecafe.swift    # Uses tokyo_menu, japan_menu
│   │   └── shared/
│   │       └── tokyo_menu.swift  # Tokyo-wide menu component
│   └── shared/
│       └── japan_menu.swift      # Japan-wide menu component
└── shared/
    └── global_nav.swift          # Global navigation
```

## How It Would Work

### 1. Build-Time Discovery
When building `bluecafe.swift`, the build script discovers shared components by walking up the directory tree:

```bash
# For: japan/tokyo/shibuya/bluecafe.swift
# Discovers:
1. japan/tokyo/shibuya/shared/*.swift  # (if exists)
2. japan/tokyo/shared/*.swift          # tokyo_menu.swift ✓
3. japan/shared/*.swift                # japan_menu.swift ✓
4. shared/*.swift                      # global_nav.swift ✓
```

### 2. Compilation
All discovered shared files are included when compiling:

```bash
swiftc \
    Sources/Swiftlets/**/*.swift \
    src/shared/*.swift \                    # Global
    src/japan/shared/*.swift \              # Japan-level
    src/japan/tokyo/shared/*.swift \        # Tokyo-level
    src/japan/tokyo/shibuya/bluecafe.swift \
    -o bin/japan/tokyo/shibuya/bluecafe
```

### 3. Usage in bluecafe.swift
```swift
// src/japan/tokyo/shibuya/bluecafe.swift

// No imports needed - all compiled together!

@main
struct BlueCafePage: SwiftletMain {
    var title = "Blue Bottle Coffee - Shibuya"
    
    var body: some HTMLElement {
        VStack {
            globalNav()           // From src/shared/global_nav.swift
            japanMenu()           // From src/japan/shared/japan_menu.swift
            tokyoMenu()           // From src/japan/tokyo/shared/tokyo_menu.swift
            
            // Page specific content
            H1("Blue Bottle Coffee Shibuya")
            P("Artisanal coffee in the heart of Shibuya")
        }
    }
}
```

### 4. Shared Component Examples

```swift
// src/shared/global_nav.swift
func globalNav() -> some HTMLElement {
    Nav {
        Link(href: "/", "Home")
        Link(href: "/japan", "Japan")
        Link(href: "/about", "About")
    }
}

// src/japan/shared/japan_menu.swift
func japanMenu() -> some HTMLElement {
    Nav {
        H3("Japan")
        Link(href: "/japan/tokyo", "Tokyo")
        Link(href: "/japan/osaka", "Osaka")
        Link(href: "/japan/kyoto", "Kyoto")
    }
}

// src/japan/tokyo/shared/tokyo_menu.swift
func tokyoMenu() -> some HTMLElement {
    Nav {
        H4("Tokyo Districts")
        Link(href: "/japan/tokyo/shibuya", "Shibuya")
        Link(href: "/japan/tokyo/shinjuku", "Shinjuku")
        Link(href: "/japan/tokyo/harajuku", "Harajuku")
    }
}
```

## Implementation in build-site

```bash
#!/bin/bash

build_swiftlet() {
    local swift_file="$1"
    local site_root="$2"
    
    # Get path relative to src/
    local rel_path="${swift_file#$site_root/src/}"
    local dir_path=$(dirname "$rel_path")
    
    # Collect shared components
    local shared_files=""
    
    # Walk up directory tree
    local current_dir="$dir_path"
    while [ "$current_dir" != "." ]; do
        if [ -d "$site_root/src/$current_dir/shared" ]; then
            shared_files="$shared_files $site_root/src/$current_dir/shared/*.swift"
        fi
        current_dir=$(dirname "$current_dir")
    done
    
    # Add global shared
    if [ -d "$site_root/src/shared" ]; then
        shared_files="$shared_files $site_root/src/shared/*.swift"
    fi
    
    # Compile with all shared files
    swiftc \
        Sources/Swiftlets/**/*.swift \
        $shared_files \
        "$swift_file" \
        -o "$output_path"
}
```

## Benefits

1. **No Import Statements** - Everything compiled together
2. **Natural Scoping** - Components available based on directory location
3. **Simple Mental Model** - Just put shared code in `shared/` folders
4. **No Module Complexity** - No `.swiftmodule` files to manage
5. **Incremental Adoption** - Add `shared/` folders as needed

## Advanced: Namespace Collision Prevention

To avoid name collisions, encourage prefixing:

```swift
// src/japan/shared/japan_menu.swift
func japanMenu() -> some HTMLElement { }      // Prefixed with 'japan'

// src/japan/tokyo/shared/tokyo_menu.swift  
func tokyoMenu() -> some HTMLElement { }      // Prefixed with 'tokyo'

// Or use structs as namespaces
struct JapanComponents {
    static func menu() -> some HTMLElement { }
}

struct TokyoComponents {
    static func menu() -> some HTMLElement { }
}
```

## Example Build Output

```bash
$ ./build-site sites/travel

Building: japan/tokyo/shibuya/bluecafe.swift
  Discovering shared components...
  ✓ Found: shared/global_nav.swift
  ✓ Found: japan/shared/japan_menu.swift
  ✓ Found: japan/tokyo/shared/tokyo_menu.swift
  Compiling with 3 shared components...
  ✓ Output: bin/japan/tokyo/shibuya/bluecafe

Building: japan/osaka/restaurants.swift
  Discovering shared components...
  ✓ Found: shared/global_nav.swift
  ✓ Found: japan/shared/japan_menu.swift
  Compiling with 2 shared components...
  ✓ Output: bin/japan/osaka/restaurants
```

## Future Enhancement: Caching

For better performance, compile shared components to object files:

```bash
# First time: compile shared to .o
swiftc -c japan/shared/*.swift -o .cache/japan_shared.o

# Use cached .o for all pages under japan/
swiftc .cache/japan_shared.o japan/tokyo/page.swift -o bin/japan/tokyo/page
```

This approach is simple, intuitive, and fits perfectly with Swiftlets' file-based philosophy!