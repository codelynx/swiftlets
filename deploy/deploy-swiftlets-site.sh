#!/bin/bash
#
# Deploy swiftlets-site to EC2
# This packages the source and builds on EC2
#

set -e

EC2_HOST="<YOUR-EC2-IP>"
EC2_USER="ubuntu"
KEY_FILE="$HOME/.ssh/<YOUR-KEY-NAME>.pem"
SITE_NAME="swiftlets-site"

echo "=== Deploying $SITE_NAME to EC2 ==="
echo ""

# Package the source
echo "1. Creating deployment package..."
tar -czf deploy-package.tar.gz \
    --exclude='.build' \
    --exclude='bin' \
    --exclude='webbin' \
    --exclude='*.tar.gz' \
    --exclude='.git' \
    Package.swift \
    Sources \
    build-site \
    run-site \
    sites/$SITE_NAME

echo "   Package size: $(du -h deploy-package.tar.gz | cut -f1)"

# Copy to EC2
echo ""
echo "2. Uploading to EC2..."
scp -i "$KEY_FILE" deploy-package.tar.gz "$EC2_USER@$EC2_HOST:/tmp/"

# Build and deploy on EC2
echo ""
echo "3. Building and deploying on EC2..."
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" << 'REMOTE_SCRIPT'
set -e

# Stop existing server if running
if pgrep -f "run-site.*swiftlets-site" > /dev/null; then
    echo "Stopping existing server..."
    pkill -f "run-site.*swiftlets-site" || true
    sleep 2
fi

# Extract package
cd ~
rm -rf swiftlets-deploy
mkdir -p swiftlets-deploy
cd swiftlets-deploy
tar -xzf /tmp/deploy-package.tar.gz

# Set up Swift environment
source /etc/profile.d/swift.sh

# Build the framework first
echo ""
echo "Building Swiftlets framework..."
# Create empty Tests directory to satisfy Package.swift
mkdir -p Tests/SwiftletsTests
swift build -c release

# Build the site
echo ""
echo "Building swiftlets-site..."
./build-site sites/swiftlets-site

# Create systemd service
echo ""
echo "Setting up systemd service..."
sudo tee /etc/systemd/system/swiftlets-site.service > /dev/null << 'SERVICE'
[Unit]
Description=Swiftlets Documentation Site
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/swiftlets-deploy
Environment="PATH=/usr/share/swift/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ExecStart=/home/ubuntu/swiftlets-deploy/run-site sites/swiftlets-site
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
SERVICE

# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable swiftlets-site
sudo systemctl restart swiftlets-site

echo ""
echo "Waiting for service to start..."
sleep 3

# Check status
sudo systemctl status swiftlets-site --no-pager

echo ""
echo "Testing the site..."
curl -s http://localhost:8080/ | grep -q "Swiftlets" && echo "✅ Site is running!" || echo "❌ Site test failed"

REMOTE_SCRIPT

# Clean up local package
rm -f deploy-package.tar.gz

echo ""
echo "✅ Deployment complete!"
echo ""
echo "Your site is available at:"
echo "  http://$EC2_HOST:8080/"
echo ""
echo "To check logs:"
echo "  ssh -i $KEY_FILE $EC2_USER@$EC2_HOST 'sudo journalctl -u swiftlets-site -f'"