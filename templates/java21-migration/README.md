# Java 8 To Java 21 Migration Guide

> Human-facing guide only. Agents must follow `AGENTS.md` as the authoritative instruction file.

Use this template when a target project is migrating from Java 8 to Java 21.

This guide is written for developers working directly in the target project.

## What The Target Project Must Have

Before first run, place one startup config in the target project root:

- `docker-compose.yml` (recommended for team-shared startup)
- `.devcontainer/devcontainer.json` (VS Code Dev Containers without Compose)

On container start, the devkit creates missing migration files from `templates/java21-migration/`, including:

- `AGENTS.md`
- `.github/copilot-instructions.md`
- `docs/migration-progress-checklist.md`
- `opencode/memory/architecture.md`
- `opencode/memory/decisions.md`
- `opencode/memory/status.md`

Migration-specific skill content is kept in:

- `skills/java21-migration/SKILL.md`

If these files do not appear in the target project after container start, verify `DEVKIT_BOOTSTRAP_TEMPLATES=true` and that `DEVKIT_JAVA_TEMPLATE=java21-migration`.

## 1) Prepare Startup Configuration In The Target Project Root

Choose one option.

### Option A: `docker-compose.yml` (recommended)

Use the template Compose file from this repository and keep the service name as `devkit`.

Required environment value for migration mode:

- `DEVKIT_JAVA_TEMPLATE=java21-migration`

Get the Compose file without cloning the devkit. From the target project root, the image copies its missing template files, including `docker-compose.yml`:

```bash
docker run --rm -v "$PWD:/workspace" -e DEVKIT_JAVA_TEMPLATE=java21-migration -e DEVKIT_BOOTSTRAP_TEMPLATES=true ghcr.io/yuneysi/java-agentic-devkit:latest true
```

In Windows PowerShell, use `"${PWD}:/workspace"`.

Reference Compose service:

```yaml
# Project-owned launcher for java-agentic-devkit. Start it from the project folder:
#   docker compose run --rm --service-ports devkit
# Pin a version for reproducible sessions, for example DEVKIT_IMAGE=ghcr.io/yuneysi/java-agentic-devkit:0.1.42
services:
  devkit:
    image: ${DEVKIT_IMAGE:-ghcr.io/yuneysi/java-agentic-devkit:latest}
    working_dir: /workspace
    environment:
      DEVKIT_PROJECT_DIR: /workspace
      DEVKIT_JAVA_TEMPLATE: java21-migration
      # Copies missing template files on start; never overwrites. Set to false to skip.
      DEVKIT_BOOTSTRAP_TEMPLATES: ${DEVKIT_BOOTSTRAP_TEMPLATES:-true}
      MAVEN_OPTS: -Dmaven.repo.local=/home/vscode/.m2/repository
      # Optional: enables the GitHub MCP server. Empty when unset on the host.
      GITHUB_TOKEN: ${GITHUB_TOKEN:-}
    volumes:
      - .:/workspace
      # HOME on macOS, Linux, and WSL; USERPROFILE on Windows PowerShell and Command Prompt.
      - ${HOME:-${USERPROFILE}}/.m2:/home/vscode/.m2
      # Optional, for Testcontainers or Docker-in-Docker workflows only. The socket gives the
      # container and its AI agents control of the host Docker engine (root-equivalent).
      # - /var/run/docker.sock:/var/run/docker.sock
    ports:
      # Bound to 127.0.0.1 so the application is not exposed on the network.
      - "127.0.0.1:${DEVKIT_APP_PORT:-8080}:${DEVKIT_APP_PORT:-8080}"
      - "127.0.0.1:${DEVKIT_DEBUG_PORT:-5005}:5005"
    stdin_open: true
    tty: true
    command: /bin/bash
```

The same file works on macOS, Linux, WSL2, and Windows shells: the image is published for `linux/amd64` and `linux/arm64`, and the Maven mount falls back from `HOME` to `USERPROFILE`.

