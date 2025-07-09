# Docker Build & Deploy for Swiftlets

This directory contains scripts to build and deploy Swiftlets using Docker, solving the EC2 resource constraints.

## Scripts

### 1. `docker-dynamic-build.sh`
Builds Swiftlets with Docker, creating dynamic binaries that include Swift runtime libraries.

**Usage:**
```bash
./docker-dynamic-build.sh
```

**Output:**
- Creates `swiftlets-dynamic-TIMESTAMP.tar.gz`
- Includes Swift runtime libraries
- Works on EC2 without Swift installation

### 2. `deploy-to-ec2.sh`
Deploys the Docker-built package to EC2.

**Usage:**
```bash
./deploy-to-ec2.sh swiftlets-dynamic-TIMESTAMP.tar.gz
```

## Benefits

1. **No building on EC2** - EC2 only runs pre-built binaries
2. **Consistent builds** - Docker ensures same environment
3. **Swift 6.0.2** - Stable version for production
4. **ARM64 native** - Builds for EC2's architecture

## Process

1. Build on Mac using Docker:
   ```bash
   ./docker-dynamic-build.sh
   ```

2. Deploy to EC2:
   ```bash
   ./deploy-to-ec2.sh swiftlets-dynamic-*.tar.gz
   ```

3. Access site:
   ```
   http://<YOUR-EC2-IP>:8080/
   ```

## Notes

- Build takes ~5-10 minutes due to ARM64 emulation
- Package includes all dependencies
- EC2 needs no Swift installation
- Works with t4g.small (2GB RAM) instances