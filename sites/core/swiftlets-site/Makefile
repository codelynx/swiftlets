# Swiftlets Site Makefile

# Detect OS and architecture
OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH := $(shell uname -m)

# Normalize architecture names
ifeq ($(ARCH),x86_64)
    ARCH := x86_64
else ifeq ($(ARCH),aarch64)
    ARCH := arm64
else ifeq ($(ARCH),arm64)
    ARCH := arm64
endif

# Binary directory
BIN_DIR := web/bin/$(OS)/$(ARCH)

# Swift files to compile
SWIFT_FILES := $(wildcard src/*.swift) $(wildcard src/**/*.swift)

# Default target
.PHONY: all
all: build

# Build all swiftlets
.PHONY: build
build: $(BIN_DIR)
	@echo "Building swiftlets for $(OS)/$(ARCH)..."
	@for file in $(SWIFT_FILES); do \
		relative=$${file#src/}; \
		output="$(BIN_DIR)/$${relative%.swift}"; \
		outdir=$$(dirname "$$output"); \
		mkdir -p "$$outdir"; \
		echo "  Building $$relative -> $$output"; \
		swiftc -parse-as-library \
		      -I ../../../core/.build/release/Modules \
		      "$$file" -o "$$output" || exit 1; \
	done
	@echo "Build complete!"

# Create binary directory
$(BIN_DIR):
	@mkdir -p $(BIN_DIR)

# Clean build artifacts
.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf web/bin
	@echo "Clean complete!"

# Run the site using swiftlets CLI
.PHONY: serve
serve: build
	@echo "Starting Swiftlets server..."
	@cd ../../.. && swiftlets serve --site sites/core/swiftlets-site

# Run without CLI (direct server)
.PHONY: run
run: build
	@echo "Starting server directly..."
	@cd ../../.. && SWIFTLETS_SITE=sites/core/swiftlets-site ./core/.build/release/swiftlets-server

# Help
.PHONY: help
help:
	@echo "Swiftlets Site Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  make build  - Build all swiftlets"
	@echo "  make serve  - Build and run with swiftlets CLI"
	@echo "  make run    - Build and run with direct server"
	@echo "  make clean  - Clean build artifacts"
	@echo "  make help   - Show this help message"
	@echo ""
	@echo "Platform: $(OS)/$(ARCH)"