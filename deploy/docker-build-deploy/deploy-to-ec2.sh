#!/bin/bash
#
# Deploy Docker-built swiftlets to EC2
#

set -e

# Check arguments
if [ $# -eq 0 ]; then
    echo "Usage: $0 <deployment-package.tar.gz>"
    echo "Run build-with-docker.sh first to create the package"
    exit 1
fi

DEPLOY_PACKAGE="$1"
if [ ! -f "$DEPLOY_PACKAGE" ]; then
    echo "Error: Package $DEPLOY_PACKAGE not found"
    exit 1
fi

# EC2 Configuration
EC2_HOST="<YOUR-EC2-IP>"
EC2_USER="ubuntu"
KEY_FILE="$HOME/.ssh/<YOUR-KEY-NAME>.pem"
SITE_NAME="swiftlets-site"

echo "=== Deploying to EC2 ==="
echo "Package: $DEPLOY_PACKAGE"
echo "Target: $EC2_USER@$EC2_HOST"
echo ""

# Upload package
echo "1. Uploading deployment package..."
scp -i "$KEY_FILE" "$DEPLOY_PACKAGE" "$EC2_USER@$EC2_HOST:/tmp/"

# Deploy on EC2
echo ""
echo "2. Deploying on EC2..."
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" << REMOTE_SCRIPT
set -e

echo "Stopping existing service..."
sudo systemctl stop swiftlets-site 2>/dev/null || true

echo ""
echo "Extracting deployment package..."
cd ~
rm -rf swiftlets-docker-deploy
mkdir -p swiftlets-docker-deploy
cd swiftlets-docker-deploy
tar -xzf /tmp/$(basename $DEPLOY_PACKAGE)

echo ""
echo "Setting up binaries..."
chmod +x bin/linux/arm64/swiftlets-server
chmod +x run-site

# Make all webbin files executable
find webbin -name "*.webbin" -exec chmod +x {} \;
find sites/*/webbin -name "*.webbin" -exec chmod +x {} \;

echo ""
echo "Creating systemd service..."
sudo tee /etc/systemd/system/swiftlets-site.service > /dev/null << 'SERVICE'
[Unit]
Description=Swiftlets Site (Docker Built)
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/swiftlets-docker-deploy
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ExecStart=/home/ubuntu/swiftlets-docker-deploy/run-site sites/$SITE_NAME
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
SERVICE

# Update the site name in service file
sudo sed -i "s/\$SITE_NAME/$SITE_NAME/g" /etc/systemd/system/swiftlets-site.service

echo ""
echo "Starting service..."
sudo systemctl daemon-reload
sudo systemctl enable swiftlets-site
sudo systemctl restart swiftlets-site

echo ""
echo "Waiting for service to start..."
sleep 5

# Check status
echo "Service status:"
sudo systemctl status swiftlets-site --no-pager || true

echo ""
echo "Testing site..."
if curl -s http://localhost:8080/ | grep -q "Swiftlets"; then
    echo "✅ Site is running!"
else
    echo "❌ Site test failed"
    echo "Recent logs:"
    sudo journalctl -u swiftlets-site -n 20
fi

# Cleanup
rm -f /tmp/$(basename $DEPLOY_PACKAGE)

echo ""
echo "Disk usage:"
df -h / | grep -v Filesystem

REMOTE_SCRIPT

echo ""
echo "✅ Deployment complete!"
echo ""
echo "Your site is available at: http://$EC2_HOST:8080/"
echo ""
echo "To check logs:"
echo "  ssh -i $KEY_FILE $EC2_USER@$EC2_HOST 'sudo journalctl -u swiftlets-site -f'"