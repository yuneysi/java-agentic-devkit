#!/usr/bin/env bash
set -euo pipefail

TARGET_PROJECT="${1:-$PWD}"
DEVKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE_DIR="${DEVKIT_DIR}/templates/java8"

if [[ ! -d "${TARGET_PROJECT}" ]]; then
    echo "Target project does not exist: ${TARGET_PROJECT}" >&2
    exit 1
fi

mkdir -p "${TARGET_PROJECT}/.github" "${TARGET_PROJECT}/docs"

cp "${TEMPLATE_DIR}/AGENTS.md" "${TARGET_PROJECT}/AGENTS.md"
cp "${TEMPLATE_DIR}/.github/copilot-instructions.md" "${TARGET_PROJECT}/.github/copilot-instructions.md"
cp "${TEMPLATE_DIR}/docs/java8-best-practices.md" "${TARGET_PROJECT}/docs/java8-best-practices.md"

echo "Java 8 template copied to: ${TARGET_PROJECT}"