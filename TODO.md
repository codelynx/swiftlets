# Swiftlets TODO List

## ✅ Recently Completed (June 8, 2025)

### SwiftUI-Style API
- [x] Design zero-boilerplate SwiftUI-style API
- [x] Implement core protocols (HTMLComponent, HTMLHeader, SwiftletMain)
- [x] Create property wrappers (@Query, @FormValue, @JSONBody, @Cookie, @Environment)
- [x] Implement ResponseBuilder for headers/cookies
- [x] Add Task Local Storage for context
- [x] Create comprehensive documentation
- [x] Add migration guide
- [x] Convert entire showcase site to new API
- [x] Fix compilation performance issues with function decomposition
- [x] Create troubleshooting guides

## 🚨 Critical Fixes (Do First)

### Missing UI Components
- [ ] Implement Container component with responsive breakpoints
- [ ] Implement Grid component with CSS Grid support
- [ ] Implement Row and Column components
- [ ] Implement Card component for content grouping
- [ ] Update showcase examples to use proper components

### Build System
- [ ] Fix build-site hanging on complex files
- [ ] Add better error reporting for compilation failures
- [ ] Implement incremental compilation
- [ ] Add build caching

- [ ] Update server to auto-detect SwiftUI-style vs traditional swiftlets

## 🎯 High Priority (This Week)

### Static File Serving (Partially Complete)
- [x] Basic static file serving implemented
- [x] Support common MIME types (css, js, images, fonts) - ✅ Already done
- [ ] Add caching headers (ETag, Last-Modified)
- [ ] Add gzip compression support
- [ ] Add range request support for large files
- [ ] Create `public/` directory as alternative to `web/`
- [ ] Add security headers (X-Content-Type-Options, etc.)
- [ ] Directory listing (optional, with config flag)

### Query Parameters
- [ ] Parse query strings in server
- [ ] Add to Request.queryParameters
- [ ] Add tests for query parsing
- [ ] Update showcase examples

### Error Handling
- [ ] Create proper 404 page
- [ ] Create 500 error page  
- [ ] Show compilation errors in browser
- [ ] Add error logging

## 🛠️ Development Tools (Next 2 Weeks)

### Basic CLI (`swiftlets` command)
- [x] Create new executable target `SwiftletsCLI`
- [x] Implement commands:
  - [x] `swiftlets new <name>` - Create new project
  - [x] `swiftlets serve` - Start dev server
  - [x] `swiftlets build` - Build for production
  - [x] `swiftlets init` - Initialize in existing directory
- [ ] Add `swiftlets routes` - List all routes
- [x] Add to Package.swift products

### Auto-Compilation
- [ ] Detect missing swiftlet executables
- [ ] Compile from source on first request
- [ ] Cache compiled binaries with timestamps
- [ ] File watcher for source changes

## 📦 Core Features (This Month)

### Enhanced Routing
- [ ] Support route parameters (`/user/:id`)
- [ ] Extract route parameters to Request
- [ ] Wildcard routes (`/files/*`)
- [ ] Route precedence rules

### Project Structure
- [ ] Create project template
- [ ] Standard directory layout
- [ ] Configuration file (swiftlets.yml)
- [ ] Environment variable support

### Testing
- [ ] Integration tests for server
- [ ] Test harness for swiftlets
- [ ] CI setup with GitHub Actions
- [ ] Cross-platform testing

## 🌟 Nice to Have (Next Month)

### Sessions
- [ ] Cookie parsing/setting
- [ ] Session middleware
- [ ] In-memory session store
- [ ] Session examples

### Forms
- [ ] URL-encoded form parsing
- [ ] Multipart form parsing
- [ ] CSRF tokens
- [ ] Form validation helpers

### Database
- [ ] SQLite integration
- [ ] Simple query builder
- [ ] Migration system
- [ ] Model generator

## 📚 Documentation Tasks

- [ ] Getting Started guide
- [ ] Installation instructions
- [ ] Your First Swiftlet tutorial
- [ ] API reference
- [ ] Deployment guide
- [ ] Migration from Express/Rails

## 🧪 Example Applications

- [ ] Simple blog (priority)
  - [ ] Post list page
  - [ ] Individual post pages
  - [ ] Create/edit forms
  - [ ] Basic styling
  
- [ ] Todo app
  - [ ] CRUD operations
  - [ ] Sessions
  - [ ] AJAX updates

- [ ] API example
  - [ ] JSON responses
  - [ ] Authentication
  - [ ] OpenAPI docs

## 🔧 Technical Debt

- [ ] Refactor server main.swift into modules
- [ ] Extract routing logic to separate type
- [ ] Improve error types and handling
- [ ] Add structured logging
- [ ] Performance profiling
- [ ] Memory leak detection

## 🐛 Known Bugs

- [ ] Server doesn't properly route showcase/layout
- [ ] Empty response bodies sometimes
- [ ] No graceful shutdown handling
- [ ] File handles might leak on errors

## 🔧 Framework Issues

### Export Issues
- [ ] Table elements (Table, THead, TBody, TFoot, TR, TH, TD, Caption) are defined but not exported from Swiftlets module

### Missing HTML Elements
- [ ] Table elements ColGroup and Col not implemented
- [ ] Form element OptGroup not implemented  
- [ ] Text formatting elements not implemented: Br, S (strikethrough), Dfn, Ruby, Wbr

### Missing UI Components (Referenced but not implemented)
- [ ] Container component - Used throughout showcase
- [ ] Grid component - Used for layouts
- [ ] Row and Column components - Used in grid layouts
- [ ] Card component - Used for content grouping

### Naming Conflicts
- [ ] User files named after framework modules cause compilation errors:
  - `lists.swift` conflicts with framework's `Lists.swift`
  - `media.swift` conflicts with framework's `Media.swift`
  - `semantic.swift` conflicts with framework's `Semantic.swift`

### Compilation Performance
- [x] Complex nested HTML causes "expression too complex" errors
- [x] Workaround documented: break into smaller functions
- [ ] Investigate Swift compiler optimization flags
- [ ] Consider alternative result builder approaches

## 💡 Future Ideas

- [ ] WebSocket support
- [ ] GraphQL integration
- [ ] Admin interface generator
- [ ] Component marketplace
- [ ] Visual route editor
- [ ] Playground for HTML DSL

---

## How to Contribute

1. Pick a task marked with 🚨 or 🎯
2. Create a feature branch
3. Write tests for your changes
4. Submit a PR with description
5. Update relevant documentation

## Priority Guide

🚨 **Critical** - Blocking issues, fix immediately  
🎯 **High** - Core functionality, do this week  
🛠️ **Medium** - Important features, do this month  
🌟 **Low** - Nice to have, when time permits  

---

*Last updated: June 8, 2025*