# Container Deployment with Swift Container Plugin

This guide covers deploying Swiftlets using Apple's Swift Container Plugin, which provides a native Swift approach to building OCI-compliant container images.

## Overview

The Swift Container Plugin allows you to build container images directly from Swift Package Manager, without writing Dockerfiles. This approach:

- ✅ Builds minimal, secure containers
- ✅ Uses static linking for smaller images
- ✅ Integrates with Swift Package Manager
- ✅ Supports cross-compilation from macOS
- ✅ Works with any OCI-compliant registry

## Prerequisites

1. **Swift 6.0+** (comes with container plugin support)
2. **Docker** or compatible container runtime
3. **Swift SDK for Linux** (required for cross-compilation from macOS):
   ```bash
   # Install Linux SDK
   swift sdk install x86_64-swift-linux-musl    # For AMD64
   swift sdk install aarch64-swift-linux-musl   # For ARM64
   ```
4. **Container registry** access (optional, for pushing images)

## Quick Start

### 1. Install Swift SDK for Linux (macOS only)

```bash
# For x86_64
swift sdk install x86_64-swift-linux-musl

# For ARM64
swift sdk install aarch64-swift-linux-musl
```

### 2. Build Container Image

```bash
# Build for linux/amd64
./deploy/container/build-container.sh swiftlets latest linux/amd64

# Build for linux/arm64
./deploy/container/build-container.sh swiftlets latest linux/arm64
```

### 3. Run Locally

```bash
docker run -p 8080:8080 swiftlets:latest
```

## Architecture

### Swift Container Plugin Approach

The plugin builds a minimal container with just your Swift executable:

```
Container Image
├── SwiftletsServer (statically linked binary)
└── Minimal runtime dependencies
```

### Full Swiftlets Container

Since Swiftlets needs additional files (sites, executables), we use a two-stage approach:

1. **Base Container**: Built by Swift Container Plugin (just the server)
2. **Full Container**: Adds sites, swiftlet executables, and configuration

```
Full Container
├── /app/
│   ├── SwiftletsServer      # Main server
│   ├── bin/                 # Swiftlet executables
│   │   └── linux/x86_64/    # Platform-specific binaries
│   ├── sites/               # Site content
│   │   └── swiftlets-site/  
│   └── run-site            # Runner script
```

## Building Containers

### Using Swift Container Plugin (Base)

```bash
# Direct plugin usage
swift package --swift-sdk x86_64-swift-linux-musl \
    plugin build-container-image \
    --product swiftlets-server \
    --repository myregistry/swiftlets

# Or use our script
./deploy/container/build-container.sh
```

**Note**: The Swift Container Plugin creates minimal containers with just the executable. For a complete Swiftlets deployment with sites, use the full container build script.

### Building Full Container with Sites

```bash
# Build complete container with a specific site
./deploy/container/build-full-container.sh \
    swiftlets-site \      # Site name
    swiftlets-full \      # Repository name
    latest \              # Tag
    linux/amd64 \         # Platform
    ghcr.io/username      # Registry (optional)
```

## Deployment Options

### 1. Local Development

```bash
# Run with default settings
docker run -p 8080:8080 swiftlets-full:latest

# Run with custom environment
docker run -p 8080:8080 \
    -e SWIFTLETS_ENV=development \
    -e PORT=3000 \
    -p 3000:3000 \
    swiftlets-full:latest
```

### 2. Docker Compose

```yaml
version: '3.8'
services:
  swiftlets:
    image: ghcr.io/username/swiftlets:latest
    ports:
      - "8080:8080"
    environment:
      - SWIFTLETS_ENV=production
    volumes:
      - ./data:/app/var
```

### 3. Kubernetes

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
        image: ghcr.io/username/swiftlets:latest
        ports:
        - containerPort: 8080
        env:
        - name: SWIFTLETS_ENV
          value: production
