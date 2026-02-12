#!/bin/bash

# Docker Deployment Script for Flutter Web App
# This script builds and deploys the Flutter web app using Docker

set -e

echo "=========================================="
echo "Docker Deployment Script"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
IMAGE_NAME="frontend-app"
CONTAINER_NAME="frontend-app"
DOCKER_REGISTRY=""
TAG="latest"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --image-name)
            IMAGE_NAME="$2"
            shift 2
            ;;
        --container-name)
            CONTAINER_NAME="$2"
            shift 2
            ;;
        --tag)
            TAG="$2"
            shift 2
            ;;
        --registry)
            DOCKER_REGISTRY="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --image-name NAME     Docker image name (default: frontend-app)"
            echo "  --container-name NAME Container name (default: frontend-app)"
            echo "  --tag TAG            Image tag (default: latest)"
            echo "  --registry REGISTRY  Docker registry URL (optional)"
            echo "  --help               Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed or not in PATH${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker found: $(docker --version)${NC}"

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Error: Docker Compose is not installed or not in PATH${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker Compose found: $(docker-compose --version)${NC}"

# Build Flutter web app
echo -e "\n${BLUE}Step 1: Building Flutter web app...${NC}"
if [ -f "scripts/build.sh" ]; then
    chmod +x scripts/build.sh
    ./scripts/build.sh
else
    flutter build web --release
fi

# Build Docker image
echo -e "\n${BLUE}Step 2: Building Docker image...${NC}"
FULL_IMAGE_NAME="${IMAGE_NAME}:${TAG}"
if [ -n "$DOCKER_REGISTRY" ]; then
    FULL_IMAGE_NAME="${DOCKER_REGISTRY}/${FULL_IMAGE_NAME}"
fi

echo -e "${YELLOW}Building image: ${FULL_IMAGE_NAME}${NC}"
docker build -t "$FULL_IMAGE_NAME" .

# Stop and remove existing container
echo -e "\n${BLUE}Step 3: Stopping existing container (if any)...${NC}"
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo -e "${YELLOW}Stopping container: ${CONTAINER_NAME}${NC}"
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    docker rm "$CONTAINER_NAME" 2>/dev/null || true
fi

# Start container using docker-compose
echo -e "\n${BLUE}Step 4: Starting container with docker-compose...${NC}"
docker-compose up -d

# Wait for container to be healthy
echo -e "\n${BLUE}Step 5: Waiting for container to be healthy...${NC}"
MAX_RETRIES=30
RETRY_COUNT=0
while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    HEALTH_STATUS=$(docker inspect --format='{{.State.Health.Status}}' "$CONTAINER_NAME" 2>/dev/null || echo "unknown")
    if [ "$HEALTH_STATUS" = "healthy" ]; then
        echo -e "${GREEN}✓ Container is healthy!${NC}"
        break
    elif [ "$HEALTH_STATUS" = "unhealthy" ]; then
        echo -e "${RED}✗ Container is unhealthy!${NC}"
        docker logs "$CONTAINER_NAME"
        exit 1
    fi
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo -e "${YELLOW}Waiting... (${RETRY_COUNT}/${MAX_RETRIES})${NC}"
    sleep 2
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo -e "${RED}✗ Container health check timed out${NC}"
    exit 1
fi

# Display container info
echo -e "\n${GREEN}=========================================="
echo "Deployment successful!"
echo "==========================================${NC}"
echo -e "${GREEN}Container Name:${NC} $CONTAINER_NAME"
echo -e "${GREEN}Image:${NC} $FULL_IMAGE_NAME"
echo -e "${GREEN}Status:${NC} $(docker ps --filter "name=$CONTAINER_NAME" --format '{{.Status}}')"
echo -e "${GREEN}Port:${NC} $(docker port "$CONTAINER_NAME" 80 | cut -d: -f2)"
echo -e "${GREEN}URL:${NC} http://localhost:$(docker port "$CONTAINER_NAME" 80 | cut -d: -f2)"
echo ""
echo -e "${YELLOW}Useful commands:${NC}"
echo "  View logs: docker logs -f $CONTAINER_NAME"
echo "  Stop container: docker-compose down"
echo "  Restart container: docker-compose restart"
echo "  View container stats: docker stats $CONTAINER_NAME"
echo ""
