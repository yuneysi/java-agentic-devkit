#!/usr/bin/env bash

set -euo pipefail

RESULTS_DIR="${MIGRATION_RESULTS_DIR:-docs/migration-results}"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
RUN_DIR="${RESULTS_DIR}/java21-candidate-${TIMESTAMP}"
LOG_FILE="${RUN_DIR}/run.log"
SUMMARY_FILE="${RUN_DIR}/summary.txt"

mkdir -p "${RUN_DIR}"

if [[ -x "./mvnw" ]]; then
    MVN="./mvnw"
else
    MVN="mvn"
fi

COMMAND=("${MVN}" clean verify)
if [[ $# -gt 0 ]]; then
    COMMAND=("$@")
fi

{
    echo "Java 21 candidate run"
    echo "====================="
    echo "Timestamp: ${TIMESTAMP}"
    echo "Working directory: ${PWD}"
    echo "Command: ${COMMAND[*]}"
    echo
    echo "Java version:"
    java -version
    echo
    echo "Maven version:"
    "${MVN}" -version
    echo
    echo "Git state:"
    git status --short || true
    echo
    echo "Running validation..."
} 2>&1 | tee "${SUMMARY_FILE}"

set +e
"${COMMAND[@]}" 2>&1 | tee "${LOG_FILE}"
EXIT_CODE=${PIPESTATUS[0]}
set -e

{
    echo
    echo "Exit code: ${EXIT_CODE}"
    echo "Log file: ${LOG_FILE}"
} | tee -a "${SUMMARY_FILE}"

if [[ ${EXIT_CODE} -eq 0 ]]; then
    echo "Java 21 candidate validation passed."
else
    echo "Java 21 candidate validation failed. Review ${LOG_FILE}."
fi

exit "${EXIT_CODE}"