# Swiftlets Project Makefile

# Configuration
BIN_DIR = bin
SRC_DIR = src
WEB_DIR = web
BUILD_MODE ?= debug
SWIFT = swift
SWIFTC = swiftc

# Path to Swiftlets core (adjust for your setup)
SWIFTLETS_CORE = ../../../core

# Colors for output
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

# Find all .webbin files
WEBBIN_FILES := $(shell find $(WEB_DIR) -name "*.webbin" -type f 2>/dev/null)
# Extract executable names from .webbin files
EXECUTABLES := $(shell cat $(WEBBIN_FILES) 2>/dev/null | sort -u)

# Default target
all: check-structure $(EXECUTABLES)
	@echo "$(GREEN)✓ All swiftlets built successfully$(NC)"

# Check directory structure
check-structure:
	@echo "$(YELLOW)Checking project structure...$(NC)"
	@test -d $(BIN_DIR) || mkdir -p $(BIN_DIR)
	@test -d $(SRC_DIR) || mkdir -p $(SRC_DIR)
	@test -d $(WEB_DIR) || mkdir -p $(WEB_DIR)
	@echo "$(GREEN)✓ Directory structure OK$(NC)"

# Build individual executables
$(BIN_DIR)/%: FORCE
	@src_name=$$(basename $@); \
	src_file=$$(find $(SRC_DIR) -name "$$src_name.swift" 2>/dev/null | head -1); \
	if [ -n "$$src_file" ]; then \
		if [ ! -f "$@" ] || [ "$$src_file" -nt "$@" ] || \
		   [ -n "$$(find $(SWIFTLETS_CORE)/Sources -name "*.swift" -newer "$@" 2>/dev/null | head -1)" ]; then \
			echo "$(YELLOW)Building $@...$(NC)"; \
			echo "  Found source: $$src_file"; \
			(cd $(SWIFTLETS_CORE) && swift build > /dev/null 2>&1); \
			CORE_SOURCES=$$(find $(SWIFTLETS_CORE)/Sources/Swiftlets -name "*.swift"); \
			$(SWIFTC) $$src_file $$CORE_SOURCES \
				-parse-as-library \
				-o $@ \
				2>&1 | sed 's/^/  /'; \
			if [ $${PIPESTATUS[0]} -eq 0 ]; then \
				chmod +x $@; \
				echo "$(GREEN)✓ Built $@$(NC)"; \
			else \
				echo "$(RED)✗ Failed to build $@$(NC)"; \
				exit 1; \
			fi; \
		else \
			echo "$(GREEN)✓ $@ is up to date$(NC)"; \
		fi; \
	else \
		echo "$(RED)✗ No source file found for $@$(NC)"; \
		echo "  Searched for: $(SRC_DIR)/$$src_name.swift"; \
		exit 1; \
	fi

# Force target for timestamp checking
FORCE:

# Clean all built executables
clean:
	@echo "$(YELLOW)Cleaning built executables...$(NC)"
	@rm -rf $(BIN_DIR)/*
	@rm -f $(WEB_DIR)/**/*.webbin $(WEB_DIR)/*.webbin
	@echo "$(GREEN)✓ Clean complete$(NC)"

# List all routes
routes:
	@echo "$(YELLOW)Available routes:$(NC)"
	@if [ -n "$(WEBBIN_FILES)" ]; then \
		echo "$(YELLOW)Dynamic routes (.webbin files):$(NC)"; \
		for webbin in $(WEBBIN_FILES); do \
			route=$$(echo $$webbin | sed 's|^$(WEB_DIR)||' | sed 's|\.webbin$$||'); \
			exec=$$(cat $$webbin); \
			echo "  $$route → $$exec"; \
		done; \
	else \
		echo "  No routes defined yet"; \
		echo "  Create .webbin files in $(WEB_DIR)/ to define routes"; \
	fi

# Development server
serve: all
	@echo "$(GREEN)Starting development server...$(NC)"
	@cd $(SWIFTLETS_CORE) && swift run swiftlets-server

# Help
help:
	@echo "$(YELLOW)Swiftlets Project Makefile$(NC)"
	@echo ""
	@echo "Targets:"
	@echo "  make              - Build all swiftlets"
	@echo "  make clean        - Remove all built executables"
	@echo "  make routes       - List all routes"
	@echo "  make serve        - Build and start development server"
	@echo "  make help         - Show this help"

.PHONY: all check-structure clean routes serve help FORCE