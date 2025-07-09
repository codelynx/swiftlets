#\!/bin/bash
#
# Deploy with bundled runtime libraries from Docker
#

set -e

EC2_HOST="<YOUR-EC2-IP>"
EC2_USER="ubuntu"
KEY_FILE="$HOME/.ssh/<YOUR-KEY-NAME>.pem"
SITE_NAME="swiftlets-site"

echo "=== Deploying with Bundled Libraries ==="
echo ""

cd "$(dirname "$0")/../.."
PROJECT_ROOT=$(pwd)

# Extract runtime libraries from Docker
echo "1. Extracting runtime libraries from Docker..."
docker run --rm \
    --platform linux/arm64 \
    -v "$PROJECT_ROOT:/app" \
    -w /app \
    swift:6.0.2 \
    bash -c '
        # Find all Swift runtime libraries
        mkdir -p runtime-libs
        ldd /usr/bin/swift | grep "=>" | awk "{print \$3}" | grep -E "(swift|Foundation|Dispatch)" | while read lib; do
            if [ -f "$lib" ]; then
                cp "$lib" runtime-libs/
            fi
        done
        
        # Also copy key libraries
        cp /usr/lib/swift/linux/*.so runtime-libs/ 2>/dev/null || true
        
        echo "Extracted $(ls runtime-libs | wc -l) libraries"
    '

# Create deployment package
echo ""
echo "2. Creating deployment package..."
tar -czf deploy-with-libs.tar.gz \
    bin/linux/arm64/swiftlets-server \
    sites/$SITE_NAME/web \
    runtime-libs \
    run-site

echo "Package size: $(du -h deploy-with-libs.tar.gz | cut -f1)"

# Deploy to EC2
echo ""
echo "3. Uploading to EC2..."
scp -i "$KEY_FILE" deploy-with-libs.tar.gz "$EC2_USER@$EC2_HOST:~/"

echo ""
echo "4. Deploying..."
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" << 'REMOTE_DEPLOY'
set -e

# Stop existing service
sudo systemctl stop swiftlets 2>/dev/null || true

# Clean and extract
rm -rf ~/swiftlets-runtime
mkdir -p ~/swiftlets-runtime
cd ~/swiftlets-runtime
tar -xzf ~/deploy-with-libs.tar.gz

# Create wrapper script with library path
cat > run-swiftlets.sh << 'WRAPPER'
#\!/bin/bash
cd "$(dirname "$0")"
export LD_LIBRARY_PATH="$(pwd)/runtime-libs:$LD_LIBRARY_PATH"
exec ./bin/linux/arm64/swiftlets-server serve --host 0.0.0.0 --port 8080
WRAPPER
chmod +x run-swiftlets.sh

# Test binary
echo "Testing binary..."
export LD_LIBRARY_PATH="$(pwd)/runtime-libs:$LD_LIBRARY_PATH"
./bin/linux/arm64/swiftlets-server --version || echo "Version check"

# Create systemd service
sudo tee /etc/systemd/system/swiftlets.service > /dev/null << 'SERVICE'
[Unit]
Description=Swiftlets Web Server
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/swiftlets-runtime
ExecStart=/home/ubuntu/swiftlets-runtime/run-swiftlets.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
SERVICE

# Start service
sudo systemctl daemon-reload
sudo systemctl enable swiftlets
sudo systemctl start swiftlets

# Wait and test
sleep 3
if curl -s http://localhost:8080/ | grep -q "Swiftlets"; then
    echo "✅ Site is running\!"
else
    echo "❌ Site failed to start"
    sudo journalctl -u swiftlets -n 20
fi

# Cleanup
rm -f ~/deploy-with-libs.tar.gz

REMOTE_DEPLOY

# Cleanup
rm -f deploy-with-libs.tar.gz runtime-libs

echo ""
echo "✅ Deployment complete\!"
echo "Access at: http://$EC2_HOST:8080/"
