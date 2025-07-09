#!/bin/bash
#
# Build Swiftlets container with cross-compilation for Linux ARM64
#

set -e

echo "=== Building Swiftlets Container ==="
echo ""

# Check if we have the Linux SDK installed
SDK_NAME=$(swift sdk list | grep -E "static-linux|swift-linux-musl" | head -1 | xargs)
if [ -z "$SDK_NAME" ]; then
    echo "❌ Linux SDK not found!"
    echo ""
    echo "Install it with:"
    echo "  ../hello-world/install-latest-sdk.sh"
    exit 1
fi

echo "Using SDK: $SDK_NAME"

# Build for Linux ARM64
echo "1. Building for Linux ARM64..."
swift build --swift-sdk aarch64-swift-linux-musl -c release

# Check if container plugin is available
if swift package --help | grep -q "container-build"; then
    echo ""
    echo "2. Building container image..."
    swift package --allow-writing-to-package-directory container-build
    
    echo ""
    echo "✅ Container built successfully!"
    echo ""
    echo "Container images:"
    ls -la .build/container-images/
else
    echo ""
    echo "⚠️  Container plugin not available. Using manual Docker build..."
    
    # Create Dockerfile
    cat > Dockerfile << 'EOF'
FROM scratch

# Copy the static binary
COPY .build/aarch64-swift-linux-musl/release/swiftlets-container /swiftlets-container

# Expose port
EXPOSE 8080

# Run the server
ENTRYPOINT ["/swiftlets-container"]
EOF
    
    echo "3. Building Docker image..."
    docker build -t swiftlets-container:latest .
    
    echo ""
    echo "✅ Docker image built successfully!"
    echo ""
    echo "To run locally:"
    echo "  docker run -p 8080:8080 swiftlets-container:latest"
fi

echo ""
echo "To deploy to EC2:"
echo "  ./deploy-to-ec2.sh"