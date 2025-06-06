#!/bin/bash
# Universal run script for Swiftlets - works on macOS and Linux (including Ubuntu ARM64)

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
    arm64)
        if [[ "$OS" == "Linux" ]]; then
            ARCH="aarch64"
        fi
        ;;
    aarch64)
        # Already correct for Linux ARM64
        ;;
    x86_64)
        # Already correct
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
        ;;
    Linux)
        PLATFORM="linux"
        BUILD_TRIPLE="${ARCH}-unknown-linux-gnu"
        ;;
    *)
        echo -e "${RED}Unsupported platform: $OS${NC}"
        exit 1
        ;;
esac

echo -e "${YELLOW}Starting Swiftlets server...${NC}"
echo -e "Platform: ${GREEN}$OS${NC}"
echo -e "Architecture: ${GREEN}$ARCH${NC}"
echo ""

# Check for Swift
if ! command -v swift &> /dev/null; then
    echo -e "${RED}Swift is not installed!${NC}"
    echo ""
    echo "Installation instructions:"
    
    case $OS in
        Darwin)
            echo "- Install Xcode from the App Store"
            echo "- Or download Swift from https://swift.org/download/"
            ;;
        Linux)
            echo "For Ubuntu ${ARCH}:"
            echo "1. Download Swift from https://swift.org/download/"
            if [[ "$ARCH" == "aarch64" ]]; then
                echo "2. Look for 'Ubuntu 22.04 aarch64' or your Ubuntu version"
                echo "3. Example for Swift 5.10.1:"
                echo "   wget https://download.swift.org/swift-5.10.1-release/ubuntu2204-aarch64/swift-5.10.1-RELEASE/swift-5.10.1-RELEASE-ubuntu22.04-aarch64.tar.gz"
                echo "   tar xzf swift-5.10.1-RELEASE-ubuntu22.04-aarch64.tar.gz"
                echo "   sudo mv swift-5.10.1-RELEASE-ubuntu22.04-aarch64 /usr/local/swift"
                echo "   echo 'export PATH=/usr/local/swift/usr/bin:\$PATH' >> ~/.bashrc"
                echo "   source ~/.bashrc"
            else
                echo "2. Look for 'Ubuntu 22.04' or your Ubuntu version for x86_64"
            fi
            ;;
    esac
    exit 1
fi

# Find the server binary
RELEASE_PATH="core/.build/${BUILD_TRIPLE}/release/swiftlets-server"
DEBUG_PATH="core/.build/${BUILD_TRIPLE}/debug/swiftlets-server"

SERVER_BINARY=""
BUILD_TYPE=""

if [ -f "$RELEASE_PATH" ]; then
    SERVER_BINARY="$RELEASE_PATH"
    BUILD_TYPE="release"
elif [ -f "$DEBUG_PATH" ]; then
    SERVER_BINARY="$DEBUG_PATH"
    BUILD_TYPE="debug"
else
    echo -e "${YELLOW}Server binary not found, building...${NC}"
    cd core
    
    # Try release build first for better performance
    if swift build --product swiftlets-server -c release; then
        SERVER_BINARY="../$RELEASE_PATH"
        BUILD_TYPE="release"
    else
        echo -e "${YELLOW}Release build failed, trying debug...${NC}"
        swift build --product swiftlets-server
        SERVER_BINARY="../$DEBUG_PATH"
        BUILD_TYPE="debug"
    fi
    cd ..
fi

# Verify binary exists
if [ ! -f "$SERVER_BINARY" ]; then
    echo -e "${RED}Failed to find or build server binary!${NC}"
    echo "Expected at: $SERVER_BINARY"
    exit 1
fi

# Set library path for Linux
if [[ "$OS" == "Linux" ]]; then
    LIB_PATH="$(pwd)/core/.build/${BUILD_TRIPLE}/${BUILD_TYPE}"
    export LD_LIBRARY_PATH="$LIB_PATH:$LD_LIBRARY_PATH"
    echo -e "Library path: ${GREEN}$LIB_PATH${NC}"
fi

# Run the server
echo -e "${GREEN}Server starting on http://localhost:8080${NC}"
echo -e "Binary: ${GREEN}$SERVER_BINARY${NC} (${BUILD_TYPE})"
echo ""

# Execute the server
exec "$SERVER_BINARY"