# Swiftlets TODO List

## 🚨 Critical Fixes (Do First)

- [x] Fix `Sendable` protocol warning in `SwiftletHTTPHandler` (main.swift:243)
- [x] Remove debug `print` statements from server
- [x] Add newline at end of Package.swift
- [x] Fix server to properly discover swiftlets without hardcoded paths

## 🎯 High Priority (This Week)

### Static File Serving
- [ ] Add static file middleware to server
- [ ] Support common MIME types (css, js, images, fonts)
- [ ] Add caching headers (ETag, Last-Modified)
- [ ] Create `public/` directory structure

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
- [ ] Create new executable target `SwiftletsCLI`
- [ ] Implement commands:
  - [ ] `swiftlets new <name>` - Create new project
  - [ ] `swiftlets serve` - Start dev server
  - [ ] `swiftlets build` - Build for production
  - [ ] `swiftlets routes` - List all routes
- [ ] Add to Package.swift products

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

*Last updated: January 2025*