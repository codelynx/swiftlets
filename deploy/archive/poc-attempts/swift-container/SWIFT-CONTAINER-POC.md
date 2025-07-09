# Swift Container Plugin POC for Swiftlets

## Overview

This POC explores using Apple's Swift Container Plugin to build OCI-compliant container images for Swiftlets deployment, as an alternative to traditional Docker-based workflows.

## Background

The goal was to leverage Apple's native Swift tooling for container creation, following the philosophy of using Swift throughout the entire deployment pipeline.

## What We Built

### 1. Hello World Example
A minimal Swift executable that demonstrates:
- Platform detection (Linux/macOS)
- Architecture detection (ARM64/x86_64)  
- Swift Container Plugin integration
- Cross-platform build capabilities

### 2. EC2 Deployment Pipeline
- Automated Swift 6.0.2 installation on Ubuntu 24.04
- Source-based deployment (build on target)
- Systemd service configuration
- Production-ready setup scripts

## Key Findings

### Swift Container Plugin
- **Pros:**
  - Native Swift tooling, no Docker required locally
  - Integrates with Swift Package Manager
  - Supports multi-architecture builds
  
- **Cons:**
  - Still requires Docker/Podman for actual container creation
  - Limited documentation and examples
  - Not widely adopted yet

### Cross-Compilation Challenges
1. **SDK Format Changes**: Swift 5.9+ requires `.artifactbundle` format
2. **Version Compatibility**: Local Swift version must match SDK version
3. **Complexity**: Setting up cross-compilation toolchain is error-prone
4. **Solution**: Build directly on target platform (EC2)

### EC2 Deployment Success
- ✅ Swift 6.0.2 runs well on Ubuntu 24.04 ARM64
- ✅ t4g.small instances provide good price/performance
- ✅ Source deployment is simpler than cross-compilation
- ✅ Build times are reasonable for small projects

## Project Structure

```
deploy/swift-container/
├── hello-world/
│   ├── Package.swift                    # Swift package with container plugin
│   ├── Sources/main.swift              # Simple test application
│   ├── README.md                       # Deployment instructions
│   ├── install-swift-ubuntu24.sh       # Swift installer for Ubuntu 24.04
│   ├── deploy-source-to-ec2.sh        # Deploy and build on EC2
│   └── build-container.sh             # Local container build (requires Docker)
└── SWIFT-CONTAINER-POC.md              # This file
```

## Deployment Workflow

### 1. Local Development
```bash
cd hello-world
swift build
swift run
```

### 2. EC2 Setup (Ubuntu 24.04)
```bash
# Install Swift on EC2
scp install-swift-ubuntu24.sh ubuntu@<ec2-ip>:/tmp/
ssh ubuntu@<ec2-ip> "bash /tmp/install-swift-ubuntu24.sh"
```

### 3. Deploy to EC2
```bash
# Deploy source and build on EC2
./deploy-source-to-ec2.sh
```

### 4. Container Build (Optional)
```bash
# Requires Docker installed
./build-container.sh
```

## Lessons Learned

1. **Build on Target**: For Linux deployment, building directly on the target platform is more reliable than cross-compilation.

2. **Ubuntu 24.04 Ready**: Latest Ubuntu LTS works well with Swift 6.0.2, with updated dependency packages.

3. **Container Plugin Status**: While interesting, the Swift Container Plugin isn't essential for Swiftlets deployment. Traditional deployment methods work well.

4. **ARM64 Advantages**: AWS Graviton (ARM64) instances offer excellent price/performance for Swift applications.

## Recommendations for Swiftlets

### Short Term
1. Use source-based deployment to EC2
2. Build directly on target instances
3. Focus on Ubuntu 24.04 with Swift 6.0.2
4. Leverage ARM64 instances for cost savings

### Long Term
1. Consider GitHub Actions for Linux builds
2. Explore container deployment when tooling matures
3. Implement build caching for faster deployments
4. Create pre-built AMIs with Swift installed

## Next Steps

1. **Deploy swiftlets-site** using the proven EC2 deployment approach
2. **Create CI/CD pipeline** with GitHub Actions
3. **Document** the deployment process in main docs
4. **Optimize** build times with caching strategies

## References

- [Swift Container Plugin](https://github.com/apple/swift-container-plugin)
- [Swift Static Linux SDK](https://www.swift.org/documentation/articles/static-linux-sdk.html)
- [AWS Graviton](https://aws.amazon.com/ec2/graviton/)

## Status

✅ POC Complete - Ready to apply learnings to production Swiftlets deployment