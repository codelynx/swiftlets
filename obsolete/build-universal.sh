#!/bin/bash
# Universal build script for Swiftlets - works on macOS and Linux (including Ubuntu ARM64)

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
        # Normalize Linux's aarch64 to arm64 for consistency
        ARCH="arm64"
        ;;
    arm64|x86_64)
        # Already in desired format
        ;;
    *)
        echo -e "${RED}Unknown architecture: $ARCH${NC}"
        exit 1
        ;;
esac

# Set platform-specific variables
case $OS in
    Darwin)
        PLATFORM="macos"
        BUILD_TRIPLE="${ARCH}-apple-macosx"
        LIB_EXT="dylib"
        ;;
    Linux)
        PLATFORM="linux"
        # Use the actual triple for building (aarch64 for ARM64 on Linux)
        if [[ "$ARCH" == "arm64" ]]; then
            BUILD_TRIPLE="aarch64-unknown-linux-gnu"
        else
            BUILD_TRIPLE="${ARCH}-unknown-linux-gnu"
        fi
        LIB_EXT="so"
        ;;
    *)
        echo -e "${RED}Unsupported platform: $OS${NC}"
        exit 1
        ;;
esac

echo -e "${YELLOW}Building Swiftlets...${NC}"
echo -e "Platform: ${GREEN}$OS${NC}"
echo -e "Architecture: ${GREEN}$ARCH${NC}"
echo -e "Build Triple: ${GREEN}$BUILD_TRIPLE${NC}"
echo ""

# Build core framework
echo -e "${YELLOW}Building core framework...${NC}"
cd core

# Build with release configuration for better performance
swift build -c release

# Get build paths
BUILD_PATH=".build/${BUILD_TRIPLE}/release"
if [ ! -d "$BUILD_PATH" ]; then
    echo -e "${YELLOW}Release build not found, trying debug...${NC}"
    BUILD_PATH=".build/${BUILD_TRIPLE}/debug"
    swift build
fi

echo -e "${GREEN}✓ Core framework built${NC}"
echo -e "Build artifacts: ${GREEN}core/$BUILD_PATH${NC}"
cd ..

# Build basic-site example
echo -e "${YELLOW}Building basic-site example...${NC}"
cd examples/basic-site

# Check if Makefile exists and use it
if [ -f "Makefile" ]; then
    make all
else
    echo -e "${YELLOW}No Makefile found, using direct Swift compilation...${NC}"
    
    # Create bin directory if it doesn't exist
    mkdir -p bin
    
    # Build each Swift file in src/
    for swift_file in src/*.swift; do
        if [ -f "$swift_file" ]; then
            filename=$(basename "$swift_file" .swift)
            echo -e "Building ${GREEN}$filename${NC}..."
            
            # Build with platform-specific settings
            swiftc "$swift_file" \
                -I "../../core/$BUILD_PATH" \
                -L "../../core/$BUILD_PATH" \
                -lSwiftletsCore \
                -lSwiftletsHTML \
                -Xlinker -rpath -Xlinker "@executable_path/../../core/$BUILD_PATH" \
                -o "bin/$filename"
        fi
    done
fi

cd ../..

echo -e "${GREEN}✓ Build complete!${NC}"
echo ""
echo -e "Platform details:"
echo -e "  OS: ${GREEN}$OS${NC}"
echo -e "  Architecture: ${GREEN}$ARCH${NC}"
echo -e "  Library extension: ${GREEN}.$LIB_EXT${NC}"
echo -e "  Build path: ${GREEN}core/$BUILD_PATH${NC}"
echo ""
echo -e "To run the server: ${GREEN}./run-universal.sh${NC}"
echo -e "Or use: ${GREEN}make server${NC}"