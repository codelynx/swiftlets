#!/bin/bash
#
# Investigate musl SDK structure and options
#

set -e

echo "=== Investigating Musl SDK ==="
echo ""

SDK_BASE="$HOME/Library/org.swift.swiftpm/swift-sdks"

# Check both SDK versions
for VERSION in "6.0.2" "6.1.2"; do
    echo "SDK Version: $VERSION"
    echo "-------------------"
    SDK_PATH="$SDK_BASE/swift-${VERSION}-RELEASE_static-linux-0.0.1.artifactbundle/swift-${VERSION}-RELEASE_static-linux-0.0.1"
    
    if [ -d "$SDK_PATH" ]; then
        echo "✓ Found at: $SDK_PATH"
        
        # Check swift-sdk.json
        if [ -f "$SDK_PATH/swift-linux-musl/swift-sdk.json" ]; then
            echo ""
            echo "SDK Configuration:"
            cat "$SDK_PATH/swift-linux-musl/swift-sdk.json" | jq '.' 2>/dev/null || cat "$SDK_PATH/swift-linux-musl/swift-sdk.json"
        fi
        
        # Check for tools
        echo ""
        echo "Looking for swift-autolink-extract:"
        find "$SDK_PATH" -name "*autolink*" -type f 2>/dev/null || echo "  Not found"
        
        # Check toolset
        if [ -f "$SDK_PATH/swift-linux-musl/toolset.json" ]; then
            echo ""
            echo "Toolset info:"
            cat "$SDK_PATH/swift-linux-musl/toolset.json"
        fi
    else
        echo "✗ Not found"
    fi
    echo ""
done

# Try alternative approach with environment variables
echo "Alternative: Setting up environment for musl"
echo "-------------------------------------------"

SDK_ROOT="$SDK_BASE/swift-6.0.2-RELEASE_static-linux-0.0.1.artifactbundle/swift-6.0.2-RELEASE_static-linux-0.0.1/swift-linux-musl"
MUSL_ROOT="$SDK_ROOT/musl-1.2.5.sdk/aarch64"

echo "Attempting with custom flags..."
swiftc hello.swift \
    -target aarch64-swift-linux-musl \
    -sdk "$MUSL_ROOT" \
    -tools-directory "$SDK_ROOT/swift.xctoolchain/usr/bin" \
    -Xlinker -nostdlib \
    -Xlinker -static \
    -o hello-musl-custom \
    2>&1 || echo "Custom flags approach failed"

echo ""

# Check what Docker actually uses
echo "Checking Docker's approach"
echo "-------------------------"
docker run --rm -v $(pwd):/app -w /app swift:6.0.2 \
    bash -c "
        which swift-autolink-extract || echo 'swift-autolink-extract not in PATH'
        echo ''
        echo 'Swift installation:'
        ls -la /usr/bin/swift*
        echo ''
        echo 'Building with verbose output:'
        swiftc hello.swift -o hello-docker-verbose -v 2>&1 | grep -E 'autolink|musl|static' || true
    "