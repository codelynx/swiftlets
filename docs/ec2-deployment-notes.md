# EC2 ARM64 Deployment Notes

## Instance Details
- **Instance Type**: t4g.small (ARM64 Graviton2)
- **OS**: Ubuntu 24.04 LTS
- **IP**: <YOUR-EC2-IP>
- **Architecture**: aarch64

## Issues Encountered

### 1. Ubuntu Version Compatibility
- Setup script expects Ubuntu 22.04 but instance has 24.04
- Python package differences: libpython3.8 → libpython3.12
- Swift 5.9.2 doesn't have official Ubuntu 24.04 builds

### 2. Build Performance
- Building on t4g.small (1GB RAM) is too slow
- Added 2GB swap space to help with memory
- Site builds take 12+ seconds per file (too slow for 27 files)

### 3. Cross-Compilation Challenges
- Swift SDK installation requires checksums
- Docker-based cross-compilation requires Docker Desktop
- Apple's container plugin needs proper SDK setup

## Solutions Applied

### Memory Optimization
```bash
# Added swap space
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

### Package Structure Fix
- Tests directory missing causing build failures
- Need to create: `mkdir -p Tests/SwiftletsTests`

## Recommended Approach

1. **Build on more powerful machine** (local Mac or larger EC2)
2. **Deploy pre-built binaries** to t4g.small
3. **Use deployment script**: `deploy/ec2/deploy.sh`

## Alternative Solutions

1. **Larger Instance**: Use t4g.medium temporarily for builds
2. **Build Service**: Set up CI/CD with GitHub Actions
3. **Container Deployment**: Use pre-built containers instead

## Next Steps

1. Fix Package.swift test path issue
2. Update setup script for Ubuntu 24.04 support
3. Implement binary deployment workflow
4. Document cross-compilation setup