# Swiftlets Deployment Options

This directory contains deployment configurations for various platforms and services.

## Available Deployment Methods

### 1. 🐳 Container Deployment (Recommended)
**Location**: `container/`

Two approaches available:
- **Swift Container Plugin** (Swift 6.0+) - Native Swift approach
- **Traditional Dockerfile** - Works with any Docker-compatible runtime

```bash
# Using Swift Container Plugin (requires Docker running)
./deploy/container/build-container.sh swiftlets latest linux/amd64

# Using traditional Dockerfile
docker build -f deploy/docker/Dockerfile -t swiftlets .
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

### For Container Deployment

1. **Prerequisites**:
   - Docker installed and running
   - Swift 6.0+ (for Container Plugin)
   - OR Swift 5.9+ (for Dockerfile approach)

2. **Build**:
   ```bash
   # Build with Swift Container Plugin
   ./deploy/container/build-full-container.sh swiftlets-site

   # OR build with Dockerfile
   docker build -f deploy/docker/Dockerfile -t swiftlets .
   ```

3. **Run locally**:
   ```bash
   docker run -p 8080:8080 swiftlets:latest
   ```

4. **Push to registry**:
   ```bash
   ./deploy/container/push-to-registry.sh swiftlets latest ghcr
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

## Support

For deployment issues:
1. Check the specific deployment method's README
2. Review troubleshooting guides in `/docs`
3. Open an issue on GitHub