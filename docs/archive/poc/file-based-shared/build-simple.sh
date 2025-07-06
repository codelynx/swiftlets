#!/bin/bash
set -e

echo "=== File-Based Shared Components POC ==="
echo

cd /Users/kyoshikawa/Projects/swiftlets

# Clean
rm -rf poc/file-based-shared/bin
mkdir -p poc/file-based-shared/bin/japan/tokyo/shibuya

echo "1. Building japan/index.swift (access to global + japan shared)"
echo "───────────────────────────────────────────────────────────────"
echo "Shared components:"
echo "  ✓ src/shared/global_nav.swift"
echo "  ✓ src/japan/shared/japan_menu.swift"
echo "  ✗ src/japan/tokyo/shared/tokyo_menu.swift (NOT accessible)"

swiftc \
    -parse-as-library \
    Sources/Swiftlets/**/*.swift \
    poc/file-based-shared/src/shared/*.swift \
    poc/file-based-shared/src/japan/shared/*.swift \
    poc/file-based-shared/src/japan/index.swift \
    -o poc/file-based-shared/bin/japan/index

echo "✓ Built successfully"
echo

echo "2. Building japan/tokyo/shibuya/bluecafe.swift (access to all levels)"
echo "────────────────────────────────────────────────────────────────────"
echo "Shared components:"
echo "  ✓ src/shared/global_nav.swift"
echo "  ✓ src/japan/shared/japan_menu.swift"
echo "  ✓ src/japan/tokyo/shared/tokyo_menu.swift"

swiftc \
    -parse-as-library \
    Sources/Swiftlets/**/*.swift \
    poc/file-based-shared/src/shared/*.swift \
    poc/file-based-shared/src/japan/shared/*.swift \
    poc/file-based-shared/src/japan/tokyo/shared/*.swift \
    poc/file-based-shared/src/japan/tokyo/shibuya/bluecafe.swift \
    -o poc/file-based-shared/bin/japan/tokyo/shibuya/bluecafe

echo "✓ Built successfully"
echo

echo "=== Testing Execution ==="
echo

echo "Japan page output (first 20 lines):"
echo "──────────────────────────────────"
./poc/file-based-shared/bin/japan/index | head -20
echo

echo "Blue Cafe page output (first 20 lines):"
echo "───────────────────────────────────────"
./poc/file-based-shared/bin/japan/tokyo/shibuya/bluecafe | head -20

echo
echo "=== Success! ==="
echo "The POC demonstrates:"
echo "1. Hierarchical shared components based on directory structure"
echo "2. No import statements needed - components compiled together"
echo "3. Natural scoping - deeper pages access more components"
echo "4. Simple implementation in build script"