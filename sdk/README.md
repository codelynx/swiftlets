# Swiftlets SDK

Welcome to the Swiftlets SDK! This directory contains everything you need to start building websites with Swiftlets.

## Directory Structure

- `examples/` - Complete example websites you can learn from
  - `html-showcase/` - Demonstrates all HTML elements and features
  - `personal-site/` - Personal website template
  - `business-site/` - Business website template
  
- `templates/` - Project templates to start from
  - `blank/` - Minimal starter template
  - `full/` - Full-featured template with examples
  
- `tools/` - Command-line tools and utilities
  - `swiftlets-init` - Project initialization script

## Getting Started

1. **Browse Examples**: Check out the `examples/` directory to see complete working sites
2. **Use a Template**: Copy a template from `templates/` to start your own project
3. **Follow the Guide**: See `docs/guides/getting-started.md` for a step-by-step tutorial

## Quick Start

### From Project Root

```bash
# Create a new project
make init NAME=my-website
# Or use the tool directly
sdk/tools/swiftlets-init my-website

cd my-website
make serve
```

### Manual Template Copy

```bash
# Copy the blank template
cp -r sdk/templates/blank my-website
cd my-website

# Build your swiftlets
make all

# Start the development server
make serve
```

## Learn More

- [Getting Started Guide](../docs/guides/getting-started.md)
- [Routing Documentation](../docs/ROUTING.md)
- [HTML DSL Reference](../docs/html-reference.md)