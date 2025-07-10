#!/bin/bash
# POC script to build and test minimal containers with static binaries

set -e

echo "Building minimal container POC for Swiftlets..."
echo "This demonstrates static binaries for Apple's container service"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "ERROR: Docker is not running!"
    echo ""
    echo "Please start Docker Desktop and try again."
    echo ""
    echo "Alternatively, you can view the Dockerfiles directly:"
    echo "  - deploy/docker/Dockerfile.minimal (scratch-based)"
    echo "  - deploy/docker/Dockerfile.alpine-minimal (Alpine-based)"
    echo ""
    echo "Documentation: docs/apple-container-static-poc.md"
    exit 1
fi

# Ensure we're in project root
cd "$(dirname "$0")/../.."

# Build different container variants
echo "1. Building Alpine-based container (minimal with utilities)..."
docker buildx build \
    --platform linux/arm64 \
    -f deploy/docker/Dockerfile.alpine-minimal \
    -t swiftlets:alpine-minimal \
    --progress=plain \
    --load \
    .

echo ""
echo "2. Building Ubuntu-based minimal container..."
docker buildx build \
    --platform linux/arm64 \
    -f deploy/docker/Dockerfile.ubuntu-minimal \
    -t swiftlets:ubuntu-minimal \
    --progress=plain \
    --load \
    .

echo ""
echo "3. Comparing with updated Alpine container..."
docker buildx build \
    --platform linux/arm64 \
    -f deploy/docker/Dockerfile.alpine \
    -t swiftlets:alpine-updated \
    --progress=plain \
    --load \
    .

echo ""
echo "Container Size Comparison:"
echo "========================="
docker images --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}" | grep swiftlets

echo ""
echo "To test with Apple's container service:"
echo "1. Save the image: docker save swiftlets:alpine-minimal -o swiftlets-minimal.tar"
echo "2. Load in container: container load < swiftlets-minimal.tar"
echo "3. Run: container run swiftlets:alpine-minimal"

echo ""
echo "To test the containers:"
echo "  Ubuntu (works): docker run --rm swiftlets:ubuntu-minimal /app/swiftlets-server --help"
echo "  Alpine (needs more libs): docker run --rm swiftlets:alpine-minimal"
echo ""
echo "Note: Alpine containers need additional libraries for glibc-linked binaries."
echo "Ubuntu-based containers are more compatible with static stdlib Swift binaries."