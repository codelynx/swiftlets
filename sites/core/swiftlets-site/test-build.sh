#!/bin/bash
# Test build for a single swiftlet

echo "Testing build for index.swift..."

# Create output directory
mkdir -p web/bin/darwin/arm64

# Try to compile index.swift with all source files
swiftc -parse-as-library \
    ../../../core/Sources/SwiftletsCore/*.swift \
    ../../../core/Sources/SwiftletsHTML/Core/*.swift \
    ../../../core/Sources/SwiftletsHTML/Elements/*.swift \
    ../../../core/Sources/SwiftletsHTML/Helpers/*.swift \
    ../../../core/Sources/SwiftletsHTML/Layout/*.swift \
    ../../../core/Sources/SwiftletsHTML/Modifiers/*.swift \
    ../../../core/Sources/SwiftletsHTML/Builders/*.swift \
    src/index.swift \
    -o web/bin/darwin/arm64/index

if [ $? -eq 0 ]; then
    echo "✓ Build successful!"
    echo "Binary created at: web/bin/darwin/arm64/index"
else
    echo "✗ Build failed"
fi