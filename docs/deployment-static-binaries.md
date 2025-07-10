# Deploying Swiftlets with Static Binaries

This guide explains how to deploy Swiftlets to EC2 using static binaries to reduce Swift runtime dependencies.

## Overview

**Important Note**: The term "static binaries" in Swift context is somewhat misleading. The `--static-swift-stdlib` flag (used by Vapor and others) only statically links the Swift standard library, NOT system libraries like glibc. These binaries still require system libraries to be present on the target system.

### What Static Linking Actually Does

- **Embeds**: Swift standard library and Swift runtime
- **Does NOT embed**: System libraries (glibc, libstdc++, OpenSSL, etc.)
- **Result**: Binaries that don't need Swift installed but still need Linux system libraries

## Benefits

- **No Swift runtime installation required** on EC2 instances
- **Simplified deployment** process (but larger binaries)
- **Version consistency** (Swift stdlib version is fixed)
- **Reduced dependency conflicts**

## Limitations

- **NOT truly static**: Still requires system libraries
- **Alpine Linux incompatible**: glibc dependencies prevent Alpine usage
- **Larger binaries**: Each binary includes Swift stdlib (~30MB overhead)
- **Memory overhead**: Each process loads its own copy of Swift stdlib

## Building Static Binaries

### Option 1: Using Docker (Recommended)

**Note**: The Alpine-based approach doesn't actually work due to glibc dependencies. Use Ubuntu-based containers instead.

```bash
# Build with static stdlib (Ubuntu-based)
docker build -f deploy/docker/Dockerfile.static -t swiftlets-static .

# Extract the binaries
docker create --name extract swiftlets-static
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

To check what libraries your "static" binaries actually need:

```bash
# On Linux, use ldd
ldd bin/index

# Will show something like:
#   linux-vdso.so.1
#   libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6
#   libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6
#   libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1
#   libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6

# Note: These are SYSTEM libraries, not Swift libraries
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

**Important**: The `-static-executable` flag doesn't work on Linux due to glibc requirements. Only use `-static-stdlib`:

```dockerfile
# Build with static stdlib only
RUN swift build -c release \
    -Xswiftc -static-stdlib

# Build site with static flag
RUN ./build-site sites/${SITE_NAME} --static
```

**Note**: Alpine Linux containers won't work with these binaries due to glibc dependencies.

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

Swift binaries built with `-static-stdlib` are NOT compatible with Alpine Linux because:
- They link against glibc (GNU C Library)
- Alpine uses musl libc instead
- The binaries will fail with "not found" errors even though the file exists

**Solution**: Use Ubuntu or other glibc-based distributions only.

## Best Practices

1. **Use Docker buildx** for faster ARM64 builds
2. **Test locally** with Docker before deploying
3. **Monitor binary sizes** - they can grow large with many dependencies
4. **Use CI/CD** for automated builds and deployments
5. **Keep deployment scripts** in version control

## Comparison with Dynamic Linking

| Aspect | Static Stdlib | Dynamic Linking |
|--------|---------------|-----------------|
| Swift runtime on server | Not required | Required |
| System libraries | Still required | Required |
| Binary size | Larger (~35MB each) | Smaller (~5MB) |
| Container compatibility | Ubuntu/Debian only | Any Linux |
| Build time | Slower | Faster |
| Runtime performance | Similar | Similar |
| Memory usage | Higher (duplicate stdlib) | Lower (shared) |

## Future Improvements

- **Swift Static Linux SDK**: When available, may enable truly static binaries
- **Better tooling**: For managing partially static deployments
- **Container optimizations**: Using distroless or minimal base images
- **Build caching**: To speed up static stdlib compilation

## References

- [Vapor Deployment Guide](https://docs.vapor.codes/deploy/docker/)
- [Swift Static Linking](https://github.com/apple/swift/blob/main/docs/StaticLinking.md)
- [Docker Buildx Documentation](https://docs.docker.com/buildx/working-with-buildx/)