### Option B: `.devcontainer/devcontainer.json` (no Compose)

If you prefer VS Code Dev Containers directly, create this file in the target project root.

Linux and macOS example:

```json
{
  "name": "Java Agentic DevKit - Java 8 To Java 21 Migration",
  "image": "ghcr.io/yuneysi/java-agentic-devkit:latest",
  "remoteUser": "vscode",
  "workspaceFolder": "/workspace",
  "overrideCommand": false,
  "containerEnv": {
    "DEVKIT_PROJECT_DIR": "/workspace",
    "DEVKIT_JAVA_TEMPLATE": "java21-migration",
    "DEVKIT_BOOTSTRAP_TEMPLATES": "true",
    "MAVEN_OPTS": "-Dmaven.repo.local=/home/vscode/.m2/repository"
  },
  "forwardPorts": [8080, 5005],
  "mounts": [
    "source=${localEnv:HOME}/.m2,target=/home/vscode/.m2,type=bind"
  ],
  "postStartCommand": "bash -lc 'use-java8 && java -version && mvn -v'"
}
```

Windows example using `USERPROFILE`:

```json
{
  "name": "Java Agentic DevKit - Java 8 To Java 21 Migration",
  "image": "ghcr.io/yuneysi/java-agentic-devkit:latest",
  "remoteUser": "vscode",
  "workspaceFolder": "/workspace",
  "overrideCommand": false,
  "containerEnv": {
    "DEVKIT_PROJECT_DIR": "/workspace",
    "DEVKIT_JAVA_TEMPLATE": "java21-migration",
    "DEVKIT_BOOTSTRAP_TEMPLATES": "true",
    "MAVEN_OPTS": "-Dmaven.repo.local=/home/vscode/.m2/repository"
  },
  "forwardPorts": [8080, 5005],
  "mounts": [
    "source=${localEnv:USERPROFILE}/.m2,target=/home/vscode/.m2,type=bind"
  ],
  "postStartCommand": "bash -lc 'use-java8 && java -version && mvn -v'"
}
```

## 2) Start The Container

For `docker-compose.yml`:

Run from the target project root:

```bash
docker compose pull
docker compose run --rm --service-ports devkit
```

This matches the tested migration workflow: pull image, start disposable devkit shell, run all migration work inside the container.

For `.devcontainer/devcontainer.json`:

Open the target project in VS Code and run `Dev Containers: Reopen in Container`.

## 3) Start OpenCode Inside The Container

From `/workspace` inside the container:

```bash
opencode
```

Quick runtime notes for target projects:

- default orchestrator is `sisyphus`
- if the UI agent label changes after provider selection, switch back to `sisyphus` in the agent picker
- OpenCode binary path in container: `/usr/local/bin/opencode`
- OpenCode config path in container: `/home/vscode/.config/opencode/opencode.json`

## 4) Start The Migration

First initialize the target project's shared memory with the `project-architecture-memory-writer` skill. Template seed values must be replaced with verified project facts.

Then use one short prompt:

```text
Start the Java 21 migration.
```

The migration skill determines the next valid phase from recorded state and evidence. Track human review in `docs/migration-progress-checklist.md`; do not copy phase instructions into the tracker.

## 5) Migration Records In Target Project

Store evidence in:

- `docs/migration-results/java8-baseline/`
- `docs/migration-results/java21-candidate/`

Use the checklist as the human sign-off tracker:

- `docs/migration-progress-checklist.md`

## Reference

- Project-wide agent rules: `AGENTS.md`
- Migration workflow skill: `skills/java21-migration/SKILL.md`
- Human sign-off tracker: `docs/migration-progress-checklist.md`

## Troubleshooting

- `AGENTS.md` or checklist files missing:
  - confirm `DEVKIT_BOOTSTRAP_TEMPLATES=true`
  - confirm `DEVKIT_JAVA_TEMPLATE=java21-migration`
- memory files missing under `opencode/memory/`:
  - restart container with bootstrap enabled
  - run preflight initialization before planning/implementation
