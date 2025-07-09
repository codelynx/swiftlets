#!/bin/bash
#
# Simplified Docker build for swiftlets-site
#

set -e

SITE_NAME="swiftlets-site"

echo "=== Simple Docker Build for Swiftlets ==="
echo ""

# Go to project root
cd "$(dirname "$0")/../.."
PROJECT_ROOT=$(pwd)

# Create a temporary directory for clean build
BUILD_DIR="/tmp/swiftlets-build-$$"
echo "1. Creating clean build directory: $BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Copy only necessary files
echo "2. Copying source files..."
cp -r Package.swift Sources sites "$BUILD_DIR/"
cp build-site run-site "$BUILD_DIR/"
# Create empty Tests directory to satisfy Package.swift
mkdir -p "$BUILD_DIR/Tests/SwiftletsTests"

# Build in Docker
echo ""
echo "3. Building with Docker..."
cd "$BUILD_DIR"

docker run --rm \
    -v "$BUILD_DIR:/app" \
    -w /app \
    --platform linux/arm64 \
    swift:6.0.2 \
    bash -c "
        set -e
        
        echo 'Building Swiftlets framework...'
        swift build -c release -Xswiftc -static-executable
        
        echo ''
        echo 'Creating bin directory...'
        mkdir -p bin/linux/arm64
        cp .build/release/swiftlets-server bin/linux/arm64/
        
        echo ''
        echo 'Building site...'
        ./build-site sites/$SITE_NAME
        
        echo ''
        echo 'Build complete!'
        ls -la bin/linux/arm64/
        find sites/$SITE_NAME/webbin -name '*.webbin' | wc -l
    "

# Create deployment package
echo ""
echo "4. Creating deployment package..."
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
DEPLOY_PACKAGE="$PROJECT_ROOT/swiftlets-deploy-$TIMESTAMP.tar.gz"

tar -czf "$DEPLOY_PACKAGE" \
    bin/linux/arm64 \
    webbin \
    sites/$SITE_NAME/webbin \
    sites/$SITE_NAME/src \
    run-site

# Cleanup
echo "5. Cleaning up..."
rm -rf "$BUILD_DIR"

echo ""
echo "✅ Build complete!"
echo "   Package: $DEPLOY_PACKAGE"
echo "   Size: $(du -h "$DEPLOY_PACKAGE" | cut -f1)"
echo ""
echo "To deploy: ./deploy/docker-build-deploy/deploy-to-ec2.sh $DEPLOY_PACKAGE"