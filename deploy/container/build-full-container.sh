#!/bin/bash
#
# Build complete Swiftlets container with sites
# This combines Swift Container Plugin with additional layers
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
SITE_NAME=${1:-"swiftlets-site"}
REPOSITORY=${2:-"swiftlets-full"}
TAG=${3:-"latest"}
PLATFORM=${4:-"linux/amd64"}
REGISTRY=${5:-""}

echo -e "${GREEN}=== Swiftlets Full Container Build ===${NC}"
echo "Site: $SITE_NAME"
echo "Repository: $REPOSITORY"
echo "Tag: $TAG"
echo "Platform: $PLATFORM"

# Step 1: Build base container with Swift Container Plugin
echo -e "${BLUE}Building base container...${NC}"
./deploy/container/build-container.sh "swiftlets-base" "latest" "$PLATFORM" ""

# Step 2: Build sites for the target platform
case "$PLATFORM" in
    "linux/amd64")
        SWIFT_SDK="x86_64-swift-linux-musl"
        ARCH="x86_64"
        ;;
    "linux/arm64")
        SWIFT_SDK="aarch64-swift-linux-musl"
        ARCH="aarch64"
        ;;
esac

echo -e "${BLUE}Building site: $SITE_NAME for $ARCH...${NC}"
./build-site "sites/$SITE_NAME" --platform linux --arch "$ARCH" --swift-sdk "$SWIFT_SDK"

# Step 3: Create build context
BUILD_DIR="deploy/container/build-context"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Copy necessary files to build context
cp -r bin "$BUILD_DIR/"
cp -r sites "$BUILD_DIR/"
cp run-site "$BUILD_DIR/"

# Step 4: Build final container
echo -e "${BLUE}Building final container...${NC}"

if [ -n "$REGISTRY" ]; then
    FULL_REPOSITORY="${REGISTRY}/${REPOSITORY}"
else
    FULL_REPOSITORY="$REPOSITORY"
fi

# Build using ContainerFile
docker build \
    --platform "$PLATFORM" \
    --build-arg BASE_IMAGE="swiftlets-base:latest" \
    --build-arg SITE_NAME="$SITE_NAME" \
    -f deploy/container/ContainerFile \
    -t "${FULL_REPOSITORY}:${TAG}" \
    "$BUILD_DIR"

# Clean up
rm -rf "$BUILD_DIR"

echo -e "${GREEN}Full container built successfully!${NC}"
echo ""
echo "Image: ${FULL_REPOSITORY}:${TAG}"
echo ""
echo "To run:"
echo "  docker run -p 8080:8080 ${FULL_REPOSITORY}:${TAG}"
echo ""
echo "To push:"
echo "  docker push ${FULL_REPOSITORY}:${TAG}"