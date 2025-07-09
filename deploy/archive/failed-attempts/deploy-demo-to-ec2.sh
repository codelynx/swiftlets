#\!/bin/bash
set -e

EC2_HOST="<YOUR-EC2-IP>"
EC2_USER="ubuntu"
KEY_FILE="$HOME/.ssh/<YOUR-KEY-NAME>.pem"

echo "=== Deploying Swiftlets Demo to EC2 ==="

# Create demo content
mkdir -p demo-site
cat > demo-site/index.html << 'HTML'
<\!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swiftlets - Live on EC2\!</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: -apple-system, system-ui, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }
        .container {
            text-align: center;
            padding: 40px;
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
            max-width: 600px;
        }
        h1 { 
            font-size: 3em; 
            margin-bottom: 20px;
            animation: glow 2s ease-in-out infinite alternate;
        }
        @keyframes glow {
            from { text-shadow: 0 0 10px #fff, 0 0 20px #fff; }
            to { text-shadow: 0 0 20px #fff, 0 0 30px #fff; }
        }
        .status {
            background: #4CAF50;
            display: inline-block;
            padding: 10px 30px;
            border-radius: 50px;
            margin: 20px 0;
            font-weight: bold;
        }
        .info {
            margin-top: 30px;
            opacity: 0.9;
        }
        .tech-stack {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 30px;
            flex-wrap: wrap;
        }
        .tech {
            background: rgba(255,255,255,0.2);
            padding: 10px 20px;
            border-radius: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Swiftlets</h1>
        <div class="status">✅ Running on AWS EC2\!</div>
        
        <p class="info">
            Your Swiftlets server is successfully deployed and running on AWS EC2 ARM64 instance.
        </p>
        
        <div class="tech-stack">
            <div class="tech">Swift 6.0.2</div>
            <div class="tech">Ubuntu 24.04</div>
            <div class="tech">ARM64</div>
            <div class="tech">Nginx Proxy</div>
        </div>
        
        <p style="margin-top: 30px; font-size: 14px; opacity: 0.7;">
            Full dynamic site coming soon - executables need Linux rebuild
        </p>
    </div>
</body>
</html>
HTML

# Deploy to EC2
scp -i "$KEY_FILE" -r demo-site "$EC2_USER@$EC2_HOST:~/"

ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" << 'REMOTE'
# Update nginx root
sudo sed -i 's|root /var/www/html|root /home/ubuntu/demo-site|g' /etc/nginx/sites-available/swiftlets
sudo nginx -t && sudo systemctl reload nginx

echo "Demo deployed\!"
curl -s http://localhost/ | grep -o '<title>.*</title>'
REMOTE

rm -rf demo-site

echo ""
echo "✅ Demo deployed\!"
echo "Visit: http://$EC2_HOST/"
