#!/bin/bash
#
# Direct cross-compilation for ARM64 Linux
# Using Swift Container Plugin with cross-compilation SDK
#

set -e

echo "=== Cross-Compile Container for ARM64 Linux ==="

cd "$(dirname "$0")"

# Function to download and install SDK
install_arm64_sdk() {
    echo "Installing ARM64 Linux SDK..."
    
    # Download SDK info
    SDK_URL="https://download.swift.org/swift-6.0.2-release/ubuntu2204-aarch64/swift-6.0.2-RELEASE/swift-6.0.2-RELEASE-ubuntu22.04-aarch64.tar.gz"
    
    # Download to temp directory
    TEMP_DIR=$(mktemp -d)
    echo "Downloading SDK..."
    curl -L "$SDK_URL" -o "$TEMP_DIR/sdk.tar.gz"
    
    # Compute checksum
    echo "Computing checksum..."
    CHECKSUM=$(swift package compute-checksum "$TEMP_DIR/sdk.tar.gz")
    echo "Checksum: $CHECKSUM"
    
    # Install with checksum
    echo "Installing SDK..."
    swift sdk install "$SDK_URL" --checksum "$CHECKSUM"
    
    # Cleanup
    rm -rf "$TEMP_DIR"
}

# Step 1: Check if we need to install SDK
echo "1. Checking for ARM64 SDK..."
if ! swift sdk list | grep -q "ubuntu.*aarch64"; then
    echo "ARM64 SDK not found. Installing..."
    install_arm64_sdk
else
    echo "ARM64 SDK already installed"
fi

# Step 2: Find the SDK name
echo ""
echo "2. Finding SDK name..."
SDK_NAME=$(swift sdk list | grep "ubuntu.*aarch64" | head -1 | awk '{print $1}')
echo "Using SDK: $SDK_NAME"

# Step 3: Build container with cross-compilation
echo ""
echo "3. Building container for ARM64..."

# Build with the SDK
swift package --disable-sandbox \
    --allow-network-connections all \
    --swift-sdk "$SDK_NAME" \
    build-container-image \
    --product hello-world \
    --repository hello-swift-arm64 \
    --tag latest

echo ""
echo "✅ Container built for ARM64!"
echo ""
echo "To save the image:"
echo "  docker save hello-swift-arm64:latest -o hello-arm64.tar"
echo ""
echo "To load on EC2:"
echo "  docker load -i hello-arm64.tar"
echo "  docker run --rm hello-swift-arm64:latest"