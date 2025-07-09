#!/bin/bash
#
# Quick test to build just a few swiftlets
#

set -e

echo "=== Quick Docker Build Test ==="
echo ""

# Test with just one file first
docker run --rm \
    -v $(pwd):/app \
    -w /app \
    --platform linux/arm64 \
    swift:6.0.2 \
    bash -c "
        # Build framework first
        echo 'Building framework...'
        swift build -c release --product swiftlets-server
        
        # Test building one swiftlet
        echo ''
        echo 'Testing build-site with one file...'
        ./build-site sites/swiftlets-site -v
    "

echo ""
echo "If this works, the full build should work too."