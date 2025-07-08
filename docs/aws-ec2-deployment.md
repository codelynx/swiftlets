# AWS EC2 Deployment Guide for Swiftlets

## Overview

This guide covers deploying Swiftlets to AWS EC2 instances. Swiftlets' modular architecture makes it well-suited for cloud deployment, with each swiftlet running as an isolated executable.

## Prerequisites

- AWS account with EC2 access
- AWS CLI configured locally
- Swift runtime installed on EC2 (we'll cover this)
- Basic knowledge of Linux system administration

## EC2 Instance Requirements

### Recommended Instance Types

For development/testing:
- **t3.micro** (1 vCPU, 1 GB RAM) - Free tier eligible
- **t3.small** (2 vCPU, 2 GB RAM) - Better performance

For production:
- **t3.medium** (2 vCPU, 4 GB RAM) - Small to medium traffic
- **t3.large** (2 vCPU, 8 GB RAM) - Medium to high traffic
- **c5.large** (2 vCPU, 4 GB RAM) - Compute-optimized for heavy processing

### Operating System

- **Ubuntu 22.04 LTS** (recommended)
- **Ubuntu 20.04 LTS** (also supported)
- Architecture: x86_64 or ARM64 (Graviton instances)

## Deployment Architecture

```
┌─────────────────────────────────────────┐
│           AWS EC2 Instance              │
├─────────────────────────────────────────┤
│  ┌───────────────────────────────────┐  │
│  │     Nginx (Reverse Proxy)         │  │
│  │     Port 80/443 → 8080            │  │
│  └───────────────────────────────────┘  │
│                    ↓                     │
│  ┌───────────────────────────────────┐  │
│  │   Swiftlets Server (Port 8080)    │  │
│  │   Running as systemd service      │  │
│  └───────────────────────────────────┘  │
│                    ↓                     │
│  ┌───────────────────────────────────┐  │
│  │   Swiftlet Executables            │  │
│  │   /opt/swiftlets/bin/linux/...    │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

## Security Considerations

### Security Groups

Required inbound rules:
- **SSH (22)**: Your IP only
- **HTTP (80)**: 0.0.0.0/0 (if public)
- **HTTPS (443)**: 0.0.0.0/0 (if using SSL)

### IAM Roles

Create an EC2 role with minimal permissions:
- S3 access (if storing assets)
- CloudWatch Logs (for logging)
- Systems Manager (for remote management)

## Deployment Steps

### 1. Prepare EC2 Instance

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Swift dependencies
sudo apt install -y \
    binutils \
    git \
    gnupg2 \
    libc6-dev \
    libcurl4-openssl-dev \
    libedit2 \
    libgcc-9-dev \
    libpython3.8 \
    libsqlite3-0 \
    libstdc++-9-dev \
    libxml2-dev \
    libz3-dev \
    pkg-config \
    tzdata \
    unzip \
    zlib1g-dev

# Install Swift (Ubuntu 22.04 example)
wget https://download.swift.org/swift-5.9.2-release/ubuntu2204/swift-5.9.2-RELEASE/swift-5.9.2-RELEASE-ubuntu22.04.tar.gz
tar xzf swift-5.9.2-RELEASE-ubuntu22.04.tar.gz
sudo mv swift-5.9.2-RELEASE-ubuntu22.04 /usr/share/swift
echo 'export PATH=/usr/share/swift/usr/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

### 2. Install Nginx

```bash
sudo apt install -y nginx
sudo systemctl enable nginx
```

### 3. Deploy Swiftlets

```bash
# Create application directory
sudo mkdir -p /opt/swiftlets
sudo chown ubuntu:ubuntu /opt/swiftlets

# Clone or copy your Swiftlets project
cd /opt/swiftlets
git clone https://github.com/yourusername/swiftlets.git .

# Build for Linux
./build-site sites/swiftlets-site
```

### 4. Configure Systemd Service

Create `/etc/systemd/system/swiftlets.service`:

```ini
[Unit]
Description=Swiftlets Web Server
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/opt/swiftlets
ExecStart=/opt/swiftlets/run-site sites/swiftlets-site --port 8080
Restart=always
RestartSec=10
StandardOutput=append:/var/log/swiftlets/access.log
StandardError=append:/var/log/swiftlets/error.log

# Security hardening
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/opt/swiftlets/sites/swiftlets-site/var

[Install]
WantedBy=multi-user.target
```

### 5. Configure Nginx

Create `/etc/nginx/sites-available/swiftlets`:

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # Static assets (optional optimization)
    location ~ \.(jpg|jpeg|png|gif|ico|css|js)$ {
        root /opt/swiftlets/sites/swiftlets-site/public;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

Enable the site:
```bash
sudo ln -s /etc/nginx/sites-available/swiftlets /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 6. Start Services

```bash
# Create log directory
sudo mkdir -p /var/log/swiftlets
sudo chown ubuntu:ubuntu /var/log/swiftlets

# Start Swiftlets
sudo systemctl daemon-reload
sudo systemctl enable swiftlets
sudo systemctl start swiftlets

# Check status
sudo systemctl status swiftlets
```

## Monitoring and Maintenance

### Logs

- Swiftlets logs: `/var/log/swiftlets/`
- Nginx logs: `/var/log/nginx/`
- System logs: `journalctl -u swiftlets`

### Health Checks

Create a health check endpoint in your Swiftlets app:

```swift
// sites/swiftlets-site/src/health.swift
import Swiftlets

@main
struct HealthCheck: Swiftlet {
    var body: some HTML {
        Text("OK")
    }
}
```

### Updates and Deployment

For zero-downtime deployments:

```bash
#!/bin/bash
# deploy.sh

# Pull latest code
cd /opt/swiftlets
git pull origin main

# Build new executables
./build-site sites/swiftlets-site

# Graceful restart
sudo systemctl reload swiftlets
```

## Performance Optimization

### 1. Enable Swap (for smaller instances)

```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

### 2. Process Pool Configuration

Configure Swiftlets to use process pooling:

```bash
# In systemd service or startup script
ExecStart=/opt/swiftlets/run-site sites/swiftlets-site --port 8080 --pool-size 4
```

### 3. CDN Integration

Use CloudFront for static assets:
- Create CloudFront distribution
- Point origin to your EC2 instance
- Configure cache behaviors for static files

## Backup Strategy

### Automated Backups

Create a backup script:

```bash
#!/bin/bash
# /opt/swiftlets/backup.sh

BACKUP_DIR="/opt/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Backup site data
tar -czf "$BACKUP_DIR/swiftlets_$TIMESTAMP.tar.gz" \
    /opt/swiftlets/sites/*/var \
    /opt/swiftlets/sites/*/.res

# Upload to S3 (requires AWS CLI)
aws s3 cp "$BACKUP_DIR/swiftlets_$TIMESTAMP.tar.gz" \
    s3://your-backup-bucket/swiftlets/

# Clean old local backups (keep last 7 days)
find "$BACKUP_DIR" -name "swiftlets_*.tar.gz" -mtime +7 -delete
```

Add to crontab:
```bash
0 2 * * * /opt/swiftlets/backup.sh
```

## Troubleshooting

### Common Issues

1. **Port conflicts**: Ensure nothing else is using port 8080
2. **Permission errors**: Check file ownership and systemd user
3. **Memory issues**: Monitor with `htop`, consider larger instance
4. **Build failures**: Ensure all Swift dependencies are installed

### Debug Commands

```bash
# Check service logs
journalctl -u swiftlets -f

# Test Swiftlets directly
cd /opt/swiftlets
./run-site sites/swiftlets-site --port 8080

# Check port binding
sudo netstat -tlnp | grep 8080

# Monitor resources
htop
```

## Cost Optimization

1. Use Spot Instances for development/testing
2. Enable Auto Scaling for production
3. Use Graviton (ARM) instances for better price/performance
4. Implement proper caching headers
5. Consider Lambda for infrequently accessed swiftlets

## Next Steps

- Set up SSL/TLS with Let's Encrypt
- Configure CloudWatch monitoring
- Implement auto-scaling policies
- Set up CI/CD pipeline
- Configure database connections (if needed)