#!/bin/bash

# Script to create a Docker image
# Usage: ./scripts/create-image.sh [image-name] [tag]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
IMAGE_NAME="${1:-java-agentic-devkit}"
TAG="${2:-latest}"
DOCKERFILE="${3:-.devcontainer/Dockerfile}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

source "${SCRIPT_DIR}/docker-utils.sh"

ensure_docker_available

echo -e "${YELLOW}🔨 Building Docker image...${NC}"
echo -e "${YELLOW}Image: ${GREEN}${IMAGE_NAME}:${TAG}${NC}"
echo -e "${YELLOW}Dockerfile: ${GREEN}${DOCKERFILE}${NC}\n${NC}"

# Build the image
if docker build -t "${IMAGE_NAME}:${TAG}" -f "${DOCKERFILE}" .; then
    echo -e "\n${GREEN}✅ Image created successfully: ${IMAGE_NAME}:${TAG}${NC}\n"
    echo "Useful commands:"
    echo "  View image:     docker images | grep ${IMAGE_NAME}"
    echo "  Run image:      docker run -it ${IMAGE_NAME}:${TAG}"
    echo "  Run bash:       docker run -it ${IMAGE_NAME}:${TAG} /bin/bash"
else
    echo -e "\n${RED}❌ Error creating image${NC}"
    exit 1
fi
