#\!/bin/bash
#
# Complete Docker build including all executables
#

set -e

SITE_NAME="swiftlets-site"

echo "=== Complete Docker Build for Linux ARM64 ==="
echo ""

cd "$(dirname "$0")/../.."
PROJECT_ROOT=$(pwd)

# Clean previous builds
echo "1. Cleaning previous Linux builds..."
rm -rf bin/linux sites/$SITE_NAME/bin

# Build everything in Docker
echo ""
echo "2. Building in Docker (this will take 10-20 minutes)..."
docker run --rm \
    -v "$PROJECT_ROOT:/app" \
    -w /app \
    --platform linux/arm64 \
    -m 4g \
    --cpus="2" \
    swift:6.0.2 \
    bash -c "
        set -e
        
        echo '=== Building Swiftlets Framework ==='
        swift build -c release --product swiftlets-server
        mkdir -p bin/linux/arm64
        cp .build/release/swiftlets-server bin/linux/arm64/
        
        echo ''
        echo '=== Building Site Executables ==='
        # Force rebuild all executables
        rm -rf sites/$SITE_NAME/bin
        ./build-site sites/$SITE_NAME -v --force
        
        echo ''
        echo '=== Verification ==='
        echo 'Checking executable format...'
        file sites/$SITE_NAME/bin/index | head -1
        echo ''
        echo 'Counting built executables...'
        find sites/$SITE_NAME/bin -type f -executable | wc -l
        echo 'executables built'
    "

echo ""
echo "3. Creating deployment package..."
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
DEPLOY_PACKAGE="swiftlets-complete-$TIMESTAMP.tar.gz"

# Extract runtime libraries from Docker
docker run --rm \
    -v "$PROJECT_ROOT:/app" \
    -w /app \
    --platform linux/arm64 \
    swift:6.0.2 \
    bash -c '
        mkdir -p runtime-libs
        # Copy Swift runtime libraries
        cp -L /usr/lib/swift/linux/*.so runtime-libs/ 2>/dev/null || true
        # Find additional dependencies
        ldd .build/release/swiftlets-server | grep "=>" | awk "{print \$3}" | while read lib; do
            if [ -f "$lib" ] && [[ "$lib" == *swift* || "$lib" == *Foundation* || "$lib" == *Dispatch* ]]; then
                cp -L "$lib" runtime-libs/ 2>/dev/null || true
            fi
        done
        echo "Packaged $(ls runtime-libs | wc -l) runtime libraries"
    '

# Create deployment package
tar -czf "$DEPLOY_PACKAGE" \
    bin/linux/arm64 \
    sites/$SITE_NAME/bin \
    sites/$SITE_NAME/web \
    sites/$SITE_NAME/src \
    runtime-libs \
    run-site

echo "Package: $DEPLOY_PACKAGE"
echo "Size: $(du -h "$DEPLOY_PACKAGE" | cut -f1)"

echo ""
echo "4. Deploying to EC2..."
./deploy/docker-build-deploy/deploy-package-to-ec2.sh "$DEPLOY_PACKAGE"

# Cleanup
rm -rf runtime-libs
