# Scripts Cleanup Guide

## Scripts to KEEP ✅

### Core Build Scripts
- **`build.sh`** - Main build script for core framework
- **`run-server.sh`** - Run the development server
- **`install-cli.sh`** - Install the Swiftlets CLI tool

### Ubuntu/Linux Support
- **`check-ubuntu-prerequisites.sh`** - Check Ubuntu dependencies

### Site Building
- **`build-test-sites.sh`** - Builds the core test sites (WORKS!)

## Scripts to DELETE 🗑️

### Migration Scripts (One-time use)
- `migrate-structure.sh` - Already completed the migration

### Obsolete Build Scripts
- `build-showcase.sh` - Old, specific to showcase site
- `build-all-sites.sh` - Has issues with imports
- `build-sites-debug.sh` - Was for debugging only
- `build-all-sites-v2.sh` - Iteration that didn't work well
- `build-all-sites-final.sh` - Another iteration, not needed
- `build-core-sites.sh` - Replaced by build-test-sites.sh

### Debug Scripts
- `test-server.sh` - Was for testing only
- `debug-test-html.sh` - Debug script, not needed

## Recommended Cleanup Commands

```bash
# Remove obsolete scripts
rm migrate-structure.sh
rm build-showcase.sh
rm build-all-sites.sh
rm build-sites-debug.sh
rm build-all-sites-v2.sh
rm build-all-sites-final.sh
rm build-core-sites.sh
rm test-server.sh
rm debug-test-html.sh
```

## After Cleanup

You'll have a clean set of scripts:
- Core building: `build.sh`
- Running: `run-server.sh`
- CLI: `install-cli.sh`
- Sites: `build-test-sites.sh`
- Linux: `check-ubuntu-prerequisites.sh`

## Building Sites

For SDK sites (like swiftlets-site):
```bash
cd sdk/sites/swiftlets-site
./build-simple.sh  # or build-direct.sh
```

For core test sites:
```bash
./build-test-sites.sh
```