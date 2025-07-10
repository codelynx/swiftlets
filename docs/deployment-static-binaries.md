# Deploying Swiftlets with Static Binaries

This guide explains how to deploy Swiftlets to EC2 using static binaries, eliminating the need for Swift runtime on the server.

## Overview

Static linking embeds all Swift runtime dependencies directly into the executable, creating self-contained binaries that can run on any Linux system without installing Swift. This approach, suggested by the Vapor community using `--static-swift-stdlib`, significantly simplifies deployment.

## Benefits

- **No Swift runtime required** on EC2 instances
- **Smaller deployment packages** (no need to bundle runtime libraries)
- **Simplified deployment** process
- **Better performance** (no dynamic library loading)
- **Improved security** (fewer external dependencies)

## Building Static Binaries

### Option 1: Using Docker (Recommended)

The Alpine-based Dockerfile automatically builds static binaries:

```bash
# Setup Docker buildx for native ARM64 builds (one-time setup)
./deploy/docker/setup-buildx.sh

# Build static binaries for EC2 ARM64
./deploy/docker/build-for-ec2.sh swiftlets-site

# Extract the binaries
docker create --name extract swiftlets-ec2-static
docker cp extract:/app/bin ./static-bin
docker cp extract:/app/sites ./static-sites
docker rm extract
```

### Option 2: Direct Build on Linux

If building directly on a Linux system:

```bash
# The --static flag only works on Linux
./build-site sites/swiftlets-site --static
```

Note: Static linking is NOT supported on macOS. The `--static` flag will be ignored with a warning.

## Verifying Static Binaries

To verify that binaries are truly static:

```bash
# On Linux, use ldd
ldd bin/index

# Should output: "not a dynamic executable"
# If it shows library dependencies, it's not fully static
```

## Deployment Process

### 1. Build Static Binaries Locally

```bash
# Build using Docker for EC2 ARM64
./deploy/docker/build-for-ec2.sh swiftlets-site
```

### 2. Extract and Package

```bash
# Create deployment package
mkdir -p swiftlets-deploy
docker create --name extract swiftlets-ec2-static
docker cp extract:/app/bin swiftlets-deploy/
docker cp extract:/app/sites swiftlets-deploy/
docker cp extract:/app/run-site swiftlets-deploy/
docker rm extract

# Create tarball
tar -czf swiftlets-static.tar.gz swiftlets-deploy/
```

### 3. Deploy to EC2

```bash
# Copy to EC2
scp swiftlets-static.tar.gz ubuntu@your-ec2-instance:~/

# On EC2, extract and run
ssh ubuntu@your-ec2-instance
tar -xzf swiftlets-static.tar.gz
cd swiftlets-deploy

# No Swift installation required!
./run-site sites/swiftlets-site
```

## Docker Build Configuration

The Alpine Dockerfile (`deploy/docker/Dockerfile.alpine`) uses these key settings:

```dockerfile
# Build with static linking
RUN swift build -c release \
    -Xswiftc -static-stdlib \
    -Xswiftc -static-executable

# Build site with static flag
RUN ./build-site sites/${SITE_NAME} --static
```

## Performance Considerations

- **Build time**: Static linking increases build time
- **Binary size**: Static binaries are larger (typically 100-150MB per executable)
- **Runtime performance**: Slightly better due to no dynamic linking overhead
- **Memory usage**: Each process has its own copy of the Swift runtime

## Troubleshooting

### "error: -static-stdlib is no longer supported for Apple platforms"

This error occurs when trying to use `--static` on macOS. Static linking only works on Linux.

### Large binary sizes

This is normal for static binaries. Each executable contains the entire Swift runtime. Consider:
- Using shared components to reduce code duplication
- Compressing binaries for transfer
- Using Docker images for easier deployment

### Build failures with Alpine

Some Swift packages may not be compatible with musl libc used by Alpine. If you encounter issues:
- Try the standard Ubuntu-based Dockerfile
- Report incompatible packages to their maintainers

## Best Practices

1. **Use Docker buildx** for faster ARM64 builds
2. **Test locally** with Docker before deploying
3. **Monitor binary sizes** - they can grow large with many dependencies
4. **Use CI/CD** for automated builds and deployments
5. **Keep deployment scripts** in version control

## Comparison with Dynamic Linking

| Aspect | Static Binaries | Dynamic Linking |
|--------|----------------|-----------------|
| Swift runtime on server | Not required | Required |
| Binary size | Larger (100-150MB) | Smaller (1-10MB) |
| Deployment complexity | Simple | Complex |
| Build time | Slower | Faster |
| Runtime performance | Slightly better | Standard |
| Memory usage | Higher | Lower |

## Future Improvements

- Swift Static Linux SDK (when available) for even better static linking
- Multi-stage builds to reduce final image size
- Automated deployment pipelines
- Binary compression/optimization techniques

## References

- [Vapor Deployment Guide](https://docs.vapor.codes/deploy/docker/)
- [Swift Static Linking](https://github.com/apple/swift/blob/main/docs/StaticLinking.md)
- [Docker Buildx Documentation](https://docs.docker.com/buildx/working-with-buildx/)