# Swiftlets Site Makefile

# Detect OS and architecture
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

# Binary directory (OUTSIDE web root for security)
BIN_DIR := bin

# Swift files to compile (find all .swift files recursively)
SWIFT_FILES := $(shell find src -name "*.swift" -type f | sort)

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
		output="bin/$${relative%.swift}"; \
		webbin="web/$${relative%.swift}.webbin"; \
		outdir=$$(dirname "$$output"); \
		mkdir -p "$$outdir" 2>/dev/null || true; \
		if [[ "$$file" == *"Components.swift" ]]; then \
			continue; \
		fi; \
		need_build=0; \
		if [ ! -f "$$output" ]; then \
			need_build=1; \
		else \
			if [ "$$file" -nt "$$output" ] || [ "src/Components.swift" -nt "$$output" ]; then \
				need_build=1; \
			else \
				for framework_file in ../../../Sources/Swiftlets/**/*.swift; do \
					if [ "$$framework_file" -nt "$$output" ]; then \
						need_build=1; \
						break; \
					fi; \
				done; \
			fi; \
		fi; \
		if [ $$need_build -eq 1 ]; then \
			echo "  Building $$relative -> $$output"; \
			temp_file=".build/temp/$$(basename $$file)"; \
			sed -e '/^import Swiftlets$$/d' \
			    -e 's/let request = try/let _ = try/' \
			    "$$file" > "$$temp_file"; \
			if swiftc -parse-as-library \
			      -module-name Swiftlets \
			      ../../../Sources/Swiftlets/Core/*.swift \
			      ../../../Sources/Swiftlets/HTML/Core/*.swift \
			      ../../../Sources/Swiftlets/HTML/Elements/*.swift \
			      ../../../Sources/Swiftlets/HTML/Helpers/*.swift \
			      ../../../Sources/Swiftlets/HTML/Layout/*.swift \
			      ../../../Sources/Swiftlets/HTML/Modifiers/*.swift \
			      ../../../Sources/Swiftlets/HTML/Builders/*.swift \
			      src/Components.swift \
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
		else \
			echo "  ✓ $$relative is up to date"; \
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
	@rm -rf bin
	@rm -f web/**/*.webbin web/*.webbin
	@echo "Clean complete!"

# Run the site using swiftlets CLI
.PHONY: serve
serve: build
	@echo "Starting Swiftlets server..."
	@cd ../../.. && swiftlets serve --site sites/examples/swiftlets-site

# Run without CLI (direct server)
.PHONY: run
run: build
	@echo "Starting server directly..."
	@cd ../../.. && SWIFTLETS_SITE=sites/examples/swiftlets-site ./bin/$(OS)/$(ARCH)/swiftlets-server

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