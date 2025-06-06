# SDK Example Sites

This directory contains example sites for SDK users to learn from.

## Available Examples

- **hello** - Minimal "Hello World" example
- **showcase** - HTML elements showcase
- **basic-site** - Basic website with multiple pages
- **swiftlets-site** - The Swiftlets project documentation website

## Usage

Each example includes:
- Source code in `src/`
- Webbin routing files in `web/`
- Build instructions in `README.md`
- Makefile or build scripts

## Running Examples

```bash
cd [example-name]
make build
make run
```

Or with the Swiftlets CLI:
```bash
swiftlets serve --site sdk/sites/[example-name]
```