#!/bin/bash
#
# Simple cross-compilation using Swift 6.0.2 in Docker
#

set -e

echo "=== Cross-compiling with Swift 6.0.2 ==="
echo ""

# Pull Swift 6.0.2 image if not present
echo "1. Ensuring Swift 6.0.2 Docker image..."
docker pull swift:6.0.2

# Cross-compile the framework
echo ""
echo "2. Building Swiftlets framework..."
docker run --rm \
    -v $(pwd):/src \
    -w /src \
    -u $(id -u):$(id -g) \
    -e HOME=/tmp \
    swift:6.0.2 \
    bash -c "
        # Install SDK inside container
        apt-get update -qq && apt-get install -y curl > /dev/null 2>&1
        echo 'Downloading Swift 6.0.2 Linux SDK...'
        curl -sL https://download.swift.org/swift-6.0.2-release/static-sdk/swift-6.0.2-RELEASE/swift-6.0.2-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz -o sdk.tar.gz
        swift sdk install sdk.tar.gz > /dev/null 2>&1
        rm sdk.tar.gz
        
        # Build for ARM64
        echo 'Cross-compiling for Linux ARM64...'
        swift build --swift-sdk aarch64-swift-linux-musl -c release
    "

echo ""
echo "✅ Cross-compilation complete!"
echo ""
echo "Binaries location:"
ls -la .build/aarch64-swift-linux-musl/release/swiftlets-server || echo "Build may have failed"