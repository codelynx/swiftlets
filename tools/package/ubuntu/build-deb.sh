#!/bin/bash
# Build Ubuntu/Debian package for Swiftlets

set -e

# Configuration
PACKAGE_NAME="swiftlets"
VERSION="0.1.0"
MAINTAINER="Swiftlets Team <team@swiftlets.org>"
DESCRIPTION="Modern Swift web framework with executable-per-route architecture"
HOMEPAGE="https://github.com/codelynx/swiftlets"

# Architecture mapping
ARCH=$(dpkg --print-architecture)
case $ARCH in
    amd64) BIN_ARCH="x86_64" ;;
    arm64) BIN_ARCH="arm64" ;;
    *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Building Debian package for $ARCH...${NC}"

# Create package directory structure
PACKAGE_DIR="swiftlets_${VERSION}_${ARCH}"
rm -rf "$PACKAGE_DIR"
mkdir -p "$PACKAGE_DIR/DEBIAN"
mkdir -p "$PACKAGE_DIR/usr/bin"
mkdir -p "$PACKAGE_DIR/usr/lib/swiftlets/Sources"
mkdir -p "$PACKAGE_DIR/usr/share/swiftlets/templates"
mkdir -p "$PACKAGE_DIR/usr/share/swiftlets/examples"
mkdir -p "$PACKAGE_DIR/usr/share/doc/swiftlets"

# Copy binaries
echo "Copying binaries..."
cp "../../../bin/linux/$BIN_ARCH/swiftlets" "$PACKAGE_DIR/usr/bin/"
cp "../../../bin/linux/$BIN_ARCH/swiftlets-server" "$PACKAGE_DIR/usr/bin/"
chmod 755 "$PACKAGE_DIR/usr/bin/"*

# Copy framework sources (for direct compilation)
echo "Copying framework sources..."
cp -r ../../../Sources/Swiftlets "$PACKAGE_DIR/usr/lib/swiftlets/Sources/"

# Copy templates
echo "Copying templates..."
cp -r ../../../templates/* "$PACKAGE_DIR/usr/share/swiftlets/templates/"

# Copy examples
echo "Copying examples..."
cp -r ../../../sites/examples/* "$PACKAGE_DIR/usr/share/swiftlets/examples/"

# Create control file
cat > "$PACKAGE_DIR/DEBIAN/control" << EOF
Package: $PACKAGE_NAME
Version: $VERSION
Architecture: $ARCH
Maintainer: $MAINTAINER
Description: $DESCRIPTION
 Swiftlets is a modern web framework for Swift that brings SwiftUI-like
 syntax to server-side development. Each route is an independent executable,
 providing perfect isolation and hot-reload capabilities.
Homepage: $HOMEPAGE
Depends: swift (>= 5.9), libc6 (>= 2.27)
Section: devel
Priority: optional
EOF

# Create postinst script
cat > "$PACKAGE_DIR/DEBIAN/postinst" << 'EOF'
#!/bin/bash
set -e

# Create symlink for SDK root
if [ ! -e /usr/lib/swiftlets ]; then
    echo "Setting up Swiftlets SDK..."
fi

# Set permissions
chmod 755 /usr/bin/swiftlets
chmod 755 /usr/bin/swiftlets-server

echo "Swiftlets has been installed successfully!"
echo "Run 'swiftlets new my-app' to create your first project."

exit 0
EOF
chmod 755 "$PACKAGE_DIR/DEBIAN/postinst"

# Create copyright file
cat > "$PACKAGE_DIR/usr/share/doc/swiftlets/copyright" << EOF
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: swiftlets
Source: $HOMEPAGE

Files: *
Copyright: 2025 Swiftlets Contributors
License: MIT
EOF

# Build the package
echo -e "${YELLOW}Building package...${NC}"
dpkg-deb --build "$PACKAGE_DIR"

# Clean up
rm -rf "$PACKAGE_DIR"

echo -e "${GREEN}Package created: ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb${NC}"
echo ""
echo "To install:"
echo "  sudo dpkg -i ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
echo ""
echo "To remove:"
echo "  sudo dpkg -r $PACKAGE_NAME"