#!/bin/bash

# Flutter Web Production Build Script
# This script builds the Flutter web app in release mode and prepares it for Docker deployment

set -e

echo "=========================================="
echo "Flutter Web Production Build Script"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}Error: Flutter is not installed or not in PATH${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Flutter found: $(flutter --version | head -n 1)${NC}"

# Clean previous builds
echo -e "\n${YELLOW}Cleaning previous builds...${NC}"
flutter clean

# Get dependencies
echo -e "\n${YELLOW}Getting dependencies...${NC}"
flutter pub get

# Build for web in release mode
echo -e "\n${YELLOW}Building Flutter web app in release mode...${NC}"
flutter build web --release

# Check if build was successful
if [ -d "build/web" ]; then
    echo -e "\n${GREEN}✓ Build successful! Output: build/web/${NC}"
    
    # Display build size
    BUILD_SIZE=$(du -sh build/web | cut -f1)
    echo -e "${GREEN}Build size: ${BUILD_SIZE}${NC}"
    
    # List main files
    echo -e "\n${YELLOW}Main build files:${NC}"
    ls -lh build/web/ | grep -E '\.(html|js|css)$' | awk '{print $9, "-", $5}'
    
    echo -e "\n${GREEN}=========================================="
    echo "Build complete! Ready for Docker deployment"
    echo "==========================================${NC}"
else
    echo -e "\n${RED}Error: Build failed - build/web directory not found${NC}"
    exit 1
fi
