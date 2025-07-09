# Cross-Compilation Options for EC2 Deployment

Since EC2 has limited resources for building, here are your options:

## Option 1: Native ARM64 Build in Docker (Recommended)
Build for Linux ARM64 using Docker on your Mac M1/M2:

```bash
docker run --rm \
    -v $(pwd):/workspace \
    -w /workspace \
    --platform linux/arm64 \
    swift:6.0.2 \
    swift build -c release
```

**Pros:**
- Works reliably with Swift 6.0.2
- Produces native ARM64 binaries
- No SDK version mismatches

**Cons:**
- Requires Docker Desktop with ARM64 support
- Builds inside emulated environment (slower)

## Option 2: Upgrade EC2 Instance
Move to a larger EC2 instance temporarily for builds:
- t4g.medium (4GB RAM) or t4g.large (8GB RAM)
- Build on EC2, then downgrade instance

**Pros:**
- Native builds, fastest performance
- No cross-compilation issues

**Cons:**
- Higher EC2 costs during build time
- Need to manage instance sizing

## Option 3: Use GitHub Actions
Set up CI/CD with GitHub Actions:
- Use Ubuntu ARM64 runners
- Build and deploy automatically

**Pros:**
- Free for public repos
- Automated deployment

**Cons:**
- Setup complexity
- Need to manage secrets

## Option 4: Pre-built Binaries
Build locally and commit binaries to a release branch:
- Build for multiple platforms
- Deploy only binaries to EC2

**Pros:**
- Fast deployment
- No build requirements on EC2

**Cons:**
- Large git repository
- Manual process

## Current Situation
- Swift 6.1.2 cross-compilation has known bugs
- Swift 6.0.2 SDK works but requires matching compiler version
- EC2 t4g.small (2GB RAM) insufficient for building Swiftlets

## Recommendation
Use **Option 1** with Docker for now:
1. Build with `--platform linux/arm64` in Docker
2. Deploy binaries to EC2
3. No Swift needed on EC2 for running