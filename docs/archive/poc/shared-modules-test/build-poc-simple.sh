#!/bin/bash
set -e

echo "=== Module-Based Shared Components POC (Simplified) ==="
echo

# Paths
SWIFTLETS_ROOT="../.."
POC_ROOT="."

# Clean
rm -rf bin
mkdir -p bin/.modules

# Step 1: Build with module emission
echo "Step 1: Building index with module emission..."
echo "---------------------------------------------"

# Build index and emit modules as a side effect
swiftc \
    -emit-module \
    -module-name TestApp \
    -emit-module-path "$POC_ROOT/bin/.modules/TestApp.swiftmodule" \
    -parse-as-library \
    $SWIFTLETS_ROOT/Sources/Swiftlets/**/*.swift \
    shared/SimpleComponents.swift \
    src/index.swift \
    -o bin/index

echo "✓ bin/index created"
echo "✓ Module created as side effect"
echo

# Step 2: Show that we can use swift-demangle to inspect
echo "Step 2: Inspecting module symbols..."
echo "------------------------------------"
echo "Public symbols in binary:"
nm bin/index | grep "sharedHeader\|SharedFooter" | head -5 || echo "nm not available"
echo

# Step 3: Alternative approach - create object files
echo "Step 3: Alternative - Object file approach..."
echo "--------------------------------------------"

# Compile shared components to object file
echo "Compiling shared components to object file..."
swiftc -c \
    -parse-as-library \
    -module-name SimpleComponents \
    $SWIFTLETS_ROOT/Sources/Swiftlets/**/*.swift \
    shared/SimpleComponents.swift \
    -o bin/SimpleComponents.o

echo "✓ Object file created"

# Now link with the object file
echo "Building about page with object file..."
swiftc \
    -parse-as-library \
    $SWIFTLETS_ROOT/Sources/Swiftlets/**/*.swift \
    bin/SimpleComponents.o \
    src/about.swift \
    -o bin/about

echo "✓ bin/about created (linked with object file)"
echo

# Step 4: Test execution
echo "Step 4: Testing execution..."
echo "---------------------------"
echo "Index page output (first 15 lines):"
./bin/index | head -15
echo
echo "Binary sizes:"
ls -lh bin/index bin/about
echo

echo "=== Key Insights ==="
echo "1. Swift modules need all dependencies present"
echo "2. Can emit modules as side effect of compilation"
echo "3. Object files (.o) provide incremental compilation"
echo "4. Both approaches avoid recompiling shared code"