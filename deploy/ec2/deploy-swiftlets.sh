#!/bin/bash
#
# Deploy Swiftlets to EC2 Instance
# This script deploys the Swiftlets application to an EC2 instance
#

set -e

# Configuration
EC2_HOST="${EC2_HOST:-}"
EC2_USER="${EC2_USER:-ubuntu}"
KEY_FILE="${KEY_FILE:-$HOME/.ssh/id_rsa}"
SITE_NAME="${SITE_NAME:-swiftlets-site}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Deploy Swiftlets to EC2 ===${NC}"

# Check parameters
if [ -z "$EC2_HOST" ]; then
    echo -e "${RED}Error: EC2_HOST not set${NC}"
    echo "Usage: EC2_HOST=<ip-address> ./deploy-swiftlets.sh"
    echo "Optional: EC2_USER=ubuntu KEY_FILE=~/.ssh/key.pem SITE_NAME=swiftlets-site"
    exit 1
fi

if [ ! -f "$KEY_FILE" ]; then
    echo -e "${RED}Error: SSH key file not found: $KEY_FILE${NC}"
    exit 1
fi

echo "Deploying to: $EC2_USER@$EC2_HOST"
echo "Site: $SITE_NAME"
echo ""

# Create deployment package
echo -e "${YELLOW}1. Creating deployment package...${NC}"
TEMP_DIR=$(mktemp -d)
DEPLOY_FILE="swiftlets-deploy.tar.gz"

# Copy necessary files
cd "$(dirname "$0")/../.."
tar -czf "$TEMP_DIR/$DEPLOY_FILE" \
    --exclude=".git" \
    --exclude="*.xcodeproj" \
    --exclude=".build" \
    --exclude="bin" \
    --exclude="external" \
    --exclude="deploy/swift-container" \
    README.md \
    Package.swift \
    Sources \
    Tests \
    build-site \
    run-site \
    sites \
    docs

echo "Package size: $(du -h "$TEMP_DIR/$DEPLOY_FILE" | cut -f1)"

# Upload to EC2
echo -e "${YELLOW}2. Uploading to EC2...${NC}"
scp -i "$KEY_FILE" "$TEMP_DIR/$DEPLOY_FILE" "$EC2_USER@$EC2_HOST:/tmp/"

# Deploy and build on EC2
echo -e "${YELLOW}3. Deploying on EC2...${NC}"
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" << REMOTE_SCRIPT
set -e

# Colors for remote output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "\${YELLOW}Setting up Swift environment...\${NC}"
source /etc/profile.d/swift.sh || true
export PATH=/usr/share/swift/usr/bin:\$PATH

echo -e "\${YELLOW}Extracting deployment package...\${NC}"
cd /opt/swiftlets
sudo rm -rf *
sudo tar -xzf /tmp/$DEPLOY_FILE
sudo chown -R \$USER:\$USER .

echo -e "\${YELLOW}Building Swiftlets framework...\${NC}"
swift build -c release

echo -e "\${YELLOW}Building site: $SITE_NAME...\${NC}"
./build-site sites/$SITE_NAME

echo -e "\${YELLOW}Setting up systemd service...\${NC}"
# Stop existing service if running
sudo systemctl stop swiftlets || true

# Create systemd service file
sudo tee /etc/systemd/system/swiftlets.service > /dev/null << 'EOF'
[Unit]
Description=Swiftlets Web Server
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/opt/swiftlets
Environment="PATH=/usr/share/swift/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ExecStart=/opt/swiftlets/run-site sites/$SITE_NAME --host 0.0.0.0 --port 8080
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Update service with correct site name
sudo sed -i "s/\$SITE_NAME/$SITE_NAME/g" /etc/systemd/system/swiftlets.service

# Reload and start service
sudo systemctl daemon-reload
sudo systemctl enable swiftlets
sudo systemctl start swiftlets

echo -e "\${YELLOW}Checking service status...\${NC}"
sleep 2
sudo systemctl status swiftlets --no-pager

echo -e "\${GREEN}=== Deployment Complete ===${NC}"
echo ""
echo "Swiftlets is running on http://\$(hostname -I | awk '{print \$1}'):8080"
echo ""
echo "Service commands:"
echo "  sudo systemctl status swiftlets"
echo "  sudo systemctl restart swiftlets"
echo "  sudo journalctl -u swiftlets -f"
REMOTE_SCRIPT

# Clean up
rm -rf "$TEMP_DIR"

echo -e "${GREEN}=== Deployment Successful ===${NC}"
echo ""
echo "Your Swiftlets site is now running at:"
echo "  http://$EC2_HOST:8080"
echo ""
echo "To view logs:"
echo "  ssh -i $KEY_FILE $EC2_USER@$EC2_HOST 'sudo journalctl -u swiftlets -f'"