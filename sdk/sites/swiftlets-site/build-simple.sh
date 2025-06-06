#!/bin/bash
# Simple build script for swiftlets-site

echo "Building swiftlets-site..."

# Detect platform
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Normalize architecture
case $ARCH in
    aarch64) ARCH="arm64" ;;
    arm64) ARCH="arm64" ;;
    x86_64) ARCH="x86_64" ;;
esac

# Create output directory
mkdir -p "web/bin/$OS/$ARCH"

# Build the standalone version
echo "Compiling index-standalone.swift..."
swiftc -parse-as-library \
    ../../../core/Sources/SwiftletsCore/*.swift \
    ../../../core/Sources/SwiftletsHTML/Core/*.swift \
    ../../../core/Sources/SwiftletsHTML/Elements/*.swift \
    ../../../core/Sources/SwiftletsHTML/Helpers/*.swift \
    ../../../core/Sources/SwiftletsHTML/Layout/*.swift \
    ../../../core/Sources/SwiftletsHTML/Modifiers/*.swift \
    ../../../core/Sources/SwiftletsHTML/Builders/*.swift \
    src/index-standalone.swift \
    -o "web/bin/$OS/$ARCH/index"

if [ $? -eq 0 ]; then
    echo "✓ Build successful!"
    echo ""
    echo "Executable created at: web/bin/$OS/$ARCH/index"
    echo ""
    echo "To run the site:"
    echo "  cd ../../.."
    echo "  SWIFTLETS_SITE=sdk/sites/swiftlets-site ./core/.build/release/swiftlets-server"
else
    echo "✗ Build failed"
    exit 1
fi