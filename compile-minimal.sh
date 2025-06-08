#!/bin/bash
cd /Users/kyoshikawa/prj/swiftlets
swiftc -parse-as-library Sources/Swiftlets/Core/Context.swift Sources/Swiftlets/Core/DefaultSwiftletContext.swift Sources/Swiftlets/Core/Request.swift Sources/Swiftlets/Core/Response.swift sites/test/resource-example/src/minimal.swift -o sites/test/resource-example/bin/index