#!/bin/bash
#
# Deploy and test hello world binary on EC2
#

set -e

EC2_HOST="<YOUR-EC2-IP>"
EC2_USER="ubuntu"
KEY_FILE="$HOME/.ssh/<YOUR-KEY-NAME>.pem"

echo "=== Deploying POC to EC2 ==="
echo ""

# Check if we have the ARM64 binary
if [ ! -f hello-arm64 ]; then
    echo "❌ hello-arm64 not found. Run compile-workaround.sh first."
    exit 1
fi

echo "1. Uploading binary to EC2..."
scp -i "$KEY_FILE" hello-arm64 "$EC2_USER@$EC2_HOST:/tmp/"

echo ""
echo "2. Testing on EC2..."
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" << 'REMOTE_TEST'
echo "EC2 System info:"
uname -a
echo ""

echo "Testing hello-arm64 binary:"
chmod +x /tmp/hello-arm64
/tmp/hello-arm64

echo ""
echo "Binary details:"
file /tmp/hello-arm64
ldd /tmp/hello-arm64 2>/dev/null || echo "ldd not available or static binary"

echo ""
echo "✅ POC Test complete!"
REMOTE_TEST

echo ""
echo "=== Summary ==="
echo "Docker ARM64 build: ✅ Works"
echo "Cross-compilation with SDK: ❌ Fails (missing swift-autolink-extract)"
echo "Deployment to EC2: ✅ Works"
echo ""
echo "Conclusion: Use Docker with --platform linux/arm64 for building"