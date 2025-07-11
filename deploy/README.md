# Swiftlets Deployment Options

This directory contains deployment configurations for various platforms and services.

## Available Deployment Methods

### 1. 🐳 Docker Container Deployment (Recommended)
**Location**: `docker/`

Production-ready Docker deployment with optimized images:
- **Optimized Build** - Uses Swift slim runtime (433MB)
- **Multi-stage Builds** - Smaller, secure images
- **Platform Support** - ARM64 and AMD64

```bash
# Build optimized container
./deploy/docker/build-optimized-container.sh swiftlets-site

# Run locally
docker run -p 8080:8080 swiftlets-optimized:latest
```

**Best for**: Kubernetes, Docker Swarm, AWS ECS/Fargate, Google Cloud Run

### 2. 🖥️ EC2 Direct Deployment
**Location**: `ec2/`

Deploy directly to AWS EC2 instances with systemd service management.

```bash
# Initial setup on EC2
./deploy/ec2/setup-instance.sh

# Deploy from local machine
./deploy/ec2/deploy.sh your-ec2-host
```

**Best for**: Traditional VPS hosting, full control over infrastructure

### 3. 🚀 AWS Lambda (Experimental)
**Location**: `lambda/`

Run Swiftlets as serverless functions using AWS Lambda runtime.

```bash
# Build Lambda deployment package
./deploy/lambda/build-lambda.sh swiftlets-site
```

**Best for**: Low-traffic sites, cost optimization, auto-scaling
**Status**: Experimental - adapter implementation complete, needs testing

## Quick Start Guide

### For Docker Container Deployment

1. **Prerequisites**:
   - Docker installed and running
   - Docker buildx for multi-platform builds (optional)

2. **Build**:
   ```bash
   # Build optimized container
   ./deploy/docker/build-optimized-container.sh swiftlets-site
   
   # Or specify platform
   ./deploy/docker/build-optimized-container.sh swiftlets-site my-image linux/arm64
   ```

3. **Run locally**:
   ```bash
   docker run -p 8080:8080 swiftlets-optimized:latest
   ```

4. **Deploy to EC2**:
   ```bash
   # Save container
   docker save swiftlets-optimized:latest | gzip > swiftlets.tar.gz
   
   # Transfer and load on EC2
   scp swiftlets.tar.gz ubuntu@ec2-host:~/
   ssh ubuntu@ec2-host 'docker load < swiftlets.tar.gz'
   ```

### For EC2 Deployment

1. **Launch EC2 instance** (Ubuntu 22.04)

2. **Run setup**:
   ```bash
   ssh ubuntu@your-ec2-ip
   wget https://raw.githubusercontent.com/.../setup-instance.sh
   ./setup-instance.sh
   ```

3. **Deploy**:
   ```bash
   ./deploy/ec2/deploy.sh your-ec2-ip
   ```

## Architecture Comparison

| Method | Pros | Cons | Best Use Case |
|--------|------|------|---------------|
| Container | Portable, scalable, isolated | Requires container runtime | Modern cloud platforms |
| EC2 | Full control, familiar | Manual scaling, more maintenance | Traditional hosting |
| Lambda | Auto-scaling, pay-per-use | Cold starts, experimental | Low-traffic or burst traffic |

## CI/CD Integration

GitHub Actions workflows available:

- EC2: `.github/workflows/deploy-ec2.yml` - Automated EC2 deployment
- Container & Lambda: Can be added using the provided scripts as templates

## Security Considerations

1. **Container**: Run as non-root user, use minimal base images
2. **EC2**: Configure firewall, use IAM roles, enable auto-updates
3. **Lambda**: Use least-privilege IAM policies

## Monitoring

- Container: Built-in health checks, Prometheus metrics
- EC2: CloudWatch, systemd logs
- Lambda: CloudWatch Logs, X-Ray tracing

## Getting Started

📖 **New to Swiftlets?** Follow [Alice's Journey](../docs/alice-story-getting-started.md) - a beginner-friendly narrative guide that walks you through building and deploying your first Swiftlets site.

## Support

For deployment issues:
1. Check the specific deployment method's README
2. Review troubleshooting guides in `/docs`
3. Open an issue on GitHub