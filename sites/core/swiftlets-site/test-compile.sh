#!/bin/bash
# Test compilation of a single swiftlet

echo "Testing compilation of index.swift..."

# First, let's check if core is built
if [ -d "../../../core/.build/release" ]; then
    echo "Core is built, attempting with package modules..."
    swiftc -I ../../../core/.build/release/Modules \
           -L ../../../core/.build/release \
           -lSwiftletsCore -lSwiftletsHTML \
           src/index.swift -o test-index
    
    if [ $? -eq 0 ]; then
        echo "✓ Compilation successful with package!"
        rm test-index
        exit 0
    else
        echo "✗ Package compilation failed"
    fi
fi

echo "Attempting direct compilation..."
# Try direct compilation
swiftc -parse-as-library \
       ../../../core/Sources/SwiftletsCore/*.swift \
       ../../../core/Sources/SwiftletsHTML/Core/*.swift \
       ../../../core/Sources/SwiftletsHTML/Elements/*.swift \
       ../../../core/Sources/SwiftletsHTML/Helpers/*.swift \
       ../../../core/Sources/SwiftletsHTML/Layout/*.swift \
       ../../../core/Sources/SwiftletsHTML/Modifiers/*.swift \
       ../../../core/Sources/SwiftletsHTML/Builders/*.swift \
       src/index.swift \
       -o test-index

if [ $? -eq 0 ]; then
    echo "✓ Direct compilation successful!"
    rm test-index
else
    echo "✗ Direct compilation failed"
    exit 1
fi