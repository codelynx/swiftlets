# My Swiftlets Website

This is a website built with [Swiftlets](https://github.com/yourusername/swiftlets).

## Structure

```
.
├── src/         # Swift source files for swiftlets
├── bin/         # Compiled swiftlet executables (gitignored)
├── web/         # Web root directory (served by the server)
│   └── *.webbin # Route definition files
├── Makefile     # Build configuration
└── Package.swift # Swift package dependencies
```

## Getting Started

1. Create a swiftlet source file in `src/`:
```swift
// src/index.swift
import Foundation

@main
struct HomePage {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, 
            from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head { Title("My Website") }
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

2. Create a route in `web/`:
```bash
echo "bin/index" > web/index.webbin
```

3. Build and run:
```bash
make serve
```

4. Open http://localhost:8080/

## Available Commands

- `make` - Build all swiftlets
- `make clean` - Clean build artifacts
- `make routes` - List all defined routes
- `make serve` - Start development server
- `make help` - Show all commands