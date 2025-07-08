#!/bin/bash
#
# Build Swiftlets container using Swift Container Plugin
# This script creates OCI-compliant container images using Swift Package Manager
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPOSITORY=${1:-"swiftlets"}
TAG=${2:-"latest"}
PLATFORM=${3:-"linux/amd64"}  # or linux/arm64
REGISTRY=${4:-""}  # e.g., ghcr.io/username or docker.io/username

echo -e "${GREEN}=== Swiftlets Container Build ===${NC}"
echo "Repository: $REPOSITORY"
echo "Tag: $TAG"
echo "Platform: $PLATFORM"
echo "Registry: ${REGISTRY:-local}"

# Validate platform
case "$PLATFORM" in
    "linux/amd64")
        SWIFT_SDK="x86_64-swift-linux-musl"
        ;;
    "linux/arm64")
        SWIFT_SDK="aarch64-swift-linux-musl"
        ;;
    *)
        echo -e "${RED}Invalid platform: $PLATFORM${NC}"
        echo "Supported platforms: linux/amd64, linux/arm64"
        exit 1
        ;;
esac

# Check if Swift SDK is installed
echo -e "${YELLOW}Checking Swift SDK...${NC}"
if ! swift sdk list | grep -q "$SWIFT_SDK"; then
    echo -e "${YELLOW}Installing Swift SDK for $PLATFORM...${NC}"
    swift sdk install "$SWIFT_SDK"
fi

# Build server executable
echo -e "${BLUE}Building SwiftletsServer...${NC}"
swift build --product SwiftletsServer -c release --swift-sdk "$SWIFT_SDK"

# Prepare container repository name
if [ -n "$REGISTRY" ]; then
    FULL_REPOSITORY="${REGISTRY}/${REPOSITORY}"
else
    FULL_REPOSITORY="$REPOSITORY"
fi

# Build container image using Swift Container Plugin
echo -e "${BLUE}Building container image...${NC}"
swift package --swift-sdk "$SWIFT_SDK" \
    --scratch-path .build/container \
    --disable-sandbox \
    plugin build-container-image \
    --product swiftlets-server \
    --repository "$FULL_REPOSITORY" \
    --tag "$TAG"

# Build sites as separate layer (optional approach)
echo -e "${BLUE}Building sites...${NC}"
# Since the container plugin builds only the executable,
# we need to handle sites separately

# Create a temporary directory for the full deployment
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Copy the built executable
cp .build/release/SwiftletsServer "$TEMP_DIR/"

# Build sites
SITE_NAME="swiftlets-site"
echo -e "${YELLOW}Building site: $SITE_NAME${NC}"
./build-site "sites/$SITE_NAME" --platform linux --swift-sdk "$SWIFT_SDK"

# Copy site artifacts
cp -r bin "$TEMP_DIR/"
cp -r sites "$TEMP_DIR/"
cp run-site "$TEMP_DIR/"

echo -e "${GREEN}Container image built successfully!${NC}"
echo ""
echo "Image: ${FULL_REPOSITORY}:${TAG}"
echo ""
echo "To run locally:"
echo "  docker run -p 8080:8080 ${FULL_REPOSITORY}:${TAG}"
echo ""
echo "To push to registry:"
echo "  docker push ${FULL_REPOSITORY}:${TAG}"
echo ""
echo "Note: Since Swift Container Plugin builds only the executable,"
echo "you may need to create a custom container with sites included."