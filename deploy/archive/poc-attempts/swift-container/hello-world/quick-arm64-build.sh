#!/bin/bash
#
# Quick ARM64 build for EC2
#

set -e

echo "=== Quick ARM64 Build for EC2 ==="

cd "$(dirname "$0")"

# Step 1: Download and install SDK
echo "1. Installing ARM64 SDK..."
echo "   This will take a few minutes on first run..."

SDK_FILE="arm64-sdk.tar.gz"
SDK_URL="https://download.swift.org/swift-6.0.2-release/ubuntu2204-aarch64/swift-6.0.2-RELEASE/swift-6.0.2-RELEASE-ubuntu22.04-aarch64.tar.gz"

# Download if not exists
if [ ! -f "$SDK_FILE" ]; then
    echo "   Downloading SDK..."
    curl -L "$SDK_URL" -o "$SDK_FILE"
fi

# Compute checksum
echo "   Computing checksum..."
CHECKSUM=$(swift package compute-checksum "$SDK_FILE")
echo "   Checksum: $CHECKSUM"

# Install SDK
echo "   Installing SDK..."
swift sdk install "$SDK_FILE" --checksum "$CHECKSUM" || echo "SDK may already be installed"

# Step 2: Build
echo ""
echo "2. Building for ARM64..."

# Get SDK name
SDK_NAME=$(swift sdk list | grep aarch64 | head -1 | awk '{print $1}')
echo "   Using SDK: $SDK_NAME"

# Build
swift build --swift-sdk "$SDK_NAME" -c release

# Step 3: Show results
echo ""
echo "3. Build complete!"
echo ""
echo "Binary location:"
find .build -name "hello-world" -type f | grep release

echo ""
echo "To deploy to your EC2 (<YOUR-EC2-IP>):"
echo "  scp -i ~/.ssh/<YOUR-KEY-NAME>.pem \$(find .build -name 'hello-world' -type f | grep release) ubuntu@<YOUR-EC2-IP>:/tmp/"
echo ""
echo "Then on EC2:"
echo "  chmod +x /tmp/hello-world"
echo "  /tmp/hello-world"