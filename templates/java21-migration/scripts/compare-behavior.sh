#!/usr/bin/env bash

set -euo pipefail

RESULTS_DIR="${MIGRATION_RESULTS_DIR:-docs/migration-results}"

if [[ $# -eq 2 ]]; then
    BASELINE_DIR="$1"
    CANDIDATE_DIR="$2"
else
    BASELINE_DIR="$(find "${RESULTS_DIR}" -maxdepth 1 -type d -name 'java8-baseline-*' 2>/dev/null | sort | tail -1 || true)"
    CANDIDATE_DIR="$(find "${RESULTS_DIR}" -maxdepth 1 -type d -name 'java21-candidate-*' 2>/dev/null | sort | tail -1 || true)"
fi

if [[ -z "${BASELINE_DIR}" || -z "${CANDIDATE_DIR}" ]]; then
    echo "Could not find baseline and candidate result directories."
    echo "Usage: $0 [java8-baseline-dir] [java21-candidate-dir]"
    echo "Default search path: ${RESULTS_DIR}"
    exit 1
fi

BASELINE_LOG="${BASELINE_DIR}/run.log"
CANDIDATE_LOG="${CANDIDATE_DIR}/run.log"

if [[ ! -f "${BASELINE_LOG}" ]]; then
    echo "Missing baseline log: ${BASELINE_LOG}"
    exit 1
fi

if [[ ! -f "${CANDIDATE_LOG}" ]]; then
    echo "Missing candidate log: ${CANDIDATE_LOG}"
    exit 1
fi

COMPARE_DIR="${RESULTS_DIR}/comparison-$(date +%Y%m%d-%H%M%S)"
DIFF_FILE="${COMPARE_DIR}/baseline-vs-candidate.diff"
SUMMARY_FILE="${COMPARE_DIR}/summary.txt"

mkdir -p "${COMPARE_DIR}"

set +e
diff -u "${BASELINE_LOG}" "${CANDIDATE_LOG}" > "${DIFF_FILE}"
DIFF_EXIT=${PIPESTATUS[0]}
set -e

{
    echo "Java 8 baseline vs Java 21 candidate comparison"
    echo "==============================================="
    echo "Baseline: ${BASELINE_DIR}"
    echo "Candidate: ${CANDIDATE_DIR}"
    echo "Diff file: ${DIFF_FILE}"
    echo
    if [[ ${DIFF_EXIT} -eq 0 ]]; then
        echo "Result: no log differences detected."
    else
        echo "Result: differences detected. Review the diff and classify migration risk."
    fi
} | tee "${SUMMARY_FILE}"

if [[ ${DIFF_EXIT} -eq 0 ]]; then
    exit 0
fi

exit 1