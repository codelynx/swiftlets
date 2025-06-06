#!/bin/bash

# Swiftlets Site Build Script

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Normalize architecture names
case $ARCH in
    x86_64)
        ARCH="x86_64"
        ;;
    aarch64)
        ARCH="arm64"
        ;;
    arm64)
        ARCH="arm64"
        ;;
    *)
        echo -e "${RED}Unsupported architecture: $ARCH${NC}"
        exit 1
        ;;
esac

# Paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BIN_DIR="$SCRIPT_DIR/web/bin/$OS/$ARCH"
SRC_DIR="$SCRIPT_DIR/src"
CORE_DIR="$SCRIPT_DIR/../../../core"

# Check if core is built
if [ ! -d "$CORE_DIR/.build/release" ]; then
    echo -e "${RED}Error: Core framework not built!${NC}"
    echo "Please build the core framework first:"
    echo "  cd $CORE_DIR && swift build -c release"
    exit 1
fi

# Create binary directory
mkdir -p "$BIN_DIR"

echo -e "${GREEN}Building swiftlets for $OS/$ARCH...${NC}"

# Find all Swift files and compile them
find "$SRC_DIR" -name "*.swift" -type f | while read -r swift_file; do
    # Get relative path from src directory
    relative_path="${swift_file#$SRC_DIR/}"
    
    # Remove .swift extension for output
    output_path="${relative_path%.swift}"
    
    # Full output path
    output="$BIN_DIR/$output_path"
    
    # Create output directory if needed
    output_dir=$(dirname "$output")
    mkdir -p "$output_dir"
    
    echo -e "${YELLOW}  Building $relative_path -> bin/$OS/$ARCH/$output_path${NC}"
    
    # Compile the swiftlet
    if swiftc -parse-as-library \
              -I "$CORE_DIR/.build/release/Modules" \
              -L "$CORE_DIR/.build/release" \
              -lSwiftletsCore -lSwiftletsHTML \
              "$swift_file" -o "$output"; then
        echo -e "${GREEN}    ✓ Success${NC}"
    else
        echo -e "${RED}    ✗ Failed${NC}"
        exit 1
    fi
done

echo -e "${GREEN}Build complete!${NC}"
echo ""
echo "To run the site:"
echo "  Using CLI:    cd ../../.. && swiftlets serve --site sites/core/swiftlets-site"
echo "  Direct:       cd ../../.. && SWIFTLETS_SITE=sites/core/swiftlets-site ./core/.build/release/swiftlets-server"