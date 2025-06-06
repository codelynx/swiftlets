# Swiftlets Root Makefile
# Convenience commands for development

# Colors
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

# Default target
.PHONY: help
help:
	@echo "$(YELLOW)Swiftlets Development Commands$(NC)"
	@echo ""
	@echo "$(GREEN)Server Commands:$(NC)"
	@echo "  make server              - Run the development server"
	@echo "  make server-build        - Build the server"
	@echo "  make server-release      - Build server in release mode"
	@echo ""
	@echo "$(GREEN)Core Framework:$(NC)"
	@echo "  make test                - Run all tests"
	@echo "  make build               - Build core framework"
	@echo "  make clean               - Clean all build artifacts"
	@echo ""
	@echo "$(GREEN)SDK Tools:$(NC)"
	@echo "  make init NAME=mysite    - Create new project using swiftlets-init"
	@echo ""
	@echo "$(GREEN)Development:$(NC)"
	@echo "  make dev                 - Start server with swiftlets-site"
	@echo "  make watch               - Watch for changes (requires fswatch)"
	@echo ""
	@echo "$(GREEN)Cross-Platform:$(NC)"
	@echo "  make check-ubuntu        - Check Ubuntu ARM64 prerequisites"

# Run the server
.PHONY: server
server:
	@echo "$(YELLOW)Starting Swiftlets server...$(NC)"
	@export SWIFTLETS_SITE=sdk/sites/swiftlets-site; \
	cd core && swift run swiftlets-server

# Build the server
.PHONY: server-build
server-build:
	@echo "$(YELLOW)Building Swiftlets server...$(NC)"
	@cd core && swift build --product swiftlets-server

# Build server in release mode
.PHONY: server-release
server-release:
	@echo "$(YELLOW)Building Swiftlets server (release)...$(NC)"
	@cd core && swift build --product swiftlets-server -c release


# Run tests
.PHONY: test
test:
	@echo "$(YELLOW)Running tests...$(NC)"
	@cd core && swift test

# Build core framework
.PHONY: build
build:
	@echo "$(YELLOW)Building core framework...$(NC)"
	@cd core && swift build

# Clean everything
.PHONY: clean
clean:
	@echo "$(YELLOW)Cleaning all build artifacts...$(NC)"
	@cd core && swift package clean
	@echo "$(GREEN)Clean complete$(NC)"

# Create new project
.PHONY: init
init:
ifndef NAME
	@echo "$(RED)Error: NAME is required$(NC)"
	@echo "Usage: make init NAME=mysite"
else
	@echo "$(YELLOW)Creating new project '$(NAME)'...$(NC)"
	@sdk/tools/swiftlets-init $(NAME)
endif

# Development mode - build and run
.PHONY: dev
dev:
	@echo "$(YELLOW)Building swiftlets-site...$(NC)"
	@cd sdk/sites/swiftlets-site && make build
	@echo "$(GREEN)Starting server with swiftlets-site...$(NC)"
	@export SWIFTLETS_SITE=sdk/sites/swiftlets-site; \
	cd core && swift run swiftlets-server

# Watch for changes (if you implement it)
.PHONY: watch
watch:
	@echo "$(YELLOW)Watching for changes...$(NC)"
	@echo "$(RED)Not implemented yet$(NC)"
	@echo "TODO: Implement file watching"

# Check Ubuntu prerequisites
.PHONY: check-ubuntu
check-ubuntu:
	@./check-ubuntu-prerequisites.sh

# Shortcuts
.PHONY: s
s: server


.PHONY: t
t: test

.PHONY: d
d: dev

