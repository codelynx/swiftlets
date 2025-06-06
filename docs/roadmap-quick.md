# Swiftlets Quick Roadmap

## Immediate Priorities (Next 2 Weeks)

### 🔧 Quick Fixes
1. [ ] Fix Sendable protocol warning in server
2. [ ] Parse query parameters from URLs
3. [ ] Add proper error pages (404, 500)
4. [ ] Clean up debug print statements
5. [ ] Add `.gitignore` for build artifacts

### 📁 Static File Serving
1. [ ] Implement static file middleware
2. [ ] Add caching headers
3. [ ] Support common MIME types
4. [ ] Enable development mode with live reload

### 🛠️ Basic CLI Tool
1. [ ] Create `swiftlets` command
2. [ ] Implement `new` command for project creation
3. [ ] Add `serve` command for development
4. [ ] Include `build` command for production

## Short Term Goals (Next Month)

### 🔄 Auto-Compilation
- [ ] Compile swiftlets on first request
- [ ] Cache compiled binaries
- [ ] Watch for file changes
- [ ] Show compilation errors in browser

### 🛣️ Better Routing
- [ ] Support route parameters (`/user/:id`)
- [ ] Automatic route discovery from filesystem
- [ ] Route groups and prefixes
- [ ] Basic middleware support

### 📝 Real Example App
- [ ] Build a simple blog with:
  - [ ] Post listing
  - [ ] Individual post pages
  - [ ] Basic styling
  - [ ] Form handling

## Medium Term Goals (Next Quarter)

### 🍪 Sessions & Auth
- [ ] Cookie-based sessions
- [ ] Login/logout functionality
- [ ] Protected routes
- [ ] Remember me functionality

### 💾 Database Integration
- [ ] SQLite support out of the box
- [ ] Simple query builder
- [ ] Migration system
- [ ] Model generation

### 🚀 Production Features
- [ ] Process pooling
- [ ] Performance monitoring
- [ ] Docker support
- [ ] Deployment guides

## Technical Debt to Address

1. **Server Architecture**
   - Refactor monolithic main.swift
   - Extract routing logic
   - Improve error handling
   - Add proper logging

2. **Testing**
   - Integration tests for server
   - Example app tests
   - Performance benchmarks
   - Cross-platform CI

3. **Documentation**
   - API reference
   - Getting started guide
   - Migration from other frameworks
   - Best practices

## Success Criteria

- **Week 1**: Static files working, basic CLI exists
- **Week 2**: Auto-compilation working, can build a simple site
- **Month 1**: Blog example complete, sessions working
- **Month 2**: Database integration, ready for beta users
- **Month 3**: Production ready with monitoring and deployment

## How to Contribute

1. **Pick a task** from the immediate priorities
2. **Create a branch** named `feature/task-name`
3. **Write tests** for your changes
4. **Submit a PR** with clear description
5. **Update docs** if needed

## Resources Needed

- [ ] Domain name for documentation site
- [ ] CI/CD setup (GitHub Actions)
- [ ] Discord or Slack for community
- [ ] Demo hosting environment
- [ ] Logo and branding

---

*Focus on shipping small improvements frequently rather than perfect features slowly.*