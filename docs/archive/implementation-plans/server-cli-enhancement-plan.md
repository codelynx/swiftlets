# Server CLI Enhancement Plan

## Overview

This document outlines the plan to enhance the Swiftlets server with command-line argument support for specifying the site root directory and server options. Currently, the server relies exclusively on environment variables for configuration.

## Problem Statement

### Current Limitations
1. **Environment Variable Dependency**: Server configuration requires setting environment variables
2. **Limited Discoverability**: Users cannot use `--help` to see available options
3. **Non-standard Interface**: Most servers accept command-line arguments for basic configuration
4. **Complex Wrapper Scripts**: Current scripts must set environment variables before execution

### Current Configuration Method
```bash
# Current approach (environment variables only)
SWIFTLETS_WEB_ROOT=sites/examples/swiftlets-site/web ./swiftlets-server
SWIFTLETS_PORT=3000 SWIFTLETS_HOST=0.0.0.0 ./swiftlets-server
```

## Proposed Solution

### Goals
1. Add command-line argument support to the server
2. Maintain backward compatibility with environment variables
3. Provide clear precedence rules
4. Improve user experience with standard CLI patterns

### New Server Interface
```bash
# Proposed command-line interface
swiftlets-server <site-root> [options]

Arguments:
  <site-root>           Site root directory containing web/ and bin/ subdirectories

Options:
  -p, --port <number>   Port to listen on (default: 8080)
  -h, --host <address>  Host to bind to (default: 127.0.0.1)
  --debug               Enable debug logging
  --help                Show help information
  --version             Show version information
```

### Terminology Clarification
- **Site Root**: The parent directory containing the site structure (e.g., `sites/examples/swiftlets-site`)
- **Web Root**: The `web/` subdirectory within the site root that serves static files
- **Bin Directory**: The `bin/` subdirectory within the site root containing compiled executables

### Directory Structure
```
site-root/              # <-- This is what we specify
├── src/                # Swift source files
├── web/                # Web root (served content)
│   ├── *.webbin       # Route markers
│   └── styles/        # Static assets
├── bin/                # Compiled executables
└── Makefile           # Build configuration
```

### Example Usage
```bash
# Basic usage - specify the site root
./swiftlets-server sites/examples/swiftlets-site --port 3000

# Current directory as site root
./swiftlets-server . --port 8080

# All options
./swiftlets-server /path/to/mysite --host 0.0.0.0 --port 8080 --debug

# Short options
./swiftlets-server sites/mysite -p 3000 -h localhost
```

## Implementation Plan

### Phase 1: Add ArgumentParser Support

#### 1.1 Update Package.swift
```swift
// Add to SwiftletsServer target dependencies
.product(name: "ArgumentParser", package: "swift-argument-parser")
```

#### 1.2 Create Command Structure
```swift
import ArgumentParser

@main
struct SwiftletsServer: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "swiftlets-server",
        abstract: "Swiftlets web server with file-based routing",
        version: "1.0.0"
    )
    
    @Argument(help: "Site root directory containing web/ and bin/ subdirectories")
    var siteRoot: String?
    
    @Option(name: [.short, .customLong("port")], help: "Port to listen on")
    var port: Int?
    
    @Option(name: [.short, .customLong("host")], help: "Host address to bind to")
    var host: String?
    
    @Flag(name: .long, help: "Enable debug logging")
    var debug: Bool = false
    
    func run() throws {
        // Determine site root
        let sitePath = siteRoot ?? {
            // Fall back to environment variable
            if let envSite = ProcessInfo.processInfo.environment["SWIFTLETS_SITE"] {
                return envSite
            }
            // Fall back to current directory
            return FileManager.default.currentDirectoryPath
        }()
        
        // Derive web root from site root
        let webRoot = "\(sitePath)/web"
        
        // Validate directory structure
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: webRoot) else {
            throw ValidationError("Web directory not found at: \(webRoot)")
        }
        
        // Start server with configuration
        let config = ServerConfig.resolve(
            siteRoot: sitePath,
            cliHost: host,
            cliPort: port,
            debug: debug
        )
        
        // ... rest of implementation
    }
}
```

### Phase 2: Configuration Precedence

#### 2.1 Priority Order (highest to lowest)
1. Command-line arguments
2. Environment variables
3. Default values

Note: For site root specifically:
- CLI positional argument (highest priority)
- Current directory (default)

#### 2.2 Configuration Resolution
```swift
extension ServerConfig {
    static func resolve(
        siteRoot: String,
        cliHost: String?,
        cliPort: Int?,
        debug: Bool
    ) -> ServerConfig {
        // Site root is already resolved in main command
        
        // Host: CLI argument > environment variable > default
        let host = cliHost 
            ?? ProcessInfo.processInfo.environment["SWIFTLETS_HOST"] 
            ?? "127.0.0.1"
            
        // Port: CLI argument > environment variable > default
        let port = cliPort 
            ?? Int(ProcessInfo.processInfo.environment["SWIFTLETS_PORT"] ?? "") 
            ?? 8080
        
        return ServerConfig(
            siteRoot: siteRoot,
            host: host,
            port: port,
            debug: debug
        )
    }
}

// Updated ServerConfig struct
struct ServerConfig {
    let siteRoot: String   // Parent directory containing web/ and bin/
    let host: String
    let port: Int
    let debug: Bool
    
    // Computed property for web root
    var webRoot: String {
        "\(siteRoot)/web"
    }
    
    // Could add other computed properties in the future
    var binRoot: String {
        "\(siteRoot)/bin"
    }
}
```

