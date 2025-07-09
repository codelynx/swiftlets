#!/bin/bash
#
# Docker build with better progress tracking and error handling
#

set -e

SITE_NAME="swiftlets-site"

echo "=== Docker Build with Progress Tracking ==="
echo ""

# Go to project root
cd "$(dirname "$0")/../.."
PROJECT_ROOT=$(pwd)

# Create a temporary directory
BUILD_DIR="/tmp/swiftlets-build-$$"
echo "1. Creating clean build directory: $BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Copy source files
echo "2. Copying source files..."
cp -r Package.swift Sources sites build-site run-site "$BUILD_DIR/"
mkdir -p "$BUILD_DIR/Tests/SwiftletsTests"

# Build in Docker with explicit timeout and progress
echo ""
echo "3. Building with Docker (this may take 10-15 minutes)..."
cd "$BUILD_DIR"

# Use timeout command to prevent hanging
timeout 1200 docker run --rm \
    -v "$BUILD_DIR:/app" \
    -w /app \
    --platform linux/arm64 \
    swift:6.0.2 \
    bash -c "
        set -e
        
        echo '=== Phase 1: Building Framework ==='
        time swift build -c release --product swiftlets-server
        
        echo ''
        echo '=== Phase 2: Setting up directories ==='
        mkdir -p bin/linux/arm64
        cp .build/release/swiftlets-server bin/linux/arm64/
        echo 'Server binary ready'
        
        echo ''
        echo '=== Phase 3: Building all swiftlets ==='
        echo 'This will build 27 Swift files...'
        echo ''
        
        # Run build-site with verbose output
        ./build-site sites/$SITE_NAME -v || {
            echo ''
            echo '❌ Build failed! Checking what was built...'
            find sites/$SITE_NAME/web -name '*.webbin' -type f | wc -l
            echo 'webbin files were created'
            exit 1
        }
        
        echo ''
        echo '=== Phase 4: Build verification ==='
        SWIFT_COUNT=\$(find sites/$SITE_NAME/src -name '*.swift' -type f | grep -v '/shared/' | grep -v 'Components.swift' | wc -l)
        WEBBIN_COUNT=\$(find sites/$SITE_NAME/web -name '*.webbin' -type f | wc -l)
        
        echo \"Source Swift files: \$SWIFT_COUNT\"
        echo \"Built webbin files: \$WEBBIN_COUNT\"
        
        if [ \"\$SWIFT_COUNT\" -ne \"\$WEBBIN_COUNT\" ]; then
            echo ''
            echo '⚠️  Not all files were built!'
            echo 'Checking which files are missing...'
            
            # List missing files
            find sites/$SITE_NAME/src -name '*.swift' -type f | grep -v '/shared/' | grep -v 'Components.swift' | while read src; do
                rel=\${src#sites/$SITE_NAME/src/}
                webbin=\"sites/$SITE_NAME/web/\${rel%.swift}.webbin\"
                if [ ! -f \"\$webbin\" ]; then
                    echo \"  Missing: \$rel\"
                fi
            done
        else
            echo ''
            echo '✅ All swiftlets built successfully!'
        fi
        
        # Package runtime libraries
        echo ''
        echo '=== Phase 5: Packaging libraries ==='
        mkdir -p deploy/lib
        ldd .build/release/swiftlets-server | grep swift | awk '{print \$3}' | while read lib; do
            if [ -f \"\$lib\" ]; then
                cp \"\$lib\" deploy/lib/
            fi
        done
        echo \"Copied \$(ls deploy/lib | wc -l) runtime libraries\"
        
        echo ''
        echo '=== Build Summary ==='
        echo \"Framework: ✓\"
        echo \"Swiftlets built: \$WEBBIN_COUNT of \$SWIFT_COUNT\"
        echo \"Runtime libs: \$(ls deploy/lib | wc -l)\"
        echo ''
        echo 'Build process complete!'
    " 2>&1 | tee build.log

# Check if Docker completed successfully
if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo ""
    echo "❌ Docker build failed or timed out!"
    echo "Check build.log for details"
    
    # Show what was built
    if [ -d "sites/$SITE_NAME/web" ]; then
        BUILT=$(find sites/$SITE_NAME/web -name "*.webbin" -type f | wc -l)
        echo "Partially built: $BUILT webbin files"
    fi
    
    # Cleanup and exit
    rm -rf "$BUILD_DIR"
    exit 1
fi

# Create deployment package
echo ""
echo "4. Creating deployment package..."
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
DEPLOY_PACKAGE="$PROJECT_ROOT/swiftlets-docker-$TIMESTAMP.tar.gz"

tar -czf "$DEPLOY_PACKAGE" \
    bin/linux/arm64 \
    webbin \
    sites/$SITE_NAME/web \
    sites/$SITE_NAME/src \
    run-site \
    deploy \
    build.log

# Cleanup
echo "5. Cleaning up..."
rm -rf "$BUILD_DIR"

echo ""
echo "✅ Docker build complete!"
echo ""
echo "Package: $DEPLOY_PACKAGE"
echo "Size: $(du -h "$DEPLOY_PACKAGE" | cut -f1)"
echo "Build log included in package"
echo ""
echo "To verify the build:"
echo "  tar -tzf $DEPLOY_PACKAGE | grep -c '\\.webbin$'"
echo ""
echo "To deploy:"
echo "  ./deploy/docker-build-deploy/deploy-to-ec2.sh $DEPLOY_PACKAGE"