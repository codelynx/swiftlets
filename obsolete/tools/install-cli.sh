#!/bin/bash
# Install Swiftlets CLI

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Installing Swiftlets CLI...${NC}"

# Check if running as root for system-wide install
if [ "$EUID" -eq 0 ]; then 
    INSTALL_PREFIX="/usr/local"
else
    INSTALL_PREFIX="$HOME/.local"
    mkdir -p "$INSTALL_PREFIX/bin"
    echo -e "${YELLOW}Installing to user directory: $INSTALL_PREFIX${NC}"
    echo -e "${YELLOW}Make sure $INSTALL_PREFIX/bin is in your PATH${NC}"
fi

# Build CLI in release mode
echo -e "${YELLOW}Building CLI...${NC}"
cd cli
swift build -c release

# Find the built executable
CLI_BINARY=".build/release/swiftlets"
if [ ! -f "$CLI_BINARY" ]; then
    echo -e "${RED}Failed to find built CLI binary${NC}"
    exit 1
fi

# Install the binary
echo -e "${YELLOW}Installing to $INSTALL_PREFIX/bin/swiftlets${NC}"
cp "$CLI_BINARY" "$INSTALL_PREFIX/bin/swiftlets"
chmod +x "$INSTALL_PREFIX/bin/swiftlets"

# Create a wrapper script that knows where the Swiftlets repo is
REPO_PATH="$(cd .. && pwd)"
cat > "$INSTALL_PREFIX/bin/swiftlets-wrapper" << EOF
#!/bin/bash
# Swiftlets CLI wrapper
export SWIFTLETS_HOME="$REPO_PATH"
exec "$INSTALL_PREFIX/bin/swiftlets" "\$@"
EOF
chmod +x "$INSTALL_PREFIX/bin/swiftlets-wrapper"

# Test installation
if command -v swiftlets &> /dev/null; then
    echo -e "${GREEN}✅ Swiftlets CLI installed successfully!${NC}"
    echo ""
    swiftlets --version
else
    echo -e "${YELLOW}⚠️  Swiftlets installed but not in PATH${NC}"
    echo -e "Add this to your shell configuration:"
    echo -e "  export PATH=\"$INSTALL_PREFIX/bin:\$PATH\""
fi

echo ""
echo "Usage:"
echo "  swiftlets new my-project    # Create a new project"
echo "  swiftlets init              # Initialize in current directory"
echo "  swiftlets serve             # Start development server"
echo "  swiftlets build             # Build swiftlets"