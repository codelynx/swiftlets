#!/bin/bash
#
# Swiftlets EC2 Instance Setup Script for Ubuntu 24.04
# This script prepares a fresh Ubuntu 24.04 EC2 instance for running Swiftlets
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
SWIFT_VERSION="6.0.2"
UBUNTU_VERSION=$(lsb_release -rs)
ARCHITECTURE=$(uname -m)

echo -e "${GREEN}=== Swiftlets EC2 Setup Script ===${NC}"
echo "Ubuntu Version: $UBUNTU_VERSION"
echo "Architecture: $ARCHITECTURE"

# Verify Ubuntu version
if [[ ! "$UBUNTU_VERSION" =~ ^24\. ]]; then
    echo -e "${RED}This script is for Ubuntu 24.04. Detected: $UBUNTU_VERSION${NC}"
    echo "Use setup-instance.sh for older Ubuntu versions."
    exit 1
fi

# Update system
echo -e "${YELLOW}Updating system packages...${NC}"
sudo apt update && sudo apt upgrade -y

# Install dependencies for Ubuntu 24.04
echo -e "${YELLOW}Installing required dependencies...${NC}"
sudo apt install -y \
    binutils \
    git \
    gnupg2 \
    libc6-dev \
    libcurl4 \
    libedit2 \
    libgcc-s1 \
    libpython3.12 \
    libsqlite3-0 \
    libstdc++6 \
    libxml2 \
    libz3-4 \
    pkg-config \
    tzdata \
    unzip \
    zlib1g-dev \
    nginx \
    htop \
    curl \
    wget \
    build-essential

# Determine Swift download URL based on architecture
if [ "$ARCHITECTURE" = "x86_64" ]; then
    SWIFT_URL="https://download.swift.org/swift-${SWIFT_VERSION}-release/ubuntu2404/swift-${SWIFT_VERSION}-RELEASE/swift-${SWIFT_VERSION}-RELEASE-ubuntu24.04.tar.gz"
elif [ "$ARCHITECTURE" = "aarch64" ]; then
    SWIFT_URL="https://download.swift.org/swift-${SWIFT_VERSION}-release/ubuntu2404-aarch64/swift-${SWIFT_VERSION}-RELEASE/swift-${SWIFT_VERSION}-RELEASE-ubuntu24.04-aarch64.tar.gz"
else
    echo -e "${RED}Unsupported architecture: $ARCHITECTURE${NC}"
    exit 1
fi

# Install Swift
echo -e "${YELLOW}Installing Swift ${SWIFT_VERSION}...${NC}"
cd /tmp
echo "Downloading from: $SWIFT_URL"
wget "$SWIFT_URL" -O swift.tar.gz
tar xzf swift.tar.gz
sudo rm -rf /usr/share/swift
sudo mv swift-${SWIFT_VERSION}-RELEASE-ubuntu24.04* /usr/share/swift

# Add Swift to PATH for all users
echo 'export PATH=/usr/share/swift/usr/bin:$PATH' | sudo tee /etc/profile.d/swift.sh
source /etc/profile.d/swift.sh

# Verify Swift installation
echo -e "${YELLOW}Verifying Swift installation...${NC}"
export PATH=/usr/share/swift/usr/bin:$PATH
swift --version

# Create application directory
echo -e "${YELLOW}Creating application directory...${NC}"
sudo mkdir -p /opt/swiftlets
sudo chown $USER:$USER /opt/swiftlets

# Create log directory
sudo mkdir -p /var/log/swiftlets
sudo chown $USER:$USER /var/log/swiftlets

# Set up swap (recommended for smaller instances)
if [ ! -f /swapfile ]; then
    echo -e "${YELLOW}Setting up 4GB swap file...${NC}"
    sudo fallocate -l 4G /swapfile
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
sudo ufw allow 8080/tcp # Swiftlets development
sudo ufw --force enable

# Clean up
echo -e "${YELLOW}Cleaning up...${NC}"
rm -f /tmp/swift.tar.gz
sudo apt autoremove -y
sudo apt clean

echo -e "${GREEN}=== Setup Complete ===${NC}"
echo ""
echo "Swift ${SWIFT_VERSION} is installed and ready!"
echo ""
echo "Next steps:"
echo "1. Deploy your Swiftlets application to /opt/swiftlets"
echo "2. Configure Nginx (see deploy/ec2/nginx.conf)"
echo "3. Set up systemd service (see deploy/ec2/swiftlets.service)"
echo "4. Start the Swiftlets service"
echo ""
echo "To use Swift in new SSH sessions:"
echo "  source /etc/profile.d/swift.sh"
echo ""
echo "To deploy your application:"
echo "  cd /opt/swiftlets"
echo "  git clone <your-repo> ."
echo "  ./build-site sites/swiftlets-site"
echo "  ./run-site sites/swiftlets-site"