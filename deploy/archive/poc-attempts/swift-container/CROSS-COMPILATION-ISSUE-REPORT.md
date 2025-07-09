# Swift 6.1.2 Cross-Compilation Issue Report

## Issue Summary
Cross-compilation from macOS to Linux ARM64 fails with the official Swift 6.1.2 static Linux SDK due to module compatibility issues.

## Environment
- **Host**: macOS 15.0 (arm64-apple-macosx15.0)
- **Swift Version**: 6.1.2 (swift-6.1.2.1.2)
- **Target**: Linux ARM64 (aarch64-swift-linux-musl)
- **SDK**: swift-6.1.2-RELEASE_static-linux-0.0.1

## Error Details

### Error 1: Module Version Mismatch
```
error: compiled module was created by a different version of the compiler ''; 
rebuild 'Dispatch' and try again: 
/Users/kyoshikawa/Library/org.swift.swiftpm/swift-sdks/swift-6.1.2-RELEASE_static-linux-0.0.1.artifactbundle/
swift-6.1.2-RELEASE_static-linux-0.0.1/swift-linux-musl/musl-1.2.5.sdk/aarch64/usr/lib/swift_static/
linux-static/aarch64/Dispatch.swiftmodule
```

**Location**: When importing system modules like Dispatch
**Cause**: Precompiled modules in the SDK were built with a different Swift compiler version

### Error 2: Missing Tool
```
error: unableToFind(tool: "swift-autolink-extract")
```

**Location**: During linking phase
**Cause**: The SDK is missing required toolchain components

## Reproduction Steps
1. Install Swift 6.1.2 on macOS
2. Download official SDK:
   ```bash
   curl -L https://download.swift.org/swift-6.1.2-release/static-sdk/swift-6.1.2-RELEASE/swift-6.1.2-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz -o sdk.tar.gz
   swift sdk install sdk.tar.gz
   ```
3. Attempt cross-compilation:
   ```bash
   swift build --swift-sdk aarch64-swift-linux-musl
   ```

## SDK Details
- **Download URL**: https://download.swift.org/swift-6.1.2-release/static-sdk/swift-6.1.2-RELEASE/swift-6.1.2-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz
- **Size**: 287MB
- **Structure**: Contains musl-1.2.5 SDK with precompiled Swift modules

## Impact
- Cannot cross-compile Swift projects from macOS to Linux
- Must build directly on Linux machines
- Slows down development workflow
- Prevents using Apple's Container Plugin for containerization

## Workarounds

### 1. Build on Target Platform
Deploy source to Linux machine and build there:
```bash
ssh ubuntu@server "cd project && swift build"
```

### 2. Use Docker
Build inside Linux container:
```bash
docker run --rm -v $(pwd):/src -w /src swift:6.1.2 swift build
```

### 3. Use Older Swift Version
Downgrade to Swift 6.0.2 where SDK works (not recommended)

## Root Cause Analysis
The SDK appears to have been built with a different patch version of the Swift 6.1.2 compiler than the released version. The error message shows an empty version string (''), suggesting a version metadata mismatch.

## Recommendations for Swift Team
1. Rebuild the SDK with the exact released Swift 6.1.2 compiler
2. Include missing tools like swift-autolink-extract in the SDK
3. Add version compatibility checks during SDK installation
4. Provide better error messages for version mismatches

## Known Issue - Confirmed
This is a **known regression** in Swift 6.1/6.2:
- GitHub Issue: [swiftlang/swift-driver#1723](https://github.com/swiftlang/swift-driver/issues/1723)
- Affects: Swift 6.1 and 6.2 cross-compilation with static Linux SDK
- Root cause: Regression in the new swift-driver implementation

## Workaround from Swift Team
Use the legacy driver by adding this flag:
```bash
swift build --swift-sdk aarch64-swift-linux-musl -Xswiftc -disallow-use-new-driver
```

## Additional Known Issues
1. **swift-autolink-extract**: Has been problematic across multiple Swift versions
   - Linux is the only platform that uses this tool
   - Missing from various Swift toolchain releases
   - Long-standing issue since Swift 5.2

2. **Module version mismatch**: Common when SDK and compiler versions don't align exactly
   - Requires exact version match between toolchain and SDK
   - Can occur even with same nominal version (6.1.2)

## Current Status
- **Official workaround exists**: Use `-disallow-use-new-driver` flag
- **Alternative**: Build directly on Linux (currently using this)
- Both development and production environments use Swift 6.1.2
- Regression tracked by Swift team, fix pending