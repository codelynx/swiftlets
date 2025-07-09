#!/bin/bash
#
# Simple cross-compilation without SDK installation
# Uses Docker for cross-compilation
#

set -e

echo "=== Cross-Compiling for ARM64 Linux ==="

cd "$(dirname "$0")"

# Option 1: Use Docker
echo "Option 1: Using Docker for cross-compilation"
echo ""

# Check if Docker is running
if docker info >/dev/null 2>&1; then
    echo "Building with Docker..."
    
    # Create a Dockerfile for building
    cat > Dockerfile.build << 'EOF'
FROM swift:6.0.2-jammy

WORKDIR /build
COPY Package.swift .
COPY Sources Sources/

RUN swift build -c release --static-swift-stdlib

# Copy the binary to a known location
RUN cp .build/release/hello-world /hello-world-linux-arm64
EOF

    # Build using Docker
    docker build -f Dockerfile.build -t hello-builder .
    
    # Extract the binary
    docker create --name extract hello-builder
    docker cp extract:/hello-world-linux-arm64 ./hello-world-linux-arm64
    docker rm extract
    
    echo "✅ Binary built: hello-world-linux-arm64"
    echo ""
    echo "To deploy to EC2:"
    echo "  scp -i ~/.ssh/<YOUR-KEY-NAME>.pem hello-world-linux-arm64 ubuntu@<YOUR-EC2-IP>:/tmp/"
    echo "  ssh -i ~/.ssh/<YOUR-KEY-NAME>.pem ubuntu@<YOUR-EC2-IP>"
    echo "  chmod +x /tmp/hello-world-linux-arm64 && /tmp/hello-world-linux-arm64"
else
    echo "Docker is not running. Please start Docker Desktop."
    echo ""
    echo "Alternative: Copy source to EC2 and build there"
    echo "  tar -czf hello-src.tar.gz Package.swift Sources"
    echo "  scp -i ~/.ssh/<YOUR-KEY-NAME>.pem hello-src.tar.gz ubuntu@<YOUR-EC2-IP>:/tmp/"
fi