#!/bin/bash

ensure_docker_available() {
    if ! command -v docker > /dev/null 2>&1; then
        echo -e "${RED}❌ Docker CLI is not installed or is not on PATH${NC}"
        echo -e "${YELLOW}Install Docker Desktop, then run this script again.${NC}"
        exit 1
    fi

    if docker info > /dev/null 2>&1; then
        return 0
    fi

    echo -e "${YELLOW}⚠️  Docker daemon is not running.${NC}"

    if [[ "$(uname -s)" == "Darwin" && -d "/Applications/Docker.app" ]]; then
        echo -e "${YELLOW}Starting Docker Desktop...${NC}"
        open -ga Docker

        for _ in {1..60}; do
            if docker info > /dev/null 2>&1; then
                echo -e "${GREEN}✅ Docker daemon is running${NC}\n"
                return 0
            fi
            sleep 2
        done
    fi

    echo -e "${RED}❌ Cannot connect to the Docker daemon.${NC}"
    echo -e "${YELLOW}Start Docker Desktop and wait until it is ready, then run this script again.${NC}"
    exit 1
}