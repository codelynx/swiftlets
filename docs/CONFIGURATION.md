# Swiftlets Server Configuration

The Swiftlets server uses command-line arguments for configuration, with environment variables as a fallback for backward compatibility.

## Command-Line Interface

### Basic Usage
```bash
swiftlets-server <site-root> [options]
```

### Arguments
- `<site-root>` - Site root directory containing `web/` and `bin/` subdirectories (optional, defaults to current directory)

### Options
- `-p, --port <port>` - Port to listen on (default: 8080)
- `-h, --host <host>` - Host address to bind to (default: 127.0.0.1)
- `--debug` - Enable debug logging
- `--help` - Show help information

## Usage Examples

### Using the Scripts (Recommended)
```bash
# Build and run a site
./build-site sites/examples/swiftlets-site
./run-site sites/examples/swiftlets-site

# Run on a different port
./run-site sites/examples/swiftlets-site --port 3000

# Listen on all interfaces
./run-site sites/examples/swiftlets-site --host 0.0.0.0 --port 8080

# Enable debug logging
./run-site sites/examples/swiftlets-site --debug
```

### Direct Server Usage
```bash
# Run the server directly
./bin/darwin/arm64/swiftlets-server sites/examples/swiftlets-site

# With options
./bin/darwin/arm64/swiftlets-server sites/examples/swiftlets-site --port 3000 --debug
```

### Running from Current Directory
```bash
# If you're in the site directory
cd sites/examples/swiftlets-site
../../../swiftlets-server

# Or explicitly specify current directory
./swiftlets-server .
```

### Running Multiple Sites
```bash
# Site 1 on port 8080
./swiftlets-server sites/blog --port 8080 &

# Site 2 on port 8081
./swiftlets-server sites/shop --port 8081 &
```

## Environment Variables (Legacy)

For backward compatibility, the server still supports these environment variables:

### SWIFTLETS_HOST
Sets the host to bind to (overridden by --host).

```bash
SWIFTLETS_HOST=0.0.0.0 ./swiftlets-server sites/mysite
```

### SWIFTLETS_PORT
Sets the port to listen on (overridden by --port).

```bash
SWIFTLETS_PORT=3000 ./swiftlets-server sites/mysite
```

## Configuration Priority

1. Command-line arguments (highest priority)
2. Environment variables
3. Default values

Example:
```bash
# CLI argument wins (uses port 9000, not 8000)
SWIFTLETS_PORT=8000 ./swiftlets-server sites/mysite --port 9000
```

## Server Output

The server logs its configuration on startup:

```
2025-06-06T10:30:00Z [INFO] Server Configuration:
2025-06-06T10:30:00Z [INFO]   Site Root: sites/examples/swiftlets-site
2025-06-06T10:30:00Z [INFO]   Web Root: sites/examples/swiftlets-site/web
2025-06-06T10:30:00Z [INFO]   Host: 127.0.0.1
2025-06-06T10:30:00Z [INFO]   Port: 8080
2025-06-06T10:30:00Z [INFO]   Platform: macos/arm64
```

## Site Structure

The server expects the following directory structure:

```
site-root/                 # <-- This is what you specify
├── src/                   # Swift source files
├── web/                   # Web root (served content)
│   ├── *.webbin          # Route markers
│   ├── styles/           # CSS files
│   └── images/           # Static assets
└── bin/                   # Compiled executables
```

## Using the Build Scripts

The project now uses dedicated scripts instead of Makefiles:

```bash
# Build and run a site
./build-site sites/examples/swiftlets-site
./run-site sites/examples/swiftlets-site

# Or combine build and run
./run-site sites/examples/swiftlets-site --build
```

## Using with swiftlets CLI

The swiftlets CLI automatically uses the new server interface:

```bash
# Serve current directory
swiftlets serve

# Serve specific site
swiftlets serve sites/examples/swiftlets-site

# With options
swiftlets serve sites/examples/swiftlets-site --port 3000 --host 0.0.0.0

# With debug logging
swiftlets serve sites/examples/swiftlets-site --debug
```

## Platform-Specific Notes

### macOS
The server automatically detects the architecture (Intel x86_64 or Apple Silicon arm64).

### Ubuntu/Linux
On Ubuntu ARM64, the platform will show as `linux/arm64`:

```bash
# On Ubuntu ARM64
cd ~/Projects/swiftlets
./bin/linux/arm64/swiftlets-server sites/examples/swiftlets-site
```

## Troubleshooting

### Web directory not found
If you see "Web root directory not found", ensure your site has a `web/` subdirectory:

```bash
mkdir -p sites/mysite/web
```

### Port already in use
If the port is already in use, try a different port:

```bash
./swiftlets-server sites/mysite --port 3001
```

### Debug mode
Enable debug logging to see detailed request handling:

```bash
./swiftlets-server sites/mysite --debug
```