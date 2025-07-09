#!/bin/bash
#
# Verify that all swiftlets in sites/swiftlets-site were built
#

set -e

SITE_NAME="swiftlets-site"
SITE_ROOT="sites/$SITE_NAME"

echo "=== Verifying Swiftlets Build ==="
echo ""

# Count source files
SWIFT_FILES=$(find "$SITE_ROOT/src" -name "*.swift" -type f | grep -v "/shared/" | grep -v "Components.swift" | sort)
TOTAL_SWIFT=$(echo "$SWIFT_FILES" | wc -l | tr -d ' ')

echo "Source files: $TOTAL_SWIFT Swift files found"
echo ""

# Check webbin files
echo "Checking built files..."
MISSING=0
FOUND=0

while IFS= read -r src_file; do
    # Convert source path to webbin path
    rel_path="${src_file#$SITE_ROOT/src/}"
    webbin_file="$SITE_ROOT/web/${rel_path%.swift}.webbin"
    
    if [ -f "$webbin_file" ]; then
        ((FOUND++))
        echo "  ✓ $rel_path"
    else
        ((MISSING++))
        echo "  ✗ $rel_path (MISSING)"
    fi
done <<< "$SWIFT_FILES"

echo ""
echo "Build Status:"
echo "  Total source files: $TOTAL_SWIFT"
echo "  Successfully built: $FOUND"
echo "  Missing:           $MISSING"

# Check global webbin directory
if [ -d "webbin" ]; then
    echo ""
    echo "Global webbin directory:"
    GLOBAL_WEBBIN=$(find webbin -name "*.webbin" -type f | wc -l | tr -d ' ')
    echo "  Files: $GLOBAL_WEBBIN"
fi

# Summary
echo ""
if [ $MISSING -eq 0 ]; then
    echo "✅ All swiftlets built successfully!"
    exit 0
else
    echo "❌ Some swiftlets failed to build!"
    exit 1
fi