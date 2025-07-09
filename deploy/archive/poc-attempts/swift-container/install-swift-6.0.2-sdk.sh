#!/bin/bash
#
# Install Swift 6.0.2 Linux SDK for cross-compilation
#

set -e

echo "=== Installing Swift 6.0.2 Linux SDK ==="
echo ""

# Swift 6.0.2 static Linux SDK
SDK_URL="https://download.swift.org/swift-6.0.2-release/static-sdk/swift-6.0.2-RELEASE/swift-6.0.2-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz"

echo "1. Downloading Swift 6.0.2 SDK (297MB)..."
curl -L "$SDK_URL" -o swift-6.0.2-sdk.tar.gz

echo ""
echo "2. Installing SDK..."
swift sdk install swift-6.0.2-sdk.tar.gz

rm swift-6.0.2-sdk.tar.gz

echo ""
echo "✅ Swift 6.0.2 Linux SDK installed!"
echo ""
echo "Installed SDKs:"
swift sdk list

echo ""
echo "To use for cross-compilation:"
echo "  swift build --swift-sdk aarch64-swift-linux-musl"