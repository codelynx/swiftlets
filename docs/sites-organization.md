# Sites Organization

## Overview

Swiftlets needs a clear organization for different types of sites:
- **Core Examples**: Official examples demonstrating framework features
- **Test Sites**: For framework testing and CI/CD
- **Developer Sites**: For local development and experimentation
- **Third-Party Templates**: Community-contributed site templates

## Directory Structure

```
swiftlets/
├── sites/                      # All sites live here
│   ├── core/                   # Core framework examples
│   │   ├── hello/              # Minimal example
│   │   ├── showcase/           # Feature showcase
│   │   ├── blog/               # Blog engine example
│   │   ├── api/                # REST API example
│   │   └── realtime/           # WebSocket example
│   │
│   ├── test/                   # Test sites (not in production)
│   │   ├── unit/               # Unit test sites
│   │   ├── integration/        # Integration test sites
│   │   ├── performance/        # Performance benchmarks
│   │   └── error-handling/     # Error cases
│   │
│   └── templates/              # Third-party site templates
│       ├── portfolio/          # Portfolio template
│       ├── ecommerce/          # E-commerce template
│       └── dashboard/          # Admin dashboard template
│
├── src/                        # Swiftlet source code (current structure)
│   └── [swiftlet sources]
│
└── bin/                        # Compiled swiftlets
    └── [platform/arch/...]
```

## Site Types

### 1. Core Examples (`sites/core/`)

Official examples maintained by the Swiftlets team:

#### hello
- Minimal "Hello World" example
- No dependencies
- Demonstrates basic request/response

#### showcase
- Demonstrates all HTML elements
- Shows result builders in action
- Interactive examples

#### blog
- Full blog engine
- Markdown support
- Categories and tags
- RSS feed generation

#### api
- RESTful API example
- JSON responses
- CRUD operations
- Authentication example

#### realtime
- WebSocket support
- Live updates
- Chat example
- Server-sent events

### 2. Test Sites (`sites/test/`)

For automated testing - not meant for production:

#### unit
- Individual component tests
- Element rendering tests
- Builder tests

#### integration
- Multi-swiftlet communication
- Session management
- Database integration

#### performance
- Load testing scenarios
- Memory usage tests
- Startup time benchmarks

#### error-handling
- 404/500 error pages
- Malformed request handling
- Security testing

### 3. Third-Party Templates (`sites/templates/`)

Community-contributed, production-ready templates:
- Each template includes documentation
- Licensed separately
- Can be installed via CLI

## Site Configuration

Each site has a `site.yaml` configuration:

```yaml
# sites/core/hello/site.yaml
name: hello
version: 1.0.0
description: Minimal Hello World example
author: Swiftlets Team
type: example

swiftlets:
  - path: /
    source: index.swift
  - path: /about
    source: about.swift

dependencies:
  - SwiftletsCore

build:
  platforms: [macos, linux]
  architectures: [x86_64, arm64]
```

## Development Workflow

### Core Developer Workflow

```bash
# Work on a core example
cd sites/core/blog
swiftlets dev

# Run all tests
cd sites/test
swiftlets test --all

# Build all core examples
cd sites/core
swiftlets build --all
```

### Third-Party Developer Workflow

```bash
# Create new template
swiftlets new template portfolio
cd sites/templates/portfolio

# Test locally
swiftlets dev

# Package for distribution
swiftlets package

# Submit to registry
swiftlets publish
```

## Site Registry

For third-party templates, maintain a registry:

```yaml
# registry.yaml
templates:
  - name: portfolio
    author: john_doe
    version: 2.1.0
    description: Modern portfolio site
    url: https://github.com/johndoe/swiftlets-portfolio
    stars: 245
    
  - name: ecommerce
    author: jane_smith
    version: 1.5.0
    description: E-commerce starter
    url: https://github.com/janesmith/swiftlets-shop
    stars: 189
```

## CLI Commands

### Site Management

```bash
# List available sites
swiftlets sites list

# Create new site from template
swiftlets sites new mysite --template portfolio

# Run a specific site
swiftlets dev --site sites/core/blog

# Build site for production
swiftlets build --site sites/core/api
```

### Template Commands

```bash
# Search templates
swiftlets templates search blog

# Install template
swiftlets templates install portfolio

# Create site from template
swiftlets new mysite --from portfolio
```

## Benefits

1. **Clear Separation**: Core vs third-party vs test sites
2. **Easy Discovery**: Users can browse examples
3. **Testing**: Dedicated test sites for CI/CD
4. **Templates**: Ready-to-use starting points
5. **Consistency**: Standard structure across all sites

## Migration from Current Structure

Current POC structure:
```
src/hello/index.swift → sites/core/hello/src/index.swift
```

This organization supports both core development needs and third-party ecosystem growth.