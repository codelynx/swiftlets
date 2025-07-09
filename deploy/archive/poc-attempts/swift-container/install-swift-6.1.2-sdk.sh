#!/bin/bash
#
# Install Swift 6.1.2 Linux SDK for cross-compilation
#

set -e

echo "=== Installing Swift 6.1.2 Linux SDK ==="
echo ""

# First, let's check if we can use the official Swift SDK
echo "1. Checking for official Swift 6.1.2 static Linux SDK..."

# Swift 6.1.2 release date was around November 2024
# The static Linux SDK might be available from swift.org
SDK_URL="https://download.swift.org/swift-6.1.2-release/static-sdk/swift-6.1.2-RELEASE/swift-6.1.2-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz"

echo "   Checking if official SDK exists..."
if curl -s --head "$SDK_URL" | grep -q "200 OK"; then
    echo "   ✅ Found official Swift 6.1.2 static Linux SDK!"
    
    echo ""
    echo "2. Downloading SDK..."
    curl -L "$SDK_URL" -o swift-6.1.2-sdk.tar.gz
    
    echo ""
    echo "3. Installing SDK..."
    swift sdk install swift-6.1.2-sdk.tar.gz
    
    rm swift-6.1.2-sdk.tar.gz
    
    echo ""
    echo "✅ Swift 6.1.2 Linux SDK installed!"
else
    echo "   ❌ Official SDK not found. Trying swift-sdk-generator..."
    
    # Alternative: Build SDK using swift-sdk-generator
    echo ""
    echo "2. Installing swift-sdk-generator..."
    
    # Clone or update swift-sdk-generator
    if [ -d "swift-sdk-generator" ]; then
        cd swift-sdk-generator
        git pull
    else
        git clone https://github.com/swiftlang/swift-sdk-generator.git
        cd swift-sdk-generator
    fi
    
    # Check out Swift 6.1 compatible version
    git checkout swift-6.1-RELEASE || git checkout main
    
    echo ""
    echo "3. Building Linux ARM64 SDK..."
    
    # Build the SDK for Linux ARM64
    swift run swift-sdk-generator make-linux-sdk \
        --swift-version 6.1.2 \
        --arch aarch64 \
        --with-static-swift-stdlib
    
    echo ""
    echo "4. Installing generated SDK..."
    
    # Find the generated SDK
    SDK_PATH=$(find .build -name "*.artifactbundle" -type d | head -1)
    if [ -n "$SDK_PATH" ]; then
        # Create tar.gz from artifactbundle
        tar -czf generated-sdk.tar.gz -C "$(dirname "$SDK_PATH")" "$(basename "$SDK_PATH")"
        swift sdk install generated-sdk.tar.gz
        rm generated-sdk.tar.gz
        
        echo ""
        echo "✅ Generated Swift 6.1.2 Linux SDK installed!"
    else
        echo "❌ Failed to generate SDK"
        exit 1
    fi
fi

echo ""
echo "5. Verifying installation..."
echo ""
echo "Installed SDKs:"
swift sdk list

echo ""
echo "To use the new SDK for cross-compilation:"
echo "  swift build --swift-sdk aarch64-swift-linux-musl"
echo ""
echo "Or for glibc-based Linux:"
echo "  swift build --swift-sdk aarch64-unknown-linux-gnu"