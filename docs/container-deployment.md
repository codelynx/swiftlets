# Docker Container Deployment for Swiftlets

This guide covers deploying Swiftlets using Docker containers, providing a consistent and portable deployment solution.

## Overview

Docker deployment offers several advantages:

- ✅ Consistent environment across development and production
- ✅ No Swift runtime installation required on servers
- ✅ Easy horizontal scaling
- ✅ Works with any container orchestration platform
- ✅ Simplified dependency management

## Container Architecture

### Optimized Production Container

The optimized container uses Swift's slim runtime image for smaller size:

```
Optimized Container (433MB)
├── Swift 6.0.2 slim runtime
├── SwiftletsServer executable
├── Site executables (pre-built)
├── Site static files
└── Minimal system dependencies
```

### Build Process

1. **Build Stage**: Uses full Swift image to compile
2. **Runtime Stage**: Uses Swift slim image for deployment
3. **Result**: 13% smaller than traditional approach

## Quick Start

### 1. Build Container

```bash
# Build optimized container for your site
./deploy/docker/build-optimized-container.sh swiftlets-site

# Or specify custom image name and platform
./deploy/docker/build-optimized-container.sh swiftlets-site my-image linux/arm64
```

### 2. Run Locally

```bash
# Run with default settings
docker run -p 8080:8080 swiftlets-optimized:latest

# Run with custom environment
docker run -p 8080:8080 \
    -e SITE_NAME=my-site \
    -e PORT=3000 \
    -p 3000:3000 \
    swiftlets-optimized:latest
```

## Deployment Options

### Docker Compose

```yaml
version: '3.8'
services:
  swiftlets:
    image: swiftlets-optimized:latest
    ports:
      - "8080:8080"
    environment:
      - SITE_NAME=swiftlets-site
      - PORT=8080
    restart: unless-stopped
    volumes:
      - ./data:/app/var  # Optional: persistent storage
```

