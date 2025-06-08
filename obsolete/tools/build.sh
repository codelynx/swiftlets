#!/bin/bash
# Build everything - with platform detection for cross-platform support

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Platform detection
OS=$(uname -s)
ARCH=$(uname -m)

# Normalize architecture names for Linux ARM64
if [[ "$OS" == "Linux" ]] && [[ "$ARCH" == "arm64" ]]; then
    ARCH="aarch64"
fi

echo -e "${YELLOW}Building Swiftlets...${NC}"
echo -e "Platform: ${GREEN}$OS ${ARCH}${NC}"

# Build core framework
echo -e "${YELLOW}Building core framework...${NC}"
cd core && swift build
cd ..

# Build swiftlets-site
echo -e "${YELLOW}Building swiftlets-site...${NC}"
cd sdk/sites/swiftlets-site && make build
cd ../../..

echo -e "${GREEN}✓ Build complete!${NC}"
echo ""
echo "To run the server: ./run-server.sh"
echo "Or use: make server"
echo ""
echo "Build complete!"