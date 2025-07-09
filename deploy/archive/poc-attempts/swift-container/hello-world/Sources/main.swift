// Simple hello world without Foundation dependency
print("🚀 Hello from Swift Container!")

// Platform detection using compile-time directives
#if os(macOS)
print("Platform: macOS")
#elseif os(Linux)
print("Platform: Linux")
#else
print("Platform: Unknown")
#endif

// Architecture detection
#if arch(x86_64)
print("Architecture: x86_64")
#elseif arch(arm64) || arch(aarch64)
print("Architecture: ARM64")
#else
print("Architecture: Unknown")
#endif

// Simple argument handling
if CommandLine.arguments.count > 1 {
    print("Arguments:", CommandLine.arguments.dropFirst().joined(separator: ", "))
}

print("Swift Cross-Compilation Success! 🎉")