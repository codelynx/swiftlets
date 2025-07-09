# Swift Container Plugin POC for Swiftlets

This POC demonstrates using Apple's Swift Container Plugin to build and deploy Swiftlets as OCI containers.

## Overview

The Swift Container Plugin (https://github.com/apple/swift-container-plugin) allows building minimal, secure containers directly from Swift Package Manager without writing Dockerfiles.

## Prerequisites

1. Swift 6.0+
2. Docker or compatible container runtime
3. Swift Container Plugin (already added to Package.swift)

## POC Steps

### 1. Build Container Image

```bash
# Build container image for swiftlets-server
swift package --disable-sandbox \
    plugin build-container-image \
    --product swiftlets-server \
    --repository swiftlets-poc \
    --tag latest
```

### 2. Run Container Locally

```bash
# Run the container
docker run -p 8080:8080 swiftlets-poc:latest
```

### 3. Deploy to Registry

```bash
# Tag for registry
docker tag swiftlets-poc:latest ghcr.io/username/swiftlets:latest

# Push to GitHub Container Registry
docker push ghcr.io/username/swiftlets:latest
```

## Benefits

1. **Minimal Size**: No unnecessary dependencies
2. **Security**: Static linking, no package manager
3. **Native Integration**: Works with Swift Package Manager
4. **Multi-Architecture**: Supports ARM64 and x86_64

## Architecture

```
Container Image (minimal)
├── /usr/bin/swiftlets-server (statically linked)
└── Minimal Linux runtime
```

## Next Steps

1. Add site files to container
2. Configure for production use
3. Set up CI/CD with container builds
4. Deploy to container orchestration platforms