### Kubernetes

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: swiftlets
spec:
  replicas: 3
  selector:
    matchLabels:
      app: swiftlets
  template:
    metadata:
      labels:
        app: swiftlets
    spec:
      containers:
      - name: swiftlets
        image: swiftlets-optimized:latest
        ports:
        - containerPort: 8080
        env:
        - name: SITE_NAME
          value: swiftlets-site
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
```

### AWS ECS Task Definition

```json
{
  "family": "swiftlets",
  "taskRoleArn": "arn:aws:iam::account:role/ecsTaskRole",
  "executionRoleArn": "arn:aws:iam::account:role/ecsExecutionRole",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",
  "memory": "512",
  "containerDefinitions": [{
    "name": "swiftlets",
    "image": "swiftlets-optimized:latest",
    "portMappings": [{
      "containerPort": 8080,
      "protocol": "tcp"
    }],
    "environment": [{
      "name": "SITE_NAME",
      "value": "swiftlets-site"
    }],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/swiftlets",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }]
}
```

## Building for Different Platforms

### Multi-Architecture Support

```bash
# Build for ARM64 (default for AWS Graviton)
./deploy/docker/build-optimized-container.sh my-site my-image linux/arm64

# Build for AMD64
./deploy/docker/build-optimized-container.sh my-site my-image linux/amd64

# Build for both platforms
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    -t my-image:latest \
    -f deploy/docker/Dockerfile.static \
    --build-arg SITE_NAME=my-site \
    .
```

## CI/CD Integration

### GitHub Actions

```yaml
name: Build and Deploy

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Login to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          file: deploy/docker/Dockerfile.static
          platforms: linux/amd64,linux/arm64
          push: true
          tags: ghcr.io/${{ github.repository_owner }}/swiftlets:latest
          build-args: |
            SITE_NAME=swiftlets-site
```

### GitLab CI

```yaml
build:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker build -f deploy/docker/Dockerfile.static --build-arg SITE_NAME=swiftlets-site -t swiftlets:latest .
    - docker push $CI_REGISTRY_IMAGE:latest
```

## Container Registries

### Docker Hub

```bash
# Tag and push
docker tag swiftlets-optimized:latest yourusername/swiftlets:latest
docker push yourusername/swiftlets:latest
```

### GitHub Container Registry

```bash
# Login
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Tag and push
docker tag swiftlets-optimized:latest ghcr.io/username/swiftlets:latest
docker push ghcr.io/username/swiftlets:latest
```

### AWS ECR

```bash
# Login
aws ecr get-login-password --region us-east-1 | \
    docker login --username AWS --password-stdin \
    123456789.dkr.ecr.us-east-1.amazonaws.com

# Create repository if needed
aws ecr create-repository --repository-name swiftlets

# Tag and push
docker tag swiftlets-optimized:latest \
    123456789.dkr.ecr.us-east-1.amazonaws.com/swiftlets:latest
docker push 123456789.dkr.ecr.us-east-1.amazonaws.com/swiftlets:latest
```

## Production Best Practices

### 1. Security

- Run containers as non-root user
- Scan images for vulnerabilities
- Use secrets management for sensitive data
- Keep base images updated

```dockerfile
# Add to Dockerfile
RUN useradd -m -u 1001 swiftlets
USER swiftlets
```

### 2. Health Checks

```dockerfile
# Add to Dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1
```

### 3. Resource Limits

```yaml
# Docker Compose
services:
  swiftlets:
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
```

### 4. Logging

Configure structured logging:

```bash
# Run with JSON logging
docker run -e LOG_FORMAT=json swiftlets-optimized:latest
```

## Troubleshooting

### Container Won't Start

```bash
# Check logs
docker logs <container-id>

# Debug interactively
docker run -it --entrypoint /bin/bash swiftlets-optimized:latest

# Check file permissions
docker run --rm swiftlets-optimized:latest ls -la /app
```

### Port Binding Issues

```bash
# Check if port is in use
lsof -i :8080

# Use different port
docker run -p 9000:8080 swiftlets-optimized:latest
```

### Performance Issues

```bash
# Monitor resource usage
docker stats <container-id>

# Increase memory limit
docker run -m 1g swiftlets-optimized:latest
```

## Advanced Configuration

### Custom Entry Point

```bash
# Override default command
docker run swiftlets-optimized:latest \
    /app/run-site /app/sites/custom-site --port 9000
```

### Volume Mounts

```bash
# Mount custom configuration
docker run -v ./config:/app/config:ro swiftlets-optimized:latest

# Persistent storage
docker run -v swiftlets-data:/app/var swiftlets-optimized:latest
```

### Environment Variables

- `SITE_NAME`: Site directory to serve (default: swiftlets-site)
- `PORT`: Port to listen on (default: 8080)
- `HOST`: Host to bind to (default: 0.0.0.0)
- `LOG_LEVEL`: Logging verbosity (debug, info, warn, error)

## Monitoring

### Prometheus Metrics

```yaml
# docker-compose.yml
services:
  swiftlets:
    image: swiftlets-optimized:latest
    ports:
      - "8080:8080"
      - "9090:9090"  # Metrics port
    environment:
      - METRICS_ENABLED=true
      - METRICS_PORT=9090
```

### Health Endpoint

```bash
# Check health
curl http://localhost:8080/health

# Expected response
{"status": "healthy", "uptime": 3600}
```

## Migration Guide

### From Traditional Deployment

1. Build container: `./deploy/docker/build-optimized-container.sh your-site`
2. Test locally: `docker run -p 8080:8080 swiftlets-optimized:latest`
3. Deploy to your platform of choice
4. Update DNS/load balancer to point to container

### From Other Container Solutions

1. Review current Dockerfile
2. Adapt build arguments to match Swiftlets structure
3. Test with sample site
4. Gradually migrate sites

## Next Steps

- Set up container orchestration (Kubernetes, Swarm)
- Implement auto-scaling policies
- Configure monitoring and alerting
- Set up automated security scanning
- Implement blue-green deployments

## References

- [Dockerfile.static](../deploy/docker/Dockerfile.static) - Production Dockerfile
- [Build Script](../deploy/docker/build-optimized-container.sh) - Build helper
- [EC2 Deployment](./aws-ec2-deployment.md) - EC2-specific guide
- [Deployment Overview](./deployment-overview.md) - All deployment options