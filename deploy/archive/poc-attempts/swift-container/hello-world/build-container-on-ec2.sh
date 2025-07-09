#!/bin/bash
#
# Build container image on EC2
#

set -e

echo "=== Build Container on EC2 ==="

cd "$(dirname "$0")"

EC2_HOST="<YOUR-EC2-IP>"
EC2_USER="ubuntu"
KEY_FILE="$HOME/.ssh/<YOUR-KEY-NAME>.pem"

# Deploy and build container on EC2
echo "Building container on EC2..."
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" << 'REMOTE_SCRIPT'
set -e

cd /tmp/hello-world-build

echo "Setting up Swift path..."
export PATH=/usr/share/swift/usr/bin:$PATH

echo "Building container image..."
swift package --allow-writing-to-package-directory container-build

echo ""
echo "Checking built image..."
ls -la .build/container-images/

echo ""
echo "✅ Container built successfully on EC2!"
REMOTE_SCRIPT

echo ""
echo "✅ Complete! Container image built on EC2."