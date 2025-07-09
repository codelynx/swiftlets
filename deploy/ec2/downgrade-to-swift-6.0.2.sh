#!/bin/bash
#
# Downgrade EC2 from Swift 6.1.2 to 6.0.2
#

set -e

EC2_HOST="<YOUR-EC2-IP>"
EC2_USER="ubuntu"
KEY_FILE="$HOME/.ssh/<YOUR-KEY-NAME>.pem"

echo "=== Downgrading EC2 to Swift 6.0.2 ==="
echo ""

ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" << 'REMOTE_SCRIPT'
set -e

echo "Current Swift version:"
swift --version || echo "Swift not found"

echo ""
echo "1. Stopping any running services..."
sudo systemctl stop swiftlets-site 2>/dev/null || true
sudo systemctl stop swiftlets-container 2>/dev/null || true

echo ""
echo "2. Removing Swift 6.1.2..."
sudo rm -rf /usr/share/swift

echo ""
echo "3. Installing Swift 6.0.2..."

# Download and install Swift 6.0.2
cd /tmp
wget https://download.swift.org/swift-6.0.2-release/ubuntu2404-aarch64/swift-6.0.2-RELEASE/swift-6.0.2-RELEASE-ubuntu24.04-aarch64.tar.gz

echo "Extracting Swift 6.0.2..."
tar xzf swift-6.0.2-RELEASE-ubuntu24.04-aarch64.tar.gz

echo "Installing Swift 6.0.2..."
sudo mv swift-6.0.2-RELEASE-ubuntu24.04-aarch64 /usr/share/swift

# Verify installation
source /etc/profile.d/swift.sh
echo ""
echo "New Swift version:"
swift --version

# Clean up
rm -f swift-6.0.2-RELEASE-ubuntu24.04-aarch64.tar.gz

echo ""
echo "4. Rebuilding swiftlets-site with Swift 6.0.2..."
cd ~/swiftlets-deploy
swift build -c release

echo ""
echo "5. Restarting services..."
sudo systemctl start swiftlets-site

echo ""
echo "✅ Successfully downgraded to Swift 6.0.2!"
echo ""
echo "Checking service status:"
sudo systemctl status swiftlets-site --no-pager

REMOTE_SCRIPT

echo ""
echo "✅ EC2 downgrade complete!"