#!/bin/bash
#
# Test musl-based cross-compilation
#

set -e

echo "=== Testing Musl Cross-Compilation ==="
echo ""
echo "Local Swift: $(swift --version | head -1)"
echo ""

# Clean up
rm -rf .build
rm -f hello-musl*

# Test 1: Direct swiftc with musl target
echo "Test 1: Direct swiftc with musl target"
echo "--------------------------------------"
SDK_ROOT="$HOME/Library/org.swift.swiftpm/swift-sdks/swift-6.0.2-RELEASE_static-linux-0.0.1.artifactbundle/swift-6.0.2-RELEASE_static-linux-0.0.1/swift-linux-musl"

if [ -d "$SDK_ROOT" ]; then
    echo "Using SDK at: $SDK_ROOT"
    
    # Try with full SDK path
    swiftc hello.swift \
        -target aarch64-swift-linux-musl \
        -sdk "$SDK_ROOT/musl-1.2.5.sdk/aarch64" \
        -static-stdlib \
        -o hello-musl-direct \
        2>&1 || echo "Direct compilation failed"
fi

echo ""

# Test 2: Using swift build with package
echo "Test 2: Swift build with musl SDK"
echo "---------------------------------"

# Ensure we have a clean Package.swift
cat > Package.swift << 'EOF'
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HelloMusl",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(name: "hello-musl", targets: ["Hello"])
    ],
    targets: [
        .executableTarget(
            name: "Hello",
            path: ".",
            sources: ["hello.swift"]
        )
    ]
)
EOF

# Try with 6.0.2 SDK and various flags
echo "Attempting with legacy driver..."
swift build \
    --swift-sdk swift-6.0.2-RELEASE_static-linux-0.0.1 \
    -c release \
    --static-swift-stdlib \
    -Xswiftc -disallow-use-new-driver \
    2>&1 || echo "Build with legacy driver failed"

echo ""

# Test 3: Check toolchain components
echo "Test 3: Checking SDK toolchain"
echo "------------------------------"
TOOLCHAIN_PATH="$SDK_ROOT/swift.xctoolchain/usr/bin"
if [ -d "$TOOLCHAIN_PATH" ]; then
    echo "Toolchain binaries:"
    ls -la "$TOOLCHAIN_PATH" | grep -E "swift|autolink" || echo "No relevant tools found"
else
    echo "Toolchain not found at expected path"
fi

echo ""

# Test 4: Manual linking approach
echo "Test 4: Manual compilation steps"
echo "--------------------------------"
# First compile to object file
swiftc hello.swift \
    -target aarch64-swift-linux-musl \
    -sdk "$SDK_ROOT/musl-1.2.5.sdk/aarch64" \
    -c \
    -o hello.o \
    2>&1 || echo "Object compilation failed"

if [ -f hello.o ]; then
    echo "✓ Object file created"
    file hello.o
fi

echo ""

# Test 5: Alternative - use Docker to verify what should work
echo "Test 5: Docker comparison (what should work)"
echo "-------------------------------------------"
docker run --rm -v $(pwd):/app -w /app swift:6.0.2 \
    bash -c "
        # Show what a working musl build looks like
        apt-get update -qq && apt-get install -y musl-tools musl-dev >/dev/null 2>&1
        echo 'Musl installed, attempting static build...'
        swiftc hello.swift -o hello-musl-docker -static-executable 2>&1 || \
        swiftc hello.swift -o hello-musl-docker -static-stdlib
    "

if [ -f hello-musl-docker ]; then
    echo "✓ Docker musl build succeeded"
    file hello-musl-docker
fi

echo ""
echo "=== Summary ==="
ls -la hello-musl* 2>/dev/null || echo "No musl binaries produced locally"