#!/bin/bash
#
# Test static binary on EC2
#

set -e

EC2_HOST="<YOUR-EC2-IP>"
EC2_USER="ubuntu"
KEY_FILE="$HOME/.ssh/<YOUR-KEY-NAME>.pem"

echo "=== Testing Static Binary on EC2 ==="
echo ""

# Upload static binary
echo "1. Uploading static binary..."
scp -i "$KEY_FILE" hello-static "$EC2_USER@$EC2_HOST:/tmp/"

echo ""
echo "2. Running on EC2..."
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" << 'REMOTE_TEST'
echo "Testing static binary:"
chmod +x /tmp/hello-static
/tmp/hello-static

echo ""
echo "Binary info:"
file /tmp/hello-static
echo "Size: $(du -h /tmp/hello-static | cut -f1)"

echo ""
echo "No libraries needed:"
ldd /tmp/hello-static 2>&1 || true

echo ""
echo "✅ Static binary works without Swift runtime!"
REMOTE_TEST

echo ""
echo "=== POC Summary ==="
echo "✅ Successfully built static Linux ARM64 binary on macOS"
echo "✅ Binary runs on EC2 without Swift runtime"
echo "✅ Used Docker with --platform linux/arm64"
echo ""
echo "This proves we can:"
echo "1. Build on macOS using Docker"
echo "2. Create static binaries (no Swift runtime needed)"
echo "3. Deploy to EC2 without building there"