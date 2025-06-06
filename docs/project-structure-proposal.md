# Swiftlets Project Structure Proposal

## Overview

We need to consider two different perspectives when organizing the project:
1. **Core Developer** - Working on Swiftlets framework itself
2. **3rd Party Developer** - Using Swiftlets to build websites

## Proposed Structure

### Unified Repository Structure

```
swiftlets/
├── core/                        # Framework core (current root level stuff)
│   ├── Sources/                 # Framework source code
│   │   ├── SwiftletsCore/       # Core request/response types
│   │   ├── SwiftletsHTML/       # HTML DSL
│   │   └── SwiftletsServer/     # Web server implementation
│   ├── Tests/                   # Framework tests
│   │   └── SwiftletsHTMLTests/
│   ├── Package.swift            # Framework package definition
│   └── README.md                # Core framework docs
├── sdk/                         # SDK for 3rd party developers
│   ├── examples/                # Ready-to-use examples
│   │   ├── html-showcase/       # HTML elements showcase
│   │   │   ├── Makefile         # Build configuration
│   │   │   ├── src/             # Source files (outside web root!)
│   │   │   │   ├── index.swift
│   │   │   │   ├── components.swift
│   │   │   │   └── forms.swift
│   │   │   ├── bin/             # Compiled executables (outside web root!)
│   │   │   │   ├── index
│   │   │   │   └── components
│   │   │   └── web/             # Web root (only this is served)
│   │   │       ├── assets/
│   │   │       │   ├── style.css
│   │   │       │   └── script.js
│   │   │       ├── index.webbin
│   │   │       └── components.webbin
│   │   ├── personal-site/       # Personal website template
│   │   └── business-site/       # Business website template
│   ├── templates/               # Project templates
│   │   ├── blank/               # Minimal template
│   │   │   ├── Package.swift
│   │   │   ├── Makefile
│   │   │   ├── src/             # Source files
│   │   │   ├── bin/             # Compiled executables
│   │   │   ├── web/             # Web root (only this is served)
│   │   │   └── .gitignore
│   │   └── full/                # Full-featured template
│   ├── tools/                   # CLI tools
│   │   └── swiftlets-init       # Project initialization script
│   └── README.md                # SDK/Getting started guide
├── docs/                        # All documentation
│   ├── core/                    # Framework documentation
│   │   ├── architecture.md
│   │   ├── contributing.md
│   │   └── api-reference.md
│   ├── guides/                  # User guides
│   │   ├── getting-started.md
│   │   ├── routing.md
│   │   └── deployment.md
│   └── README.md                # Documentation index
├── examples/                    # Core developer examples/testing
│   ├── basic-site/              # Current web/ directory
│   │   ├── Makefile
│   │   ├── src/                 # Source files
│   │   ├── bin/                 # Compiled executables
│   │   └── web/                 # Web root (only this is served)
│   │       ├── index.webbin
│   │       ├── hello.webbin
│   │       └── style.css
│   └── test-site/               # For testing new features
├── LICENSE
└── README.md                    # Project overview
```

### Benefits of This Structure

1. **Single Repository** - Everything in one place for now
2. **Clear Separation** - `core/` vs `sdk/` makes roles obvious
3. **Future Flexibility** - `sdk/` can become a submodule later
4. **Shared Documentation** - All docs in one place but organized
5. **No Confusion** - Clear what's framework vs what's for users

### End User's Project Structure

When a 3rd party developer creates their own site:

```
my-awesome-site/
├── Package.swift                # Dependencies (includes Swiftlets)
├── Makefile                     # Build configuration
├── src/                         # Swiftlet sources (NOT in web root!)
│   ├── index.swift
│   ├── about.swift
│   └── api/
│       └── posts.swift
├── bin/                         # Compiled swiftlets (NOT in web root!)
│   ├── index
│   ├── about
│   └── api-posts
├── web/                         # Web root (ONLY this is served)
│   ├── assets/                  # Static assets
│   │   ├── css/
│   │   ├── js/
│   │   └── images/
│   ├── index.webbin
│   ├── about.webbin
│   └── api/
│       └── posts.json.webbin
├── .gitignore
└── README.md
```

## Security Considerations

### Critical: Keep Build Artifacts Outside Web Root
- **`Makefile`, `src/`, and `bin/` MUST be outside the web root**
- Only files inside `web/` directory should be accessible via HTTP
- This prevents:
  - Exposing source code via `/src/index.swift`
  - Leaking build configuration via `/Makefile`
  - Direct access to executables via `/bin/index`

### Proper Structure
```
project/
├── Makefile    # Safe from web access
├── src/        # Safe from web access
├── bin/        # Safe from web access
└── web/        # ONLY this directory is served
    ├── *.webbin files
    └── static assets
```

## Key Decisions to Discuss

### 1. Directory Naming
- `web/` vs `public/` vs `www/` for the web root?
- `src/` vs `sources/` vs `swiftlets/` for source files?
- `bin/` vs `build/` vs `.build/` for compiled files?

### 2. Static Assets
- Separate `public/` or `assets/` directory for static files?
- Or mix static files with .webbin files (current approach)?

### 3. Source Organization
- Flat structure in `src/`?
- Or mirror the URL structure in `src/`?
  ```
  src/
  ├── index.swift
  └── api/
      └── posts.swift     # for /api/posts route
  ```

### 4. SDK Distribution
- Separate repository for SDK?
- Or subdirectory in main repo?
- Package manager distribution (brew, npm for tooling)?

### 5. Development Workflow
- How to handle hot reloading?
- Development vs production builds?
- Environment configuration?

## Migration Path

From current structure to proposed:
1. Create `core/` directory
2. Move `Sources/`, `Tests/`, `Package.swift` → `core/`
3. Move `sites/` → `sdk/examples/`
4. Move current `web/` → `examples/basic-site/web/`
5. Move root `src/` → `examples/basic-site/web/src/`
6. Move root `bin/` → `examples/basic-site/web/bin/`
7. Create `sdk/templates/` with starter templates
8. Reorganize `docs/` with core/ and guides/ subdirectories

## Benefits

### Single Repository Approach
- Easier to maintain and version together
- No dependency management between core and SDK
- Can always split later into submodules
- Simpler for contributors

### For Core Developers
- Clear separation of framework vs examples
- Easy to test changes across multiple example sites
- Documentation lives with code
- Can work on SDK examples while developing core

### For 3rd Party Developers
- Clean project structure
- No framework internals in their project
- Easy to get started with templates
- Clear upgrade path
- Everything they need in `sdk/` directory

## Questions for Discussion

1. Should we enforce the `web/` directory or make it configurable?
2. Should compiled binaries go inside `web/bin/` or outside at project root?
3. How should we handle shared components between swiftlets?
4. Should we support multiple sites in one project?
5. What's the best way to handle dependencies (Swift packages, git submodules, etc.)?

## Next Steps

1. Agree on structure
2. Create migration script
3. Update Makefile paths
4. Create project template
5. Write "Getting Started" guide for 3rd party developers