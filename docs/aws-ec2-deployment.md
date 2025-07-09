# AWS EC2 Deployment Guide for Swiftlets

## Current Production Deployment

🚀 **Live Site**: http://<YOUR-EC2-IP>:8080/

- **Instance**: t4g.small (ARM64, 2GB RAM)
- **OS**: Ubuntu 24.04 LTS
- **Swift**: 6.0.2 (via Docker builds)
- **Web Server**: Nginx reverse proxy on port 8080
- **Status**: ✅ 22/27 pages successfully deployed

## Overview

This guide documents deploying Swiftlets to AWS EC2 instances. The deployment uses Docker for building Linux executables and Nginx as a reverse proxy.

## Prerequisites

- AWS account with EC2 access
- AWS CLI configured locally
- Docker installed locally (for building)
- SSH key pair for EC2 instances
- Basic knowledge of Linux system administration

## EC2 Instance Requirements

### Recommended Instance Types

For production (Currently Used):
- **t4g.small** (2 vCPU, 2 GB RAM) - ARM64, excellent price/performance
- **t4g.medium** (2 vCPU, 4 GB RAM) - ARM64, for higher traffic

For development/testing:
- **t3.small** (2 vCPU, 2 GB RAM) - x86_64, if ARM not available
- **t2.micro** (1 vCPU, 1 GB RAM) - Free tier, testing only

### Operating System

- **Ubuntu 24.04 LTS** (recommended - currently in production)
- **Ubuntu 22.04 LTS** (alternative)
- Architecture: ARM64 (Graviton) recommended for cost

## Deployment Architecture

```
┌─────────────────────────────────────────┐
│           AWS EC2 Instance              │
├─────────────────────────────────────────┤
│  ┌───────────────────────────────────┐  │
│  │     Nginx (Reverse Proxy)         │  │
│  │     Port 8080 → localhost:8081    │  │
│  └───────────────────────────────────┘  │
│                    ↓                     │
│  ┌───────────────────────────────────┐  │
│  │   Swiftlets Server (Port 8081)    │  │
│  │   With bundled runtime libraries  │  │
│  └───────────────────────────────────┘  │
│                    ↓                     │
│  ┌───────────────────────────────────┐  │
│  │   Linux ARM64 Executables         │  │
│  │   Built with Docker Swift 6.0.2   │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

## Security Groups

Required inbound rules:
- **SSH (22)**: Your IP only
- **HTTP (80)**: 0.0.0.0/0 (optional)
- **Custom TCP (8080)**: 0.0.0.0/0 (main web port)
- **HTTPS (443)**: 0.0.0.0/0 (future SSL)

## Quick Deployment

### 1. Build Linux Executables Locally

```bash
# Build with Docker (from project root)
./deploy/direct-docker-build.sh

# This creates Linux ARM64 executables
```

### 2. Deploy to EC2

```bash
# Set your EC2 details
export EC2_HOST="your-ec2-ip"
export KEY_FILE="~/.ssh/your-key.pem"

# Deploy using the main script
./deploy/deploy-swiftlets-site.sh
```

## Manual Deployment Steps

### 1. Prepare EC2 Instance

```bash
# Connect to EC2
ssh -i ~/.ssh/your-key.pem ubuntu@<ec2-ip>

# Update system
sudo apt update && sudo apt upgrade -y

# Install Swift 6.1.2 (for runtime)
wget https://download.swift.org/swift-6.1.2-release/ubuntu2404-aarch64/swift-6.1.2-RELEASE/swift-6.1.2-RELEASE-ubuntu24.04-aarch64.tar.gz
tar xzf swift-6.1.2-RELEASE-ubuntu24.04-aarch64.tar.gz
sudo mv swift-6.1.2-RELEASE-ubuntu24.04-aarch64 /usr/share/swift
echo 'export PATH=/usr/share/swift/usr/bin:$PATH' | sudo tee /etc/profile.d/swift.sh

# Install Nginx
sudo apt install -y nginx
```

### 2. Build Executables with Docker

On your local machine:

```bash
# Clean previous builds
rm -rf sites/swiftlets-site/bin

# Build all executables
docker run --rm \
    -v "$(pwd):/app" \
    -w /app \
    --platform linux/arm64 \
    -m 6g \
    swift:6.0.2 \
    ./build-site sites/swiftlets-site --force

# Package with runtime libraries
./deploy/docker-build-deploy/package-deployment.sh
```

### 3. Deploy to EC2

```bash
# Upload package
scp -i ~/.ssh/your-key.pem swiftlets-deploy.tar.gz ubuntu@<ec2-ip>:~/

# On EC2, extract and setup
ssh -i ~/.ssh/your-key.pem ubuntu@<ec2-ip>
tar -xzf swiftlets-deploy.tar.gz
cd swiftlets-deploy

# Start server
export LD_LIBRARY_PATH="$(pwd)/runtime-libs:$LD_LIBRARY_PATH"
./bin/linux/arm64/swiftlets-server sites/swiftlets-site --host 127.0.0.1 --port 8081 &
```

### 4. Configure Nginx

```nginx
# /etc/nginx/sites-available/swiftlets
server {
    listen 8080 default_server;
    listen [::]:8080 default_server;
    
    location / {
        proxy_pass http://127.0.0.1:8081;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Enable and reload:
```bash
sudo ln -sf /etc/nginx/sites-available/swiftlets /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl reload nginx
```

## Known Issues and Solutions

### Cross-Compilation Challenges
- Swift 6.1.2 SDK missing tools (swift-autolink-extract)
- Solution: Use Docker with Swift 6.0.2 for building

### Build Script Limitations
- build-site only builds first file then stops
- Solution: Use direct Docker compilation script

### Memory Constraints
- 2GB RAM insufficient for on-instance builds
- Solution: Build locally with Docker, deploy binaries

### Missing Executables
- 5 files in docs/concepts/* failed to build
- These appear to have complex type expressions
- Main site functionality unaffected

## Monitoring

Check logs:
```bash
# Nginx logs
sudo tail -f /var/log/nginx/access.log

# Swiftlets process
ps aux | grep swiftlets

# System resources
htop
```

## Updates

To update the site:
1. Build new executables locally with Docker
2. Package with runtime libraries
3. Upload and extract on EC2
4. Restart the Swiftlets process

## Cost Optimization

- t4g.small ARM64: ~$12/month
- Data transfer: First 100GB free
- Consider reserved instances for long-term savings
- Use CloudFront for static assets

## Next Steps

- [ ] Set up systemd service for auto-restart
- [ ] Configure SSL with Let's Encrypt
- [ ] Implement health checks
- [ ] Set up automated deployments
- [ ] Add CloudWatch monitoring

## References

- Deployment scripts: `/deploy/`
- Docker build: `/deploy/direct-docker-build.sh`
- Main deploy script: `/deploy/deploy-swiftlets-site.sh`
- Archive of attempts: `/deploy/archive/`