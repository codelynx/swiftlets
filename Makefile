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
	@echo "$(GREEN)Example Commands:$(NC)"
	@echo "  make example             - Build and run basic-site example"
	@echo "  make example-build       - Build basic-site example"
	@echo "  make example-clean       - Clean basic-site example"
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
	@echo "  make dev                 - Start server with basic-site example"
	@echo "  make watch               - Watch for changes (requires fswatch)"
	@echo ""
	@echo "$(GREEN)Cross-Platform:$(NC)"
	@echo "  make build-universal     - Build with cross-platform support"
	@echo "  make run-universal       - Run with cross-platform support"
	@echo "  make check-ubuntu        - Check Ubuntu ARM64 prerequisites"

# Run the server
.PHONY: server
server:
	@echo "$(YELLOW)Starting Swiftlets server...$(NC)"
	@if [ -d "examples/basic-site" ]; then \
		export SWIFTLETS_SITE=examples/basic-site; \
	fi; \
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

# Build and run example
.PHONY: example
example:
	@echo "$(YELLOW)Building basic-site example...$(NC)"
	@cd examples/basic-site && make all
	@echo "$(GREEN)Starting server with basic-site...$(NC)"
	@cd core && swift run swiftlets-server

# Build example only
.PHONY: example-build
example-build:
	@echo "$(YELLOW)Building basic-site example...$(NC)"
	@cd examples/basic-site && make all

# Clean example
.PHONY: example-clean
example-clean:
	@echo "$(YELLOW)Cleaning basic-site example...$(NC)"
	@cd examples/basic-site && make clean

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
	@cd examples/basic-site && make clean
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
dev: example-build server

# Watch for changes (if you implement it)
.PHONY: watch
watch:
	@echo "$(YELLOW)Watching for changes...$(NC)"
	@echo "$(RED)Not implemented yet$(NC)"
	@echo "TODO: Implement file watching"

# Cross-platform build
.PHONY: build-universal
build-universal:
	@echo "$(YELLOW)Building with cross-platform support...$(NC)"
	@./build-universal.sh

# Cross-platform run
.PHONY: run-universal
run-universal:
	@echo "$(YELLOW)Running with cross-platform support...$(NC)"
	@./run-universal.sh

# Check Ubuntu prerequisites
.PHONY: check-ubuntu
check-ubuntu:
	@./check-ubuntu-prerequisites.sh

# Shortcuts
.PHONY: s
s: server

.PHONY: e
e: example

.PHONY: t
t: test

.PHONY: d
d: dev

.PHONY: bu
bu: build-universal

.PHONY: ru
ru: run-universal