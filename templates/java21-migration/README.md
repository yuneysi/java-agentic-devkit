# Java 8 To Java 21 Migration Guide

Use this template when a target project is migrating from Java 8 to Java 21.

This guide is written for developers working directly in the target project.

## Important Update

This README no longer claims that the container auto-copies `docker-compose.yml` into the target project.

You must place `docker-compose.yml` in the target project root before running the container.

## What The Target Project Must Have

Before first run, the only file you must add manually is:

- `docker-compose.yml`

On container start, the devkit creates missing migration files in the target project, including:

- `AGENTS.md`
- `.github/copilot-instructions.md`
- `docs/migration-progress-checklist.md`

Those files come from `templates/java21-migration/` and are created only when missing.

## 1) Prepare `docker-compose.yml` In The Target Project Root

Use the template Compose file from this repository and keep the service name as `devkit`.

Required environment value for migration mode:

- `DEVKIT_JAVA_TEMPLATE=java21-migration`

Reference Compose service:

```yaml
services:
  devkit:
    image: ghcr.io/yuneysi/java-agentic-devkit:latest
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

Windows PowerShell or Command Prompt volume mapping:

```yaml
    volumes:
      - .:/workspace
      - ${USERPROFILE}/.m2:/home/vscode/.m2
      - /var/run/docker.sock:/var/run/docker.sock
```

## 2) Start The Container (Recommended Flow)

Run from the target project root:

```bash
docker compose pull
docker compose run --rm devkit
```

This matches the tested migration workflow: pull image, start disposable devkit shell, run all migration work inside the container.

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

## 6) Migration Records In Target Project

Store evidence in:

- `docs/migration-results/java8-baseline/`
- `docs/migration-results/java21-candidate/`

Use the checklist as the human sign-off tracker:

- `docs/migration-progress-checklist.md`

## Reference

- Migration rules and skill behavior: `AGENTS.md`
- Human tracker and prompt checklist: `docs/migration-progress-checklist.md`
