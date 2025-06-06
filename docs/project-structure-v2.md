# Swiftlets Project Structure v2

## Overview

Swiftlets uses a clear separation between core framework development and SDK/user-facing components. This structure supports both internal development needs and external developer experience.

## Top-Level Structure

```
swiftlets/
├── core/                    # Core framework
├── sdk/                     # SDK, tools, and examples for users
├── cli/                     # Command-line interface tool
├── docs/                    # Technical documentation
└── external/                # External dependencies (e.g., Ignite reference)
```

## Detailed Structure

### Core Directory

The `core/` directory contains the framework implementation and internal testing sites.

```
core/
├── Package.swift           # Core framework package definition
├── Sources/
│   ├── SwiftletsCore/     # Core functionality
│   │   ├── Request.swift
│   │   ├── Response.swift
│   │   └── Swiftlet.swift
│   ├── SwiftletsHTML/     # HTML DSL
│   │   ├── Builders/
│   │   ├── Core/
│   │   ├── Elements/
│   │   ├── Helpers/
│   │   ├── Layout/
│   │   └── Modifiers/
│   └── SwiftletsServer/   # Development server
├── Tests/                 # Unit tests
└── sites/                 # Internal test sites
    ├── test-routing/      # Routing system tests
    ├── test-html/         # HTML DSL tests
    ├── test-forms/        # Form handling tests
    ├── benchmark/         # Performance benchmarks
    └── integration/       # Integration test scenarios
```

**Purpose of `core/sites/`:**
- Internal testing during framework development
- Not meant as user examples
- Can contain experimental or broken code
- Used for CI/CD testing
- Performance benchmarking

### SDK Directory

The `sdk/` directory contains everything third-party developers need.

```
sdk/
├── README.md              # SDK documentation
├── tools/                 # Developer tools
│   ├── swiftlets-init    # Project initializer
│   ├── swiftlets-build   # Build helper
│   └── swiftlets-deploy  # Deployment tool
├── templates/             # Project templates
│   ├── blank/            # Minimal template
│   ├── website/          # Basic website template
│   └── api/              # API service template
└── sites/                 # Example sites for users
    ├── hello/             # Minimal "Hello World"
    ├── showcase/          # HTML elements showcase
    ├── blog/              # Full blog example
    ├── api-demo/          # REST API example
    ├── realtime-chat/     # WebSocket example
    └── swiftlets-site/    # Project documentation website
```

**Purpose of `sdk/sites/`:**
- Clean, well-documented examples
- Best practices demonstrations
- Learning resources for developers
- Copy-paste starting points
- Showcase of framework capabilities

### Site Structure

Each site (in both `core/sites/` and `sdk/sites/`) follows this structure:

```
site-name/
├── Package.swift          # Swift package (if needed)
├── Makefile              # Build automation
├── README.md             # Site documentation
├── src/                  # Swift source files
│   ├── index.swift       # Homepage
│   ├── about.swift       # About page
│   └── api/              # Nested routes
│       └── users.swift
├── web/                  # Web root directory
│   ├── *.webbin         # Routing files
│   ├── bin/             # Compiled executables
│   │   └── {os}/{arch}/ # Platform-specific binaries
│   └── static/          # Static assets
│       ├── css/
│       ├── js/
│       └── images/
└── tests/               # Site-specific tests (optional)
```

## Benefits of This Structure

1. **Clear Separation of Concerns**
   - Core developers work in `core/`
   - SDK users work with `sdk/`
   - No confusion about which examples to follow

2. **Different Quality Standards**
   - `core/sites/` can be experimental
   - `sdk/sites/` must be polished and documented

3. **Focused Development**
   - Core team can test features without worrying about user experience
   - SDK examples can focus on being educational

4. **Scalability**
   - Easy to add more test sites for core development
   - SDK examples can grow based on user needs

## Migration Plan

Current structure to new structure:

```bash
# Move current sites
sites/core/hello → sdk/sites/hello
sites/core/showcase → sdk/sites/showcase
sites/core/swiftlets-site → sdk/sites/swiftlets-site

# Create core test sites
→ core/sites/test-routing
→ core/sites/test-html
→ core/sites/benchmark

# Move SDK components
examples/ → sdk/sites/
sdk/templates/ → sdk/templates/
sdk/tools/ → sdk/tools/
```

## Usage Examples

### Core Developer Workflow

```bash
# Working on routing feature
cd core/sites/test-routing
# Make changes to test new routing logic
make test

# Benchmarking performance
cd core/sites/benchmark
make bench
```

### SDK User Workflow

```bash
# Learning from examples
cd sdk/sites/showcase
make build
make run

# Starting new project
cd my-project
cp -r swiftlets/sdk/sites/hello/* .
# Customize from there
```

## Future Considerations

As the number of examples grows, we might introduce categories:

```
sdk/sites/
├── basic/           # Simple examples
├── applications/    # Full applications  
├── integrations/    # Third-party integrations
└── advanced/        # Advanced patterns
```

But starting with a flat structure is recommended until we have 10+ examples.