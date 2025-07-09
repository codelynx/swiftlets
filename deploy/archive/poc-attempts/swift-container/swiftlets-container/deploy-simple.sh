#!/bin/bash
# Simple deployment - build on EC2

EC2_HOST="<YOUR-EC2-IP>"
EC2_USER="ubuntu"
KEY_FILE="$HOME/.ssh/<YOUR-KEY-NAME>.pem"

echo "Deploying source to EC2..."

# Create package
tar -czf swiftlets-src.tar.gz Package.swift Sources

# Copy to EC2
scp -i "$KEY_FILE" swiftlets-src.tar.gz "$EC2_USER@$EC2_HOST:/tmp/"

# Build and run on EC2
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" << 'REMOTE'
set -e

# Stop existing service
sudo systemctl stop swiftlets-container 2>/dev/null || true

# Extract
cd /tmp
rm -rf swiftlets-container
mkdir swiftlets-container
cd swiftlets-container
tar -xzf ../swiftlets-src.tar.gz

# Build
source /etc/profile.d/swift.sh
swift build -c release

# Install
sudo mkdir -p /opt/swiftlets-container
sudo cp .build/release/swiftlets-container /opt/swiftlets-container/

# Create service
sudo tee /etc/systemd/system/swiftlets-container.service > /dev/null << 'SERVICE'
[Unit]
Description=Swiftlets Container Demo
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/opt/swiftlets-container
Environment="HOST=0.0.0.0"
Environment="PORT=8080"
ExecStart=/opt/swiftlets-container/swiftlets-container
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

# Start service
sudo systemctl daemon-reload
sudo systemctl enable swiftlets-container
sudo systemctl start swiftlets-container

echo ""
echo "✅ Deployed!"
sleep 2
sudo systemctl status swiftlets-container --no-pager
REMOTE

echo ""
echo "Your app is running at: http://$EC2_HOST:8080/"
