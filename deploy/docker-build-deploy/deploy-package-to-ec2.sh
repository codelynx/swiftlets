#\!/bin/bash
#
# Deploy a complete package to EC2
#

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <package.tar.gz>"
    exit 1
fi

PACKAGE="$1"
EC2_HOST="<YOUR-EC2-IP>"
EC2_USER="ubuntu"
KEY_FILE="$HOME/.ssh/<YOUR-KEY-NAME>.pem"

echo "=== Deploying $PACKAGE to EC2 ==="

# Upload
echo "1. Uploading package..."
scp -i "$KEY_FILE" "$PACKAGE" "$EC2_USER@$EC2_HOST:/tmp/"

# Deploy
echo ""
echo "2. Deploying on EC2..."
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" << REMOTE_DEPLOY
set -e

# Stop existing services
echo "Stopping existing services..."
sudo systemctl stop swiftlets 2>/dev/null || true
pkill -f swiftlets-server || true

# Clean and setup
echo "Setting up deployment..."
rm -rf ~/swiftlets-deploy
mkdir -p ~/swiftlets-deploy
cd ~/swiftlets-deploy

# Extract
tar -xzf /tmp/$(basename "$PACKAGE")

# Create start script
cat > start-server.sh << 'SCRIPT'
#\!/bin/bash
cd "\$(dirname "\$0")"
export LD_LIBRARY_PATH="\$(pwd)/runtime-libs:\$LD_LIBRARY_PATH"
exec ./bin/linux/arm64/swiftlets-server sites/swiftlets-site --host 0.0.0.0 --port 8080
SCRIPT
chmod +x start-server.sh

# Create systemd service
sudo tee /etc/systemd/system/swiftlets.service > /dev/null << 'SERVICE'
[Unit]
Description=Swiftlets Web Server
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/swiftlets-deploy
ExecStart=/home/ubuntu/swiftlets-deploy/start-server.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
SERVICE

# Start service
echo "Starting service..."
sudo systemctl daemon-reload
sudo systemctl enable swiftlets
sudo systemctl start swiftlets

# Wait and test
sleep 5
echo ""
echo "=== Testing ==="
if curl -s http://localhost:8080/ | grep -q "Swiftlets"; then
    echo "✅ Site is running\!"
    echo ""
    echo "Homepage content:"
    curl -s http://localhost:8080/ | grep -A5 -B5 "<h1" | head -20
else
    echo "❌ Site test failed"
    echo "Service status:"
    sudo systemctl status swiftlets --no-pager
    echo ""
    echo "Logs:"
    sudo journalctl -u swiftlets -n 30
fi

# Cleanup
rm -f /tmp/$(basename "$PACKAGE")

echo ""
echo "Deployment complete\!"
echo "Disk usage: \$(df -h / | tail -1 | awk '{print \$5}') used"

REMOTE_DEPLOY

echo ""
echo "✅ Deployment finished\!"
echo "Access your site at: http://$EC2_HOST:8080/"
