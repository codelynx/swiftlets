#\!/bin/bash
#
# Build Linux executables one by one for reliability
#

set -e

SITE_NAME="swiftlets-site"
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== Building Linux Executables One by One ==="
echo ""

# Get list of Swift files to build
cd "$PROJECT_ROOT"
FILES=$(find sites/$SITE_NAME/src -name "*.swift" -type f | grep -v Components.swift | grep -v "/shared/" | sort)
TOTAL=$(echo "$FILES" | wc -l | tr -d ' ')
BUILT=0
FAILED=0

echo "Found $TOTAL Swift files to build"
echo ""

# Create a build status file
STATUS_FILE="/tmp/swiftlets-build-status.txt"
> "$STATUS_FILE"

# Build each file individually
for swift_file in $FILES; do
    REL_PATH=${swift_file#sites/$SITE_NAME/src/}
    BASENAME=$(basename "$REL_PATH" .swift)
    
    BUILT=$((BUILT + 1))
    echo "[$BUILT/$TOTAL] Building: $REL_PATH"
    
    # Run Docker build for this single file
    if docker run --rm \
        -v "$PROJECT_ROOT:/app" \
        -w /app \
        --platform linux/arm64 \
        -m 2g \
        swift:6.0.2 \
        timeout 120 ./build-site sites/$SITE_NAME --force >/dev/null 2>&1; then
        
        # Check if executable was created
        if [ -f "sites/$SITE_NAME/bin/${REL_PATH%.swift}" ]; then
            echo "  ✓ Success"
            echo "SUCCESS: $REL_PATH" >> "$STATUS_FILE"
        else
            echo "  ✗ Failed (no output)"
            echo "FAILED: $REL_PATH" >> "$STATUS_FILE"
            FAILED=$((FAILED + 1))
        fi
    else
        echo "  ✗ Failed (build error)"
        echo "FAILED: $REL_PATH" >> "$STATUS_FILE"
        FAILED=$((FAILED + 1))
    fi
    
    # Show progress every 5 files
    if [ $((BUILT % 5)) -eq 0 ]; then
        echo ""
        echo "Progress: $BUILT/$TOTAL files processed"
        SUCCESSFUL=$((BUILT - FAILED))
        echo "Successful: $SUCCESSFUL, Failed: $FAILED"
        echo ""
    fi
done

# Final summary
echo ""
echo "=== Build Complete ==="
SUCCESSFUL=$((TOTAL - FAILED))
echo "Total files: $TOTAL"
echo "Successfully built: $SUCCESSFUL"
echo "Failed: $FAILED"
echo ""

# List built executables
echo "Checking built executables..."
EXEC_COUNT=$(find sites/$SITE_NAME/bin -type f -executable 2>/dev/null | wc -l | tr -d ' ')
echo "Found $EXEC_COUNT executables"

# Show failed files if any
if [ $FAILED -gt 0 ]; then
    echo ""
    echo "Failed files:"
    grep "^FAILED:" "$STATUS_FILE" | cut -d: -f2-
fi

# Create deployment package if successful
if [ $EXEC_COUNT -gt 0 ]; then
    echo ""
    echo "Creating deployment package..."
    
    # Package executables with runtime libs
    docker run --rm \
        -v "$PROJECT_ROOT:/app" \
        -w /app \
        --platform linux/arm64 \
        swift:6.0.2 \
        bash -c '
            mkdir -p deploy-package/runtime-libs
            cp -L /usr/lib/swift/linux/*.so deploy-package/runtime-libs/ 2>/dev/null || true
            echo "Packaged $(ls deploy-package/runtime-libs | wc -l) runtime libraries"
        '
    
    # Add executables and web files
    cp -r sites/$SITE_NAME/bin deploy-package/
    cp -r sites/$SITE_NAME/web deploy-package/
    cp -r bin/linux/arm64/swiftlets-server deploy-package/ 2>/dev/null || true
    
    # Create tarball
    TIMESTAMP=$(date +%Y%m%d-%H%M%S)
    tar -czf "swiftlets-linux-$TIMESTAMP.tar.gz" deploy-package/
    rm -rf deploy-package
    
    echo "Package created: swiftlets-linux-$TIMESTAMP.tar.gz"
    echo "Size: $(du -h swiftlets-linux-$TIMESTAMP.tar.gz | cut -f1)"
    echo ""
    echo "To deploy: scp -i ~/.ssh/<YOUR-KEY-NAME>.pem swiftlets-linux-$TIMESTAMP.tar.gz ubuntu@<YOUR-EC2-IP>:~/"
fi

rm -f "$STATUS_FILE"
