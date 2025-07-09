#!/bin/bash
#
# Docker build for swiftlets-site with dynamic linking
# Packages Swift runtime libraries with the deployment
#

set -e

SITE_NAME="swiftlets-site"

echo "=== Docker Build for Swiftlets (Dynamic) ==="
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
mkdir -p "$BUILD_DIR/Tests/SwiftletsTests"

# Build in Docker
echo ""
echo "3. Building with Docker (dynamic linking)..."
cd "$BUILD_DIR"

docker run --rm \
    -v "$BUILD_DIR:/app" \
    -w /app \
    --platform linux/arm64 \
    swift:6.0.2 \
    bash -c "
        set -e
        
        echo 'Building Swiftlets framework...'
        swift build -c release
        
        echo ''
        echo 'Creating deployment structure...'
        mkdir -p deploy/bin/linux/arm64
        mkdir -p deploy/lib
        
        # Copy server binary
        cp .build/release/swiftlets-server deploy/bin/linux/arm64/
        
        # Copy Swift runtime libraries
        echo 'Copying Swift runtime libraries...'
        for lib in \$(ldd .build/release/swiftlets-server | grep swift | awk '{print \$3}'); do
            if [ -f \"\$lib\" ]; then
                cp \"\$lib\" deploy/lib/
            fi
        done
        
        # Copy other required libraries
        cp /lib/aarch64-linux-gnu/libm.so.6 deploy/lib/ || true
        cp /lib/aarch64-linux-gnu/libpthread.so.0 deploy/lib/ || true
        cp /lib/aarch64-linux-gnu/libdl.so.2 deploy/lib/ || true
        cp /lib/aarch64-linux-gnu/librt.so.1 deploy/lib/ || true
        
        echo ''
        echo 'Building site...'
        ./build-site sites/$SITE_NAME
        
        echo ''
        echo 'Creating run wrapper...'
        cat > deploy/run-server.sh << 'EOF'
#!/bin/bash
DIR=\"\$(cd \"\$(dirname \"\${BASH_SOURCE[0]}\")\" && pwd)\"
export LD_LIBRARY_PATH=\"\$DIR/lib:\$LD_LIBRARY_PATH\"
\"\$DIR/bin/linux/arm64/swiftlets-server\" \"\$@\"
EOF
        chmod +x deploy/run-server.sh
        
        echo ''
        echo 'Build complete!'
        ls -la deploy/bin/linux/arm64/
        ls -la deploy/lib/ | wc -l
        find sites/$SITE_NAME/webbin -name '*.webbin' | wc -l
    "

# Create deployment package
echo ""
echo "4. Creating deployment package..."
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
DEPLOY_PACKAGE="$PROJECT_ROOT/swiftlets-dynamic-$TIMESTAMP.tar.gz"

tar -czf "$DEPLOY_PACKAGE" \
    deploy \
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
echo "This package includes Swift runtime libraries."
echo "To deploy: ./deploy/docker-build-deploy/deploy-dynamic.sh $DEPLOY_PACKAGE"