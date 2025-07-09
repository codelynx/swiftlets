#!/bin/bash
#
# Build just the binary for ARM64 Linux (no container)
# This is simpler and can be deployed directly to EC2
#

set -e

echo "=== Building Binary for ARM64 Linux ==="

cd "$(dirname "$0")"

# First, let's check what SDKs are available
echo "Available Swift SDKs:"
swift sdk list

echo ""
echo "To build for ARM64 Linux, you need to:"
echo ""
echo "1. Install the SDK (one time only):"
echo "   curl -L https://download.swift.org/swift-6.0.2-release/ubuntu2204-aarch64/swift-6.0.2-RELEASE/swift-6.0.2-RELEASE-ubuntu22.04-aarch64.tar.gz -o sdk.tar.gz"
echo "   swift sdk install sdk.tar.gz --checksum \$(swift package compute-checksum sdk.tar.gz)"
echo ""
echo "2. Build with the SDK:"
echo "   swift build --swift-sdk <SDK_NAME> -c release"
echo ""
echo "3. The binary will be at:"
echo "   .build/<SDK_NAME>/release/hello-world"
echo ""
echo "Example deployment:"
echo "   scp .build/*/release/hello-world ubuntu@<YOUR-EC2-IP>:/tmp/"
echo "   ssh ubuntu@<YOUR-EC2-IP> 'chmod +x /tmp/hello-world && /tmp/hello-world'"