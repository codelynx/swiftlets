#!/bin/bash
#
# Install the latest Swift Static Linux SDK
#

set -e

echo "=== Installing Latest Swift Static Linux SDK ==="
echo ""

# Swift 6.0.2 Release - Latest stable
echo "Installing Swift 6.0.2 Static Linux SDK..."
echo ""

SDK_URL="https://download.swift.org/swift-6.0.2-release/static-sdk/swift-6.0.2-RELEASE/swift-6.0.2-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz"
SDK_CHECKSUM="aa5515476a403797223fc2aad4ca0c3bf83995d5427fb297cab1d93c68cee075"

echo "Downloading and installing..."
swift sdk install "$SDK_URL" --checksum "$SDK_CHECKSUM"

echo ""
echo "Installed SDKs:"
swift sdk list

echo ""
echo "Usage examples:"
echo ""
echo "Build for x86_64 Linux:"
echo "  swift build --swift-sdk x86_64-swift-linux-musl -c release"
echo ""
echo "Build for ARM64 Linux:"
echo "  swift build --swift-sdk aarch64-swift-linux-musl -c release"
echo ""
echo "Build and test your hello-world app:"
echo "  cd $(dirname "$0")"
echo "  swift build --swift-sdk aarch64-swift-linux-musl -c release"
echo "  # Binary will be at: .build/aarch64-swift-linux-musl/release/hello-world"