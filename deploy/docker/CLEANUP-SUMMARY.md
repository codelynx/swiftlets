# Docker Cleanup Summary

Date: January 2025

## What Was Cleaned Up

### 1. Moved to `experimental/` directory:
- `Dockerfile.minimal` - Scratch-based attempt (failed - no system libs)
- `Dockerfile.alpine` - Alpine attempt (failed - glibc incompatibility)  
- `Dockerfile.alpine-minimal` - Minimal Alpine variant
- `Dockerfile.ubuntu-minimal` - Minimal Ubuntu (evolved into Dockerfile.static)
- `Dockerfile.server-static` - Static server binary attempt
- `build-minimal-poc.sh` - POC comparison script
- `test-static-container.sh` - Static container test script

### 2. Documentation Updates:
- Removed references to non-existent "Apple container service"
- Clarified that "static" binaries still need system libraries
- Updated Alpine incompatibility warnings
- Renamed `build-for-apple-container.sh` to `build-optimized-container.sh`

### 3. Current Production Files:
- `Dockerfile` - Traditional full Swift runtime (500MB+)
- `Dockerfile.static` - Swift slim runtime (433MB, 13% smaller)
- `docker-compose.yml` - Multi-variant deployment
- `build-optimized-container.sh` - Production build script

## Key Learnings

1. **"Static" is misleading** - Swift `-static-stdlib` only embeds Swift libs, not system libs
2. **Alpine doesn't work** - Swift binaries require glibc, Alpine uses musl
3. **Slim runtime is the sweet spot** - Reduces size while maintaining compatibility
4. **Container approach is best** - More reliable than trying to deploy "static" binaries

## Recommendation

Use `Dockerfile.static` with `build-optimized-container.sh` for production deployments. It provides the best balance of size reduction (13% smaller) and compatibility.