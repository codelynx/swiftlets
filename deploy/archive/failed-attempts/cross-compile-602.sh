#!/bin/bash
#
# Cross-compile using Swift 6.0.2 with proper permissions
#

set -e

echo "=== Cross-compiling with Swift 6.0.2 ==="
echo ""

# Clean build directory first
echo "1. Cleaning build directory..."
rm -rf .build/aarch64-swift-linux-musl

# Create a temporary directory for the SDK
SDK_DIR="/tmp/swift-sdk-$$"
mkdir -p "$SDK_DIR"

# Download SDK locally
echo ""
echo "2. Downloading Swift 6.0.2 SDK locally..."
if [ ! -f /tmp/swift-6.0.2-sdk.tar.gz ]; then
    curl -L https://download.swift.org/swift-6.0.2-release/static-sdk/swift-6.0.2-RELEASE/swift-6.0.2-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz \
        -o /tmp/swift-6.0.2-sdk.tar.gz
fi

# Run Docker with better permissions
echo ""
echo "3. Cross-compiling for Linux ARM64..."
docker run --rm \
    -v $(pwd):/workspace \
    -v /tmp/swift-6.0.2-sdk.tar.gz:/sdk.tar.gz:ro \
    -v "$SDK_DIR:/sdk" \
    -w /workspace \
    --platform linux/amd64 \
    swift:6.0.2 \
    bash -c "
        # Install SDK
        swift sdk install /sdk.tar.gz
        
        # Build
        swift build --swift-sdk aarch64-swift-linux-musl -c release
        
        # Fix permissions
        chown -R $(id -u):$(id -g) .build/aarch64-swift-linux-musl || true
    "

# Clean up
rm -rf "$SDK_DIR"

echo ""
echo "✅ Cross-compilation complete!"
echo ""
echo "Checking built binary:"
if [ -f .build/aarch64-swift-linux-musl/release/swiftlets-server ]; then
    echo "✓ swiftlets-server built successfully"
    file .build/aarch64-swift-linux-musl/release/swiftlets-server
else
    echo "✗ Build may have failed"
fi