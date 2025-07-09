# Production Deployment Guide

## Overview

This guide documents the current production deployment of Swiftlets on AWS EC2 with custom DNS and systemd service management.

## Live Site

🚀 **Production URL**: http://swiftlet.eastlynx.com:8080/

## Infrastructure

### EC2 Instance
- **Type**: t4g.small (ARM64 Graviton2)
- **OS**: Ubuntu 24.04 LTS
- **Region**: us-east-1
- **IP**: `<YOUR-EC2-IP>` (Elastic IP recommended)

### Software Stack
- **Swift**: 6.1.2 (runtime) / 6.0.2 (Docker builds)
- **Web Server**: Nginx reverse proxy
- **Process Manager**: systemd
- **DNS**: AWS Route 53

## DNS Configuration

### Route 53 Setup

1. **Create A Record**:
```bash
# Using AWS CLI
aws route53 change-resource-record-sets \
  --hosted-zone-id <YOUR-ZONE-ID> \
  --change-batch '{
    "Changes": [{
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "swiftlet.yourdomain.com",
        "Type": "A",
        "TTL": 300,
        "ResourceRecords": [{"Value": "<YOUR-EC2-IP>"}]
      }
    }]
  }'
```

2. **Verify DNS**:
```bash
nslookup swiftlet.yourdomain.com
dig swiftlet.yourdomain.com
```

## Systemd Service Configuration

### Service File

Located at `/etc/systemd/system/swiftlets.service`:

```ini
[Unit]
Description=Swiftlets Web Server
After=network.target
Wants=network-online.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/swiftlets-prod
Environment="LD_LIBRARY_PATH=/home/ubuntu/swiftlets-prod/runtime-libs"
ExecStart=/home/ubuntu/swiftlets-prod/bin/linux/arm64/swiftlets-server sites/swiftlets-site --host 127.0.0.1 --port 8081
Restart=always
RestartSec=10
StandardOutput=append:/home/ubuntu/swiftlets-prod/server.log
StandardError=append:/home/ubuntu/swiftlets-prod/server.log

# Process management
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=30

# Resource limits
LimitNOFILE=65536
MemoryMax=1G

[Install]
WantedBy=multi-user.target
```

### Service Management

```bash
# Enable service (start on boot)
sudo systemctl enable swiftlets

# Start/Stop/Restart
sudo systemctl start swiftlets
sudo systemctl stop swiftlets
sudo systemctl restart swiftlets

# Check status
sudo systemctl status swiftlets

# View logs
sudo journalctl -u swiftlets -f        # Live logs
sudo journalctl -u swiftlets -n 100    # Last 100 lines
sudo journalctl -u swiftlets --since "1 hour ago"

# Reload systemd after config changes
sudo systemctl daemon-reload
```

## Nginx Configuration

### Reverse Proxy Setup

Located at `/etc/nginx/sites-available/swiftlets`:

```nginx
server {
    listen 8080 default_server;
    listen [::]:8080 default_server;
    
    server_name swiftlet.yourdomain.com;
    
    # Proxy to Swiftlets
    location / {
        proxy_pass http://127.0.0.1:8081;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
    
    # Static files (optional optimization)
    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        proxy_pass http://127.0.0.1:8081;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

### Nginx Management

```bash
# Test configuration
sudo nginx -t

# Reload configuration
sudo systemctl reload nginx

# Check status
sudo systemctl status nginx

# View logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

## Deployment Process

### 1. Build Executables (Local)

```bash
# From project root
./deploy/docker-build-deploy/direct-docker-build.sh

# This creates Linux ARM64 executables in:
# sites/swiftlets-site/bin/
```

### 2. Deploy to EC2

```bash
# Quick deployment script
cat > deploy-update.sh << 'EOF'
#!/bin/bash
EC2_HOST="<YOUR-EC2-IP>"
EC2_USER="ubuntu"
KEY_FILE="~/.ssh/<YOUR-KEY-NAME>.pem"

# Package executables
tar -czf update.tar.gz sites/swiftlets-site/bin

# Upload and deploy
scp -i "$KEY_FILE" update.tar.gz "$EC2_USER@$EC2_HOST:/tmp/"
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" 'cd /home/ubuntu/swiftlets-prod && \
  tar -xzf /tmp/update.tar.gz && \
  sudo systemctl restart swiftlets && \
  rm /tmp/update.tar.gz'

rm update.tar.gz
echo "✅ Deployment complete!"
EOF

chmod +x deploy-update.sh
./deploy-update.sh
```

