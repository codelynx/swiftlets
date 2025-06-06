# Swiftlets Showcase Site

This is the official showcase website for the Swiftlets web framework. It demonstrates the framework's capabilities and serves as both documentation and example code.

## Structure

```
swiftlets-site/
├── src/                    # Swift source files (swiftlets)
│   ├── index.swift        # Homepage
│   ├── docs.swift         # Documentation hub
│   ├── showcase.swift     # Component showcase
│   ├── about.swift        # About page
│   └── docs/              # Documentation pages
│       └── getting-started.swift
├── web/                   # Web root directory
│   ├── *.webbin          # Routing files
│   ├── bin/              # Compiled executables (generated)
│   └── styles/           # CSS files
│       └── main.css
├── build.sh              # Build script
├── Makefile              # Alternative build system
└── README.md             # This file
```

## Building

First, ensure the core framework is built:
```bash
cd ../../../core
swift build -c release
```

Then build the site using either:

### Option 1: Build Script
```bash
./build.sh
```

### Option 2: Makefile
```bash
make build
```

## Running

### Using Swiftlets CLI (recommended)
```bash
# From the project root
swiftlets serve --site sites/core/swiftlets-site
```

### Direct Server
```bash
# From the project root
SWIFTLETS_SITE=sites/core/swiftlets-site ./core/.build/release/swiftlets-server
```

### Using Makefile
```bash
# Build and serve with CLI
make serve

# Build and run directly
make run
```

## Development

Each `.swift` file in the `src/` directory becomes an executable that handles a specific route. The SwiftletsHTML DSL is used to generate type-safe HTML responses.

Example swiftlet:
```swift
import SwiftletsCore
import SwiftletsHTML

@main
struct Index {
    static func main() {
        let html = Html {
            Head {
                Title("Swiftlets")
            }
            Body {
                H1("Welcome to Swiftlets!")
            }
        }
        
        Response(html: html.render()).send()
    }
}
```

## Adding New Pages

1. Create a new `.swift` file in `src/`
2. Create a corresponding `.webbin` file in `web/`
3. Run the build script to compile
4. The page will be available at the route matching the filename

## Styling

The site uses a simple CSS framework located in `web/styles/main.css`. Feel free to modify or extend the styles as needed.