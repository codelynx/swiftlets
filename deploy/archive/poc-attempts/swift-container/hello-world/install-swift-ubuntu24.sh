#!/bin/bash
#
# Install Swift on Ubuntu 24.04 ARM64
#

set -e

echo "=== Installing Swift on Ubuntu 24.04 ARM64 ==="

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

# Swift 6.0.2 for Ubuntu 24.04 ARM64
SWIFT_VERSION="6.0.2"
SWIFT_URL="https://download.swift.org/swift-${SWIFT_VERSION}-release/ubuntu2404-aarch64/swift-${SWIFT_VERSION}-RELEASE/swift-${SWIFT_VERSION}-RELEASE-ubuntu24.04-aarch64.tar.gz"

echo "Downloading Swift ${SWIFT_VERSION}..."
cd /tmp
wget "$SWIFT_URL" -O swift.tar.gz

echo "Extracting Swift..."
tar xzf swift.tar.gz

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
echo "✅ Swift installed successfully!"
echo ""
echo "To use Swift in new sessions, run:"
echo "  source /etc/profile.d/swift.sh"
echo "Or add to your .bashrc:"
echo "  echo 'source /etc/profile.d/swift.sh' >> ~/.bashrc"