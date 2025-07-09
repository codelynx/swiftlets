#\!/bin/bash
#
# Simple deployment with static file serving only
#

set -e

EC2_HOST="<YOUR-EC2-IP>"
EC2_USER="ubuntu"
KEY_FILE="$HOME/.ssh/<YOUR-KEY-NAME>.pem"
SITE_NAME="swiftlets-site"

echo "=== Simple Static Deployment ==="
echo ""

cd "$(dirname "$0")/../.."
PROJECT_ROOT=$(pwd)

# Check if we have the Docker-built server
if [ \! -f "bin/linux/arm64/swiftlets-server" ]; then
    echo "Server binary not found. Building..."
    docker run --rm \
        -v "$PROJECT_ROOT:/app" \
        -w /app \
        --platform linux/arm64 \
        swift:6.0.2 \
        bash -c "
            swift build -c release --product swiftlets-server
            mkdir -p bin/linux/arm64
            cp .build/release/swiftlets-server bin/linux/arm64/
        "
fi

# Get runtime libs
echo "Extracting runtime libraries..."
docker run --rm \
    -v "$PROJECT_ROOT:/app" \
    -w /app \
    --platform linux/arm64 \
    swift:6.0.2 \
    bash -c '
        mkdir -p runtime-libs
        cp -L /usr/lib/swift/linux/*.so runtime-libs/ 2>/dev/null || true
        echo "Extracted $(ls runtime-libs | wc -l) libraries"
    '

# Create static HTML files
echo "Creating static HTML files..."
mkdir -p static-site
cat > static-site/index.html << 'HTML'
<\!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swiftlets - Modern Swift Web Framework</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: -apple-system, system-ui, sans-serif;
            line-height: 1.6;
            color: #333;
            background: #f5f5f5;
        }
        .hero {
            background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            color: white;
            padding: 100px 20px;
            text-align: center;
        }
        .hero h1 { font-size: 3em; margin-bottom: 20px; }
        .hero p { font-size: 1.2em; opacity: 0.9; }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 50px;
        }
        .feature {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .feature h3 { margin-bottom: 15px; color: #2c3e50; }
        .cta {
            text-align: center;
            margin-top: 50px;
        }
        .cta a {
            display: inline-block;
            padding: 15px 30px;
            background: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
        }
        .cta a:hover { background: #2980b9; }
    </style>
</head>
<body>
    <div class="hero">
        <h1>Swiftlets</h1>
        <p>Modern Swift Web Framework with SwiftUI-Inspired Syntax</p>
    </div>
    
    <div class="container">
        <h2>Welcome to Swiftlets on EC2\!</h2>
        <p>Your Swiftlets server is running successfully on AWS EC2.</p>
        
        <div class="features">
            <div class="feature">
                <h3>🚀 Fast & Lightweight</h3>
                <p>Built with Swift for maximum performance and minimal resource usage.</p>
            </div>
            <div class="feature">
                <h3>🎨 SwiftUI-Style API</h3>
                <p>Familiar declarative syntax for Swift developers.</p>
            </div>
            <div class="feature">
                <h3>🔧 Modular Architecture</h3>
                <p>File-based routing with independent executable modules.</p>
            </div>
        </div>
        
        <div class="cta">
            <a href="/docs/">View Documentation</a>
        </div>
    </div>
    
    <footer style="text-align: center; padding: 40px; color: #666;">
        <p>Swiftlets © 2025 - Running on EC2 ARM64</p>
    </footer>
</body>
</html>
HTML

# Create package
echo "Creating deployment package..."
tar -czf static-deploy.tar.gz \
    bin/linux/arm64/swiftlets-server \
    runtime-libs \
    static-site

echo "Package size: $(du -h static-deploy.tar.gz | cut -f1)"

# Deploy
echo ""
echo "Deploying to EC2..."
scp -i "$KEY_FILE" static-deploy.tar.gz "$EC2_USER@$EC2_HOST:~/"

ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" << 'REMOTE'
set -e

# Stop existing
sudo systemctl stop swiftlets 2>/dev/null || true
pkill -f swiftlets-server || true

# Setup
rm -rf ~/swiftlets-static
mkdir -p ~/swiftlets-static
cd ~/swiftlets-static
tar -xzf ~/static-deploy.tar.gz

# Create simple HTTP server script
cat > serve.sh << 'SERVE'
#\!/bin/bash
cd "$(dirname "$0")"
export LD_LIBRARY_PATH="$(pwd)/runtime-libs:$LD_LIBRARY_PATH"

# For now, use Python to serve static files
cd static-site
python3 -m http.server 8080 --bind 0.0.0.0
SERVE
chmod +x serve.sh

# Create systemd service
sudo tee /etc/systemd/system/swiftlets-static.service > /dev/null << 'SERVICE'
[Unit]
Description=Swiftlets Static Server
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/swiftlets-static
ExecStart=/home/ubuntu/swiftlets-static/serve.sh
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

# Start
sudo systemctl daemon-reload
sudo systemctl enable swiftlets-static
sudo systemctl start swiftlets-static

# Test
sleep 3
echo ""
echo "Testing..."
if curl -s http://localhost:8080/ | grep -q "Swiftlets"; then
    echo "✅ Site is running\!"
else
    echo "❌ Failed to start"
    sudo systemctl status swiftlets-static --no-pager
fi

# Cleanup
rm ~/static-deploy.tar.gz

REMOTE

# Cleanup
rm -rf static-deploy.tar.gz runtime-libs static-site

echo ""
echo "✅ Deployment complete\!"
echo "Access your site at: http://$EC2_HOST:8080/"
