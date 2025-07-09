#!/bin/bash
#
# Try cross-compilation with known workarounds
#

set -e

echo "=== Testing Cross-Compilation Workarounds ==="
echo ""

# Clean previous attempts
rm -rf .build

# Method 1: Use the legacy driver workaround
echo "Method 1: Using -disallow-use-new-driver workaround"
echo "---------------------------------------------------"
swift build --swift-sdk swift-6.0.2-RELEASE_static-linux-0.0.1 \
    -c release \
    -Xswiftc -disallow-use-new-driver \
    2>&1 || echo "Workaround with 6.0.2 SDK failed"

echo ""

# Check if it produced anything
if [ -f .build/aarch64-swift-linux-musl/release/hello ]; then
    echo "✅ Success! Binary created:"
    file .build/aarch64-swift-linux-musl/release/hello
else
    echo "❌ No binary produced"
fi

echo ""

# Method 2: Try with explicit toolchain
echo "Method 2: Using explicit SDK path"
echo "---------------------------------"
SDK_PATH="$HOME/Library/org.swift.swiftpm/swift-sdks/swift-6.0.2-RELEASE_static-linux-0.0.1.artifactbundle/swift-6.0.2-RELEASE_static-linux-0.0.1/swift-linux-musl"

if [ -d "$SDK_PATH" ]; then
    echo "Found SDK at: $SDK_PATH"
    swiftc hello.swift \
        -target aarch64-swift-linux-musl \
        -sdk "$SDK_PATH" \
        -resource-dir "$SDK_PATH/usr/lib/swift" \
        -o hello-explicit \
        2>&1 || echo "Explicit SDK path failed"
else
    echo "SDK path not found"
fi

echo ""

# Method 3: Simple Docker ARM64 build
echo "Method 3: Docker ARM64 native build"
echo "-----------------------------------"
docker run --rm \
    -v $(pwd):/app \
    -w /app \
    --platform linux/arm64 \
    swift:6.0.2 \
    bash -c "swiftc hello.swift -o hello-arm64 && chmod 755 hello-arm64"

if [ -f hello-arm64 ]; then
    echo "✅ Docker ARM64 build successful:"
    file hello-arm64
fi