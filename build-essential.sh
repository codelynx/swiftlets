#!/bin/bash
  cd ~/swiftlets

  # Array of essential files to build
  files=("index" "about" "docs/index" "showcase/index")

  for file in "${files[@]}"; do
      echo "Building: $file"
      dir=$(dirname "$file")
      base=$(basename "$file")

      # Create directory if needed
      mkdir -p "sites/swiftlets-site/bin/$dir"

      # Compile
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
          "sites/swiftlets-site/src/$file.swift" \
          -o "sites/swiftlets-site/bin/$file"

      # Create webbin
      mkdir -p "sites/swiftlets-site/web/$dir"
      echo '{"type":"executable","path":"'$file'"}' >
  "sites/swiftlets-site/web/$file.webbin"
  done

  echo "Essential pages built!"

