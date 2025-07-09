#!/bin/bash
#
# Deploy pre-built Docker binaries to EC2
#

set -e

# EC2 Configuration
EC2_HOST="<YOUR-EC2-IP>"
EC2_USER="ubuntu"
KEY_FILE="$HOME/.ssh/<YOUR-KEY-NAME>.pem"
SITE_NAME="swiftlets-site"

echo "=== Deploying Pre-built Binaries to EC2 ==="
echo ""

# Go to project root
cd "$(dirname "$0")/../.."
PROJECT_ROOT=$(pwd)

# Check pre-built binaries exist
if [ ! -f "bin/linux/arm64/swiftlets-server" ]; then
    echo "❌ No pre-built binaries found!"
    echo "Run ./deploy/docker-build-deploy/docker-build-batched.sh first"
    exit 1
fi

# Create deployment package with ONLY pre-built files
echo "1. Creating deployment package (pre-built files only)..."
DEPLOY_DIR="/tmp/swiftlets-prebuilt-$$"
mkdir -p "$DEPLOY_DIR"

# Copy pre-built binaries
cp -r bin "$DEPLOY_DIR/"
cp -r sites/$SITE_NAME/web "$DEPLOY_DIR/web"
cp -r sites/$SITE_NAME/src "$DEPLOY_DIR/src"
cp run-site "$DEPLOY_DIR/"

# Copy webbin if exists
if [ -d "webbin" ]; then
    cp -r webbin "$DEPLOY_DIR/"
fi

# Create a modified run-site that skips building
cat > "$DEPLOY_DIR/run-site-prebuilt" << 'EOF'
#!/bin/bash
# Modified run-site that uses pre-built binaries

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Default values
HOST="127.0.0.1"
PORT="8080"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --host)
            HOST="$2"
            shift 2
            ;;
        --port)
            PORT="$2"
            shift 2
            ;;
        *)
            SITE_PATH="$1"
            shift
            ;;
    esac
done

# Use pre-built server binary
SERVER_BIN="$SCRIPT_DIR/bin/linux/arm64/swiftlets-server"

if [ ! -f "$SERVER_BIN" ]; then
    echo "Error: Pre-built server not found at $SERVER_BIN"
    exit 1
fi

echo "Starting pre-built Swiftlets server..."
echo "Host: $HOST"
echo "Port: $PORT"

# Run the pre-built server
exec "$SERVER_BIN" serve --host "$HOST" --port "$PORT"
EOF
chmod +x "$DEPLOY_DIR/run-site-prebuilt"

# Create package
cd "$DEPLOY_DIR"
tar -czf swiftlets-prebuilt.tar.gz *
mv swiftlets-prebuilt.tar.gz "$PROJECT_ROOT/"
cd "$PROJECT_ROOT"
rm -rf "$DEPLOY_DIR"

echo "Package size: $(du -h swiftlets-prebuilt.tar.gz | cut -f1)"

# Upload to EC2
echo ""
echo "2. Uploading to EC2..."
scp -i "$KEY_FILE" swiftlets-prebuilt.tar.gz "$EC2_USER@$EC2_HOST:/tmp/"

# Deploy on EC2
echo ""
echo "3. Deploying on EC2..."
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" << 'REMOTE_SCRIPT'
set -e

# Stop existing service
echo "Stopping existing services..."
sudo systemctl stop swiftlets 2>/dev/null || true
sudo systemctl stop swiftlets-site 2>/dev/null || true

# Clean old installations
echo "Cleaning old installations..."
rm -rf /opt/swiftlets
sudo mkdir -p /opt/swiftlets
sudo chown ubuntu:ubuntu /opt/swiftlets

# Extract new deployment
echo "Installing pre-built binaries..."
cd /opt/swiftlets
tar -xzf /tmp/swiftlets-prebuilt.tar.gz

# Make binaries executable
chmod +x bin/linux/arm64/swiftlets-server
chmod +x run-site-prebuilt

# Create systemd service
echo "Creating systemd service..."
sudo tee /etc/systemd/system/swiftlets.service > /dev/null << 'SERVICE'
[Unit]
Description=Swiftlets Web Server (Pre-built)
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/opt/swiftlets
ExecStart=/opt/swiftlets/run-site-prebuilt sites/swiftlets-site --host 0.0.0.0 --port 8080
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
SERVICE

# Start service
echo "Starting service..."
sudo systemctl daemon-reload
sudo systemctl enable swiftlets
sudo systemctl restart swiftlets

# Wait for startup
sleep 3

# Check status
echo ""
echo "=== Service Status ==="
sudo systemctl status swiftlets --no-pager || true

# Test the site
echo ""
echo "=== Testing Site ==="
if curl -s -m 5 http://localhost:8080/ | grep -q "Swiftlets"; then
    echo "✅ Site is running with pre-built binaries!"
else
    echo "❌ Site test failed"
    sudo journalctl -u swiftlets -n 20
fi

# Cleanup
rm -f /tmp/swiftlets-prebuilt.tar.gz

# Show info
echo ""
echo "Disk usage: $(df -h / | tail -1 | awk '{print $5}') used"

REMOTE_SCRIPT

# Cleanup local package
rm -f swiftlets-prebuilt.tar.gz

echo ""
echo "✅ Pre-built deployment complete!"
echo ""
echo "Your site should be running at: http://$EC2_HOST:8080/"
echo "Using pre-built binaries (no compilation on EC2)"