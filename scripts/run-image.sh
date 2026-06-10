#!/bin/bash

# Script to run a Docker image
# Usage: ./scripts/run-image.sh [image:tag] [command]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
IMAGE="${1:-java-agentic-devkit:latest}"
COMMAND="${2:-/bin/bash}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

source "${SCRIPT_DIR}/docker-utils.sh"

ensure_docker_available

echo -e "${YELLOW}🚀 Running Docker image...${NC}"
echo -e "${BLUE}Image: ${GREEN}${IMAGE}${NC}"
echo -e "${BLUE}Command: ${GREEN}${COMMAND}${NC}\n${NC}"

# Check if image exists
if ! docker image inspect "${IMAGE}" > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: Image '${IMAGE}' does not exist${NC}"
    echo -e "${YELLOW}Available images:${NC}"
    docker images
    exit 1
fi

# Run the container
echo -e "${YELLOW}Starting container...${NC}\n"
docker run -it --rm "${IMAGE}" ${COMMAND}

echo -e "\n${GREEN}✅ Container finished${NC}"
