#!/bin/bash
#
# Install Swift 6.1.2 on Ubuntu 24.04 ARM64
# This will match your local Mac Swift version!
#

set -e

echo "=== Installing Swift 6.1.2 on Ubuntu 24.04 ARM64 ==="

# Check Ubuntu version
UBUNTU_VERSION=$(lsb_release -rs)
if [[ ! "$UBUNTU_VERSION" =~ ^24\. ]]; then
    echo "❌ This script is for Ubuntu 24.04. Detected: $UBUNTU_VERSION"
    exit 1
fi

# Update package list
sudo apt update

# Install dependencies for Ubuntu 24.04
echo "Installing dependencies..."
sudo apt install -y \
    binutils \
    git \
    gnupg2 \
    libc6-dev \
    libcurl4 \
    libedit2 \
    libgcc-s1 \
    libpython3.12 \
    libsqlite3-0 \
    libstdc++6 \
    libxml2 \
    libz3-4 \
    pkg-config \
    tzdata \
    unzip \
    zlib1g-dev

# Swift 6.1.2 for Ubuntu 24.04 ARM64
SWIFT_VERSION="6.1.2"
SWIFT_URL="https://download.swift.org/swift-${SWIFT_VERSION}-release/ubuntu2404-aarch64/swift-${SWIFT_VERSION}-RELEASE/swift-${SWIFT_VERSION}-RELEASE-ubuntu24.04-aarch64.tar.gz"

echo ""
echo "Downloading Swift ${SWIFT_VERSION} (825MB)..."
cd /tmp
wget "$SWIFT_URL" -O swift.tar.gz

echo ""
echo "Extracting Swift..."
tar xzf swift.tar.gz

echo ""
echo "Installing Swift..."
sudo rm -rf /usr/share/swift
sudo mv swift-${SWIFT_VERSION}-RELEASE-ubuntu24.04-aarch64 /usr/share/swift

# Add Swift to PATH
echo 'export PATH=/usr/share/swift/usr/bin:$PATH' | sudo tee /etc/profile.d/swift.sh
source /etc/profile.d/swift.sh

# Verify installation
echo ""
echo "Verifying Swift installation..."
export PATH=/usr/share/swift/usr/bin:$PATH
swift --version

echo ""
echo "✅ Swift ${SWIFT_VERSION} installed successfully!"
echo ""
echo "Now your EC2 has the same Swift version as your Mac!"
echo ""
echo "To use Swift in new sessions, run:"
echo "  source /etc/profile.d/swift.sh"
echo "Or add to your .bashrc:"
echo "  echo 'source /etc/profile.d/swift.sh' >> ~/.bashrc"