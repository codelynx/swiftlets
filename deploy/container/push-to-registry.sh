#!/bin/bash
#
# Push Swiftlets container to various registries
# Supports GitHub Container Registry, Docker Hub, AWS ECR, etc.
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
IMAGE_NAME=${1:-"swiftlets"}
TAG=${2:-"latest"}
REGISTRY_TYPE=${3:-"ghcr"}  # ghcr, docker, ecr, gcr

echo -e "${GREEN}=== Push to Container Registry ===${NC}"
echo "Image: $IMAGE_NAME:$TAG"
echo "Registry: $REGISTRY_TYPE"

# Function to push to GitHub Container Registry
push_to_ghcr() {
    local USERNAME=${GITHUB_USERNAME:-$USER}
    local TOKEN=${GITHUB_TOKEN:-}
    
    if [ -z "$TOKEN" ]; then
        echo -e "${RED}Error: GITHUB_TOKEN environment variable not set${NC}"
        echo "Generate a token at: https://github.com/settings/tokens/new"
        echo "Scopes needed: write:packages"
        exit 1
    fi
    
    echo -e "${YELLOW}Logging in to GitHub Container Registry...${NC}"
    echo "$TOKEN" | docker login ghcr.io -u "$USERNAME" --password-stdin
    
    local FULL_IMAGE="ghcr.io/$USERNAME/$IMAGE_NAME:$TAG"
    
    echo -e "${BLUE}Tagging image...${NC}"
    docker tag "$IMAGE_NAME:$TAG" "$FULL_IMAGE"
    
    echo -e "${BLUE}Pushing to ghcr.io...${NC}"
    docker push "$FULL_IMAGE"
    
    echo -e "${GREEN}Successfully pushed to: $FULL_IMAGE${NC}"
    echo ""
    echo "Make image public at: https://github.com/users/$USERNAME/packages/container/$IMAGE_NAME/settings"
}

# Function to push to Docker Hub
push_to_docker() {
    local USERNAME=${DOCKER_USERNAME:-}
    local PASSWORD=${DOCKER_PASSWORD:-}
    
    if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
        echo -e "${RED}Error: DOCKER_USERNAME and DOCKER_PASSWORD must be set${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Logging in to Docker Hub...${NC}"
    echo "$PASSWORD" | docker login -u "$USERNAME" --password-stdin
    
    local FULL_IMAGE="$USERNAME/$IMAGE_NAME:$TAG"
    
    echo -e "${BLUE}Tagging image...${NC}"
    docker tag "$IMAGE_NAME:$TAG" "$FULL_IMAGE"
    
    echo -e "${BLUE}Pushing to Docker Hub...${NC}"
    docker push "$FULL_IMAGE"
    
    echo -e "${GREEN}Successfully pushed to: $FULL_IMAGE${NC}"
}

# Function to push to AWS ECR
push_to_ecr() {
    local REGION=${AWS_REGION:-us-east-1}
    local ACCOUNT_ID=${AWS_ACCOUNT_ID:-$(aws sts get-caller-identity --query Account --output text)}
    local REGISTRY="$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"
    
    echo -e "${YELLOW}Logging in to AWS ECR...${NC}"
    aws ecr get-login-password --region "$REGION" | \
        docker login --username AWS --password-stdin "$REGISTRY"
    
    # Create repository if it doesn't exist
    aws ecr describe-repositories --repository-names "$IMAGE_NAME" --region "$REGION" 2>/dev/null || \
        aws ecr create-repository --repository-name "$IMAGE_NAME" --region "$REGION"
    
    local FULL_IMAGE="$REGISTRY/$IMAGE_NAME:$TAG"
    
    echo -e "${BLUE}Tagging image...${NC}"
    docker tag "$IMAGE_NAME:$TAG" "$FULL_IMAGE"
    
    echo -e "${BLUE}Pushing to ECR...${NC}"
    docker push "$FULL_IMAGE"
    
    echo -e "${GREEN}Successfully pushed to: $FULL_IMAGE${NC}"
}

# Function to push to Google Container Registry
push_to_gcr() {
    local PROJECT_ID=${GCP_PROJECT_ID:-}
    
    if [ -z "$PROJECT_ID" ]; then
        echo -e "${RED}Error: GCP_PROJECT_ID must be set${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Configuring Docker for GCR...${NC}"
    gcloud auth configure-docker
    
    local FULL_IMAGE="gcr.io/$PROJECT_ID/$IMAGE_NAME:$TAG"
    
    echo -e "${BLUE}Tagging image...${NC}"
    docker tag "$IMAGE_NAME:$TAG" "$FULL_IMAGE"
    
    echo -e "${BLUE}Pushing to GCR...${NC}"
    docker push "$FULL_IMAGE"
    
    echo -e "${GREEN}Successfully pushed to: $FULL_IMAGE${NC}"
}

# Check if image exists locally
if ! docker image inspect "$IMAGE_NAME:$TAG" >/dev/null 2>&1; then
    echo -e "${RED}Error: Image $IMAGE_NAME:$TAG not found locally${NC}"
    echo "Build it first with: ./deploy/container/build-full-container.sh"
    exit 1
fi

# Push based on registry type
case "$REGISTRY_TYPE" in
    ghcr)
        push_to_ghcr
        ;;
    docker)
        push_to_docker
        ;;
    ecr)
        push_to_ecr
        ;;
    gcr)
        push_to_gcr
        ;;
    *)
        echo -e "${RED}Unknown registry type: $REGISTRY_TYPE${NC}"
        echo "Supported types: ghcr, docker, ecr, gcr"
        exit 1
        ;;
esac

echo -e "${GREEN}=== Push Complete ===${NC}"