## Monitoring

### Health Checks

```bash
# Basic health check
curl -f http://swiftlet.yourdomain.com:8080/ || echo "Site is down!"

# Check specific endpoints
curl -s http://swiftlet.yourdomain.com:8080/docs/ | grep -q "Documentation"

# Monitor response time
curl -w "@curl-format.txt" -o /dev/null -s http://swiftlet.yourdomain.com:8080/
```

### System Monitoring

```bash
# CPU and Memory
htop

# Disk usage
df -h

# Network connections
sudo netstat -tlnp | grep -E "(8080|8081)"

# Process monitoring
ps aux | grep swiftlet
```

### Log Analysis

```bash
# Recent errors
sudo journalctl -u swiftlets -p err -n 50

# Request patterns
sudo awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -rn | head -20

# Response codes
sudo awk '{print $9}' /var/log/nginx/access.log | sort | uniq -c | sort -rn
```

## Troubleshooting

### Service Won't Start

```bash
# Check logs
sudo journalctl -u swiftlets -n 100

# Verify executable permissions
ls -la /home/ubuntu/swiftlets-prod/bin/linux/arm64/

# Check runtime libraries
ldd /home/ubuntu/swiftlets-prod/bin/linux/arm64/swiftlets-server

# Test manually
cd /home/ubuntu/swiftlets-prod
export LD_LIBRARY_PATH="$(pwd)/runtime-libs:$LD_LIBRARY_PATH"
./bin/linux/arm64/swiftlets-server sites/swiftlets-site --host 127.0.0.1 --port 8081
```

### Port Issues

```bash
# Check what's using ports
sudo lsof -i :8080
sudo lsof -i :8081

# Verify firewall rules
sudo ufw status

# Check EC2 security groups via AWS Console
```

### DNS Not Resolving

```bash
# Check Route 53 record
aws route53 list-resource-record-sets --hosted-zone-id <YOUR-ZONE-ID>

# Test DNS propagation
dig @8.8.8.8 swiftlet.yourdomain.com
nslookup swiftlet.yourdomain.com

# Clear local DNS cache (macOS)
sudo dscacheutil -flushcache
```

## Backup and Recovery

### Backup Strategy

```bash
# Backup executables and configuration
tar -czf swiftlets-backup-$(date +%Y%m%d).tar.gz \
  /home/ubuntu/swiftlets-prod \
  /etc/systemd/system/swiftlets.service \
  /etc/nginx/sites-available/swiftlets

# Store in S3
aws s3 cp swiftlets-backup-*.tar.gz s3://your-backup-bucket/
```

### Recovery Process

1. Launch new EC2 instance
2. Run setup scripts from `/deploy/ec2/`
3. Restore from backup
4. Update Route 53 to point to new instance

## Security Best Practices

1. **EC2 Security Groups**:
   - SSH (22): Your IP only
   - HTTP (8080): 0.0.0.0/0
   - All other ports: Closed

2. **Updates**:
   ```bash
   # Regular system updates
   sudo apt update && sudo apt upgrade -y
   
   # Security updates only
   sudo unattended-upgrades
   ```

3. **Monitoring**:
   - Enable CloudWatch for EC2
   - Set up billing alerts
   - Monitor failed SSH attempts

## Cost Optimization

- **Instance**: t4g.small (~$12/month)
- **Storage**: 15GB EBS (~$1.50/month)
- **Data Transfer**: First 100GB free
- **Route 53**: $0.50/hosted zone + queries

### Tips:
- Use Reserved Instances for 30-70% savings
- Enable auto-shutdown for dev instances
- Consider Savings Plans for flexibility

## Future Enhancements

1. **SSL/TLS Setup**:
   - Use Let's Encrypt with Certbot
   - Configure nginx for HTTPS
   - Redirect HTTP to HTTPS

2. **Performance**:
   - Enable nginx caching
   - Use CloudFront CDN
   - Optimize static assets

3. **High Availability**:
   - Multi-AZ deployment
   - Application Load Balancer
   - Auto Scaling Groups

4. **Monitoring**:
   - CloudWatch dashboards
   - SNS alerts
   - APM tools (New Relic, DataDog)