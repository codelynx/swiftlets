# Structure Migration Changes Summary

## Overview
Reorganized project structure to separate core framework testing from user-facing examples.

## Major Changes

### 1. New Directory Structure
- Created `core/sites/` for internal framework testing
- Created `sdk/sites/` for user-facing examples
- Removed redundant directories (will clean up `sites/`, `examples/` after verification)

### 2. Core Test Sites Created
```
core/sites/
├── test-routing/     # Tests routing functionality
├── test-html/        # Tests HTML DSL features
└── benchmark/        # Performance benchmarking
```

### 3. SDK Example Sites
```
sdk/sites/
└── swiftlets-site/   # Project documentation website
```

### 4. Build Scripts
- **Added**: `build-test-sites.sh` - Builds core test sites
- **Kept**: Core scripts (build.sh, run-server.sh, install-cli.sh, etc.)
- **Removed**: 9 obsolete/debug scripts

### 5. File Changes

#### Created Files:
- `/core/sites/README.md`
- `/core/sites/test-routing/README.md`
- `/core/sites/test-routing/src/index.swift`
- `/core/sites/test-routing/src/index-standalone.swift`
- `/core/sites/test-html/README.md`
- `/core/sites/test-html/src/index.swift`
- `/core/sites/test-html/src/index-standalone.swift`
- `/core/sites/benchmark/README.md`
- `/core/sites/benchmark/src/index.swift`
- `/sdk/sites/README.md`
- `/sdk/sites/swiftlets-site/` (full site structure)
- `/docs/project-structure-v2.md`
- `/docs/structure-migration-guide.md`
- `/docs/scripts-cleanup-guide.md`
- `/build-test-sites.sh`

#### Modified Files:
- `/README.md` - Updated project structure section

#### Deleted Scripts:
- migrate-structure.sh
- build-showcase.sh
- build-all-sites.sh
- build-sites-debug.sh
- build-all-sites-v2.sh
- build-all-sites-final.sh
- build-core-sites.sh
- test-server.sh
- debug-test-html.sh

## Benefits
1. Clear separation between internal tests and user examples
2. Cleaner project root
3. Better organization for both core developers and SDK users
4. Removed confusing/broken build scripts