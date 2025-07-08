#!/bin/bash
#
# Swiftlets EC2 Deployment Script
# Deploy or update Swiftlets on an EC2 instance
#

set -e

# Configuration
REMOTE_USER=${REMOTE_USER:-ubuntu}
REMOTE_HOST=${1:-}
SITE_NAME=${2:-swiftlets-site}
DEPLOY_KEY=${3:-~/.ssh/id_rsa}

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Usage
if [ -z "$REMOTE_HOST" ]; then
    echo "Usage: $0 <ec2-host> [site-name] [ssh-key]"
    echo ""
    echo "Examples:"
    echo "  $0 ec2-1-2-3-4.compute.amazonaws.com"
    echo "  $0 10.0.1.50 swiftlets-site ~/.ssh/mykey.pem"
    exit 1
fi

echo -e "${GREEN}=== Swiftlets EC2 Deployment ===${NC}"
echo "Target: $REMOTE_USER@$REMOTE_HOST"
echo "Site: $SITE_NAME"

# Check SSH connection
echo -e "${YELLOW}Testing SSH connection...${NC}"
if ! ssh -i "$DEPLOY_KEY" -o ConnectTimeout=10 "$REMOTE_USER@$REMOTE_HOST" "echo 'SSH connection successful'"; then
    echo -e "${RED}Failed to connect to $REMOTE_HOST${NC}"
    exit 1
fi

# Build for Linux if not already built
echo -e "${YELLOW}Building for Linux...${NC}"
./deploy/ec2/build-for-linux.sh "$SITE_NAME"

# Get the latest build package
PACKAGE=$(ls -t deploy/ec2/builds/swiftlets-${SITE_NAME}-*.tar.gz | head -1)
if [ -z "$PACKAGE" ]; then
    echo -e "${RED}No build package found!${NC}"
    exit 1
fi

echo -e "${BLUE}Deploying package: $(basename $PACKAGE)${NC}"

# Upload the package
echo -e "${YELLOW}Uploading package...${NC}"
scp -i "$DEPLOY_KEY" "$PACKAGE" "$REMOTE_USER@$REMOTE_HOST:/tmp/"

# Deploy on remote server
echo -e "${YELLOW}Deploying on remote server...${NC}"
ssh -i "$DEPLOY_KEY" "$REMOTE_USER@$REMOTE_HOST" bash -s << 'REMOTE_SCRIPT'
set -e

# Colors for remote output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PACKAGE_FILE=$(ls -t /tmp/swiftlets-*.tar.gz | head -1)
BACKUP_DIR="/opt/swiftlets/backups/$(date +%Y%m%d_%H%M%S)"

echo -e "${YELLOW}Creating backup...${NC}"
if [ -d "/opt/swiftlets/bin" ]; then
    sudo mkdir -p "$BACKUP_DIR"
    sudo cp -r /opt/swiftlets/bin "$BACKUP_DIR/"
    sudo cp -r /opt/swiftlets/sites "$BACKUP_DIR/"
fi

echo -e "${YELLOW}Extracting new deployment...${NC}"
cd /opt/swiftlets
sudo tar -xzf "$PACKAGE_FILE"

echo -e "${YELLOW}Setting permissions...${NC}"
sudo chown -R ubuntu:ubuntu /opt/swiftlets
chmod +x /opt/swiftlets/run-site
find /opt/swiftlets/bin -type f -exec chmod +x {} \;

echo -e "${YELLOW}Restarting Swiftlets service...${NC}"
sudo systemctl restart swiftlets

# Wait for service to start
sleep 5

# Check service status
if sudo systemctl is-active --quiet swiftlets; then
    echo -e "${GREEN}Swiftlets service is running${NC}"
    
    # Test the deployment
    echo -e "${YELLOW}Testing deployment...${NC}"
    if curl -f -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "200"; then
        echo -e "${GREEN}Deployment successful! Site is responding.${NC}"
    else
        echo -e "${RED}Warning: Site is not responding as expected${NC}"
    fi
else
    echo -e "${RED}Swiftlets service failed to start!${NC}"
    echo "Check logs with: sudo journalctl -u swiftlets -n 50"
    exit 1
fi

# Clean up
rm -f "$PACKAGE_FILE"
echo -e "${GREEN}Deployment complete!${NC}"
REMOTE_SCRIPT

echo -e "${GREEN}=== Deployment Complete ===${NC}"
echo ""
echo "Your Swiftlets site is now deployed to: http://$REMOTE_HOST"
echo ""
echo "Useful commands on the server:"
echo "  sudo systemctl status swiftlets    # Check service status"
echo "  sudo journalctl -u swiftlets -f    # View logs"
echo "  sudo systemctl restart swiftlets   # Restart service"