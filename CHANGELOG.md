# Changelog

All notable changes to Swiftlets will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **CLI Tool** - Complete command-line interface for project management
  - `swiftlets new` command for creating projects from templates
  - `swiftlets init` command for initializing in existing directories
  - `swiftlets serve` command for running development server
  - `swiftlets build` command for building swiftlets
- **Configurable Web Root** - Server now supports environment variables
  - `SWIFTLETS_SITE` for specifying site directory
  - `SWIFTLETS_WEB_ROOT` for direct web root path
  - `SWIFTLETS_HOST` and `SWIFTLETS_PORT` for network configuration
- **Cross-Platform Support** - Full Linux ARM64 (aarch64) support
  - Universal build scripts that detect platform/architecture
  - Fixed compilation issues on Ubuntu ARM64
  - Consistent `arm64` naming across platforms

### Changed
- Server can now run from any directory (not just parent of `web/`)
- Build scripts now use platform detection for better compatibility
- Makefile uses bash shell for Ubuntu compatibility

### Fixed
- "Bad substitution" error in Makefile on Ubuntu
- Module import errors in basic-site example
- Top-level code compilation errors on Linux

## [0.1.0] - 2025-01-01

### Added
- Initial SwiftNIO-based HTTP server
- Executable-per-route architecture
- Basic webbin routing system
- SwiftletsHTML DSL with 60+ elements
- Cross-platform support (macOS/Linux)
- Basic examples and documentation

[Unreleased]: https://github.com/codelynx/swiftlets/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/codelynx/swiftlets/releases/tag/v0.1.0