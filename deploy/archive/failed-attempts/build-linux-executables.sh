#\!/bin/bash
set -e

echo "=== Building Linux Executables in Batches ==="

# Get all Swift files
FILES=$(find sites/swiftlets-site/src -name "*.swift" -type f | grep -v Components.swift | grep -v "/shared/" | sort)
TOTAL=$(echo "$FILES" | wc -l)
BUILT=0

echo "Found $TOTAL files to build"

# Build in batches of 5
BATCH_SIZE=5
BATCH_NUM=0

echo "$FILES" | while IFS= read -r batch; do
    if [ -z "$batch" ]; then
        continue
    fi
    
    BATCH_NUM=$((BATCH_NUM + 1))
    echo ""
    echo "=== Batch $BATCH_NUM ==="
    
    # Build this batch in Docker
    docker run --rm \
        -v "$(pwd):/app" \
        -w /app \
        --platform linux/arm64 \
        -m 4g \
        swift:6.0.2 \
        bash -c "
            # Build specific files
            for file in $batch; do
                echo \"Building: \$file\"
                ./build-site sites/swiftlets-site --force >/dev/null 2>&1 || echo \"Failed: \$file\"
            done
        "
    
    BUILT=$((BUILT + 1))
    echo "Progress: $BUILT/$TOTAL files"
    
    # Process only first batch for now
    if [ $BATCH_NUM -ge 1 ]; then
        break
    fi
done

echo ""
echo "Checking results..."
find sites/swiftlets-site/bin -type f | wc -l
echo "executables built"
