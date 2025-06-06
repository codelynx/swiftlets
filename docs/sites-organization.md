# Sites Organization

## Overview

Sites in Swiftlets are organized into two main categories under the `sites/` directory:

1. **examples/** - User-facing example sites and documentation
2. **tests/** - Internal test sites for framework development

## Site Structure

Each site follows a standard layout:

```
site-name/
├── Makefile           # Build configuration
├── README.md         # Site documentation
├── src/              # Swift source files
│   ├── index.swift   # Home page
│   ├── about.swift   # About page
│   └── docs/         # Nested routes
│       └── *.swift
└── web/              # Web root directory
    ├── bin/          # Compiled executables
    ├── *.webbin      # Route markers
    └── styles/       # Static assets
```

## How It Works

1. Each `.swift` file in `src/` becomes a route
2. Files are compiled to executables in `web/bin/`
3. `.webbin` files mark dynamic routes and contain MD5 hashes
4. The server executes the appropriate binary for each request

## Building Sites

```bash
# From site directory
make build

# Build and serve
make serve
```

For more details, see the main [Project Structure](PROJECT-STRUCTURE.md) documentation.