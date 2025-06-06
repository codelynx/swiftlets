# Basic Site Example

This is the basic example site demonstrating the webbin routing system with proper security structure.

## Structure

```
basic-site/
├── Makefile     # Build configuration (outside web root for security)
├── src/         # Swift source files (outside web root for security)
│   ├── index.swift
│   ├── hello.swift
│   └── api-users.swift
├── bin/         # Compiled executables (outside web root for security)
│   ├── index
│   ├── hello
│   └── api-users
└── web/         # Web root (ONLY this directory is served)
    ├── index.webbin      # Routes to bin/index
    ├── hello.webbin      # Routes to bin/hello
    ├── style.css         # Static CSS file
    └── api/
        └── users.json.webbin  # Routes to bin/api-users
```

## Security Features

- **Makefile** is outside `web/` - cannot be accessed via URL
- **Source files** in `src/` - cannot be accessed via URL
- **Executables** in `bin/` - cannot be accessed via URL
- Only files in `web/` are served by the HTTP server

## Running

```bash
# Build all swiftlets
make all

# Start the server
make serve
```

Then visit:
- http://localhost:8080/ - Homepage
- http://localhost:8080/hello - Hello page
- http://localhost:8080/style.css - Static CSS
- http://localhost:8080/api/users.json - Dynamic JSON API

## Development

1. Edit source files in `src/`
2. Run `make` to rebuild
3. Refresh browser to see changes