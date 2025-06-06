#!/bin/bash
# Build script for test-routing site

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
case $ARCH in
    aarch64) ARCH="arm64" ;;
    arm64) ARCH="arm64" ;;
    x86_64) ARCH="x86_64" ;;
esac

mkdir -p "web/bin/$OS/$ARCH"

swiftc -parse-as-library \
    ../../../Sources/SwiftletsCore/*.swift \
    ../../../Sources/SwiftletsHTML/Core/*.swift \
    ../../../Sources/SwiftletsHTML/Elements/*.swift \
    ../../../Sources/SwiftletsHTML/Helpers/*.swift \
    ../../../Sources/SwiftletsHTML/Layout/*.swift \
    ../../../Sources/SwiftletsHTML/Modifiers/*.swift \
    ../../../Sources/SwiftletsHTML/Builders/*.swift \
    src/index.swift \
    -o "web/bin/$OS/$ARCH/index"