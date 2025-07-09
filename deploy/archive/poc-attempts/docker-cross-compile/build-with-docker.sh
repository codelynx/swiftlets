#!/bin/bash
#
# Cross-compile Swiftlets using Docker with Swift 6.0.2
#

set -e

# Build the Docker image with Swift 6.0.2
echo "=== Building Docker image with Swift 6.0.2 ==="
docker build -t swift-cross-compile:6.0.2 .

# Go to project root
cd ../..

echo ""
echo "=== Cross-compiling Swiftlets with Swift 6.0.2 ==="

# Run cross-compilation in Docker
docker run --rm \
    -v $(pwd):/build \
    -v $HOME/.cache:/root/.cache \
    swift-cross-compile:6.0.2

echo ""
echo "✅ Cross-compilation complete!"
echo ""
echo "Built binaries are in:"
echo "  .build/aarch64-swift-linux-musl/release/"