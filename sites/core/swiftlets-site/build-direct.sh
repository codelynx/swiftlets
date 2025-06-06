#!/bin/bash
# Direct build script that compiles with source files

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

echo -e "${YELLOW}Direct build for $OS/$ARCH${NC}"

# Paths
CORE_SRC="../../../core/Sources"
BIN_DIR="web/bin/$OS/$ARCH"

# Create bin directory
mkdir -p "$BIN_DIR"
mkdir -p "$BIN_DIR/docs"

# Function to compile a swiftlet
compile_swiftlet() {
    local src_file=$1
    local output_file=$2
    
    echo -e "${YELLOW}Compiling $src_file -> $output_file${NC}"
    
    # Compile with all necessary source files
    swiftc -parse-as-library \
        "$CORE_SRC/SwiftletsCore"/*.swift \
        "$CORE_SRC/SwiftletsHTML/Core"/*.swift \
        "$CORE_SRC/SwiftletsHTML/Elements"/*.swift \
        "$CORE_SRC/SwiftletsHTML/Helpers"/*.swift \
        "$CORE_SRC/SwiftletsHTML/Layout"/*.swift \
        "$CORE_SRC/SwiftletsHTML/Modifiers"/*.swift \
        "$CORE_SRC/SwiftletsHTML/Builders"/*.swift \
        "$src_file" \
        -o "$output_file"
        
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✓ Success${NC}"
    else
        echo -e "${RED}  ✗ Failed${NC}"
        return 1
    fi
}

# Compile each swiftlet
compile_swiftlet "src/index.swift" "$BIN_DIR/index"
compile_swiftlet "src/docs.swift" "$BIN_DIR/docs"
compile_swiftlet "src/showcase.swift" "$BIN_DIR/showcase"
compile_swiftlet "src/about.swift" "$BIN_DIR/about"
compile_swiftlet "src/docs/getting-started.swift" "$BIN_DIR/docs/getting-started"

echo -e "${GREEN}Build complete!${NC}"
echo ""
echo "To run the site:"
echo "  cd ../../.. && SWIFTLETS_SITE=sites/core/swiftlets-site ./core/.build/release/swiftlets-server"