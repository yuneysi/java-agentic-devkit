#!/usr/bin/env bash
set -euo pipefail

TARGET_PROJECT="${1:-$PWD}"
DEVKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE_DIR="${DEVKIT_DIR}/templates/java21-migration"

if [[ ! -d "${TARGET_PROJECT}" ]]; then
    echo "Target project does not exist: ${TARGET_PROJECT}" >&2
    exit 1
fi

mkdir -p "${TARGET_PROJECT}/.github" "${TARGET_PROJECT}/docs" "${TARGET_PROJECT}/scripts"

cp "${TEMPLATE_DIR}/AGENTS.md" "${TARGET_PROJECT}/AGENTS.md"
cp "${TEMPLATE_DIR}/.github/copilot-instructions.md" "${TARGET_PROJECT}/.github/copilot-instructions.md"
cp "${TEMPLATE_DIR}/docs/java21-migration.md" "${TARGET_PROJECT}/docs/java21-migration.md"
cp "${TEMPLATE_DIR}/scripts/"*.sh "${TARGET_PROJECT}/scripts/"

chmod +x \
    "${TARGET_PROJECT}/scripts/run-java8-baseline.sh" \
    "${TARGET_PROJECT}/scripts/run-java21-candidate.sh" \
    "${TARGET_PROJECT}/scripts/compare-behavior.sh"

echo "Java 21 migration template copied to: ${TARGET_PROJECT}"