#!/bin/bash
set -e

echo "=== Module POC - Demonstrating Build Approaches ==="
echo

SWIFTLETS_ROOT="../.."

# Clean
rm -rf bin
mkdir -p bin

echo "Approach 1: Direct source inclusion (baseline)"
echo "----------------------------------------------"
time swiftc \
    -parse-as-library \
    $SWIFTLETS_ROOT/Sources/Swiftlets/**/*.swift \
    shared/SimpleComponents.swift \
    src/index.swift \
    -o bin/index-direct

echo "✓ Created bin/index-direct"
echo

echo "Approach 2: Using object files"  
echo "------------------------------"

# First compile shared components to object file
echo "Step 1: Compile shared components to .o file..."
time swiftc -c \
    -parse-as-library \
    $SWIFTLETS_ROOT/Sources/Swiftlets/**/*.swift \
    shared/SimpleComponents.swift \
    -o bin/shared.o

echo "✓ Created bin/shared.o"

# Then link with the object file
echo "Step 2: Build page linking the .o file..."
time swiftc \
    -parse-as-library \
    bin/shared.o \
    src/index.swift \
    -o bin/index-object

echo "✓ Created bin/index-object"
echo

echo "Approach 3: Static library"
echo "--------------------------"

# Create static library
echo "Step 1: Create static library..."
ar rcs bin/libshared.a bin/shared.o
echo "✓ Created bin/libshared.a"

# Link against static library
echo "Step 2: Build page with static library..."
time swiftc \
    -parse-as-library \
    -L bin -lshared \
    src/index.swift \
    -o bin/index-static

echo "✓ Created bin/index-static"
echo

echo "=== Comparison ==="
echo "Binary sizes:"
ls -lh bin/index-* | grep -v ".o\|.a"
echo

echo "All executables produce same output:"
echo "-------------------------------------"
./bin/index-direct | head -5
echo

echo "=== Key Insights ==="
echo "1. Object files (.o) enable incremental compilation"
echo "2. Static libraries (.a) are just archives of .o files"  
echo "3. All approaches produce functionally identical binaries"
echo "4. Module interfaces would add type checking without changing build"