#!/usr/bin/env bash
set -euo pipefail

# Check that a release version has not been used before, in Git and in Nexus.
# Usage: check-release-version <version> [groupId:artifactId]
#
# Environment:
#   NEXUS_REPOSITORY_URL  Required. Release repository URL, for example https://nexus.example.com/repository/releases/
#   NEXUS_REPOSITORY_ID   Server id in ~/.m2/settings.xml that holds the Nexus credentials (default: nexus).
#   RELEASE_ARTIFACT      groupId:artifactId of the deployed artifact (default: the project's root POM).
#
# Exit codes: 0 = version is free, 1 = version is already used, 2 = the check could not complete.
# Credentials stay in ~/.m2/settings.xml; Maven reads them, this script never does.

VERSION="${1:-}"
if [[ -z "${VERSION}" ]]; then
    echo "Usage: check-release-version <version> [groupId:artifactId]" >&2
    exit 2
fi
if [[ -z "${NEXUS_REPOSITORY_URL:-}" ]]; then
    echo "NEXUS_REPOSITORY_URL is not set. Set it on the host before you start the devkit." >&2
    exit 2
fi

USED=0

# 1. Git: release branches and tags.
if git rev-parse --git-dir > /dev/null 2>&1; then
    # Remote refs (what the team sees) plus local refs (unpushed branches and tags).
    REMOTE_REFS="$(git ls-remote --heads --tags origin 2> /dev/null || true)"
    if [[ -z "${REMOTE_REFS}" ]]; then
        echo "Could not read the remote 'origin'; checking local refs only." >&2
    fi
    ALL_REFS="${REMOTE_REFS}"$'\n'"$(git show-ref 2> /dev/null || true)"
    for REF in "heads/release/${VERSION}" "remotes/origin/release/${VERSION}" "tags/${VERSION}" "tags/release-${VERSION}" "tags/v${VERSION}"; do
        if grep -q "refs/${REF}$" <<< "${ALL_REFS}"; then
            echo "USED in Git: refs/${REF}"
            USED=1
        fi
    done
    LATEST_BRANCH="$(grep -o -E 'refs/(heads|remotes/origin)/release/[^ ]+$' <<< "${ALL_REFS}" | sed -E 's#refs/(heads|remotes/origin)/##' | sort -u | sort -V | tail -1 || true)"
    echo "Latest release branch: ${LATEST_BRANCH:-none}"
else
    echo "Not a Git repository; skipping the Git check." >&2
fi

# 2. Nexus: does the artifact already exist in this version?
ARTIFACT="${2:-${RELEASE_ARTIFACT:-}}"
if [[ -z "${ARTIFACT}" ]]; then
    ARTIFACT="$(mvn -q -N help:evaluate -Dexpression=project.groupId -DforceStdout 2> /dev/null):$(mvn -q -N help:evaluate -Dexpression=project.artifactId -DforceStdout 2> /dev/null)"
fi
if [[ ! "${ARTIFACT}" =~ ^[^:]+:[^:]+$ ]]; then
    echo "Could not determine groupId:artifactId. Pass it as the second argument or set RELEASE_ARTIFACT." >&2
    exit 2
fi

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT
# Run outside the project and with an empty local repository, so only Nexus answers.
if OUTPUT="$(cd "${WORK_DIR}" && mvn -B -U -Dmaven.repo.local="${WORK_DIR}/repo" \
    org.apache.maven.plugins:maven-dependency-plugin:3.8.1:get \
    -Dartifact="${ARTIFACT}:${VERSION}:pom" -Dtransitive=false \
    -DremoteRepositories="${NEXUS_REPOSITORY_ID:-nexus}::default::${NEXUS_REPOSITORY_URL}" 2>&1)"; then
    echo "USED in Nexus: ${ARTIFACT}:${VERSION}"
    USED=1
elif grep -q "was not found in" <<< "${OUTPUT}"; then
    echo "Free in Nexus: ${ARTIFACT}:${VERSION}"
else
    echo "Could not query Nexus (network, VPN, or credentials). Maven said:" >&2
    grep -E "^\[ERROR\]" <<< "${OUTPUT}" | grep -v -i -E "password|token" | head -3 >&2
    exit 2
fi

if [[ "${USED}" -eq 1 ]]; then
    echo "Version ${VERSION} is already used. Choose another version."
    exit 1
fi
echo "Version ${VERSION} is free."
