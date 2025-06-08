#!/bin/bash
cd /Users/kyoshikawa/prj/swiftlets

swiftc -parse-as-library \
  Sources/Swiftlets/Core/Context.swift \
  Sources/Swiftlets/Core/DefaultSwiftletContext.swift \
  Sources/Swiftlets/Core/Request.swift \
  Sources/Swiftlets/Core/Response.swift \
  Sources/Swiftlets/HTML/Core/HTMLElement.swift \
  Sources/Swiftlets/HTML/Core/HTMLAttributes.swift \
  Sources/Swiftlets/HTML/Elements/Document.swift \
  Sources/Swiftlets/HTML/Elements/Headings.swift \
  Sources/Swiftlets/HTML/Elements/Paragraph.swift \
  Sources/Swiftlets/HTML/Elements/Text.swift \
  Sources/Swiftlets/HTML/Builders/HTMLBuilder.swift \
  sites/test/resource-example/src/index.swift \
  -o sites/test/resource-example/bin/index