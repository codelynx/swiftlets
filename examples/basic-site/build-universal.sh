#!/bin/bash
# Universal build script for basic-site example

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Platform detection
OS=$(uname -s)
ARCH=$(uname -m)

# Normalize architecture names
case $ARCH in
    aarch64)
        ARCH="arm64"
        ;;
esac

echo -e "${YELLOW}Building basic-site swiftlets...${NC}"
echo -e "Platform: ${GREEN}$OS $ARCH${NC}"

# Build core framework first
echo -e "${YELLOW}Building core framework...${NC}"
cd ../../core
swift build --product SwiftletsCore --product SwiftletsHTML

# Determine build path
case $OS in
    Darwin)
        BUILD_TRIPLE="${ARCH}-apple-macosx"
        ;;
    Linux)
        if [[ "$ARCH" == "arm64" ]]; then
            BUILD_TRIPLE="aarch64-unknown-linux-gnu"
        else
            BUILD_TRIPLE="${ARCH}-unknown-linux-gnu"
        fi
        ;;
esac

BUILD_PATH=".build/${BUILD_TRIPLE}/debug"
MODULE_PATH="${BUILD_PATH}/Modules"
LIB_PATH="${BUILD_PATH}"

cd ../examples/basic-site

# Simple swiftlets (no dependencies)
echo -e "${YELLOW}Building hello/index...${NC}"
swiftc src/hello/index.swift -o web/bin/index

# Swiftlets with SwiftletsCore dependencies
echo -e "${YELLOW}Building other swiftlets...${NC}"
for src in src/*.swift; do
    if [ -f "$src" ]; then
        name=$(basename "$src" .swift)
        echo -e "  Building ${GREEN}$name${NC}..."
        
        if [[ "$OS" == "Linux" ]]; then
            # Linux needs rpath
            swiftc "$src" \
                -I "../../core/${MODULE_PATH}" \
                -L "../../core/${LIB_PATH}" \
                -lSwiftletsCore -lSwiftletsHTML \
                -Xlinker -rpath -Xlinker "$(pwd)/../../core/${LIB_PATH}" \
                -o "web/bin/$name"
        else
            # macOS
            swiftc "$src" \
                -I "../../core/${MODULE_PATH}" \
                -L "../../core/${LIB_PATH}" \
                -lSwiftletsCore -lSwiftletsHTML \
                -o "web/bin/$name"
        fi
    fi
done

echo -e "${GREEN}✓ Build complete!${NC}"
echo ""
echo "To run the server from the project root:"
echo "  cd ../.. && ./run-universal.sh"