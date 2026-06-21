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
- `docs/java21-migration-guide.md` (copy of this guide)
- `docs/migration-progress-checklist.md`
- `opencode/memory/architecture.md`
- `opencode/memory/decisions.md`
- `opencode/memory/status.md`

## 1) Prepare Startup Configuration In The Target Project Root

Choose one option.

### Option A: `docker-compose.yml` (recommended)

Use the template Compose file from this repository and keep the service name as `devkit`.

Required environment value for migration mode:

- `DEVKIT_JAVA_TEMPLATE=java21-migration`

Reference Compose service:

```yaml
services:
  devkit:
    image: ghcr.io/yuneysi/java-agentic-devkit:latest
    platform: linux/amd64
    working_dir: /workspace
    environment:
      DEVKIT_PROJECT_DIR: /workspace
      DEVKIT_JAVA_TEMPLATE: java21-migration
      MAVEN_OPTS: -Dmaven.repo.local=/home/vscode/.m2/repository
    volumes:
      - .:/workspace
      - ${HOME}/.m2:/home/vscode/.m2
      - /var/run/docker.sock:/var/run/docker.sock
    stdin_open: true
    tty: true
    command: /bin/bash
```

For macOS users, keep `platform: linux/amd64` in the Compose service.

For Windows users, remove `platform: linux/amd64`.

Windows PowerShell or Command Prompt volume mapping:

```yaml
    volumes:
      - .:/workspace
      - ${USERPROFILE}/.m2:/home/vscode/.m2
      - /var/run/docker.sock:/var/run/docker.sock
```

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
    "source=${localEnv:HOME}/.m2,target=/home/vscode/.m2,type=bind",
    "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind"
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
    "source=${localEnv:USERPROFILE}/.m2,target=/home/vscode/.m2,type=bind",
    "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind"
  ],
  "postStartCommand": "bash -lc 'use-java8 && java -version && mvn -v'"
}
```

## 2) Start The Container

For `docker-compose.yml`:

Run from the target project root:

```bash
docker compose pull
docker compose run --rm devkit
```

This matches the tested migration workflow: pull image, start disposable devkit shell, run all migration work inside the container.

For `.devcontainer/devcontainer.json`:

Open the target project in VS Code and run `Dev Containers: Reopen in Container`.

## 3) Start OpenCode Inside The Container

From `/workspace` inside the container:

```bash
opencode
```

For OpenCode and oh-my-openagent behavior details, use `opencode/README.md`.

That guide covers:

- default `sisyphus` orchestration and how to switch back to it
- why the UI can change after selecting another agent
- config and binary paths inside the container

## 4) Prompt Flow That Works Well

Use short prompts. `AGENTS.md` contains the detailed rules.

Recommended sequence:

1. Baseline capture:

```text
Use the java8-baseline-capture-phase skill.
```

2. Characterization tests after baseline (when suggested):

```text
Use the java8-characterization-test-phase skill.
```

3. Migration planning:

```text
Use the java21-migration-planning-phase skill.
```

4. Small implementation step:

```text
Use the java21-migration-implementation-phase skill.
Apply the next planned small migration step.
```

5. Candidate validation:

```text
Use the java21-candidate-validation-phase skill.
```

Track progress in `docs/migration-progress-checklist.md` during each step.

## 5) Migration Records In Target Project

Store evidence in:

- `docs/migration-results/java8-baseline/`
- `docs/migration-results/java21-candidate/`

Use the checklist as the human sign-off tracker:

- `docs/migration-progress-checklist.md`

## Reference

- Migration rules and skill behavior: `AGENTS.md`
- Human tracker and prompt checklist: `docs/migration-progress-checklist.md`
