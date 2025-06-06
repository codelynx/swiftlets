# Swiftlets Web Directory Makefile
# This Makefile manages the building of swiftlet executables based on .webbin files

# Configuration
BIN_DIR = web/bin
SRC_DIR = src
BUILD_MODE ?= debug
SWIFT = swift
SWIFTC = swiftc

# Colors for output
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

# Find all .webbin files
WEBBIN_FILES := $(shell find web -name "*.webbin" -type f)
# Extract executable names from .webbin files
# Derive executable paths from webbin locations: web/hello.webbin -> web/bin/hello
EXECUTABLES := $(shell for f in $(WEBBIN_FILES); do echo $$f | sed 's|^web/||' | sed 's|\.webbin$$||' | sed 's|^|$(BIN_DIR)/|'; done | sort -u)

# Default target
all: check-structure $(EXECUTABLES)
	@echo "$(GREEN)✓ All swiftlets built successfully$(NC)"

# Check directory structure
check-structure:
	@echo "$(YELLOW)Checking project structure...$(NC)"
	@test -d $(BIN_DIR) || mkdir -p $(BIN_DIR)
	@test -d $(SRC_DIR) || mkdir -p $(SRC_DIR)
	@echo "$(GREEN)✓ Directory structure OK$(NC)"

# List all routes
routes:
	@echo "$(YELLOW)Available routes:$(NC)"
	@echo "$(YELLOW)Static files:$(NC)"
	@find web -type f ! -name "*.webbin" ! -name "Makefile" | sed 's|^web|  |'
	@echo ""
	@echo "$(YELLOW)Dynamic routes (.webbin files):$(NC)"
	@for webbin in $(WEBBIN_FILES); do \
		route=$$(echo $$webbin | sed 's|^web||' | sed 's|\.webbin$$||'); \
		exec=$$(cat $$webbin); \
		echo "  $$route → $$exec"; \
	done

# Validate all .webbin files
validate:
	@echo "$(YELLOW)Validating .webbin files...$(NC)"
	@errors=0; \
	for webbin in $(WEBBIN_FILES); do \
		exec=$$(cat $$webbin 2>/dev/null); \
		if [ -z "$$exec" ]; then \
			echo "$(RED)✗ $$webbin is empty$(NC)"; \
			errors=$$((errors + 1)); \
		else \
			echo "$(GREEN)✓ $$webbin → $$exec$(NC)"; \
		fi; \
	done; \
	if [ $$errors -gt 0 ]; then \
		echo "$(RED)✗ Found $$errors validation errors$(NC)"; \
		exit 1; \
	else \
		echo "$(GREEN)✓ All .webbin files valid$(NC)"; \
	fi

# Build individual executables with timestamp checking
$(BIN_DIR)/%: FORCE
	@src_name=$$(basename $@); \
	src_file=$$(find $(SRC_DIR) -name "$$src_name.swift" 2>/dev/null | head -1); \
	if [ -n "$$src_file" ]; then \
		if [ ! -f "$@" ] || [ "$$src_file" -nt "$@" ] || \
		   [ -n "$$(find ../../core/Sources/SwiftletsCore ../../core/Sources/SwiftletsHTML -name "*.swift" -newer "$@" 2>/dev/null | head -1)" ]; then \
			echo "$(YELLOW)Building $@...$(NC)"; \
			echo "  Found source: $$src_file"; \
			mkdir -p $$(dirname $@); \
			(cd ../../core && swift build --product SwiftletsCore --product SwiftletsHTML > /dev/null 2>&1); \
			CORE_SOURCES=$$(find ../../core/Sources/SwiftletsCore -name "*.swift"); \
			HTML_SOURCES=$$(find ../../core/Sources/SwiftletsHTML -name "*.swift"); \
			$(SWIFTC) $$src_file $$CORE_SOURCES $$HTML_SOURCES \
				-parse-as-library \
				-o $@ \
				2>&1 | sed 's/^/  /'; \
			if [ $${PIPESTATUS[0]} -eq 0 ]; then \
				chmod +x $@; \
				MD5=$$(md5 -q $@ 2>/dev/null || md5sum $@ | cut -d' ' -f1); \
				for webbin in $$(find web -name "*.webbin" -type f); do \
					webbin_target=$$(basename $$webbin .webbin); \
					if [ "$$webbin_target" = "$$src_name" ]; then \
						echo "$$MD5" > "$$webbin"; \
						echo "  Updated $$webbin with MD5: $$MD5"; \
					fi; \
				done; \
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
	@echo "$(GREEN)✓ Clean complete$(NC)"

# Watch for changes and rebuild
watch:
	@echo "$(YELLOW)Watching for changes...$(NC)"
	@echo "Press Ctrl+C to stop"
	@which fswatch > /dev/null || (echo "$(RED)Error: fswatch not installed. Install with: brew install fswatch$(NC)" && exit 1)
	@fswatch -o $(SRC_DIR) $(WEBBIN_FILES) | xargs -n1 -I{} $(MAKE) --no-print-directory

# Development server
serve: all
	@echo "$(GREEN)Starting development server...$(NC)"
	@cd ../../core && swift run swiftlets-server

# Build for production
release:
	@$(MAKE) BUILD_MODE=release all

# Help
help:
	@echo "$(YELLOW)Swiftlets Web Makefile$(NC)"
	@echo ""
	@echo "Targets:"
	@echo "  make              - Build all swiftlets (debug mode)"
	@echo "  make release      - Build all swiftlets (release mode)"
	@echo "  make routes       - List all routes (static and dynamic)"
	@echo "  make validate     - Validate all .webbin files"
	@echo "  make clean        - Remove all built executables"
	@echo "  make watch        - Watch for changes and rebuild"
	@echo "  make serve        - Build and start development server"
	@echo "  make help         - Show this help"
	@echo ""
	@echo "Variables:"
	@echo "  BUILD_MODE=debug|release - Set build mode (default: debug)"

.PHONY: all check-structure routes validate clean watch serve release help

# Prevent deletion of intermediate files
.PRECIOUS: $(BIN_DIR)/%