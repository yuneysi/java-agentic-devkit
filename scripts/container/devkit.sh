#!/usr/bin/env bash

# Start the Java Agentic DevKit - builds image and runs container
# Usage: ./scripts/container/devkit.sh [mount-path] [java-version]
# 
# Examples:
#   ./scripts/container/devkit.sh                    # Uses current directory
#   ./scripts/container/devkit.sh /path/to/project   # Mount specific project
#   ./scripts/container/devkit.sh . java21           # Use Java 21

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEVKIT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

source "${DEVKIT_DIR}/scripts/docker-utils.sh"

normalize_mount_path() {
    local path="$1"

    if [[ "$path" == "." ]]; then
        cd "$path" && pwd
        return
    fi

    if [[ "$path" =~ ^[A-Za-z]:[\\/].* ]]; then
        if command -v wslpath > /dev/null 2>&1; then
            wslpath -u "$path"
            return
        fi

        if command -v cygpath > /dev/null 2>&1; then
            cygpath -u "$path"
            return
        fi
    fi

    printf '%s\n' "$path"
}

# Default values
MOUNT_PATH="${1:-.}"
JAVA_VERSION="${2:-java8}"
IMAGE_NAME="java-agentic-devkit"
TAG="latest"
FULL_IMAGE="${IMAGE_NAME}:${TAG}"

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   Java Agentic DevKit - Start${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

ensure_docker_available

# Step 1: Check if image exists
echo -e "${YELLOW}1️⃣  Checking Docker image...${NC}"
if docker image inspect "${FULL_IMAGE}" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Image already exists: ${FULL_IMAGE}${NC}\n"
else
    echo -e "${YELLOW}📦 Building image: ${FULL_IMAGE}${NC}"
    docker build -t "${FULL_IMAGE}" -f "${DEVKIT_DIR}/.devcontainer/Dockerfile" "${DEVKIT_DIR}" > /dev/null 2>&1
    echo -e "${GREEN}✅ Image built successfully${NC}\n"
fi

# Step 2: Resolve absolute mount path
echo -e "${YELLOW}2️⃣  Preparing project mount...${NC}"
MOUNT_PATH="$(normalize_mount_path "$MOUNT_PATH")"

if [ ! -d "$MOUNT_PATH" ]; then
    echo -e "${RED}❌ Directory does not exist: $MOUNT_PATH${NC}"
    if [[ "$MOUNT_PATH" =~ ^[A-Za-z]:[^\\/].* ]]; then
        echo -e "${YELLOW}   Tip: use forward slashes for Windows paths, for example C:/Git/2026/27801_arus${NC}"
    fi
    exit 1
fi

MOUNT_PATH="$(cd "$MOUNT_PATH" && pwd)"

CONTAINER_MOUNT="/workspace"
echo -e "${GREEN}✅ Mounting: ${MOUNT_PATH}${NC}"
echo -e "${GREEN}   at: ${CONTAINER_MOUNT}${NC}\n"

# Step 3: Set up Java environment
echo -e "${YELLOW}3️⃣  Setting up Java environment: ${JAVA_VERSION}${NC}"
case "$JAVA_VERSION" in
    java8)
        JAVA_SETUP="use-java8"
        echo -e "${GREEN}✅ Using Java 8${NC}\n"
        ;;
    java21)
        JAVA_SETUP="use-java21"
        echo -e "${GREEN}✅ Using Java 21${NC}\n"
        ;;
    *)
        echo -e "${RED}❌ Invalid Java version: $JAVA_VERSION${NC}"
        echo -e "${YELLOW}   Supported: java8, java21${NC}"
        exit 1
        ;;
esac

TEMPLATE_DIR="$(cd "${DEVKIT_DIR}/templates/${JAVA_VERSION}" && pwd)"
if [[ -f "${MOUNT_PATH}/AGENTS.md" ]]; then
    echo -e "${GREEN}✅ AGENTS.md already exists${NC}\n"
else
    cp "${TEMPLATE_DIR}/AGENTS.md" "${MOUNT_PATH}/AGENTS.md"
    echo -e "${GREEN}✅ Created AGENTS.md from ${JAVA_VERSION} template${NC}\n"
fi

# Step 4: Start container
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}4️⃣  Starting container...${NC}\n"

docker run -it --rm \
    -e "DEVKIT_JAVA_VERSION=${JAVA_VERSION}" \
    -e "DEVKIT_PROJECT_DIR=${CONTAINER_MOUNT}" \
    -v "${MOUNT_PATH}:${CONTAINER_MOUNT}" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    "${FULL_IMAGE}" \
    /bin/bash -c "
        # Switch to correct Java version
        ${JAVA_SETUP}
        
        # Navigate to project
        cd "${CONTAINER_MOUNT}"
        
        # Print welcome message
        echo ''
        echo -e '${GREEN}╔════════════════════════════════════════════════════════════╗${NC}'
        echo -e '${GREEN}║  Java Agentic DevKit - Ready to Work                       ║${NC}'
        echo -e '${GREEN}╚════════════════════════════════════════════════════════════╝${NC}'
        echo ''
        echo -e '${YELLOW}📁 Project:${NC} ${CONTAINER_MOUNT}'
        echo -e '${YELLOW}☕ Java:${NC} '
        java -version 2>&1 | head -1
        echo ''
        echo -e '${YELLOW}Available Commands:${NC}'
        echo -e '  ${BLUE}use-java8${NC}         - Switch to Java 8'
        echo -e '  ${BLUE}use-java21${NC}       - Switch to Java 21'
        echo -e '  ${BLUE}mvn clean install${NC} - Build with Maven'
        echo -e '  ${BLUE}opencode${NC}         - Start AI agent framework'
        echo -e '  ${BLUE}start-tomcat9${NC}    - Start Tomcat 9'
        echo -e '  ${BLUE}start-activemq${NC}   - Start ActiveMQ'
        echo ''
        echo -e '${YELLOW}AI Providers:${NC}'
        echo -e '  ${BLUE}Claude${NC}           - export ANTHROPIC_API_KEY=...'
        echo -e '  ${BLUE}OpenAI${NC}           - export OPENAI_API_KEY=...'
        echo -e '  ${BLUE}GitHub Copilot${NC}   - export GITHUB_TOKEN=...'
        echo -e '  ${BLUE}Ollama${NC}           - http://host.docker.internal:11434'
        echo ''
        
        # Start interactive shell
        bash
    "

echo -e "\n${GREEN}✅ Container session ended${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"
