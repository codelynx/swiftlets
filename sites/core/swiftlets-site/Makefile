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
BIN_DIR := web/bin

# Swift files to compile (subdirectories first to avoid conflicts)
SWIFT_FILES := $(sort $(wildcard src/**/*.swift)) $(sort $(wildcard src/*.swift))

# Default target
.PHONY: all
all: build

# Build all swiftlets
.PHONY: build
build: $(BIN_DIR)
	@echo "Building swiftlets..."
	@mkdir -p .build/temp
	@for file in $(SWIFT_FILES); do \
		relative=$${file#src/}; \
		output="web/bin/$${relative%.swift}"; \
		webbin="web/$${relative%.swift}.webbin"; \
		outdir=$$(dirname "$$output"); \
		mkdir -p "$$outdir" 2>/dev/null || true; \
		echo "  Building $$relative -> $$output"; \
		temp_file=".build/temp/$$(basename $$file)"; \
		sed -e '/^import Swiftlets$$/d' \
		    -e 's/let request = try/let _ = try/' \
		    "$$file" > "$$temp_file"; \
		if swiftc -parse-as-library \
		      -module-name Swiftlets \
		      ../../../core/Sources/Swiftlets/Core/*.swift \
		      ../../../core/Sources/Swiftlets/HTML/Core/*.swift \
		      ../../../core/Sources/Swiftlets/HTML/Elements/*.swift \
		      ../../../core/Sources/Swiftlets/HTML/Helpers/*.swift \
		      ../../../core/Sources/Swiftlets/HTML/Layout/*.swift \
		      ../../../core/Sources/Swiftlets/HTML/Modifiers/*.swift \
		      ../../../core/Sources/Swiftlets/HTML/Builders/*.swift \
		      "$$temp_file" -o "$$output" 2>&1; then \
			echo "    ✓ Success"; \
			if [ -f "$$output" ]; then \
				MD5=$$(md5 -q "$$output" 2>/dev/null || md5sum "$$output" | cut -d' ' -f1); \
				echo "$$MD5" > "$$webbin"; \
				echo "    ✓ Updated $$webbin"; \
			fi; \
		else \
			echo "    ✗ Failed"; \
			rm -rf .build/temp; \
			exit 1; \
		fi; \
	done
	@rm -rf .build/temp
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