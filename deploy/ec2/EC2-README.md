# EC2 Deployment Guide for Swiftlets

This directory contains scripts and configuration for deploying Swiftlets to AWS EC2 instances.

## Prerequisites

- AWS EC2 instance (Ubuntu 20.04, 22.04, or 24.04)
- SSH access to the instance
- Minimum instance size: t3.small or t4g.small (2GB RAM)

## Setup Scripts

### For Ubuntu 24.04 (Recommended)
```bash
# Copy and run the setup script
scp -i ~/.ssh/your-key.pem setup-instance-ubuntu24.sh ubuntu@<ec2-ip>:/tmp/
ssh -i ~/.ssh/your-key.pem ubuntu@<ec2-ip> "bash /tmp/setup-instance-ubuntu24.sh"
```

This installs:
- Swift 6.0.2
- All required dependencies
- Nginx for reverse proxy
- 4GB swap file for build performance

### For Ubuntu 20.04/22.04
```bash
# Copy and run the setup script
scp -i ~/.ssh/your-key.pem setup-instance.sh ubuntu@<ec2-ip>:/tmp/
ssh -i ~/.ssh/your-key.pem ubuntu@<ec2-ip> "bash /tmp/setup-instance.sh"
```

This installs:
- Swift 5.9.2
- All required dependencies
- Nginx for reverse proxy
- 2GB swap file

## Deployment

After setting up the instance, deploy Swiftlets:

```bash
# Deploy from your local machine
EC2_HOST=<ec2-ip> KEY_FILE=~/.ssh/your-key.pem ./deploy-swiftlets.sh
```

Options:
- `EC2_HOST` - Required: IP address of your EC2 instance
- `EC2_USER` - Optional: SSH user (default: ubuntu)
- `KEY_FILE` - Optional: Path to SSH key (default: ~/.ssh/id_rsa)
- `SITE_NAME` - Optional: Site to deploy (default: swiftlets-site)

## What the Deployment Does

1. **Packages** your Swiftlets application (excluding unnecessary files)
2. **Uploads** to EC2 instance
3. **Builds** the Swift framework and site on the instance
4. **Configures** systemd service for automatic startup
5. **Starts** the Swiftlets server on port 8080

## Service Management

Once deployed, manage the service with:

```bash
# Check status
sudo systemctl status swiftlets

# View logs
sudo journalctl -u swiftlets -f

# Restart service
sudo systemctl restart swiftlets

# Stop service
sudo systemctl stop swiftlets
```

## Nginx Configuration

To serve on port 80/443, configure Nginx as a reverse proxy:

```bash
# Copy nginx config
scp -i ~/.ssh/your-key.pem nginx.conf ubuntu@<ec2-ip>:/tmp/

# On EC2 instance
sudo cp /tmp/nginx.conf /etc/nginx/sites-available/swiftlets
sudo ln -s /etc/nginx/sites-available/swiftlets /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## Architecture Support

- **x86_64**: Intel/AMD instances (t3, m5, c5 series)
- **ARM64**: Graviton instances (t4g, m6g, c6g series) - Recommended for cost efficiency

## Troubleshooting

### Build Failures
- Ensure at least 2GB RAM + swap
- Check Swift installation: `swift --version`
- View build logs: `sudo journalctl -u swiftlets`

### Connection Issues
- Check security group allows ports 22, 80, 443, 8080
- Verify service is running: `curl http://localhost:8080`
- Check firewall: `sudo ufw status`

### Performance
- Use larger instance for faster builds
- ARM64 instances (t4g) offer better price/performance
- Consider building locally and deploying binaries for production

## Production Recommendations

1. **Use Auto Scaling Groups** for high availability
2. **Place behind Application Load Balancer**
3. **Enable CloudWatch monitoring**
4. **Set up automated backups**
5. **Use separate RDS for database if needed**
6. **Configure SSL/TLS with ACM certificates**

## Cost Optimization

- Use ARM64 instances (up to 20% cheaper)
- Enable auto-shutdown for development instances
- Use spot instances for non-critical workloads
- Consider Lambda deployment for low-traffic sites