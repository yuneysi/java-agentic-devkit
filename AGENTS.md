# AGENTS.md

## Purpose

This repository is `java-agentic-devkit`.

It is a reusable Docker-based Java development kit and template repository for teams working with:

- Java 8 projects
- Java 21 projects
- Java 8 to Java 21 migrations

Act as a senior Java enterprise engineer, tooling maintainer, documentation editor, and regression-focused reviewer.

This file is the authoritative instruction file for agents working in this repository.

If this file conflicts with another Markdown file, this file wins.

---

## Repository Ownership

This repository owns:

- Docker image definitions under `.devcontainer/`
- startup and build scripts under `scripts/`
- OpenCode configuration under `opencode/`
- reusable project templates under `templates/`
- human documentation under `docs/`

The devkit itself should stay outside target Java projects. Developers run the devkit and pass the target project path to it.

---

## Language and Documentation

Write code comments, README text, and code-facing documentation in English.

Use concise, friendly, practical documentation.

Prefer copy-pasteable commands.

Keep examples consistent. Use this command style:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/java/project
```

Do not document a `devkit` shell shortcut or symlink unless the user explicitly asks for one.

---

## Java Defaults

Java 8 is the default runtime.

Use Java 21 only when explicitly requested or when the documented workflow requires Java 21 validation.

Examples:

```bash
./scripts/container/start-devkit-container.sh /path/to/java/project
./scripts/container/start-devkit-container.sh /path/to/java/project java8
./scripts/container/start-devkit-container.sh /path/to/java/project java21
```

---

## Templates

This repository has three target-project templates:

| Template | Use when |
|----------|----------|
| `templates/java8/` | The target project stays on Java 8. |
| `templates/java21/` | The target project already runs on Java 21. |
| `templates/java21-migration/` | The target project is migrating from Java 8 to Java 21. |

`templates/AGENTS.md` is the single shared `AGENTS.md` template for target projects.

The root `AGENTS.md` in this repository is not visible to target Java projects. Put target-project agent behavior, migration rules, validation rules, and prompts in `templates/AGENTS.md` or the files under `templates/`.

Do not add separate `AGENTS.md` files under `templates/java8/`, `templates/java21/`, or `templates/java21-migration/`.

For target projects, `AGENTS.md` is the authoritative instruction file for OpenCode and oh-my-opencode agents.

Do not reintroduce `opencode/instructions.md` unless the user explicitly decides to restore that model.

---

## OpenCode Configuration

`opencode/opencode.json` should reference the default project mount:

```json
"instructions": [
  "{file:/workspace/AGENTS.md}"
]
```

The container entrypoint rewrites this reference at startup when `DEVKIT_PROJECT_DIR` points to a different mounted project path.

Do not point OpenCode back to `instructions.md`.

When updating OpenCode skills, describe `AGENTS.md` as the authoritative agent instruction file.

---

## Dockerfile Rules

Prefer Windows-friendly Dockerfile patterns.

When generating helper scripts or shell config inside Dockerfiles, use `printf '%s\n' ... > file` instead of heredocs such as `cat <<EOF`.

This avoids CRLF and heredoc issues for Windows contributors.

Keep Docker downloads robust:

- write downloaded archives with `-o /tmp/file.tar.gz`
- use fallback URLs where practical
- fail clearly when an unsupported architecture is detected

Do not add Dockerfile `COPY` commands for files that are generated, deleted, or template-only.

---

## Script Rules

Shell scripts should be Bash scripts with:

```bash
#!/usr/bin/env bash
set -euo pipefail
```

Keep scripts focused and predictable.

Validate Docker availability before Docker build/run operations.

Preserve the existing public command style:

```bash
./scripts/container/start-devkit-container.sh /path/to/project [java8|java21|java21-migration]
```

---

## Documentation Structure

Keep `docs/` focused:

- `docs/README.md` is the general devkit guide.
- `docs/JAVA8_TO_JAVA21_MIGRATION.md` is the migration workflow guide.

Keep `templates/README.md` as the template inventory and generated-file reference.

Do not add extra top-level workflow docs unless the user explicitly asks for them.

---

## Validation

After editing JSON, validate it with `jq` when available.

After editing shell scripts, run `bash -n` on the touched scripts.

After editing Dockerfiles, prefer:

```bash
docker build --check -f .devcontainer/Dockerfile .
```

When full builds are expensive, run the cheapest check that can catch the changed slice.

---

## Change Discipline

Keep changes small and scoped to the user's request.

Do not revert unrelated user changes.

Do not force push or rewrite Git history.

Before finalizing, keep references aligned with the current repository structure.

Use `AGENTS.md`, `docs/README.md`, `docs/JAVA8_TO_JAVA21_MIGRATION.md`, `templates/README.md`, and the scripts under `scripts/` as the source of truth.

Do not document `devkit ~/...` shortcut examples unless the user explicitly asks for that workflow.
