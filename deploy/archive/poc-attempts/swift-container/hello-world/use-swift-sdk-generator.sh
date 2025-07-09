#!/bin/bash
#
# Use Swift SDK Generator approach
# Based on https://github.com/swiftlang/swift-sdk-generator
#

set -e

echo "=== Swift SDK Cross-Compilation Guide ==="
echo ""
echo "The old SDK format (raw tar.gz) is not compatible with Swift 6.0+"
echo "You need to use the new artifactbundle format."
echo ""
echo "Options:"
echo ""
echo "1. Use the Static Linux SDK (Recommended):"
echo "   This is the official way for cross-compiling to Linux"
echo ""
echo "   Install:"
echo "   swift sdk install \\"
echo "     https://download.swift.org/swift-6.0.2-branch/static-sdk/\\"
echo "     swift-6.0.2-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz \\"
echo "     --checksum <provided-checksum>"
echo ""
echo "   Build:"
echo "   swift build --swift-sdk aarch64-swift-linux-musl -c release"
echo ""
echo "2. Use Swift SDK Generator:"
echo "   git clone https://github.com/swiftlang/swift-sdk-generator"
echo "   cd swift-sdk-generator"
echo "   # Follow instructions to generate SDK for your target"
echo ""
echo "3. Build on Target (Simplest):"
echo "   Since cross-compilation setup is complex, consider:"
echo "   - Building directly on your EC2 instance"
echo "   - Using Docker with Linux Swift image"
echo "   - Using GitHub Actions with Linux runners"
echo ""
echo "For your EC2 ARM64 instance, the simplest approach is:"
echo "./deploy-source-to-ec2.sh"