#!/bin/bash
# Direct compilation script for showcase site
# This compiles the swiftlets directly without relying on Swift Package Manager

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Detect platform
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Normalize architecture
case $ARCH in
    aarch64) ARCH="arm64" ;;
    arm64) ARCH="arm64" ;;
    x86_64) ARCH="x86_64" ;;
esac

echo -e "${YELLOW}Direct compilation for $OS/$ARCH${NC}"

# Paths
CORE_SRC="../../../core/Sources"
BIN_DIR="web/bin/$OS/$ARCH"

# Create bin directory
mkdir -p "$BIN_DIR"

# Check if we can find core sources
if [ ! -d "$CORE_SRC" ]; then
    echo -e "${RED}Error: Cannot find core sources at $CORE_SRC${NC}"
    exit 1
fi

echo -e "${GREEN}Found core sources${NC}"

# Function to compile a swiftlet
compile_swiftlet() {
    local src_file=$1
    local output_name=$2
    
    echo -e "${YELLOW}Compiling $src_file -> $output_name${NC}"
    
    # Compile with all necessary source files
    swiftc \
        -parse-as-library \
        "$CORE_SRC/SwiftletsCore"/*.swift \
        "$CORE_SRC/SwiftletsHTML/Core"/*.swift \
        "$CORE_SRC/SwiftletsHTML/Elements"/*.swift \
        "$CORE_SRC/SwiftletsHTML/Helpers"/*.swift \
        "$CORE_SRC/SwiftletsHTML/Layout"/*.swift \
        "$CORE_SRC/SwiftletsHTML/Modifiers"/*.swift \
        "$CORE_SRC/SwiftletsHTML/Builders"/*.swift \
        "$src_file" \
        -o "$BIN_DIR/$output_name" 2>&1
        
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✓ Success${NC}"
    else
        echo -e "${RED}  ✗ Failed${NC}"
        return 1
    fi
}

# Compile each swiftlet
compile_swiftlet "src/index.swift" "index"
compile_swiftlet "src/docs.swift" "docs"
compile_swiftlet "src/showcase.swift" "showcase"
compile_swiftlet "src/about.swift" "about"
compile_swiftlet "src/docs/getting-started.swift" "docs/getting-started"

echo -e "${GREEN}Compilation complete!${NC}"
echo ""
echo "Run the site with:"
echo "  cd ../../.. && SWIFTLETS_SITE=sites/core/swiftlets-site ./core/.build/release/swiftlets-server"