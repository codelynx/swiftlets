#!/bin/bash
# Setup Docker buildx for multi-platform builds
# This enables native ARM64 builds instead of slow emulation

set -e

echo "Setting up Docker buildx for multi-platform builds..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker first."
    exit 1
fi

# Create buildx builder instance
echo "Creating buildx builder..."
docker buildx create --name swiftlets-builder --use --bootstrap

# Verify platforms
echo ""
echo "Available platforms:"
docker buildx inspect --bootstrap | grep Platforms

echo ""
echo "Buildx setup complete!"
echo ""
echo "Usage examples:"
echo ""
echo "1. Build for Linux ARM64 (EC2 t4g instances):"
echo "   docker buildx build --platform linux/arm64 -f deploy/docker/Dockerfile.alpine -t swiftlets-arm64 ."
echo ""
echo "2. Build for both ARM64 and x86_64:"
echo "   docker buildx build --platform linux/arm64,linux/amd64 -f deploy/docker/Dockerfile.alpine -t swiftlets:multi ."
echo ""
echo "3. Build and push to registry:"
echo "   docker buildx build --platform linux/arm64 -f deploy/docker/Dockerfile.alpine -t myregistry/swiftlets:latest --push ."
echo ""
echo "4. Build and load locally (single platform only):"
echo "   docker buildx build --platform linux/arm64 -f deploy/docker/Dockerfile.alpine -t swiftlets-arm64 --load ."