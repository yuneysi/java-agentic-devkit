#!/usr/bin/env bash
set -euo pipefail

# Start the Java Agentic DevKit container for a target project.
# Usage: ./scripts/container/start-devkit-container.sh [mount-path] [java8|java21|java21-migration]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEVKIT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

source "${DEVKIT_DIR}/scripts/docker-utils.sh"

normalize_mount_path() {
    local path="$1"

    if [[ "${path}" == "." ]]; then
        cd "${path}" && pwd
        return
    fi

    if [[ "${path}" =~ ^[A-Za-z]:[\\/].* ]]; then
        if command -v wslpath > /dev/null 2>&1; then
            wslpath -u "${path}"
            return
        fi

        if command -v cygpath > /dev/null 2>&1; then
            cygpath -u "${path}"
            return
        fi
    fi

    printf '%s\n' "${path}"
}

MOUNT_PATH="${1:-.}"
JAVA_VERSION="${2:-java8}"
IMAGE_NAME="java-agentic-devkit"
TAG="latest"
FULL_IMAGE="${IMAGE_NAME}:${TAG}"

printf '%b\n' "${BLUE}===========================================================${NC}"
printf '%b\n' "${BLUE}   Java Agentic DevKit - Start${NC}"
printf '%b\n\n' "${BLUE}===========================================================${NC}"

ensure_docker_available

printf '%b\n' "${YELLOW}Checking Docker image...${NC}"
if docker image inspect "${FULL_IMAGE}" > /dev/null 2>&1; then
    printf '%b\n\n' "${GREEN}Image already exists: ${FULL_IMAGE}${NC}"
else
    printf '%b\n' "${YELLOW}Building image: ${FULL_IMAGE}${NC}"
    docker build -t "${FULL_IMAGE}" -f "${DEVKIT_DIR}/.devcontainer/Dockerfile" "${DEVKIT_DIR}" > /dev/null 2>&1
    printf '%b\n\n' "${GREEN}Image built successfully${NC}"
fi

printf '%b\n' "${YELLOW}Preparing project mount...${NC}"
MOUNT_PATH="$(normalize_mount_path "${MOUNT_PATH}")"

if [[ ! -d "${MOUNT_PATH}" ]]; then
    printf '%b\n' "${RED}Directory does not exist: ${MOUNT_PATH}${NC}"
    if [[ "${MOUNT_PATH}" =~ ^[A-Za-z]:[^\\/].* ]]; then
        printf '%b\n' "${YELLOW}Tip: use forward slashes for Windows paths, for example C:/Git/2026/27801_arus${NC}"
    fi
    exit 1
fi

MOUNT_PATH="$(cd "${MOUNT_PATH}" && pwd)"
CONTAINER_MOUNT="/workspace"

printf '%b\n' "${GREEN}Mounting: ${MOUNT_PATH}${NC}"
printf '%b\n\n' "${GREEN}Container path: ${CONTAINER_MOUNT}${NC}"

printf '%b\n' "${YELLOW}Setting Java mode: ${JAVA_VERSION}${NC}"
case "${JAVA_VERSION}" in
    java8)
        JAVA_SETUP="use-java8"
        printf '%b\n\n' "${GREEN}Using Java 8${NC}"
        ;;
    java21)
        JAVA_SETUP="use-java21"
        printf '%b\n\n' "${GREEN}Using Java 21${NC}"
        ;;
    java21-migration)
        JAVA_SETUP="use-java8"
        printf '%b\n\n' "${GREEN}Using Java 8 for the Java 21 migration baseline${NC}"
        ;;
    *)
        printf '%b\n' "${RED}Invalid Java version: ${JAVA_VERSION}${NC}"
        printf '%b\n' "${YELLOW}Supported: java8, java21, java21-migration${NC}"
        exit 1
        ;;
esac

printf '%b\n' "${BLUE}===========================================================${NC}"
printf '%b\n\n' "${YELLOW}Starting container...${NC}"

docker run -it --rm \
    -e "DEVKIT_JAVA_VERSION=${JAVA_VERSION}" \
    -e "DEVKIT_PROJECT_DIR=${CONTAINER_MOUNT}" \
    -v "${MOUNT_PATH}:${CONTAINER_MOUNT}" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    "${FULL_IMAGE}" \
    /bin/bash -c "
        ${JAVA_SETUP}
        cd \"${CONTAINER_MOUNT}\"

        echo ''
        echo '============================================================'
        echo ' Java Agentic DevKit - Ready'
        echo '============================================================'
        echo ''
        echo 'Project: ${CONTAINER_MOUNT}'
        echo -n 'Java: '
        java -version 2>&1 | head -1
        echo ''
        echo 'Available commands:'
        echo '  use-java8       - Switch to Java 8'
        echo '  use-java21      - Switch to Java 21'
        echo '  mvn clean verify'
        echo '  opencode'
        echo '  start-tomcat9'
        echo '  start-activemq'
        echo ''

        bash
    "

printf '%b\n' "${GREEN}Container session ended${NC}"
printf '%b\n' "${BLUE}===========================================================${NC}"
