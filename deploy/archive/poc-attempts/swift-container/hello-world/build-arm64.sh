#!/bin/bash
#
# Cross-compile Hello World for ARM64 Linux (EC2 t4g instances)
#

set -e

echo "=== Cross-Compiling for ARM64 Linux ==="

cd "$(dirname "$0")"

# Step 1: Check for Linux SDK
echo "1. Checking for Linux ARM64 SDK..."

# List available SDKs
echo "Available SDKs:"
swift sdk list

echo ""
echo "2. Installing Linux ARM64 SDK (if needed)..."
echo "To install the SDK, run:"
echo "  swift sdk install https://download.swift.org/swift-6.0.2-release/ubuntu2204-aarch64/swift-6.0.2-RELEASE/swift-6.0.2-RELEASE-ubuntu22.04-aarch64.tar.gz"
echo ""
echo "OR try:"
echo "  swift sdk install 6.0.2-RELEASE_ubuntu_jammy_aarch64"
echo ""

# Step 3: Build for Linux ARM64
echo "3. Building for Linux ARM64..."

# Try different SDK names
SDK_NAMES=(
    "6.0.2-RELEASE_ubuntu_jammy_aarch64"
    "aarch64-swift-linux-gnu"
    "swift-6.0.2-RELEASE-ubuntu22.04-aarch64"
)

BUILD_SUCCESS=false

for SDK in "${SDK_NAMES[@]}"; do
    echo "Trying SDK: $SDK"
    if swift build --swift-sdk "$SDK" -c release 2>/dev/null; then
        echo "✅ Build successful with SDK: $SDK"
        BUILD_SUCCESS=true
        break
    fi
done

if [ "$BUILD_SUCCESS" = false ]; then
    echo "❌ Could not build with any SDK"
    echo ""
    echo "Manual build command:"
    echo "  swift build --swift-sdk <SDK_NAME> -c release"
    echo ""
    echo "The binary would be at:"
    echo "  .build/release/hello-world"
    exit 1
fi

# Step 4: Package for deployment
echo ""
echo "4. Creating deployment package..."

mkdir -p deploy-arm64
cp .build/release/hello-world deploy-arm64/
tar -czf hello-world-arm64.tar.gz deploy-arm64/

echo "✅ Package created: hello-world-arm64.tar.gz"
echo ""
echo "To deploy to EC2:"
echo "  scp -i ~/.ssh/your-key.pem hello-world-arm64.tar.gz ubuntu@your-ec2-ip:/tmp/"
echo ""
echo "On EC2:"
echo "  tar -xzf /tmp/hello-world-arm64.tar.gz"
echo "  ./deploy-arm64/hello-world"