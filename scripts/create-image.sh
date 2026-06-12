#!/bin/bash

# Script to create the Docker image.
# Usage:
#   ./scripts/create-image.sh
#   ./scripts/create-image.sh [image-name] [tag]
#   ./scripts/create-image.sh [full-image-ref]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEVKIT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

IMAGE_REF="${1:-java-agentic-devkit}"
TAG="${2:-latest}"
DOCKERFILE_ARG="${3:-.devcontainer/Dockerfile}"

if [[ $# -eq 1 && "${IMAGE_REF}" == *:* ]]; then
    FULL_IMAGE="${IMAGE_REF}"
else
    FULL_IMAGE="${IMAGE_REF}:${TAG}"
fi

if [[ "${DOCKERFILE_ARG}" = /* ]]; then
    DOCKERFILE="${DOCKERFILE_ARG}"
else
    DOCKERFILE="${DEVKIT_DIR}/${DOCKERFILE_ARG}"
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

source "${SCRIPT_DIR}/docker-utils.sh"

ensure_docker_available

echo -e "${YELLOW}Building Docker image...${NC}"
echo -e "${YELLOW}Image: ${GREEN}${FULL_IMAGE}${NC}"
echo -e "${YELLOW}Dockerfile: ${GREEN}${DOCKERFILE}${NC}"
echo -e "${YELLOW}Build context: ${GREEN}${DEVKIT_DIR}${NC}\n${NC}"

if docker build -t "${FULL_IMAGE}" -f "${DOCKERFILE}" "${DEVKIT_DIR}"; then
    echo -e "\n${GREEN}Image created successfully: ${FULL_IMAGE}${NC}\n"
    echo "Useful commands:"
    echo "  View image:     docker images | grep ${IMAGE_REF%%:*}"
    echo "  Run image:      docker run -it ${FULL_IMAGE}"
    echo "  Run bash:       docker run -it ${FULL_IMAGE} /bin/bash"
else
    echo -e "\n${RED}Error creating image${NC}"
    exit 1
fi
