#!/bin/bash
#
# Properly install Swift SDK for cross-compilation
#

set -e

echo "=== Installing Swift SDK for ARM64 Linux ==="

cd "$(dirname "$0")"

# Create proper bundle structure
echo "1. Creating SDK bundle structure..."

BUNDLE_NAME="swift-6.0.2-ubuntu22.04-aarch64.artifactbundle"
rm -rf "$BUNDLE_NAME"
mkdir -p "$BUNDLE_NAME"

# Extract the SDK
echo "2. Extracting SDK..."
tar -xzf arm64-sdk.tar.gz

# Move to bundle
mv swift-6.0.2-RELEASE-ubuntu22.04-aarch64 "$BUNDLE_NAME/swift-6.0.2-RELEASE-ubuntu22.04-aarch64"

# Create info.json for the bundle
echo "3. Creating bundle metadata..."
cat > "$BUNDLE_NAME/info.json" << 'EOF'
{
    "schemaVersion": "1.0",
    "artifacts": {
        "swift-6.0.2-RELEASE-ubuntu22.04-aarch64": {
            "type": "swiftSDK",
            "version": "6.0.2",
            "variants": [
                {
                    "path": "swift-6.0.2-RELEASE-ubuntu22.04-aarch64",
                    "supportedTriples": ["aarch64-unknown-linux-gnu"]
                }
            ]
        }
    }
}
EOF

# Create tar.gz of the bundle
echo "4. Creating bundle archive..."
tar -czf "$BUNDLE_NAME.tar.gz" "$BUNDLE_NAME"

# Install the bundle
echo "5. Installing SDK bundle..."
CHECKSUM=$(swift package compute-checksum "$BUNDLE_NAME.tar.gz")
swift sdk install "$BUNDLE_NAME.tar.gz" --checksum "$CHECKSUM"

# Clean up
rm -rf "$BUNDLE_NAME" "$BUNDLE_NAME.tar.gz"

# List SDKs
echo ""
echo "6. Installed SDKs:"
swift sdk list

echo ""
echo "✅ SDK installation complete!"