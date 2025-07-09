# Swift Container Plugin Implementation for Swiftlets

Based on official Apple documentation, here's how to properly implement container builds for Swiftlets.

## Two Apple Container Technologies

### 1. Swift Container Plugin (What we need)
- **Purpose**: Build container images from Swift packages
- **URL**: https://github.com/apple/swift-container-plugin
- **Use Case**: Deploy Swift apps to cloud platforms

### 2. Apple Container Tool (Different project)
- **Purpose**: Run containers on macOS using VMs
- **URL**: https://github.com/apple/container
- **Use Case**: Local development on Apple Silicon Macs

## Implementation Steps

### Step 1: Install Cross-Compilation SDK

```bash
# For Linux x86_64
swift sdk install x86_64-swift-linux-musl

# For Linux ARM64
swift sdk install aarch64-swift-linux-musl
```

### Step 2: Build Container Image

```bash
# Build for Linux x86_64
swift package --swift-sdk x86_64-swift-linux-musl \
    plugin build-container-image \
    --product swiftlets-server \
    --repository swiftlets

# Build for Linux ARM64 (for EC2 t4g instances)
swift package --swift-sdk aarch64-swift-linux-musl \
    plugin build-container-image \
    --product swiftlets-server \
    --repository swiftlets-arm64
```

### Step 3: Deploy to Registry

```bash
# Tag for registry
docker tag swiftlets:latest ghcr.io/codelynx/swiftlets:latest

# Push to registry
docker push ghcr.io/codelynx/swiftlets:latest
```

### Step 4: Run on EC2

```bash
# On EC2 instance
docker run -p 8080:8080 ghcr.io/codelynx/swiftlets:latest
```

## Benefits Over Traditional Docker

1. **No Dockerfile needed** - Swift Package Manager handles everything
2. **Minimal images** - Only includes necessary dependencies
3. **Static linking** - Smaller, more secure binaries
4. **Native integration** - Works seamlessly with Swift packages

## Complete Workflow

```bash
# 1. On your Mac - build container
swift package --swift-sdk aarch64-swift-linux-musl \
    plugin build-container-image \
    --product swiftlets-server \
    --repository swiftlets \
    --tag arm64

# 2. Push to registry
docker push swiftlets:arm64

# 3. On EC2 - pull and run
docker pull swiftlets:arm64
docker run -d -p 80:8080 swiftlets:arm64
```

## Next Steps

1. Set up GitHub Actions to automate builds
2. Create multi-architecture images
3. Add site files to container
4. Configure for production use