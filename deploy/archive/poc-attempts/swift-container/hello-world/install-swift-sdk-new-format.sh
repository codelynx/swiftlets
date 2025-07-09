#!/bin/bash
#
# Install Swift SDK using the new format (Swift 5.9+)
# Using the official static Linux SDK for cross-compilation
#

set -e

echo "=== Installing Swift SDK (New Format) ==="

cd "$(dirname "$0")"

# Option 1: Use the official static Linux SDK
echo "Installing official Swift Static Linux SDK..."

# For ARM64
SDK_URL="https://download.swift.org/swift-6.0-branch/static-sdk/swift-6.0-DEVELOPMENT-SNAPSHOT-2024-07-02-a/swift-6.0-DEVELOPMENT-SNAPSHOT-2024-07-02-a_static-linux-0.0.1.artifactbundle.tar.gz"
SDK_CHECKSUM="42a361e1a240e97e4bb3a388f2f947409011dcd3d3f20b396c28999e9736df36"

echo "Downloading Static Linux SDK..."
swift sdk install "$SDK_URL" --checksum "$SDK_CHECKSUM"

echo ""
echo "Available SDKs:"
swift sdk list

echo ""
echo "To build with the SDK:"
echo "  swift build --swift-sdk aarch64-swift-linux-musl -c release"
echo ""
echo "Or for x86_64:"
echo "  swift build --swift-sdk x86_64-swift-linux-musl -c release"