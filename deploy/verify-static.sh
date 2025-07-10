#!/bin/bash
# Verify that binaries are statically linked
# Run this on your Linux deployment target

set -e

echo "Verifying static binaries..."
echo ""

# Check if we're on Linux
if [[ "$OSTYPE" != "linux"* ]]; then
    echo "Warning: This script should be run on Linux to verify static binaries."
    echo "Static linking verification is not meaningful on macOS."
    exit 1
fi

# Check for ldd command
if ! command -v ldd &> /dev/null; then
    echo "Error: ldd command not found. Install it with:"
    echo "  Ubuntu/Debian: apt-get install libc-bin"
    echo "  Alpine: apk add libc6-compat"
    exit 1
fi

# Find all executables in bin directory
if [ ! -d "bin" ]; then
    echo "Error: No bin directory found. Run this from the site root."
    exit 1
fi

echo "Checking executables in bin/..."
echo ""

STATIC_COUNT=0
DYNAMIC_COUNT=0

# Check each executable
while IFS= read -r -d '' file; do
    if [ -x "$file" ]; then
        echo -n "Checking $(basename "$file")... "
        
        # Run ldd and check output
        if ldd "$file" 2>&1 | grep -q "not a dynamic executable"; then
            echo "✓ STATIC"
            ((STATIC_COUNT++))
        else
            echo "✗ DYNAMIC"
            ((DYNAMIC_COUNT++))
            echo "  Dependencies:"
            ldd "$file" 2>&1 | sed 's/^/    /'
        fi
        echo ""
    fi
done < <(find bin -type f -print0)

# Summary
echo "Summary:"
echo "  Static binaries: $STATIC_COUNT"
echo "  Dynamic binaries: $DYNAMIC_COUNT"
echo ""

if [ $STATIC_COUNT -gt 0 ] && [ $DYNAMIC_COUNT -eq 0 ]; then
    echo "✓ All binaries are static! No Swift runtime required."
elif [ $DYNAMIC_COUNT -gt 0 ]; then
    echo "⚠️  Some binaries are dynamic and will require Swift runtime."
    echo "  To create static binaries, build with:"
    echo "    ./build-site sites/your-site --static"
    echo "  Or use the Alpine Docker build."
fi