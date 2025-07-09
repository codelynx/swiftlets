#!/bin/bash
#
# Test different cross-compilation approaches
#

set -e

echo "=== Swift Cross-Compilation POC ==="
echo ""
echo "Local Swift version:"
swift --version
echo ""

# Method 1: Try with -target flag directly
echo "Method 1: Using -target flag"
echo "----------------------------"
swiftc hello.swift \
    -target aarch64-unknown-linux-gnu \
    -sdk /usr/lib/swift \
    -o hello-method1 \
    2>&1 || echo "Method 1 failed"

echo ""

# Method 2: Using swift build with SDK
echo "Method 2: Using SDK (requires Package.swift)"
echo "--------------------------------------------"

# Create minimal Package.swift
cat > Package.swift << 'EOF'
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HelloPOC",
    products: [
        .executable(name: "hello", targets: ["Hello"])
    ],
    targets: [
        .executableTarget(
            name: "Hello",
            path: ".",
            sources: ["hello.swift"]
        )
    ]
)
EOF

# Try with 6.0.2 SDK
echo "Trying with Swift 6.0.2 SDK..."
swift build --swift-sdk swift-6.0.2-RELEASE_static-linux-0.0.1 -c release 2>&1 || echo "6.0.2 SDK failed"

echo ""

# Try with 6.1.2 SDK
echo "Trying with Swift 6.1.2 SDK..."
swift build --swift-sdk swift-6.1.2-RELEASE_static-linux-0.0.1 -c release 2>&1 || echo "6.1.2 SDK failed"

echo ""

# Method 3: Using swiftc with static linking
echo "Method 3: Static compilation attempt"
echo "-----------------------------------"
swiftc hello.swift \
    -static-stdlib \
    -target aarch64-unknown-linux \
    -o hello-method3 \
    2>&1 || echo "Method 3 failed"

echo ""

# Method 4: Using Docker as baseline
echo "Method 4: Docker baseline (for comparison)"
echo "-----------------------------------------"
docker run --rm -v $(pwd):/app -w /app swift:6.0.2 swiftc hello.swift -o hello-docker

echo ""
echo "Checking outputs:"
ls -la hello* 2>/dev/null || echo "No binaries produced"

echo ""
echo "File types:"
file hello* 2>/dev/null || echo "No files to check"