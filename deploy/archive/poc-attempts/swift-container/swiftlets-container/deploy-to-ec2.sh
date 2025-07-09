#!/bin/bash
#
# Deploy Swiftlets container to EC2
#

set -e

EC2_HOST="<YOUR-EC2-IP>"
EC2_USER="ubuntu"
KEY_FILE="$HOME/.ssh/<YOUR-KEY-NAME>.pem"

echo "=== Deploy Swiftlets Container to EC2 ==="
echo ""

# Check if binary exists
if [ ! -f ".build/aarch64-swift-linux-musl/release/swiftlets-container" ]; then
    echo "❌ Binary not found. Run ./build-container.sh first"
    exit 1
fi

echo "1. Copying binary to EC2..."
scp -i "$KEY_FILE" .build/aarch64-swift-linux-musl/release/swiftlets-container "$EC2_USER@$EC2_HOST:/tmp/"

echo ""
echo "2. Setting up on EC2..."
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" << 'REMOTE_SCRIPT'
set -e

# Stop existing Swiftlets service
echo "Stopping existing service..."
sudo systemctl stop swiftlets || true

# Create directory
sudo mkdir -p /opt/swiftlets-container
sudo cp /tmp/swiftlets-container /opt/swiftlets-container/
sudo chmod +x /opt/swiftlets-container/swiftlets-container

# Create systemd service
echo "Creating systemd service..."
sudo tee /etc/systemd/system/swiftlets-container.service > /dev/null << 'EOF'
[Unit]
Description=Swiftlets Container Server
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/opt/swiftlets-container
Environment="HOST=0.0.0.0"
Environment="PORT=8080"
ExecStart=/opt/swiftlets-container/swiftlets-container
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Reload and start service
sudo systemctl daemon-reload
sudo systemctl enable swiftlets-container
sudo systemctl start swiftlets-container

echo ""
echo "Checking service status..."
sleep 2
sudo systemctl status swiftlets-container --no-pager

echo ""
echo "Testing server..."
curl -I http://localhost:8080/
REMOTE_SCRIPT

echo ""
echo "✅ Deployment complete!"
echo ""
echo "Your containerized Swiftlets app is running at:"
echo "  http://$EC2_HOST:8080/"
echo ""
echo "To view logs:"
echo "  ssh -i $KEY_FILE $EC2_USER@$EC2_HOST 'sudo journalctl -u swiftlets-container -f'"