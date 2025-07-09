# Swift Container Plugin POC for EC2 Deployment

## Summary

This POC demonstrates building and deploying Swift applications to EC2 ARM64 instances.

## What We Accomplished

1. **Created a simple hello-world Swift app** that uses the Swift Container Plugin
2. **Successfully installed Swift 6.0.2 on Ubuntu 24.04 ARM64** EC2 instance
3. **Built and ran the app natively on EC2** 
4. **Documented the deployment process**

## Key Findings

### Cross-Compilation Challenges
- Swift SDK format changed in Swift 5.9+ to require `.artifactbundle` format
- Version mismatch between local Swift (6.1.2) and available SDKs (6.0.2)
- Cross-compilation toolchain setup is complex and error-prone

### Successful Approach: Build on Target
- Deploying source code to EC2 and building there works reliably
- Swift 6.0.2 runs well on Ubuntu 24.04 ARM64 (t4g.small instance)
- Build times are reasonable for small projects

### Container Plugin Status
- The Swift Container Plugin requires additional setup on Linux
- The `swift package container-build` command is not available by default
- Would need Docker or Podman installed on EC2 for container building

## Files Created

- `Package.swift` - Swift package with container plugin dependency
- `Sources/main.swift` - Simple hello-world app
- `install-swift-ubuntu24.sh` - Installs Swift on Ubuntu 24.04
- `deploy-source-to-ec2.sh` - Deploys source and builds on EC2
- `build-container.sh` - Builds container locally (requires Docker)

## Next Steps for Swiftlets Deployment

1. **Update EC2 setup scripts** for Ubuntu 24.04 compatibility
2. **Use source deployment approach** instead of cross-compilation
3. **Consider GitHub Actions** for building Linux binaries
4. **Explore container deployment** once Docker/Podman is set up on EC2

## Deployment Instructions

```bash
# 1. Install Swift on EC2
scp install-swift-ubuntu24.sh ubuntu@<ec2-ip>:/tmp/
ssh ubuntu@<ec2-ip> "bash /tmp/install-swift-ubuntu24.sh"

# 2. Deploy and build
./deploy-source-to-ec2.sh

# The app will be built and tested on EC2
```

## EC2 Instance Details
- Type: t4g.small (2 vCPU, 2GB RAM)
- OS: Ubuntu 24.04 LTS ARM64
- Swift: 6.0.2
- IP: <YOUR-EC2-IP> (example)