### Phase 3: Update Server Logic

#### 3.1 Executable Path Resolution
With access to the site root, the server can properly resolve executable paths:

```swift
private func readWebbinFile(_ webbinPath: String) -> String? {
    // ... existing MD5 reading logic ...
    
    // Derive executable path from site root
    let webbinURL = URL(fileURLWithPath: webbinPath)
    let filename = webbinURL.lastPathComponent.replacingOccurrences(of: ".webbin", with: "")
    
    // Get relative path from web root
    let relativePath = webbinURL.path
        .replacingOccurrences(of: config.webRoot + "/", with: "")
        .replacingOccurrences(of: ".webbin", with: "")
    
    // Build executable path: siteRoot/bin/relativePath
    let executablePath = "\(config.siteRoot)/bin/\(relativePath)"
    
    return executablePath
}
```

#### 3.2 Benefits of Site Root Access
- Direct access to `bin/` directory without path manipulation
- Future support for site-level configuration files
- Ability to validate site structure on startup
- Support for site-specific resources or templates

### Phase 4: Backward Compatibility

#### 4.1 Environment Variable Support
- Continue supporting all existing environment variables
- No breaking changes for current users
- Wrapper scripts continue to work unchanged

#### 4.2 Migration Messages
```swift
// When using environment variables, suggest CLI usage
if ProcessInfo.processInfo.environment["SWIFTLETS_PORT"] != nil && port == nil {
    log(.info, "Tip: You can also use --port flag instead of SWIFTLETS_PORT")
}
```

### Phase 5: Update Integration Points

#### 5.1 CLI Wrapper Updates
```swift
// SwiftletsCLI serve command can choose approach:

// Option A: Continue using environment variables for port/host
environment["SWIFTLETS_PORT"] = String(port)

// Option B: Switch to CLI arguments
process.arguments = [sitePath, "--port", String(port), "--host", host]
```

#### 5.2 Script Updates
- Update `smake` to support both methods
- Add examples to documentation
- Update Docker/deployment scripts

## Testing Strategy

### 1. Unit Tests
- Test configuration precedence
- Test argument parsing
- Test environment variable fallback

### 2. Integration Tests
```bash
# Test with site root as positional argument
./swiftlets-server sites/examples/swiftlets-site --port 9000

# Test with current directory
./swiftlets-server . --port 9001

# Test environment variables still work for port/host
SWIFTLETS_PORT=9001 ./swiftlets-server sites/mysite

# Test precedence (CLI should win)
SWIFTLETS_PORT=9001 ./swiftlets-server sites/mysite --port 9002

# Test help
./swiftlets-server --help

# Test without arguments (should use current directory)
cd sites/mysite && ../../swiftlets-server
```

### 3. Backward Compatibility Tests
- Ensure all existing scripts continue to work
- Test with Docker configurations
- Verify systemd service files

## Documentation Updates

### 1. README.md
- Add new CLI usage examples
- Keep environment variable examples for compatibility

### 2. CLI Reference
- Document all command-line options
- Show precedence rules
- Provide migration guide

### 3. Deployment Guides
- Update production deployment docs
- Show both configuration methods
- Recommend CLI args for new deployments

## Timeline

### Week 1
- [ ] Add ArgumentParser dependency
- [ ] Implement basic CLI structure
- [ ] Maintain environment variable support

### Week 2
- [ ] Add configuration precedence logic
- [ ] Update logging for debug flag
- [ ] Write unit tests

### Week 3
- [ ] Update documentation
- [ ] Update wrapper scripts (optional)
- [ ] Test backward compatibility

### Week 4
- [ ] Final testing
- [ ] Release notes
- [ ] Announce changes

## Benefits

1. **Better UX**: Standard `--help` flag for discovering options
2. **Simpler Scripts**: Direct command-line usage without environment setup
3. **Industry Standard**: Aligns with common server patterns (e.g., `python -m http.server`)
4. **Flexibility**: Support both CLI args and env vars
5. **Debugging**: Easy to see configuration in process list
6. **Clear Semantics**: Site root as positional argument makes the architecture explicit
7. **Integrated Access**: Server knows about both `web/` and `bin/` directories
8. **Future-Proof**: Easy to add more site-level features (e.g., site-specific config files)

## Risks and Mitigation

### Risk 1: Breaking Existing Deployments
**Mitigation**: Full backward compatibility with environment variables

### Risk 2: Confusion with Two Methods
**Mitigation**: Clear documentation and precedence rules

### Risk 3: Increased Complexity
**Mitigation**: Clean implementation with ArgumentParser

## Future Enhancements

1. **Configuration File Support**: `--config server.yaml`
2. **Watch Mode**: `--watch` for development auto-reload
3. **Logging Levels**: `--log-level debug|info|warn|error`
4. **TLS Support**: `--tls-cert` and `--tls-key` options
5. **Request Logging**: `--access-log path/to/log`

## Conclusion

This enhancement will modernize the Swiftlets server interface while maintaining full backward compatibility. Users can continue using environment variables or adopt the new command-line interface at their convenience.