```

### 4. AWS ECS/Fargate

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
    "image": "ghcr.io/username/swiftlets:latest",
    "portMappings": [{
      "containerPort": 8080,
      "protocol": "tcp"
    }],
    "environment": [{
      "name": "SWIFTLETS_ENV",
      "value": "production"
    }]
  }]
}
```

## CI/CD Integration

### GitHub Actions

```yaml
name: Build and Push Container

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: swift-actions/setup-swift@v2
        with:
          swift-version: "6.0"
      
      - name: Install Swift SDK
        run: swift sdk install x86_64-swift-linux-musl
      
      - name: Build Container
        run: |
          ./deploy/container/build-full-container.sh \
            swiftlets-site \
            swiftlets \
            ${{ github.sha }} \
            linux/amd64 \
            ghcr.io/${{ github.repository_owner }}
      
      - name: Push to Registry
        run: |
          echo ${{ secrets.GITHUB_TOKEN }} | docker login ghcr.io -u ${{ github.actor }} --password-stdin
          docker push ghcr.io/${{ github.repository_owner }}/swiftlets:${{ github.sha }}
```

## Multi-Architecture Builds

Build for multiple platforms:

```bash
# Build AMD64
./deploy/container/build-full-container.sh site swiftlets amd64 linux/amd64

# Build ARM64
./deploy/container/build-full-container.sh site swiftlets arm64 linux/arm64

# Create manifest for multi-arch
docker manifest create swiftlets:latest \
    swiftlets:amd64 \
    swiftlets:arm64

docker manifest push swiftlets:latest
```

## Container Registries

### GitHub Container Registry

```bash
# Login
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Build and push
./deploy/container/build-full-container.sh \
    swiftlets-site \
    swiftlets \
    latest \
    linux/amd64 \
    ghcr.io/username
```

### AWS ECR

```bash
# Login
aws ecr get-login-password --region us-east-1 | \
    docker login --username AWS --password-stdin \
    123456789.dkr.ecr.us-east-1.amazonaws.com

# Build and push
./deploy/container/build-full-container.sh \
    swiftlets-site \
    swiftlets \
    latest \
    linux/amd64 \
    123456789.dkr.ecr.us-east-1.amazonaws.com
```

## Best Practices

### 1. Security

- Always run as non-root user
- Use minimal base images
- Scan images for vulnerabilities
- Don't include build tools in production images

### 2. Size Optimization

- Use static linking with musl
- Multi-stage builds
- Only include necessary files
- Compress static assets

### 3. Performance

- Use container orchestration for scaling
- Implement health checks
- Configure resource limits
- Use CDN for static assets

### 4. Monitoring

- Export metrics (Prometheus format)
- Structured logging (JSON)
- Distributed tracing support
- Health check endpoints

## Troubleshooting

### Build Failures

```bash
# Check Swift SDK installation
swift sdk list

# Verbose build output
swift build --swift-sdk x86_64-swift-linux-musl -v

# Test executable locally
.build/release/SwiftletsServer
```

### Runtime Issues

```bash
# Check container logs
docker logs <container-id>

# Debug shell access
docker run -it --entrypoint /bin/bash swiftlets:latest

# Test health endpoint
curl http://localhost:8080/health
```

### Cross-Compilation Issues

- Ensure Swift SDK matches target architecture
- Check for platform-specific dependencies
- Verify static linking with `ldd`

## Advanced Configuration

### Custom Entry Point

```bash
# Override default command
docker run swiftlets:latest \
    ./run-site sites/custom-site --port 9000
```

### Volume Mounts

```bash
# Mount custom sites
docker run -v ./my-sites:/app/sites swiftlets:latest

# Persistent data
docker run -v swiftlets-data:/app/var swiftlets:latest
```

### Environment Variables

- `SWIFTLETS_ENV`: Environment (development/production)
- `PORT`: Server port (default: 8080)
- `SITE_NAME`: Site to run (default: swiftlets-site)
- `LOG_LEVEL`: Logging verbosity

## Next Steps

1. Set up CI/CD pipeline
2. Configure container orchestration
3. Implement monitoring and logging
4. Set up automated security scanning
5. Configure CDN for static assets