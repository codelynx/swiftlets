# Swiftlets Core Framework

This directory contains the core Swiftlets framework components:

## Structure

- `Sources/` - Framework source code
  - `SwiftletsCore/` - Core types (Request, Response, Swiftlet protocol)
  - `SwiftletsHTML/` - HTML DSL for building web pages
  - `SwiftletsServer/` - HTTP server with webbin routing
- `Tests/` - Framework unit tests
- `Package.swift` - Swift package definition

## Building

```bash
cd core
swift build
```

## Testing

```bash
cd core
swift test
```

## For Framework Contributors

This is the core framework code. If you're looking to use Swiftlets to build a website, check out the `sdk/` directory for examples and templates.