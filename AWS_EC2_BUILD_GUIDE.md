# Swiftlets Build Guide for AWS EC2 Ubuntu ARM64

This document outlines the steps to build and run Swiftlets on AWS EC2 Ubuntu ARM64 instances.

## Prerequisites

- AWS EC2 instance running Ubuntu on ARM64 architecture
- Swift 6.0+ installed (confirmed: Swift 6.0.2)
- Git for cloning the repository

## Build Steps

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/swiftlets.git
cd swiftlets
```

### 2. Build the Swiftlets Server
```bash
./build-server
```

This command:
- Builds the server in debug mode
- Detects platform automatically (linux/arm64)
- Compiles SwiftletsServer using SwiftNIO
- Installs server to: `/home/ubuntu/swiftlets/bin/linux/arm64/swiftlets-server`
- Also builds and installs the CLI tool

Expected output:
- Build time: ~30 seconds
- Server binary size: ~36MB
- Installation paths:
  - Server: `bin/linux/arm64/swiftlets-server`
  - CLI: `bin/linux/arm64/swiftlets`

### 3. Build the Showcase Site
```bash
./build-site sites/swiftlets-site
```

Options for complex sites:
```bash
# Increase timeout (avoid parallel builds on EC2)
./build-site sites/swiftlets-site -t 120

# Force rebuild all files
./build-site sites/swiftlets-site --force

# Verbose output for debugging
./build-site sites/swiftlets-site --verbose
```

### 4. Run the Server

For local access only:
```bash
./run-site sites/swiftlets-site
```

For external access (required for EC2):
```bash
./run-site sites/swiftlets-site --host 0.0.0.0 --port 8080
```

### 5. AWS Security Group Configuration

Ensure your EC2 security group allows inbound traffic:
- Type: Custom TCP
- Port: 8080
- Source: Your IP or 0.0.0.0/0 (for public access)

## Known Issues

### Swift Compiler Timeouts
The showcase site contains complex HTML DSL code that causes Swift compiler timeouts. As of July 2025, the following pages build successfully:

**Working Pages** (6 total):
- `index` - Main homepage
- `about` - About page  
- `README-JA` - Japanese documentation
- `docs/index` - Documentation index
- `showcase/basic-elements-simple` - Simplified HTML elements demo
- `showcase/text-formatting-simple` - Simplified text formatting demo

**Failed Pages** (21 total):
- Most showcase examples with complex nested HTML
- Documentation pages with heavy shared component usage
- Any file with deep type inference chains

### Build Performance
- Default timeout increased to 60 seconds (was 30s)
- Complex HTML DSL structures may timeout even at 120s
- DO NOT use parallel builds (-j > 1) on EC2 - causes memory issues

### Build Script Issues
- The build script may appear to hang after processing files
- Manual compilation using swiftc directly works more reliably
- Consider building files individually if bulk build fails

## Troubleshooting

### If builds timeout:
1. Try manual build for specific files:
   ```bash
   swiftc -parse-as-library -module-name Swiftlets \
     Sources/Swiftlets/**/*.swift \
     sites/swiftlets-site/src/your-file.swift \
     -o sites/swiftlets-site/bin/your-file
   ```
2. Create simplified versions without complex shared components
3. Check `AWS_DEPLOYMENT_SUMMARY.md` for patterns that work

### To check build status:
```bash
# Count source files
find sites/swiftlets-site/src -name "*.swift" | wc -l

# Count built executables
find sites/swiftlets-site/bin -type f | wc -l

# List built executables
ls -la sites/swiftlets-site/bin/
```

### To verify server is running:
```bash
ps aux | grep swiftlets-server
```

## Complete Build Script

Here's a complete script to set up Swiftlets on a fresh EC2 instance:

```bash
#!/bin/bash
# Swiftlets AWS EC2 Setup Script

# Navigate to project directory
cd /home/ubuntu/swiftlets

# Build server
echo "Building Swiftlets server..."
./build-server

# Build showcase site with extended timeout
echo "Building showcase site..."
./build-site sites/swiftlets-site -t 60

# Run server on all interfaces
echo "Starting server..."
./run-site sites/swiftlets-site --host 0.0.0.0 --port 8080
```

## Access the Site

Once running, access your site at:
```
http://<your-ec2-public-ip>:8080/
```

Example:
```
http://ec2-<YOUR-EC2-PUBLIC-IP>.compute-1.amazonaws.com:8080/
```

## Platform Details

Tested on:
- Platform: Linux 6.8.0-1029-aws
- Architecture: aarch64 (ARM64)
- Swift: 6.0.2 (swift-6.0.2-RELEASE)
- Target: aarch64-unknown-linux-gnu