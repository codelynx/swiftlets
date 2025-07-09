#!/bin/bash
  cd /home/ubuntu/swiftlets

  for file in sites/swiftlets-site/src/*.swift; do
      base=$(basename "$file" .swift)
      echo "Building: $base"

      swiftc -parse-as-library -module-name Swiftlets \
          Sources/Swiftlets/Core/*.swift \
          Sources/Swiftlets/HTML/Core/*.swift \
          Sources/Swiftlets/HTML/Elements/*.swift \
          Sources/Swiftlets/HTML/Helpers/*.swift \
          Sources/Swiftlets/HTML/Layout/*.swift \
          Sources/Swiftlets/HTML/Modifiers/*.swift \
          Sources/Swiftlets/HTML/Builders/*.swift \
          sites/swiftlets-site/src/Components.swift \
          sites/swiftlets-site/src/shared/*.swift \
          "$file" \
          -o "sites/swiftlets-site/bin/$base" 2>/dev/null

      if [ $? -eq 0 ]; then
          echo '{"type":"executable","path":"'$base'"}' >
  "sites/swiftlets-site/web/$base.webbin"
          echo "  ✓ Built successfully"
      else
          echo "  ✗ Failed to build"
      fi
  done

