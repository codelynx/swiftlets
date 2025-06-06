# Swiftlets Templates

This directory contains third-party site templates that can be used as starting points for new projects.

## Available Templates

Templates are managed through the Swiftlets registry. To browse available templates:

```bash
swiftlets templates list
```

## Installing Templates

```bash
# Install a template
swiftlets templates install portfolio

# Create new site from template
swiftlets new my-portfolio --from portfolio
```

## Creating Templates

To create a template for distribution:

1. Create your site in this directory
2. Add a `template.yaml` with metadata
3. Include comprehensive documentation
4. Test on all supported platforms
5. Submit to the registry

### Template Structure

```
templates/your-template/
├── template.yaml       # Template metadata
├── site.yaml          # Site configuration
├── src/               # Swiftlet sources
├── static/            # Static assets (if any)
├── README.md          # Documentation
└── LICENSE            # License file
```

### template.yaml Example

```yaml
name: portfolio
version: 1.0.0
description: Modern portfolio website template
author: Your Name
license: MIT
repository: https://github.com/yourusername/swiftlets-portfolio

features:
  - Responsive design
  - Dark mode support
  - Project showcase
  - Contact form

requirements:
  swiftlets: ">=1.0.0"
  
tags: [portfolio, personal, showcase]
```

## Guidelines

1. **Documentation**: Include clear setup instructions
2. **Examples**: Provide example content/data
3. **Customization**: Make it easy to customize
4. **Performance**: Optimize for production use
5. **Licensing**: Choose an appropriate license

## Popular Templates

Check the [Swiftlets Registry](https://swiftlets.dev/templates) for popular templates and ratings.