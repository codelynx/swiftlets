#!/bin/bash
# Build script that includes all source files

set -e

echo "Building showcase site..."

# Create output directories
mkdir -p web/bin/darwin/arm64/docs

# Base compile command with all source files
COMPILE_CMD="swiftc -parse-as-library \
    ../../../core/Sources/SwiftletsCore/Request.swift \
    ../../../core/Sources/SwiftletsCore/Response.swift \
    ../../../core/Sources/SwiftletsCore/Swiftlet.swift \
    ../../../core/Sources/SwiftletsHTML/Core/HTMLElement.swift \
    ../../../core/Sources/SwiftletsHTML/Core/HTMLAttributes.swift \
    ../../../core/Sources/SwiftletsHTML/Core/AnyHTMLElement.swift \
    ../../../core/Sources/SwiftletsHTML/Builders/HTMLBuilder.swift \
    ../../../core/Sources/SwiftletsHTML/Elements/Document.swift \
    ../../../core/Sources/SwiftletsHTML/Elements/Headings.swift \
    ../../../core/Sources/SwiftletsHTML/Elements/Text.swift \
    ../../../core/Sources/SwiftletsHTML/Elements/Paragraph.swift \
    ../../../core/Sources/SwiftletsHTML/Elements/Link.swift \
    ../../../core/Sources/SwiftletsHTML/Elements/Lists.swift \
    ../../../core/Sources/SwiftletsHTML/Elements/Div.swift \
    ../../../core/Sources/SwiftletsHTML/Elements/Semantic.swift \
    ../../../core/Sources/SwiftletsHTML/Elements/Form.swift \
    ../../../core/Sources/SwiftletsHTML/Elements/Table.swift \
    ../../../core/Sources/SwiftletsHTML/Elements/Media.swift \
    ../../../core/Sources/SwiftletsHTML/Elements/Script.swift \
    ../../../core/Sources/SwiftletsHTML/Elements/Inline.swift \
    ../../../core/Sources/SwiftletsHTML/Elements/TextFormatting.swift \
    ../../../core/Sources/SwiftletsHTML/Elements/DataDisplay.swift \
    ../../../core/Sources/SwiftletsHTML/Layout/Stack.swift \
    ../../../core/Sources/SwiftletsHTML/Helpers/Fragment.swift \
    ../../../core/Sources/SwiftletsHTML/Helpers/ForEach.swift \
    ../../../core/Sources/SwiftletsHTML/Helpers/Conditional.swift \
    ../../../core/Sources/SwiftletsHTML/Modifiers/AttributeModifiers.swift \
    ../../../core/Sources/SwiftletsHTML/Modifiers/StyleModifiers.swift"

# Build index
echo "Building index.swift..."
$COMPILE_CMD src/index.swift -o web/bin/darwin/arm64/index

# Build docs
echo "Building docs.swift..."
$COMPILE_CMD src/docs.swift -o web/bin/darwin/arm64/docs

# Build showcase
echo "Building showcase.swift..."
$COMPILE_CMD src/showcase.swift -o web/bin/darwin/arm64/showcase

# Build about
echo "Building about.swift..."
$COMPILE_CMD src/about.swift -o web/bin/darwin/arm64/about

# Build getting-started
echo "Building docs/getting-started.swift..."
$COMPILE_CMD src/docs/getting-started.swift -o web/bin/darwin/arm64/docs/getting-started

echo "✓ Build complete!"
echo ""
echo "To run:"
echo "cd ../../.. && SWIFTLETS_SITE=sites/core/swiftlets-site ./core/.build/release/swiftlets-server"