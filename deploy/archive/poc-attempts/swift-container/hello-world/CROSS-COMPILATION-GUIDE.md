# Cross-Compilation Guide for ARM64 Linux

This guide shows how to build Swift binaries and containers on macOS for ARM64 Linux (EC2 t4g instances).

## Prerequisites

- Swift 6.0+ on macOS
- Docker (for container builds)

## Option 1: Direct Binary Cross-Compilation

### Step 1: Install Linux ARM64 SDK

```bash
# Download the SDK
curl -L https://download.swift.org/swift-6.0.2-release/ubuntu2204-aarch64/swift-6.0.2-RELEASE/swift-6.0.2-RELEASE-ubuntu22.04-aarch64.tar.gz -o arm64-sdk.tar.gz

# Compute checksum
CHECKSUM=$(swift package compute-checksum arm64-sdk.tar.gz)

# Install SDK
swift sdk install arm64-sdk.tar.gz --checksum $CHECKSUM

# Verify installation
swift sdk list
```

### Step 2: Build Binary

```bash
# Find your SDK name (something like '6.0.2-RELEASE_ubuntu_jammy_aarch64')
SDK_NAME=$(swift sdk list | grep aarch64 | awk '{print $1}')

# Build
swift build --swift-sdk $SDK_NAME -c release

# Binary location
ls .build/*/release/hello-world
```

### Step 3: Deploy to EC2

```bash
# Copy to EC2
scp -i ~/.ssh/your-key.pem .build/*/release/hello-world ubuntu@<YOUR-EC2-IP>:/tmp/

# Run on EC2
ssh -i ~/.ssh/your-key.pem ubuntu@<YOUR-EC2-IP>
./tmp/hello-world
```

## Option 2: Container Cross-Compilation

### Using Swift Container Plugin

```bash
# Build container for ARM64
swift package --disable-sandbox \
    --allow-network-connections all \
    --swift-sdk $SDK_NAME \
    build-container-image \
    --product hello-world \
    --repository hello-arm64 \
    --tag latest
```

### Save and Transfer

```bash
# Save container image
docker save hello-arm64:latest -o hello-arm64.tar

# Copy to EC2
scp -i ~/.ssh/your-key.pem hello-arm64.tar ubuntu@<YOUR-EC2-IP>:/tmp/

# On EC2: Load and run
docker load -i /tmp/hello-arm64.tar
docker run --rm hello-arm64:latest
```

## Option 3: Build on EC2 (Fallback)

If cross-compilation doesn't work:

```bash
# Copy source to EC2
tar -czf hello-src.tar.gz Package.swift Sources
scp -i ~/.ssh/your-key.pem hello-src.tar.gz ubuntu@<YOUR-EC2-IP>:/tmp/

# On EC2: Build natively
tar -xzf /tmp/hello-src.tar.gz
swift build -c release
.build/release/hello-world
```

## Troubleshooting

### SDK Not Found
- Make sure you download the correct Ubuntu version (22.04 for EC2)
- Check architecture matches (aarch64 for ARM64)

### Build Errors
- Ensure all dependencies support Linux
- Use `#if os(Linux)` for platform-specific code

### Container Issues
- Docker must be running
- Use local registry prefix to avoid auth issues

## Summary

1. **Fastest**: Direct binary cross-compilation
2. **Most portable**: Container with Swift Container Plugin
3. **Simplest**: Build on EC2 directly

For Swiftlets deployment, Option 1 (direct binary) is recommended for development, while Option 2 (containers) is better for production.