#!/bin/bash
# Build Swiftlets for EC2 ARM64 deployment with static binaries
# This script builds static binaries that don't require Swift runtime on EC2

set -e

# Configuration
SITE_NAME="${1:-swiftlets-site}"
IMAGE_TAG="swiftlets-ec2-static"
PLATFORM="linux/arm64"

echo "Building Swiftlets for EC2 ARM64 deployment..."
echo "Site: $SITE_NAME"
echo "Platform: $PLATFORM"
echo ""

# Ensure we're in the project root
cd "$(dirname "$0")/../.."

# Build with Alpine Dockerfile for static binaries
echo "Building Docker image with static binaries..."
docker buildx build \
    --platform "$PLATFORM" \
    --build-arg SITE_NAME="$SITE_NAME" \
    -f deploy/docker/Dockerfile.alpine \
    -t "$IMAGE_TAG" \
    --progress=plain \
    .

echo ""
echo "Build complete!"
echo ""
echo "To extract the static binaries:"
echo "1. Create a container: docker create --name extract $IMAGE_TAG"
echo "2. Copy binaries: docker cp extract:/app/bin ./static-bin"
echo "3. Copy site files: docker cp extract:/app/sites ./static-sites"
echo "4. Clean up: docker rm extract"
echo ""
echo "The extracted binaries will be fully static and can run on any Linux ARM64 system without Swift runtime."