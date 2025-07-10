#!/bin/bash
# Quick test of static binary container concept

set -e

echo "Testing static binary container concept..."
echo ""

# Create a simple Swift executable
mkdir -p /tmp/swift-static-test
cd /tmp/swift-static-test

cat > hello.swift << 'EOF'
import Foundation

print("Hello from static Swift!")
print("Process ID: \(getpid())")
print("Swift version: \(ProcessInfo.processInfo.environment["SWIFT_VERSION"] ?? "unknown")")
print("Running on: \(ProcessInfo.processInfo.operatingSystemVersionString)")
EOF

echo "1. Building static binary with Docker..."
docker run --rm -v "$PWD":/src -w /src swift:6.0.2 \
    swiftc hello.swift -o hello-static \
    -static-stdlib 2>/dev/null || echo "Note: -static-stdlib not supported on this platform"

echo ""
echo "2. Building regular binary..."
docker run --rm -v "$PWD":/src -w /src swift:6.0.2 \
    swiftc hello.swift -o hello-dynamic

echo ""
echo "3. Comparing file sizes..."
ls -lh hello-* 2>/dev/null || echo "Build may have failed"

echo ""
echo "For Swiftlets POC with Apple's container service:"
echo ""
echo "Step 1: Build minimal container"
echo "  cd /path/to/swiftlets"
echo "  ./deploy/docker/build-minimal-poc.sh"
echo ""
echo "Step 2: Export for Apple's container"
echo "  docker save swiftlets:alpine-minimal -o swiftlets-minimal.tar"
echo ""
echo "Step 3: Use with Apple's container service"
echo "  container load < swiftlets-minimal.tar"
echo "  container run swiftlets:alpine-minimal"
echo ""
echo "Benefits:"
echo "- Minimal attack surface (Alpine + static binaries)"
echo "- No Swift runtime required in container"
echo "- Fast startup times"
echo "- Small container images"

# Cleanup
cd - > /dev/null
rm -rf /tmp/swift-static-test