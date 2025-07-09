#!/bin/bash
#
# Deploy pre-built swiftlets binaries to EC2
# This avoids building on EC2 due to resource constraints
#

set -e

EC2_HOST="<YOUR-EC2-IP>"
EC2_USER="ubuntu"
KEY_FILE="$HOME/.ssh/<YOUR-KEY-NAME>.pem"
SITE_NAME="swiftlets-site"

echo "=== Deploying Pre-built Binaries to EC2 ==="
echo ""

# 1. Build locally with Docker and Swift 6.0.2
echo "1. Building with Docker (Swift 6.0.2)..."
cd docker-cross-compile
./build-with-docker.sh
cd ..

# 2. Build the site locally
echo ""
echo "2. Building swiftlets-site locally..."
cd ..
./build-site sites/$SITE_NAME

# 3. Package binaries and site files
echo ""
echo "3. Creating deployment package..."
tar -czf deploy-binaries.tar.gz \
    --exclude='.build/*/build' \
    --exclude='.build/checkouts' \
    --exclude='.build/repositories' \
    .build/aarch64-swift-linux-musl/release/swiftlets-server \
    bin \
    webbin \
    sites/$SITE_NAME/webbin \
    sites/$SITE_NAME/src \
    run-site

echo "   Package size: $(du -h deploy-binaries.tar.gz | cut -f1)"

# 4. Upload to EC2
echo ""
echo "4. Uploading binaries to EC2..."
scp -i "$KEY_FILE" deploy-binaries.tar.gz "$EC2_USER@$EC2_HOST:/tmp/"

# 5. Deploy on EC2
echo ""
echo "5. Deploying on EC2..."
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" << 'REMOTE_SCRIPT'
set -e

# Stop existing service
echo "Stopping existing service..."
sudo systemctl stop swiftlets-site 2>/dev/null || true

# Extract binaries
cd ~
rm -rf swiftlets-binary-deploy
mkdir -p swiftlets-binary-deploy
cd swiftlets-binary-deploy
tar -xzf /tmp/deploy-binaries.tar.gz

# Make executables
chmod +x .build/aarch64-swift-linux-musl/release/swiftlets-server
chmod +x run-site
chmod +x bin/linux/arm64/*
chmod +x webbin/*/*

# Create symlink for server
ln -sf .build/aarch64-swift-linux-musl/release/swiftlets-server ./swiftlets-server

# Update systemd service
sudo tee /etc/systemd/system/swiftlets-site.service > /dev/null << 'SERVICE'
[Unit]
Description=Swiftlets Documentation Site (Pre-built)
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/swiftlets-binary-deploy
ExecStart=/home/ubuntu/swiftlets-binary-deploy/run-site sites/swiftlets-site
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
SERVICE

# Reload and start service
sudo systemctl daemon-reload
sudo systemctl enable swiftlets-site
sudo systemctl start swiftlets-site

echo ""
echo "Waiting for service to start..."
sleep 3

# Check status
sudo systemctl status swiftlets-site --no-pager

echo ""
echo "Testing the site..."
curl -s http://localhost:8080/ | grep -q "Swiftlets" && echo "✅ Site is running!" || echo "❌ Site test failed"

# Clean up
rm -f /tmp/deploy-binaries.tar.gz

REMOTE_SCRIPT

# Clean up local package
rm -f deploy-binaries.tar.gz

echo ""
echo "✅ Binary deployment complete!"
echo ""
echo "Your site is running at: http://$EC2_HOST:8080/"
echo ""
echo "Benefits:"
echo "- No building on EC2 (saves resources)"
echo "- Uses Swift 6.0.2 for reliable cross-compilation"
echo "- Fast deployment (only transfers binaries)"