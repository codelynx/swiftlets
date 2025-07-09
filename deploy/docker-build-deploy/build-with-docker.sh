#!/bin/bash
#
# Build swiftlets-site using Docker
# Creates static binaries that don't need Swift runtime
#

set -e

# Configuration
SWIFT_VERSION="6.0.2"
SITE_NAME="swiftlets-site"

echo "=== Building Swiftlets with Docker ==="
echo "Swift version: $SWIFT_VERSION"
echo "Site: $SITE_NAME"
echo ""

# Go to project root
cd "$(dirname "$0")/../.."
PROJECT_ROOT=$(pwd)

# Clean previous builds
echo "1. Cleaning previous builds..."
# Use Docker to clean with proper permissions
docker run --rm -v "$PROJECT_ROOT:/workspace:rw" -w /workspace -u root alpine:latest \
    rm -rf .build bin/linux/arm64 webbin

# Build the Swiftlets framework and server
echo ""
echo "2. Building Swiftlets framework (static)..."
docker run --rm \
    -v "$PROJECT_ROOT:/workspace:rw" \
    -w /workspace \
    --platform linux/arm64 \
    -u root \
    swift:$SWIFT_VERSION \
    bash -c "
        echo 'Building for Linux ARM64...'
        swift build -c release -Xswiftc -static-executable
        
        # Create bin directory structure
        mkdir -p bin/linux/arm64
        
        # Copy server binary
        cp .build/release/swiftlets-server bin/linux/arm64/
        
        echo ''
        echo 'Built binaries:'
        ls -la .build/release/
        
        # Fix permissions
        chown -R $(id -u):$(id -g) .build bin || true
    "

# Build the site
echo ""
echo "3. Building $SITE_NAME..."
docker run --rm \
    -v "$PROJECT_ROOT:/workspace:rw" \
    -w /workspace \
    --platform linux/arm64 \
    -u root \
    swift:$SWIFT_VERSION \
    bash -c "
        # Run build-site script
        ./build-site sites/$SITE_NAME
        
        # Fix permissions
        chown -R $(id -u):$(id -g) webbin sites/$SITE_NAME/webbin || true
    "

# Check results
echo ""
echo "4. Build results:"
echo "   Server binary: $(file bin/linux/arm64/swiftlets-server 2>/dev/null || echo 'Not found')"
echo "   Site files: $(find sites/$SITE_NAME/webbin -name "*.webbin" | wc -l) webbin files"

# Create deployment package
echo ""
echo "5. Creating deployment package..."
DEPLOY_PACKAGE="swiftlets-deploy-$(date +%Y%m%d-%H%M%S).tar.gz"

tar -czf "$DEPLOY_PACKAGE" \
    --exclude='.build' \
    --exclude='.git' \
    --exclude='*.swift' \
    bin/linux/arm64 \
    webbin \
    sites/$SITE_NAME/webbin \
    sites/$SITE_NAME/src \
    run-site

echo "   Package created: $DEPLOY_PACKAGE"
echo "   Size: $(du -h $DEPLOY_PACKAGE | cut -f1)"

echo ""
echo "✅ Docker build complete!"
echo ""
echo "Next step: Run ./deploy-to-ec2.sh $DEPLOY_PACKAGE"