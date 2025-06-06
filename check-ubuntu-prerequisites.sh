#!/bin/bash
# Ubuntu ARM64 Prerequisites Check for Swiftlets
# Based on sister project requirements

echo "🔍 Checking Ubuntu ARM64 prerequisites for Swiftlets..."
echo

# Check OS version
echo "📋 OS Information:"
lsb_release -a 2>/dev/null || cat /etc/os-release
echo

# Check architecture
echo "🏗️ Architecture:"
uname -m
echo

# Check if running in VM
echo "🖥️ Virtualization:"
systemd-detect-virt 2>/dev/null || echo "Cannot detect virtualization"
echo

# Check Swift
echo "🦉 Swift:"
if command -v swift &> /dev/null; then
    swift --version
else
    echo "❌ Swift not installed"
    echo "To install Swift on Ubuntu ARM64:"
    echo "1. Download from https://swift.org/download/"
    echo "2. Look for 'Ubuntu 22.04 aarch64' or your Ubuntu version"
fi
echo

# Check essential build tools
echo "🔨 Build tools:"
for tool in make git curl tar; do
    if command -v $tool &> /dev/null; then
        echo "✅ $tool: $(command -v $tool)"
    else
        echo "❌ $tool: not found"
    fi
done
echo

# Check required libraries
echo "📚 Required libraries:"
ldconfig -p 2>/dev/null | grep -E "(libncurses|libpython|libxml2|libedit|libsqlite3|libz)" | head -10 || echo "Cannot check libraries"
echo

# Check available memory
echo "💾 Memory:"
free -h
echo

# Check disk space
echo "💿 Disk space:"
df -h /
echo

# Installation commands
echo "📦 If prerequisites are missing, install with:"
echo "sudo apt update"
echo "sudo apt install -y \\"
echo "    binutils \\"
echo "    git \\"
echo "    gnupg2 \\"
echo "    libc6-dev \\"
echo "    libcurl4-openssl-dev \\"
echo "    libedit2 \\"
echo "    libgcc-11-dev \\"
echo "    libpython3.10 \\"
echo "    libsqlite3-0 \\"
echo "    libstdc++-11-dev \\"
echo "    libxml2-dev \\"
echo "    libz3-dev \\"
echo "    pkg-config \\"
echo "    tzdata \\"
echo "    unzip \\"
echo "    zlib1g-dev"
echo
echo "🦉 Swift installation for Ubuntu ARM64:"
echo "# Example for Swift 5.10.1 (check https://swift.org/download/ for latest)"
echo "wget https://download.swift.org/swift-5.10.1-release/ubuntu2204-aarch64/swift-5.10.1-RELEASE/swift-5.10.1-RELEASE-ubuntu22.04-aarch64.tar.gz"
echo "tar xzf swift-5.10.1-RELEASE-ubuntu22.04-aarch64.tar.gz"
echo "sudo mv swift-5.10.1-RELEASE-ubuntu22.04-aarch64 /usr/local/swift"
echo "echo 'export PATH=/usr/local/swift/usr/bin:\$PATH' >> ~/.bashrc"
echo "source ~/.bashrc"
echo
echo "🚀 After installing prerequisites, use:"
echo "  ./build-universal.sh  - to build everything"
echo "  ./run-universal.sh    - to run the server"