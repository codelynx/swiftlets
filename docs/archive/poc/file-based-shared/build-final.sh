#!/bin/bash
set -e

echo "=== File-Based Shared Components POC ==="
echo

cd /Users/kyoshikawa/Projects/swiftlets

# Clean
rm -rf poc/file-based-shared/bin
mkdir -p poc/file-based-shared/bin/japan/tokyo/shibuya

# Framework sources in correct order
FRAMEWORK_SOURCES="Sources/Swiftlets/HTML/Core/*.swift \
    Sources/Swiftlets/HTML/Builders/*.swift \
    Sources/Swiftlets/HTML/Elements/*.swift \
    Sources/Swiftlets/HTML/Helpers/*.swift \
    Sources/Swiftlets/HTML/Layout/*.swift \
    Sources/Swiftlets/HTML/Modifiers/*.swift \
    Sources/Swiftlets/Core/*.swift"

echo "1. Building japan/index.swift (limited scope)"
echo "────────────────────────────────────────────"
echo "Available components:"
echo "  ✓ globalNav() - from shared/"
echo "  ✓ japanMenu() - from japan/shared/"
echo "  ✗ tokyoDistrictMenu() - NOT available"

swiftc \
    -parse-as-library \
    $FRAMEWORK_SOURCES \
    poc/file-based-shared/src/shared/*.swift \
    poc/file-based-shared/src/japan/shared/*.swift \
    poc/file-based-shared/src/japan/index.swift \
    -o poc/file-based-shared/bin/japan/index

echo "✓ Success"
echo

echo "2. Building japan/tokyo/shibuya/bluecafe.swift (full scope)"
echo "──────────────────────────────────────────────────────────"
echo "Available components:"
echo "  ✓ globalNav() - from shared/"
echo "  ✓ japanMenu() - from japan/shared/"
echo "  ✓ tokyoDistrictMenu() - from japan/tokyo/shared/"

swiftc \
    -parse-as-library \
    $FRAMEWORK_SOURCES \
    poc/file-based-shared/src/shared/*.swift \
    poc/file-based-shared/src/japan/shared/*.swift \
    poc/file-based-shared/src/japan/tokyo/shared/*.swift \
    poc/file-based-shared/src/japan/tokyo/shibuya/bluecafe.swift \
    -o poc/file-based-shared/bin/japan/tokyo/shibuya/bluecafe

echo "✓ Success"
echo

echo "=== Testing Output ==="
echo

echo "Japan page (shows limited components):"
echo "────────────────────────────────────"
./poc/file-based-shared/bin/japan/index | grep -E "<h1>|<h3>|<h4>" | head -10

echo
echo "Blue Cafe page (shows all component levels):"
echo "──────────────────────────────────────────"
./poc/file-based-shared/bin/japan/tokyo/shibuya/bluecafe | grep -E "<h1>|<h3>|<h4>" | head -10

echo
echo "=== Key Takeaways ==="
echo "✓ No import statements needed"
echo "✓ Components available based on directory hierarchy"
echo "✓ Simple file-based discovery"
echo "✓ Natural scoping without complex module system"