#!/bin/bash
#
# Deploy source to EC2 and build there
# Simplest approach - no cross-compilation needed
#

set -e

echo "=== Deploy Source to EC2 ==="

cd "$(dirname "$0")"

EC2_HOST="<YOUR-EC2-IP>"
EC2_USER="ubuntu"
KEY_FILE="$HOME/.ssh/<YOUR-KEY-NAME>.pem"

# Create source package
echo "1. Creating source package..."
tar -czf hello-world-src.tar.gz Package.swift Sources

# Copy to EC2
echo "2. Copying to EC2..."
scp -i "$KEY_FILE" hello-world-src.tar.gz "$EC2_USER@$EC2_HOST:/tmp/"

# Build on EC2
echo "3. Building on EC2..."
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" << 'REMOTE_SCRIPT'
set -e

echo "Extracting source..."
cd /tmp
rm -rf hello-world-build
mkdir hello-world-build
cd hello-world-build
tar -xzf ../hello-world-src.tar.gz

echo "Setting up Swift path..."
export PATH=/usr/share/swift/usr/bin:$PATH

echo "Checking Swift..."
swift --version

echo "Building..."
swift build -c release

echo "Running..."
.build/release/hello-world

echo ""
echo "✅ Build successful on EC2!"
echo "Binary at: /tmp/hello-world-build/.build/release/hello-world"
REMOTE_SCRIPT

echo ""
echo "✅ Complete! The hello-world app is now built and tested on EC2."