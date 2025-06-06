# Swiftlets Root Makefile

# Colors
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

# Platform detection
OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH := $(shell uname -m)

# Normalize OS names
ifeq ($(OS),Darwin)
    OS := darwin
endif

# Normalize architecture names
ifeq ($(ARCH),x86_64)
    ARCH := x86_64
else ifeq ($(ARCH),aarch64)
    ARCH := arm64
else ifeq ($(ARCH),arm64)
    ARCH := arm64
endif

# Binary output directory
BIN_DIR := bin/$(OS)/$(ARCH)

# Default target
.PHONY: help
help:
	@echo "$(YELLOW)Swiftlets Build System$(NC)"
	@echo ""
	@echo "$(GREEN)Build Commands:$(NC)"
	@echo "  make build               - Build all components"
	@echo "  make build-server        - Build server only"
	@echo "  make build-cli           - Build CLI only"
	@echo "  make build-release       - Build in release mode"
	@echo ""
	@echo "$(GREEN)Run Commands:$(NC)"
	@echo "  make run                 - Run server with example site"
	@echo "  make run-dev             - Run in development mode"
	@echo ""
	@echo "$(GREEN)Site Commands:$(NC)"
	@echo "  make sites               - Build all example sites"
	@echo "  make test-sites          - Build test sites"
	@echo ""
	@echo "$(GREEN)Development:$(NC)"
	@echo "  make test                - Run all tests"
	@echo "  make clean               - Clean build artifacts"
	@echo "  make format              - Format Swift code"
	@echo ""
	@echo "$(GREEN)Package Commands:$(NC)"
	@echo "  make package-ubuntu      - Create Ubuntu .deb package"
	@echo "  make package-macos       - Create macOS installer"
	@echo ""
	@echo "Platform: $(OS)/$(ARCH)"
	@echo "Binaries: $(BIN_DIR)"

# Build all components
.PHONY: build
build: build-server build-cli

# Build server
.PHONY: build-server
build-server:
	@echo "$(YELLOW)Building Swiftlets server...$(NC)"
	@mkdir -p $(BIN_DIR)
	@swift build --product swiftlets-server
	@cp .build/debug/swiftlets-server $(BIN_DIR)/
	@echo "$(GREEN)Server built: $(BIN_DIR)/swiftlets-server$(NC)"

# Build CLI
.PHONY: build-cli
build-cli:
	@echo "$(YELLOW)Building Swiftlets CLI...$(NC)"
	@mkdir -p $(BIN_DIR)
	@swift build --product swiftlets
	@cp .build/debug/swiftlets $(BIN_DIR)/
	@echo "$(GREEN)CLI built: $(BIN_DIR)/swiftlets$(NC)"

# Build release versions
.PHONY: build-release
build-release:
	@echo "$(YELLOW)Building release versions...$(NC)"
	@mkdir -p $(BIN_DIR)
	@swift build -c release --product swiftlets-server
	@swift build -c release --product swiftlets
	@cp .build/release/swiftlets-server $(BIN_DIR)/
	@cp .build/release/swiftlets $(BIN_DIR)/
	@echo "$(GREEN)Release build complete$(NC)"

# Run server
.PHONY: run
run: build-server
	@echo "$(YELLOW)Starting Swiftlets server...$(NC)"
	@export SWIFTLETS_SITE=sites/examples/swiftlets-site; \
	$(BIN_DIR)/swiftlets-server

# Run in development mode
.PHONY: run-dev
run-dev: build-server sites
	@echo "$(YELLOW)Starting server in development mode...$(NC)"
	@export SWIFTLETS_SITE=sites/examples/swiftlets-site; \
	$(BIN_DIR)/swiftlets-server

# Build example sites
.PHONY: sites
sites:
	@echo "$(YELLOW)Building example sites...$(NC)"
	@cd sites/examples/swiftlets-site && make build
	@echo "$(GREEN)Sites built successfully$(NC)"

# Build test sites
.PHONY: test-sites
test-sites:
	@echo "$(YELLOW)Building test sites...$(NC)"
	@for site in sites/tests/*/; do \
		if [ -f "$$site/Makefile" ]; then \
			echo "Building $$site..."; \
			cd "$$site" && make build && cd -; \
		fi \
	done

# Run tests
.PHONY: test
test:
	@echo "$(YELLOW)Running tests...$(NC)"
	@swift test

# Clean build artifacts
.PHONY: clean
clean:
	@echo "$(YELLOW)Cleaning build artifacts...$(NC)"
	@swift package clean
	@rm -rf bin/*/
	@echo "$(GREEN)Clean complete$(NC)"

# Format code
.PHONY: format
format:
	@echo "$(YELLOW)Formatting Swift code...$(NC)"
	@swift-format -i -r Sources/
	@swift-format -i -r Tests/

# Package for Ubuntu
.PHONY: package-ubuntu
package-ubuntu: build-release
	@echo "$(YELLOW)Creating Ubuntu package...$(NC)"
	@./tools/package/ubuntu/build-deb.sh
	@echo "$(GREEN)Ubuntu package created$(NC)"

# Package for macOS
.PHONY: package-macos
package-macos: build-release
	@echo "$(YELLOW)Creating macOS installer...$(NC)"
	@./tools/package/macos/build-pkg.sh
	@echo "$(GREEN)macOS installer created$(NC)"

# Install locally (development)
.PHONY: install
install: build-release
	@echo "$(YELLOW)Installing Swiftlets...$(NC)"
	@sudo cp $(BIN_DIR)/swiftlets /usr/local/bin/
	@sudo cp $(BIN_DIR)/swiftlets-server /usr/local/bin/
	@echo "$(GREEN)Installation complete$(NC)"

# Uninstall
.PHONY: uninstall
uninstall:
	@echo "$(YELLOW)Uninstalling Swiftlets...$(NC)"
	@sudo rm -f /usr/local/bin/swiftlets
	@sudo rm -f /usr/local/bin/swiftlets-server
	@echo "$(GREEN)Uninstall complete$(NC)"

# Shortcuts
.PHONY: b
b: build

.PHONY: r
r: run

.PHONY: t
t: test

.PHONY: c
c: clean