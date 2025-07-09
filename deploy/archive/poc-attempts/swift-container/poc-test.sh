#!/bin/bash
#
# POC: Test Swift Container Plugin with Swiftlets
#

set -e

echo "=== Swift Container Plugin POC ==="
echo "Repository: https://github.com/apple/swift-container-plugin"
echo ""

# Step 1: Check prerequisites
echo "1. Checking prerequisites..."

# Check Swift version
echo -n "   Swift version: "
swift --version | head -1

# Check Docker
echo -n "   Docker: "
if docker --version >/dev/null 2>&1; then
    docker --version
else
    echo "NOT INSTALLED - Please install Docker"
    exit 1
fi

# Check container plugin
echo -n "   Container plugin: "
if swift package plugin --list | grep -q "build-container-image"; then
    echo "INSTALLED ✓"
else
    echo "NOT FOUND"
    exit 1
fi

# Step 2: Build a minimal test
echo ""
echo "2. Building container image..."
echo "   This will create a minimal container with just swiftlets-server"

# Create build command
BUILD_CMD="swift package --disable-sandbox plugin build-container-image --product swiftlets-server --repository swiftlets-poc --tag test"

echo ""
echo "Command to run:"
echo "  $BUILD_CMD"
echo ""
echo "Note: This requires Docker to be running"
echo ""

# Ask user to proceed
read -p "Ready to build? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    eval $BUILD_CMD
    
    echo ""
    echo "3. Container built! To run it:"
    echo "   docker run -p 8080:8080 swiftlets-poc:test"
    echo ""
    echo "4. To see the image:"
    echo "   docker images | grep swiftlets-poc"
fi