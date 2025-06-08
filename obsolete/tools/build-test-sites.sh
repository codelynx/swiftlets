#!/bin/bash
# Build test sites using standalone versions

set -e

echo "Building test sites..."

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
case $ARCH in
    aarch64) ARCH="arm64" ;;
    arm64) ARCH="arm64" ;;
    x86_64) ARCH="x86_64" ;;
esac

# Build test-routing
echo "Building test-routing..."
mkdir -p core/sites/test-routing/web/bin/$OS/$ARCH
if [ -f "core/sites/test-routing/src/index-standalone.swift" ]; then
    swiftc -parse-as-library \
        core/Sources/SwiftletsCore/*.swift \
        core/Sources/SwiftletsHTML/Core/*.swift \
        core/Sources/SwiftletsHTML/Elements/*.swift \
        core/Sources/SwiftletsHTML/Helpers/*.swift \
        core/Sources/SwiftletsHTML/Layout/*.swift \
        core/Sources/SwiftletsHTML/Modifiers/*.swift \
        core/Sources/SwiftletsHTML/Builders/*.swift \
        core/sites/test-routing/src/index-standalone.swift \
        -o core/sites/test-routing/web/bin/$OS/$ARCH/index
    echo "✓ test-routing built"
    
    # Create webbin
    echo "# Test routing" > core/sites/test-routing/web/index.webbin
fi

# Build test-html  
echo "Building test-html..."
mkdir -p core/sites/test-html/web/bin/$OS/$ARCH
if [ -f "core/sites/test-html/src/index-standalone.swift" ]; then
    swiftc -parse-as-library \
        core/Sources/SwiftletsCore/*.swift \
        core/Sources/SwiftletsHTML/Core/*.swift \
        core/Sources/SwiftletsHTML/Elements/*.swift \
        core/Sources/SwiftletsHTML/Helpers/*.swift \
        core/Sources/SwiftletsHTML/Layout/*.swift \
        core/Sources/SwiftletsHTML/Modifiers/*.swift \
        core/Sources/SwiftletsHTML/Builders/*.swift \
        core/sites/test-html/src/index-standalone.swift \
        -o core/sites/test-html/web/bin/$OS/$ARCH/index
    echo "✓ test-html built"
    
    # Create webbin
    echo "# Test HTML" > core/sites/test-html/web/index.webbin
fi

echo ""
echo "Test sites built! You can now run:"
echo "  ./core/.build/release/swiftlets-server core/sites/test-routing"
echo "  ./core/.build/release/swiftlets-server core/sites/test-html"