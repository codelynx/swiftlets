# EC2 Deployment Files

This directory contains all the necessary files for deploying Swiftlets to AWS EC2.

## Files Overview

### Setup and Configuration
- `setup-instance.sh` - Initial EC2 instance setup script (installs Swift, dependencies)
- `swiftlets.service` - Systemd service configuration for running Swiftlets
- `nginx.conf` - Nginx reverse proxy configuration
- `swiftlets-proxy.conf` - Nginx proxy snippet with security headers

### Build and Deployment
- `build-for-linux.sh` - Build script for creating Linux executables
- `deploy.sh` - Deployment script to push updates to EC2 instances

### Infrastructure
- `security-groups.tf` - Terraform configuration for AWS security groups
- `../../../.github/workflows/deploy-ec2.yml` - GitHub Actions workflow for automated deployment

## Quick Start

### 1. Initial EC2 Setup

On a fresh Ubuntu EC2 instance:
```bash
wget https://raw.githubusercontent.com/yourusername/swiftlets/main/deploy/ec2/setup-instance.sh
chmod +x setup-instance.sh
./setup-instance.sh
```

### 2. Configure Services

```bash
# Copy systemd service
sudo cp /opt/swiftlets/deploy/ec2/swiftlets.service /etc/systemd/system/

# Configure Nginx
sudo cp /opt/swiftlets/deploy/ec2/nginx.conf /etc/nginx/sites-available/swiftlets
sudo cp /opt/swiftlets/deploy/ec2/swiftlets-proxy.conf /etc/nginx/snippets/
sudo ln -s /etc/nginx/sites-available/swiftlets /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# Start Swiftlets
sudo systemctl enable swiftlets
sudo systemctl start swiftlets
```

### 3. Deploy Updates

From your local machine:
```bash
./deploy/ec2/deploy.sh ec2-instance.amazonaws.com swiftlets-site ~/.ssh/mykey.pem
```

## GitHub Actions Setup

Required secrets:
- `AWS_ACCESS_KEY_ID` - AWS access key
- `AWS_SECRET_ACCESS_KEY` - AWS secret key
- `EC2_SSH_PRIVATE_KEY` - Private SSH key for EC2 access

Required variables:
- `EC2_INSTANCE_ID` - Your EC2 instance ID
- `AWS_REGION` - AWS region (default: us-east-1)

## Security Considerations

1. **SSH Access**: Restrict SSH to known IPs only
2. **HTTPS**: Enable SSL/TLS with Let's Encrypt
3. **Firewall**: Use security groups and UFW
4. **Updates**: Keep system and Swift runtime updated

## Monitoring

Check service status:
```bash
sudo systemctl status swiftlets
sudo journalctl -u swiftlets -f
```

View Nginx logs:
```bash
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

## Troubleshooting

### Service won't start
1. Check logs: `sudo journalctl -u swiftlets -n 100`
2. Verify permissions: `ls -la /opt/swiftlets`
3. Test manually: `cd /opt/swiftlets && ./run-site sites/swiftlets-site`

### Build failures
1. Ensure Swift is installed: `swift --version`
2. Check available memory: `free -h`
3. Review build logs

### Connection issues
1. Verify security groups allow traffic
2. Check Nginx is running: `sudo systemctl status nginx`
3. Test backend directly: `curl http://localhost:8080`