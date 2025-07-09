#!/bin/bash
#
# Working cross-compilation solution
#

set -e

echo "=== Cross-compiling Swiftlets with Swift 6.0.2 ==="
echo ""

# Option 1: Build natively for Linux inside Docker (not cross-compilation, but works)
echo "Building for Linux ARM64 in Docker..."
docker run --rm \
    -v $(pwd):/workspace \
    -w /workspace \
    --platform linux/arm64 \
    swift:6.0.2 \
    swift build -c release

echo ""
echo "✅ Build complete!"
echo ""
echo "Built binaries:"
ls -la .build/release/swiftlets-server

echo ""
echo "To deploy these binaries to EC2:"
echo "1. Copy .build/release/* to EC2"
echo "2. Run directly (no Swift needed on EC2)"