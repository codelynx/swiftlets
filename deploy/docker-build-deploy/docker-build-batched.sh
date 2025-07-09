#!/bin/bash
#
# Build swiftlets in smaller batches to avoid timeouts
#

set -e

SITE_NAME="swiftlets-site"

echo "=== Batched Docker Build ==="
echo ""

cd "$(dirname "$0")/../.."
PROJECT_ROOT=$(pwd)

# First build the framework
echo "1. Building framework..."
docker run --rm \
    -v "$PROJECT_ROOT:/app" \
    -w /app \
    --platform linux/arm64 \
    swift:6.0.2 \
    bash -c "
        swift build -c release --product swiftlets-server
        mkdir -p bin/linux/arm64
        cp .build/release/swiftlets-server bin/linux/arm64/
    "

# Then build the site with increased memory and timeout settings
echo ""
echo "2. Building swiftlets (may take 10-15 minutes)..."
docker run --rm \
    -v "$PROJECT_ROOT:/app" \
    -w /app \
    --platform linux/arm64 \
    -m 4g \
    --cpus="2" \
    swift:6.0.2 \
    bash -c "
        # Increase timeout for each file
        export BUILD_TIMEOUT=120
        
        # Build with verbose output to see progress
        ./build-site sites/$SITE_NAME -v
        
        # Show results
        echo ''
        echo 'Build complete. Verifying...'
        find sites/$SITE_NAME/web -name '*.webbin' | wc -l
        echo 'webbin files created'
    "

echo ""
echo "✅ Build complete!"