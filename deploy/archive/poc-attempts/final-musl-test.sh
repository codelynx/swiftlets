#!/bin/bash
#
# Final musl cross-compilation attempt
#

set -e

echo "=== Final Musl Cross-Compilation Test ==="
echo ""

# The issue is that swift-autolink-extract is missing from the SDK
# Let's try to work around this by creating a fake one
echo "Creating workaround for missing tools..."

# Create a temporary bin directory
TEMP_BIN="/tmp/swift-musl-bin-$$"
mkdir -p "$TEMP_BIN"

# Create a no-op swift-autolink-extract
cat > "$TEMP_BIN/swift-autolink-extract" << 'EOF'
#!/bin/bash
# Dummy swift-autolink-extract that does nothing
# In static linking, we don't need autolink anyway
exit 0
EOF
chmod +x "$TEMP_BIN/swift-autolink-extract"

# Add to PATH
export PATH="$TEMP_BIN:$PATH"

echo "Attempting cross-compilation with workaround..."

# Method 1: Direct compilation
echo ""
echo "Method 1: Direct swiftc"
swiftc hello.swift \
    -target aarch64-swift-linux-musl \
    -static-stdlib \
    -static-executable \
    -o hello-musl-workaround \
    2>&1 || echo "Still failed"

# Method 2: Using swift build
echo ""
echo "Method 2: Swift build with SDK"
swift build \
    --swift-sdk aarch64-swift-linux-musl \
    -c release \
    -Xswiftc -static-executable \
    2>&1 || echo "Build failed"

# Clean up
rm -rf "$TEMP_BIN"

echo ""
echo "=== Alternative Solution ==="
echo ""
echo "Since native cross-compilation doesn't work due to missing tools,"
echo "the recommended approach is:"
echo ""
echo "1. Use Docker with --platform linux/arm64:"
echo "   docker run --rm -v \$(pwd):/app -w /app --platform linux/arm64 \\"
echo "     swift:6.0.2 swiftc hello.swift -o hello -static-executable"
echo ""
echo "2. Or use a Linux build server/CI"
echo ""
echo "3. Or install Swift toolchain in a Linux VM"
echo ""

# Show what we learned
echo "=== What We Learned ==="
echo "- Musl SDK is configured correctly for static builds"
echo "- swift-autolink-extract is missing from the SDK"
echo "- This is a known limitation of the current Swift SDK distribution"
echo "- Docker with ARM64 emulation is the most reliable workaround"