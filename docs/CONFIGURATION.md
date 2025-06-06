# Swiftlets Server Configuration

The Swiftlets server now supports environment variables for flexible configuration.

## Environment Variables

### SWIFTLETS_SITE
Sets the site directory. The server will look for a `web/` subdirectory within this path.

```bash
# Run with the swiftlets-site
SWIFTLETS_SITE=sdk/sites/swiftlets-site ./swiftlets-server

# Or use the run script
./run-server.sh
```

### SWIFTLETS_WEB_ROOT
Directly sets the web root directory (overrides SWIFTLETS_SITE).

```bash
# Point directly to a web directory
SWIFTLETS_WEB_ROOT=/path/to/my/web ./swiftlets-server
```

### SWIFTLETS_HOST
Sets the host to bind to (default: 127.0.0.1).

```bash
# Listen on all interfaces
SWIFTLETS_HOST=0.0.0.0 ./swiftlets-server
```

### SWIFTLETS_PORT
Sets the port to listen on (default: 8080).

```bash
# Use a different port
SWIFTLETS_PORT=3000 ./swiftlets-server
```

## Usage Examples

### Running from Project Root
```bash
# Using make (automatically sets SWIFTLETS_SITE)
make server

# Using run script (auto-detects sdk/sites/swiftlets-site)
./run-server.sh

# Specify a different site
SWIFTLETS_SITE=sites/my-site ./run-server.sh
```

### Running from Any Directory
```bash
# Set absolute paths
SWIFTLETS_WEB_ROOT=/home/user/myproject/web /path/to/swiftlets-server

# Or use SWIFTLETS_SITE
SWIFTLETS_SITE=/home/user/myproject /path/to/swiftlets-server
```

### Running Multiple Sites
```bash
# Site 1 on port 8080
SWIFTLETS_SITE=sites/blog SWIFTLETS_PORT=8080 ./swiftlets-server &

# Site 2 on port 8081
SWIFTLETS_SITE=sites/shop SWIFTLETS_PORT=8081 ./swiftlets-server &
```

## Configuration Priority

1. `SWIFTLETS_WEB_ROOT` (highest priority)
2. `SWIFTLETS_SITE` + `/web`
3. Default: `web` (relative to current directory)

## Server Output

The server now logs its configuration on startup:

```
2025-06-06T10:30:00Z [INFO] Server Configuration:
2025-06-06T10:30:00Z [INFO]   Web Root: sdk/sites/swiftlets-site/web
2025-06-06T10:30:00Z [INFO]   Host: 127.0.0.1
2025-06-06T10:30:00Z [INFO]   Port: 8080
2025-06-06T10:30:00Z [INFO]   Platform: macos/arm64
```

## Ubuntu/Linux Notes

On Ubuntu ARM64, the platform will show as `linux/arm64` and the server will use the Linux-specific binary paths.

```bash
# On Ubuntu ARM64
cd ~/Projects/swiftlets
SWIFTLETS_SITE=sites/examples/swiftlets-site ./bin/linux/arm64/swiftlets-server
```