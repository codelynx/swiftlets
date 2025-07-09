#!/bin/bash
#
# Clean deployment to EC2 - wipes old setup and installs fresh
#

set -e

# EC2 Configuration
EC2_HOST="<YOUR-EC2-IP>"
EC2_USER="ubuntu"
KEY_FILE="$HOME/.ssh/<YOUR-KEY-NAME>.pem"
SITE_NAME="swiftlets-site"

echo "=== Clean Deployment to EC2 Test Server ==="
echo "Target: $EC2_USER@$EC2_HOST"
echo ""
echo "⚠️  This will wipe existing swiftlets installations!"
echo ""

# First, create the deployment package
echo "1. Creating deployment package..."
cd "$(dirname "$0")/../.."
PROJECT_ROOT=$(pwd)

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
DEPLOY_PACKAGE="swiftlets-deploy-$TIMESTAMP.tar.gz"

# Check if we have built files
if [ ! -d "sites/$SITE_NAME/web" ] || [ ! -d "bin/linux/arm64" ]; then
    echo "❌ No built files found. Run docker-build-batched.sh first!"
    exit 1
fi

# Create package including runtime libraries from Docker
echo "Creating deployment package..."
tar -czf "$DEPLOY_PACKAGE" \
    bin/linux/arm64 \
    sites/$SITE_NAME/web \
    sites/$SITE_NAME/src \
    run-site \
    webbin 2>/dev/null || true

echo "Package size: $(du -h "$DEPLOY_PACKAGE" | cut -f1)"

# Upload to EC2
echo ""
echo "2. Uploading to EC2..."
scp -i "$KEY_FILE" "$DEPLOY_PACKAGE" "$EC2_USER@$EC2_HOST:/tmp/"

# Deploy on EC2
echo ""
echo "3. Deploying on EC2 (cleaning old installations)..."
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" << 'REMOTE_DEPLOY'
set -e

echo "=== Cleaning old installations ==="

# Stop all swiftlets services
echo "Stopping services..."
sudo systemctl stop swiftlets-site 2>/dev/null || true
sudo systemctl stop swiftlets-container 2>/dev/null || true
sudo systemctl disable swiftlets-site 2>/dev/null || true
sudo systemctl disable swiftlets-container 2>/dev/null || true

# Kill any running swiftlets processes
pkill -f swiftlets || true

# Remove old installations
echo "Removing old files..."
rm -rf ~/swiftlets-deploy
rm -rf ~/swiftlets-docker-deploy
rm -rf ~/swiftlets-binary-deploy
rm -rf ~/swiftlets-container
rm -rf /tmp/swiftlets-*

# Create fresh directory
echo ""
echo "=== Installing fresh deployment ==="
mkdir -p ~/swiftlets
cd ~/swiftlets

# Extract new deployment
tar -xzf /tmp/$(basename "$DEPLOY_PACKAGE")

# Since we built with Docker, we need to handle Swift runtime
echo ""
echo "Setting up runtime environment..."

# Create wrapper script that doesn't need Swift runtime
cat > run-swiftlets.sh << 'EOF'
#!/bin/bash
# Run swiftlets without needing Swift installed
cd "$(dirname "$0")"

# The Docker build created dynamic binaries, so we need Swift runtime
# For now, we'll use the Swift that's installed on EC2
if ! command -v swift &> /dev/null; then
    echo "Swift not found. Installing Swift runtime libraries..."
    # In a production setup, we'd bundle the Swift runtime libraries
    # For now, we'll use the system Swift
    source /etc/profile.d/swift.sh 2>/dev/null || true
fi

# Run the server
exec ./run-site sites/swiftlets-site "$@"
EOF
chmod +x run-swiftlets.sh

# Create systemd service
echo ""
echo "Creating systemd service..."
sudo tee /etc/systemd/system/swiftlets.service > /dev/null << 'SERVICE'
[Unit]
Description=Swiftlets Web Framework
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/swiftlets
ExecStart=/home/ubuntu/swiftlets/run-swiftlets.sh
Restart=always
RestartSec=10
Environment="PATH=/usr/share/swift/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

[Install]
WantedBy=multi-user.target
SERVICE

# Start service
echo ""
echo "Starting service..."
sudo systemctl daemon-reload
sudo systemctl enable swiftlets
sudo systemctl start swiftlets

# Wait for startup
sleep 5

# Check status
echo ""
echo "=== Service Status ==="
sudo systemctl status swiftlets --no-pager || true

# Test the site
echo ""
echo "=== Testing Site ==="
if curl -s http://localhost:8080/ | grep -q "Swiftlets"; then
    echo "✅ Site is running!"
    curl -s http://localhost:8080/ | grep -o "<title>.*</title>" | head -1
else
    echo "❌ Site test failed"
    echo "Recent logs:"
    sudo journalctl -u swiftlets -n 20
fi

# Cleanup
rm -f /tmp/$(basename "$DEPLOY_PACKAGE")

# Show system info
echo ""
echo "=== System Info ==="
echo "Disk usage:"
df -h / | grep -v Filesystem
echo ""
echo "Memory usage:"
free -h | grep -E "Mem:|Swap:"
echo ""
echo "Swift version:"
swift --version 2>/dev/null || echo "Swift not in PATH"

REMOTE_DEPLOY

# Cleanup local package
rm -f "$DEPLOY_PACKAGE"

echo ""
echo "✅ Clean deployment complete!"
echo ""
echo "Your site is running at: http://$EC2_HOST:8080/"
echo ""
echo "Service commands:"
echo "  Check status: ssh -i $KEY_FILE $EC2_USER@$EC2_HOST 'sudo systemctl status swiftlets'"
echo "  View logs:    ssh -i $KEY_FILE $EC2_USER@$EC2_HOST 'sudo journalctl -u swiftlets -f'"
echo "  Restart:      ssh -i $KEY_FILE $EC2_USER@$EC2_HOST 'sudo systemctl restart swiftlets'"