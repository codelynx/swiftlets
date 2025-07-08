#!/bin/bash
#
# Build Swiftlets for Linux deployment
# This script can be run locally on macOS to cross-compile for Linux
# or on the Linux server directly
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if we're on macOS or Linux
OS=$(uname -s)
ARCH=$(uname -m)

echo -e "${GREEN}=== Swiftlets Linux Build Script ===${NC}"
echo "Operating System: $OS"
echo "Architecture: $ARCH"

# Function to build a site
build_site() {
    local SITE_PATH=$1
    local TARGET_PLATFORM=$2
    local TARGET_ARCH=$3
    
    echo -e "${BLUE}Building site: $SITE_PATH${NC}"
    echo "Target: $TARGET_PLATFORM/$TARGET_ARCH"
    
    if [ "$OS" = "Darwin" ]; then
        # On macOS, we need to use Docker for cross-compilation
        echo -e "${YELLOW}Cross-compilation from macOS requires Docker${NC}"
        
        # Check if Docker is installed
        if ! command -v docker &> /dev/null; then
            echo -e "${RED}Docker is not installed. Please install Docker Desktop.${NC}"
            exit 1
        fi
        
        # Use Swift Docker image for Linux builds
        docker run --rm \
            -v "$(pwd)":/workspace \
            -w /workspace \
            swift:5.9.2-ubuntu22.04 \
            bash -c "./build-site $SITE_PATH --platform linux --arch $TARGET_ARCH"
    else
        # Native Linux build
        ./build-site "$SITE_PATH" --platform linux --arch "$TARGET_ARCH"
    fi
}

# Function to package the build
package_build() {
    local SITE_NAME=$1
    local VERSION=${2:-"latest"}
    local OUTPUT_DIR="deploy/ec2/builds"
    
    mkdir -p "$OUTPUT_DIR"
    
    echo -e "${YELLOW}Packaging $SITE_NAME for deployment...${NC}"
    
    # Create deployment package
    local PACKAGE_NAME="swiftlets-${SITE_NAME}-${VERSION}-linux-${ARCH}.tar.gz"
    
    tar -czf "$OUTPUT_DIR/$PACKAGE_NAME" \
        --exclude='*.swift' \
        --exclude='.git' \
        --exclude='*.md' \
        --exclude='Tests' \
        "bin/linux/$ARCH" \
        "sites/$SITE_NAME" \
        "run-site" \
        "Package.swift"
    
    echo -e "${GREEN}Package created: $OUTPUT_DIR/$PACKAGE_NAME${NC}"
    
    # Generate deployment metadata
    cat > "$OUTPUT_DIR/${SITE_NAME}-${VERSION}.json" <<EOF
{
    "name": "$SITE_NAME",
    "version": "$VERSION",
    "platform": "linux",
    "architecture": "$ARCH",
    "build_date": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "package": "$PACKAGE_NAME",
    "sha256": "$(sha256sum "$OUTPUT_DIR/$PACKAGE_NAME" | cut -d' ' -f1)"
}
EOF
}

# Main build process
main() {
    # Parse command line arguments
    SITE_NAME=${1:-"swiftlets-site"}
    VERSION=${2:-"latest"}
    TARGET_ARCH=${3:-"$ARCH"}
    
    # Validate architecture
    if [[ "$TARGET_ARCH" != "x86_64" && "$TARGET_ARCH" != "aarch64" ]]; then
        echo -e "${RED}Invalid architecture: $TARGET_ARCH${NC}"
        echo "Supported architectures: x86_64, aarch64"
        exit 1
    fi
    
    # Clean previous builds
    echo -e "${YELLOW}Cleaning previous builds...${NC}"
    rm -rf "bin/linux/$TARGET_ARCH"
    
    # Build the site
    build_site "sites/$SITE_NAME" "linux" "$TARGET_ARCH"
    
    # Verify build
    if [ -d "bin/linux/$TARGET_ARCH" ]; then
        echo -e "${GREEN}Build successful!${NC}"
        echo "Executables built to: bin/linux/$TARGET_ARCH"
        
        # List built executables
        echo -e "${BLUE}Built executables:${NC}"
        find "bin/linux/$TARGET_ARCH" -type f -executable | sort
    else
        echo -e "${RED}Build failed!${NC}"
        exit 1
    fi
    
    # Package the build
    package_build "$SITE_NAME" "$VERSION"
}

# Show usage if no arguments
if [ $# -eq 0 ]; then
    echo "Usage: $0 <site-name> [version] [architecture]"
    echo ""
    echo "Examples:"
    echo "  $0 swiftlets-site                    # Build latest version for current arch"
    echo "  $0 swiftlets-site v1.0.0             # Build specific version"
    echo "  $0 swiftlets-site latest x86_64      # Build for specific architecture"
    echo ""
    echo "Supported architectures: x86_64, aarch64"
    exit 0
fi

# Run main build process
main "$@"