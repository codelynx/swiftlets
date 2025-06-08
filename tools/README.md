# Swiftlets Tools

This directory contains utility scripts for Swiftlets development and distribution.

## Active Tools

### `check-ubuntu-prerequisites.sh`
Checks if Ubuntu ARM64 system has all required prerequisites for Swift development.
- Verifies OS version and architecture
- Checks for Swift installation
- Lists required libraries and build tools
- Provides installation commands if prerequisites are missing

**Usage:**
```bash
./tools/check-ubuntu-prerequisites.sh
```

### `package/`
Contains scripts for creating platform-specific distribution packages:
- `ubuntu/build-deb.sh` - Creates .deb package for Ubuntu/Debian systems
- `macos/` - (Reserved for macOS installer scripts)
- `docker/` - (Reserved for Docker image creation)

## Main Scripts (Project Root)

The primary build and run scripts are now in the project root:

### `build-server`
Builds the Swiftlets server binary and installs to `bin/{os}/{arch}/`

### `build-site <site-root>`
Builds a Swiftlets site by compiling Swift sources to executables

### `run-site <site-root>`
Launches the Swiftlets server with the specified site

See `/docs/scripts-workflow.md` for detailed usage.