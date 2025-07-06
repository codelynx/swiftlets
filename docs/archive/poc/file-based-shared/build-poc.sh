#!/bin/bash
set -e

echo "=== File-Based Shared Components POC ==="
echo

SWIFTLETS_ROOT="../.."
POC_ROOT="."

# Function to discover shared components for a given file
discover_shared() {
    local swift_file="$1"
    local src_root="$POC_ROOT/src"
    
    # Get directory path relative to src/
    local rel_path="${swift_file#$src_root/}"
    local dir_path=$(dirname "$rel_path")
    
    echo "Discovering shared components for: $rel_path"
    
    local shared_files=""
    local shared_list=""
    
    # Walk up directory tree from file location
    local current_dir="$dir_path"
    while [ "$current_dir" != "." ] && [ "$current_dir" != "/" ]; do
        if [ -d "$src_root/$current_dir/shared" ]; then
            echo "  ✓ Found: $current_dir/shared/"
            shared_files="$shared_files $src_root/$current_dir/shared/*.swift"
            shared_list="$shared_list$current_dir/shared/, "
        fi
        current_dir=$(dirname "$current_dir")
    done
    
    # Add global shared
    if [ -d "$src_root/shared" ]; then
        echo "  ✓ Found: shared/ (global)"
        shared_files="$shared_files $src_root/shared/*.swift"
        shared_list="${shared_list}shared/ (global)"
    fi
    
    echo "$shared_files"
}

# Function to build a swiftlet with discovered shared components
build_swiftlet() {
    local swift_file="$1"
    local output_name=$(basename "$swift_file" .swift)
    local rel_path="${swift_file#$POC_ROOT/src/}"
    local output_dir="$POC_ROOT/bin/$(dirname "$rel_path")"
    
    echo
    echo "Building: $rel_path"
    echo "────────────────────────────────────────"
    
    # Discover shared components
    local shared_files=$(discover_shared "$swift_file")
    
    # Create output directory
    mkdir -p "$output_dir"
    
    # Build command
    echo "Compiling with:"
    echo "  - Swiftlets framework"
    echo "  - Discovered shared components"
    echo "  - $rel_path"
    
    # Compile (using absolute paths to avoid duplicates)
    local abs_shared_files=""
    for f in $shared_files; do
        abs_shared_files="$abs_shared_files $(cd "$(dirname "$f")" && pwd)/$(basename "$f")"
    done
    
    swiftc \
        -parse-as-library \
        $SWIFTLETS_ROOT/Sources/Swiftlets/HTML/Core/*.swift \
        $SWIFTLETS_ROOT/Sources/Swiftlets/HTML/Builders/*.swift \
        $SWIFTLETS_ROOT/Sources/Swiftlets/HTML/Elements/*.swift \
        $SWIFTLETS_ROOT/Sources/Swiftlets/HTML/Helpers/*.swift \
        $SWIFTLETS_ROOT/Sources/Swiftlets/HTML/Layout/*.swift \
        $SWIFTLETS_ROOT/Sources/Swiftlets/HTML/Modifiers/*.swift \
        $SWIFTLETS_ROOT/Sources/Swiftlets/Core/*.swift \
        $abs_shared_files \
        "$(cd "$(dirname "$swift_file")" && pwd)/$(basename "$swift_file")" \
        -o "$output_dir/$output_name"
    
    if [ $? -eq 0 ]; then
        echo "✓ Success: bin/$rel_path"
    else
        echo "✗ Failed to build $rel_path"
        return 1
    fi
}

# Clean
rm -rf bin
mkdir -p bin

# Build different pages to demonstrate scoping
echo "=== Building Pages with Different Scope Levels ==="

# 1. Build japan/index.swift (has access to global + japan shared)
build_swiftlet "$POC_ROOT/src/japan/index.swift"

# 2. Build japan/tokyo/shibuya/bluecafe.swift (has access to all levels)
build_swiftlet "$POC_ROOT/src/japan/tokyo/shibuya/bluecafe.swift"

echo
echo "=== Testing Execution ==="
echo

# Test japan page
echo "1. Japan overview page (limited scope):"
echo "───────────────────────────────────────"
./bin/japan/index | head -15
echo "..."

echo
echo "2. Blue Cafe page (full scope):"
echo "───────────────────────────────────────"
./bin/japan/tokyo/shibuya/bluecafe | head -15
echo "..."

echo
echo "=== Key Observations ==="
echo "1. japan/index only has access to:"
echo "   - shared/ (global)"
echo "   - japan/shared/"
echo
echo "2. japan/tokyo/shibuya/bluecafe has access to:"
echo "   - shared/ (global)"
echo "   - japan/shared/"
echo "   - japan/tokyo/shared/"
echo
echo "3. No import statements needed - all compiled together"
echo "4. Natural scoping based on directory structure"
echo "5. Shared components are discovered automatically"