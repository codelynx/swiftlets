#!/bin/bash
set -e

echo "=== Module-Based Shared Components POC ==="
echo

# Paths
SWIFTLETS_ROOT="../.."
POC_ROOT="."
MODULES_DIR="$POC_ROOT/bin/.modules"

# Clean
rm -rf bin
mkdir -p bin/.modules

# Step 1: Create the module (interface only)
echo "Step 1: Creating SimpleComponents module..."
echo "----------------------------------------"

# First, we need to compile Swiftlets sources into a module too
echo "Creating Swiftlets module..."
swiftc \
    -emit-module \
    -module-name Swiftlets \
    -emit-module-path "$MODULES_DIR/Swiftlets.swiftmodule" \
    -parse-as-library \
    $SWIFTLETS_ROOT/Sources/Swiftlets/**/*.swift

echo "✓ Swiftlets.swiftmodule created"

# Now create SimpleComponents module
echo "Creating SimpleComponents module..."
swiftc \
    -emit-module \
    -module-name SimpleComponents \
    -emit-module-path "$MODULES_DIR/SimpleComponents.swiftmodule" \
    -parse-as-library \
    -I "$MODULES_DIR" \
    $SWIFTLETS_ROOT/Sources/Swiftlets/**/*.swift \
    shared/SimpleComponents.swift

echo "✓ SimpleComponents.swiftmodule created"
echo

# Show what was created
echo "Generated modules:"
ls -la bin/.modules/
echo

# Step 2: Build pages using the module
echo "Step 2: Building pages with shared components..."
echo "---------------------------------------------"

# Build index page
echo "Building index.swift..."
swiftc \
    -I "$MODULES_DIR" \
    -parse-as-library \
    $SWIFTLETS_ROOT/Sources/Swiftlets/**/*.swift \
    shared/SimpleComponents.swift \
    src/index.swift \
    -o bin/index

echo "✓ bin/index created"

# Build about page  
echo "Building about.swift..."
swiftc \
    -I "$MODULES_DIR" \
    -parse-as-library \
    $SWIFTLETS_ROOT/Sources/Swiftlets/**/*.swift \
    shared/SimpleComponents.swift \
    src/about.swift \
    -o bin/about

echo "✓ bin/about created"
echo

# Step 3: Test execution
echo "Step 3: Testing execution..."
echo "---------------------------"
echo "Running index page:"
./bin/index | head -20
echo
echo "..."
echo

# Summary
echo "=== Summary ==="
echo "✓ Module created: bin/.modules/SimpleComponents.swiftmodule"
echo "✓ Pages built:    bin/index, bin/about"
echo "✓ Both import and use shared components via module"
echo
echo "Key insight: The .swiftmodule provides the interface,"
echo "but we still include source files when building."