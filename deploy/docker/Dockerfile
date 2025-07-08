# Multi-stage Dockerfile for Swiftlets
# Builds and runs Swiftlets in a minimal container

# Stage 1: Build stage
FROM swift:5.9-jammy AS builder

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /build

# Copy package files first (for better caching)
COPY Package.swift Package.resolved ./

# Copy source code
COPY Sources ./Sources
COPY sites ./sites
COPY build-site ./build-site
COPY build-server ./build-server

# Make scripts executable
RUN chmod +x build-site build-server

# Build the server
RUN ./build-server

# Build the site (default: swiftlets-site)
ARG SITE_NAME=swiftlets-site
RUN ./build-site sites/${SITE_NAME}

# Stage 2: Runtime stage
FROM swift:5.9-jammy-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libssl3 \
    zlib1g \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash swiftlets

# Set working directory
WORKDIR /app

# Copy built artifacts from builder
COPY --from=builder /build/.build/release/SwiftletsServer /app/
COPY --from=builder /build/bin /app/bin
COPY --from=builder /build/sites /app/sites
COPY --from=builder /build/run-site /app/

# Make executable
RUN chmod +x /app/SwiftletsServer /app/run-site

# Change ownership
RUN chown -R swiftlets:swiftlets /app

# Switch to non-root user
USER swiftlets

# Expose port
EXPOSE 8080

# Environment variables
ENV SWIFTLETS_ENV=production
ENV PORT=8080

# Default site to run
ARG SITE_NAME=swiftlets-site
ENV SITE_NAME=${SITE_NAME}

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${PORT}/ || exit 1

# Start command
CMD ["sh", "-c", "./run-site sites/${SITE_NAME} --port ${PORT}"]