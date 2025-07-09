#\!/bin/bash
set -e

echo "=== Direct Docker Build for All Swiftlets ==="

docker run --rm \
    -v "$(pwd):/app" \
    -w /app \
    --platform linux/arm64 \
    -m 6g \
    --cpus="4" \
    swift:6.0.2 \
    bash -c '
        set -e
        
        # Clean everything
        rm -rf sites/swiftlets-site/bin
        mkdir -p sites/swiftlets-site/bin
        
        # Get framework sources
        FRAMEWORK_SOURCES="Sources/Swiftlets/Core/*.swift \
            Sources/Swiftlets/HTML/Core/*.swift \
            Sources/Swiftlets/HTML/Elements/*.swift \
            Sources/Swiftlets/HTML/Helpers/*.swift \
            Sources/Swiftlets/HTML/Layout/*.swift \
            Sources/Swiftlets/HTML/Modifiers/*.swift \
            Sources/Swiftlets/HTML/Builders/*.swift"
        
        # Get shared components
        SHARED_SOURCES="sites/swiftlets-site/src/Components.swift \
            sites/swiftlets-site/src/shared/*.swift"
        
        # Build each Swift file directly
        echo "Building Swift files..."
        COUNT=0
        
        for src in sites/swiftlets-site/src/*.swift sites/swiftlets-site/src/**/*.swift; do
            # Skip Components.swift and shared files
            if [[ "$src" == *"Components.swift" ]] || [[ "$src" == */shared/* ]]; then
                continue
            fi
            
            if [ -f "$src" ]; then
                COUNT=$((COUNT + 1))
                REL_PATH=${src#sites/swiftlets-site/src/}
                OUT_PATH="sites/swiftlets-site/bin/${REL_PATH%.swift}"
                OUT_DIR=$(dirname "$OUT_PATH")
                
                echo "[$COUNT] Building: $REL_PATH"
                mkdir -p "$OUT_DIR"
                
                # Create temp file without import
                TEMP_FILE="/tmp/$(basename $src)"
                sed "/^import Swiftlets$/d" "$src" > "$TEMP_FILE"
                
                # Build
                if timeout 60 swiftc -parse-as-library -module-name Swiftlets \
                    $FRAMEWORK_SOURCES $SHARED_SOURCES "$TEMP_FILE" \
                    -o "$OUT_PATH" 2>/dev/null; then
                    echo "  ✓ Success"
                    
                    # Create webbin
                    md5sum "$OUT_PATH" | cut -d" " -f1 > "sites/swiftlets-site/web/${REL_PATH%.swift}.webbin"
                else
                    echo "  ✗ Failed"
                fi
                
                rm -f "$TEMP_FILE"
            fi
        done
        
        echo ""
        echo "=== Build Complete ==="
        echo "Total executables built:"
        find sites/swiftlets-site/bin -type f | wc -l
    '
