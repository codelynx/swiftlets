print("Hello from Swift on Linux ARM64!")
print("Platform: \(getplatform())")

func getplatform() -> String {
    #if os(Linux)
    let os = "Linux"
    #elseif os(macOS)
    let os = "macOS"
    #else
    let os = "Unknown"
    #endif
    
    #if arch(x86_64)
    let arch = "x86_64"
    #elseif arch(arm64) || arch(aarch64)
    let arch = "ARM64"
    #else
    let arch = "Unknown"
    #endif
    
    return "\(os) \(arch)"
}