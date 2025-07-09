#!/bin/bash
#
# Simple deployment of Docker-built swiftlets to EC2
#

set -e

EC2_HOST="<YOUR-EC2-IP>"
EC2_USER="ubuntu"
KEY_FILE="$HOME/.ssh/<YOUR-KEY-NAME>.pem"

echo "=== Simple EC2 Deployment ==="
echo ""

# Create package
echo "1. Creating package..."
cd "$(dirname "$0")/../.."

# Check if binaries exist
if [ ! -f "bin/linux/arm64/swiftlets-server" ]; then
    echo "❌ No binaries found. Building with Docker first..."
    ./deploy/docker-build-deploy/docker-build-batched.sh
fi

# Create simple package
tar -czf deploy.tar.gz \
    bin/linux/arm64/swiftlets-server \
    sites/swiftlets-site/web \
    run-site

echo "Package size: $(du -h deploy.tar.gz | cut -f1)"

# Upload
echo ""
echo "2. Uploading to EC2..."
scp -i "$KEY_FILE" deploy.tar.gz "$EC2_USER@$EC2_HOST:~/"

# Deploy
echo ""
echo "3. Deploying..."
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" << 'EOF'
set -e

# Stop old service
sudo systemctl stop swiftlets 2>/dev/null || true

# Extract
rm -rf swiftlets-new
mkdir swiftlets-new
cd swiftlets-new
tar -xzf ~/deploy.tar.gz

# Test binary
echo "Testing binary..."
./bin/linux/arm64/swiftlets-server --version || echo "Binary test"

# Create simple start script
cat > start.sh << 'SCRIPT'
#!/bin/bash
cd "$(dirname "$0")"
./bin/linux/arm64/swiftlets-server serve --host 0.0.0.0 --port 8080
SCRIPT
chmod +x start.sh

# Start in background for now
echo "Starting server..."
nohup ./start.sh > server.log 2>&1 &
SERVER_PID=$!

sleep 5

# Test
echo ""
echo "Testing..."
if curl -s http://localhost:8080/ | grep -q "Swiftlets"; then
    echo "✅ Server is running!"
    echo "PID: $SERVER_PID"
else
    echo "❌ Server failed to start"
    cat server.log
fi

# Cleanup
rm ~/deploy.tar.gz

EOF

rm deploy.tar.gz

echo ""
echo "✅ Deployment complete!"
echo "Access your site at: http://$EC2_HOST:8080/"