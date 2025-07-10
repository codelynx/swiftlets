# Experimental Docker Files

This directory contains experimental and proof-of-concept Docker configurations that were used during the exploration of static binary deployment options.

## Files

- `Dockerfile.minimal` - Attempted to use scratch base (doesn't work - missing system libraries)
- `Dockerfile.alpine-minimal` - Minimal Alpine attempt (fails due to glibc dependencies)
- `Dockerfile.ubuntu-minimal` - Minimal Ubuntu attempt (evolved into Dockerfile.static)
- `Dockerfile.server-static` - Attempted static server binary only
- `build-minimal-poc.sh` - POC build script for comparing different approaches
- `test-static-container.sh` - Test script for static container experiments

## Key Learnings

1. **Full static linking doesn't work** - Swift binaries require system libraries (glibc, libstdc++, etc.)
2. **Alpine Linux is incompatible** - Swift binaries are linked against glibc, Alpine uses musl
3. **"Static stdlib" is only partial** - Only embeds Swift runtime, not system libraries
4. **Scratch-based containers fail** - Need at least basic system libraries

## Current Approach

Based on these experiments, we now use:
- `Dockerfile.static` - Ubuntu-based with Swift slim runtime (production ready)
- `Dockerfile` - Traditional full Swift runtime (for development)
- `Dockerfile.alpine` - Kept for reference but doesn't work properly

These experimental files are preserved for historical reference and to document what approaches were tried and why they didn't work.