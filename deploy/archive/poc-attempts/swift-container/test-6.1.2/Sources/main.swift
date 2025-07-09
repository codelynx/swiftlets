print("Swift 6.1.2 Cross-Compilation Test")
print("Platform: ", terminator: "")

#if os(Linux)
print("Linux", terminator: "")
#elseif os(macOS)  
print("macOS", terminator: "")
#else
print("Unknown", terminator: "")
#endif

print(" / ", terminator: "")

#if arch(x86_64)
print("x86_64")
#elseif arch(arm64) || arch(aarch64)
print("ARM64")
#else
print("Unknown")
#endif

print("✅ Cross-compilation successful!")