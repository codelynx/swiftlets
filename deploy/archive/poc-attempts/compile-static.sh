#!/bin/bash
#
# Build static binary for EC2
#

set -e

echo "=== Building Static Binary for Linux ARM64 ==="
echo ""

# Method 1: Static linking in Docker
echo "Building static binary with Docker..."
docker run --rm \
    -v $(pwd):/app \
    -w /app \
    --platform linux/arm64 \
    swift:6.0.2 \
    bash -c "
        swiftc hello.swift \
            -o hello-static \
            -static-executable \
            && chmod 755 hello-static
    "

if [ -f hello-static ]; then
    echo ""
    echo "✅ Static binary created:"
    file hello-static
    echo "Size: $(du -h hello-static | cut -f1)"
else
    echo "❌ Static build failed"
fi

# Method 2: Alternative - bundle with required libraries
echo ""
echo "Alternative: Creating bundle with libraries..."
docker run --rm \
    -v $(pwd):/app \
    -w /app \
    --platform linux/arm64 \
    swift:6.0.2 \
    bash -c "
        # Build normal binary
        swiftc hello.swift -o hello-bundle
        
        # Find and copy required libraries
        mkdir -p bundle/lib
        cp hello-bundle bundle/
        
        # Copy Swift runtime libraries
        for lib in \$(ldd hello-bundle | grep swift | awk '{print \$3}'); do
            if [ -f \"\$lib\" ]; then
                cp \"\$lib\" bundle/lib/
            fi
        done
        
        # Create run script
        cat > bundle/run.sh << 'EOF'
#!/bin/bash
DIR=\"\$(cd \"\$(dirname \"\${BASH_SOURCE[0]}\")\" && pwd)\"
export LD_LIBRARY_PATH=\"\$DIR/lib:\$LD_LIBRARY_PATH\"
\"\$DIR/hello-bundle\" \"\$@\"
EOF
        chmod +x bundle/run.sh
        
        # Package it
        tar -czf hello-bundle.tar.gz bundle/
    "

if [ -f hello-bundle.tar.gz ]; then
    echo ""
    echo "✅ Bundle created: hello-bundle.tar.gz"
    echo "Size: $(du -h hello-bundle.tar.gz | cut -f1)"
fi