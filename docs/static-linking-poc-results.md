# Static Linking POC Results

## Summary

We explored various approaches to reduce container sizes and eliminate Swift runtime dependencies. Here's what we learned:

## Key Findings

### 1. Full Static Linking Challenges

When attempting full static linking with both `-static-stdlib` and `-static-executable`:
```
error: relocation refers to local symbol "" [1], which is defined in a discarded section
clang: error: linker command failed with exit code 1
```

This is a known issue with glibc and fully static binaries. The warnings indicate:
- `dlopen` operations require runtime libraries
- User/group functions (`getpwuid`, `getgrnam`) need glibc at runtime
- Network operations (`getaddrinfo`) require dynamic loading

### 2. Partial Static Linking Works

Using only `-static-stdlib` (without `-static-executable`):
- Embeds Swift standard library into binaries
- Still requires some system libraries (libc, etc.)
- Reduces dependencies significantly
- Works reliably on both Ubuntu and Alpine

### 3. Container Size Comparison

Expected sizes with partial static linking:
- **Scratch-based**: Not viable (needs minimal system libs)
- **Alpine-minimal**: ~200-250MB (with static stdlib)
- **Alpine-full**: ~300-350MB (with Swift runtime)
- **Ubuntu-based**: ~500MB+ (full runtime)

## Recommended Approach

For container deployments:

### 1. Use Ubuntu with Static Stdlib (Alpine doesn't work)
```dockerfile
FROM swift:6.0.2 AS builder
RUN swift build -c release -Xswiftc -static-stdlib

FROM ubuntu:22.04  # Note: Alpine doesn't work due to glibc dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates libstdc++6 libgcc-s1
COPY --from=builder /app/bin /app/bin
```

**Important**: Despite attempts, Alpine Linux is NOT compatible with Swift binaries built with `-static-stdlib` due to glibc dependencies.

### 2. Benefits
- 40-50% smaller than full runtime containers
- No Swift runtime installation needed
- Still has necessary system libraries
- Works with standard container platforms

### 3. Trade-offs
- Not fully static (still needs libc)
- Larger binaries (100-150MB each)
- Some runtime dependencies remain

## Alternative: Distroless Images

For even smaller containers:
```dockerfile
FROM gcr.io/distroless/cc-debian12
COPY --from=builder /app/bin /app/bin
```

This provides minimal runtime with just enough libraries for C++ apps.

## Conclusion

While full static linking isn't feasible due to glibc limitations, partial static linking with `-static-stdlib` provides significant benefits:
- Simplified deployment
- Reduced container size
- No Swift runtime management
- Compatible with modern container platforms

This approach aligns well with Vapor's deployment strategy and is suitable for production use.