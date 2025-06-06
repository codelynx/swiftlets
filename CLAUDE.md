# Project: Swiftlets

## Overview
This project is inspired by Paul Hudson's Ignite static site generator. While Ignite only renders static websites, this project aims to use similar result builder patterns to develop a dynamic web server and CGI-like Swift components that work on both macOS and Linux (Ubuntu).

## Architecture
Swiftlets uses a unique modular architecture where:
- The web server acts as a router to standalone executable modules ("swiftlets")
- Each route maps to an independent executable (e.g., `/getting-started` → `bin/getting-started/index`)
- Executables are built on-demand from Swift source files
- Each swiftlet is isolated and can be updated without restarting the server
- Future support for multiple languages beyond Swift

### Platform Support
- **macOS**: x86_64 (Intel) and arm64 (Apple Silicon)
- **Linux**: x86_64 and arm64 (Ubuntu and other distributions)

Core development builds executables into platform-specific paths:
- `bin/macos/x86_64/` for macOS Intel
- `bin/macos/arm64/` for macOS Apple Silicon  
- `bin/linux/x86_64/` for Linux x64
- `bin/linux/arm64/` for Linux ARM

Third-party SDKs provide pre-built executables in `sdk/{platform}/{architecture}/` format. During deployment, only the target platform binaries are used.

See `/docs/swiftlet-architecture.md` for detailed architecture documentation.

## Goals
- Create a SwiftUI-like declarative syntax for building dynamic web applications
- Support server-side rendering with real-time data
- Implement CGI-like components for handling HTTP requests/responses
- Cross-platform compatibility (macOS and Linux/Ubuntu)
- Use Swift result builders similar to Ignite's architecture
- Enable hot-reload development with automatic compilation
- Support process pooling for performance
- Allow mixing of different programming languages

## Project Structure
- `/docs/project-structure.md` - Modular structure for core and third-party development
- `/docs/swiftlet-architecture.md` - Detailed explanation of the executable module system
- `/docs/poc-simple-server.md` - First POC implementation without result builders
- `/docs/sites-organization.md` - Organization of sites for core, test, and third-party development
- `/docs/html-builder-implementation-plan.md` - Detailed plan for HTML component builder using result builders
- `/docs/html-builder-poc.swift` - Proof of concept demonstrating SwiftUI-like HTML generation

## Latest Development
- Implemented SwiftletsHTML library with Ignite-inspired DSL
- Basic HTML elements: Text, Div, Section, Headings (H1-H6), Paragraph, Link
- Document structure: Html, Head, Body, Title, Meta
- Modifiers: classes, styles, padding, margin, colors, etc.
- Result builder (@HTMLBuilder) for SwiftUI-like syntax
- Working example at `/dsl` route showing type-safe HTML generation

## Sites
- `/sites/core/` - Official example sites (hello, showcase)
- `/sites/test/` - Test sites for framework development
- `/sites/templates/` - Third-party site templates

Run with: `SWIFTLETS_SITE=sites/core/showcase .build/release/swiftlets-server`

## References
- Ignite framework (in `/external/Ignite/`) - MIT Licensed static site generator by Paul Hudson