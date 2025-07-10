# Docker Deployment for Swiftlets

This directory contains Docker configurations for deploying Swiftlets in containers.

## Deployment Options

### 1. Traditional Deployment (`Dockerfile`)
- **Size**: ~500MB+
- **Includes**: Full Swift runtime
- **Compatibility**: Maximum
- **Use when**: You need guaranteed compatibility

### 2. Swift Slim Runtime Deployment (`Dockerfile.static`) - RECOMMENDED
- **Size**: ~433MB (13% smaller than traditional)
- **Includes**: Swift slim runtime (minimal libraries)
- **Compatibility**: Excellent, same as traditional
- **Use when**: Deploying to production environments


## Quick Start

### For Optimized Deployment (Recommended)
```bash
# Build with Swift slim runtime
./build-optimized-container.sh swiftlets-site

# Or build directly
docker build -f Dockerfile.static -t swiftlets-optimized .

# Run the container
docker run -p 8080:8080 swiftlets-optimized:latest
```

### For General Docker Deployment
```bash
# Using docker-compose (runs multiple variants)
docker-compose up swiftlets-static

# Or build traditional version
docker build -t swiftlets-traditional .
docker run -p 8080:8080 swiftlets-traditional
```

## File Structure

- `Dockerfile` - Traditional deployment with full Swift runtime
- `Dockerfile.static` - Swift slim runtime deployment (recommended)
- `docker-compose.yml` - Run multiple deployment variants
- `experimental/` - POC and experimental configurations (Alpine, minimal, etc.)
- `build-optimized-container.sh` - Build script for optimized containers
- `build-for-ec2.sh` - Build script for AWS EC2 deployment

## Container Comparison

| File | Size | Swift Runtime | Best For |
|------|------|---------------|----------|
| Dockerfile | 500MB+ | Full runtime | Development, maximum compatibility |
| Dockerfile.static | 433MB | Slim runtime | Production, smaller containers |

## Experimental Files

Proof-of-concept and experimental configurations have been moved to the `experimental/` subdirectory. See `experimental/README.md` for details about what was tried and why certain approaches didn't work.

## Best Practices

1. **Use `Dockerfile.static` for production** - Best balance of size and compatibility
2. **Test locally first** - Ensure your site builds and runs correctly
3. **Use multi-platform builds** - Support both ARM64 and x86_64
4. **Tag your images** - Use semantic versioning for containers
5. **Monitor sizes** - Track container image sizes

## Troubleshooting

### Build Failures
- Check for "expression too complex" errors
- Break down complex HTML into smaller functions
- See `/docs/troubleshooting-complex-expressions.md`

### Runtime Issues
- Alpine containers may have glibc compatibility issues
- Use Ubuntu-based containers for maximum compatibility
- Check with `ldd` for missing libraries

### Performance
- Use `--platform` flag for native architecture
- Enable Docker BuildKit for faster builds
- Cache layers appropriately