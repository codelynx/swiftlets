#!/bin/bash
#
# Swiftlets EC2 Instance Setup Script
# This script prepares a fresh Ubuntu EC2 instance for running Swiftlets
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
SWIFT_VERSION="5.9.2"
UBUNTU_VERSION=$(lsb_release -rs)
ARCHITECTURE=$(uname -m)

echo -e "${GREEN}=== Swiftlets EC2 Setup Script ===${NC}"
echo "Ubuntu Version: $UBUNTU_VERSION"
echo "Architecture: $ARCHITECTURE"

# Update system
echo -e "${YELLOW}Updating system packages...${NC}"
sudo apt update && sudo apt upgrade -y

# Install dependencies
echo -e "${YELLOW}Installing required dependencies...${NC}"
sudo apt install -y \
    binutils \
    git \
    gnupg2 \
    libc6-dev \
    libcurl4-openssl-dev \
    libedit2 \
    libgcc-9-dev \
    libpython3.8 \
    libsqlite3-0 \
    libstdc++-9-dev \
    libxml2-dev \
    libz3-dev \
    pkg-config \
    tzdata \
    unzip \
    zlib1g-dev \
    nginx \
    htop \
    curl \
    wget

# Determine Swift download URL based on Ubuntu version and architecture
if [ "$UBUNTU_VERSION" = "22.04" ]; then
    if [ "$ARCHITECTURE" = "x86_64" ]; then
        SWIFT_URL="https://download.swift.org/swift-${SWIFT_VERSION}-release/ubuntu2204/swift-${SWIFT_VERSION}-RELEASE/swift-${SWIFT_VERSION}-RELEASE-ubuntu22.04.tar.gz"
    elif [ "$ARCHITECTURE" = "aarch64" ]; then
        SWIFT_URL="https://download.swift.org/swift-${SWIFT_VERSION}-release/ubuntu2204-aarch64/swift-${SWIFT_VERSION}-RELEASE/swift-${SWIFT_VERSION}-RELEASE-ubuntu22.04-aarch64.tar.gz"
    fi
elif [ "$UBUNTU_VERSION" = "20.04" ]; then
    if [ "$ARCHITECTURE" = "x86_64" ]; then
        SWIFT_URL="https://download.swift.org/swift-${SWIFT_VERSION}-release/ubuntu2004/swift-${SWIFT_VERSION}-RELEASE/swift-${SWIFT_VERSION}-RELEASE-ubuntu20.04.tar.gz"
    elif [ "$ARCHITECTURE" = "aarch64" ]; then
        SWIFT_URL="https://download.swift.org/swift-${SWIFT_VERSION}-release/ubuntu2004-aarch64/swift-${SWIFT_VERSION}-RELEASE/swift-${SWIFT_VERSION}-RELEASE-ubuntu20.04-aarch64.tar.gz"
    fi
else
    echo -e "${RED}Unsupported Ubuntu version: $UBUNTU_VERSION${NC}"
    exit 1
fi

# Install Swift
echo -e "${YELLOW}Installing Swift ${SWIFT_VERSION}...${NC}"
cd /tmp
wget "$SWIFT_URL" -O swift.tar.gz
tar xzf swift.tar.gz
sudo rm -rf /usr/share/swift
sudo mv swift-${SWIFT_VERSION}-RELEASE-ubuntu* /usr/share/swift

# Add Swift to PATH for all users
echo 'export PATH=/usr/share/swift/usr/bin:$PATH' | sudo tee /etc/profile.d/swift.sh
source /etc/profile.d/swift.sh

# Verify Swift installation
echo -e "${YELLOW}Verifying Swift installation...${NC}"
swift --version

# Create application directory
echo -e "${YELLOW}Creating application directory...${NC}"
sudo mkdir -p /opt/swiftlets
sudo chown $USER:$USER /opt/swiftlets

# Create log directory
sudo mkdir -p /var/log/swiftlets
sudo chown $USER:$USER /var/log/swiftlets

# Set up swap (optional, for smaller instances)
if [ ! -f /swapfile ]; then
    echo -e "${YELLOW}Setting up 2GB swap file...${NC}"
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

# Configure firewall
echo -e "${YELLOW}Configuring firewall...${NC}"
sudo ufw allow 22/tcp   # SSH
sudo ufw allow 80/tcp   # HTTP
sudo ufw allow 443/tcp  # HTTPS
sudo ufw --force enable

echo -e "${GREEN}=== Setup Complete ===${NC}"
echo ""
echo "Next steps:"
echo "1. Deploy your Swiftlets application to /opt/swiftlets"
echo "2. Configure Nginx (see deploy/ec2/nginx.conf)"
echo "3. Set up systemd service (see deploy/ec2/swiftlets.service)"
echo "4. Start the Swiftlets service"
echo ""
echo "To deploy your application:"
echo "  cd /opt/swiftlets"
echo "  git clone <your-repo> ."
echo "  ./build-site sites/swiftlets-site"