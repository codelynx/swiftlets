#!/bin/bash
#
# Build Hello World as a container using Swift Container Plugin
#

set -e

echo "=== Building Hello World Container ==="

# Step 1: Try to build container
echo "Building container image..."

cd "$(dirname "$0")"

# Build the container (local build only)
swift package --disable-sandbox \
    --allow-network-connections all \
    build-container-image \
    --product hello-world \
    --repository localhost/hello-swift \
    --tag latest

echo ""
echo "✅ Container built successfully!"
echo ""
echo "To run the container:"
echo "  docker run --rm hello-swift:latest"
echo ""
echo "To run with loop mode:"
echo "  docker run --rm hello-swift:latest --loop"