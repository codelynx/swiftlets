#!/bin/bash
# Run Swiftlets development server

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Swiftlets server...${NC}"

# Ensure core is built
echo -e "${YELLOW}Building server...${NC}"
cd core && swift build --product swiftlets-server

# Run the server
echo -e "${GREEN}Server starting on http://localhost:8080${NC}"
swift run swiftlets-server