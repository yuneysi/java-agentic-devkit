# AGENTS.md

## Purpose

This file is the authoritative instruction file for agents working inside `java-agentic-devkit`.

The devkit is a reusable Docker-based Java development kit for:

- Java 8 target projects
- Java 21 target projects
- Java 8 to Java 21 migrations

The devkit itself stays outside target Java projects. Developers run the devkit and mount the target project at `/workspace`.

If this file conflicts with another Markdown file in this repository, this file wins.

---

## Language

Write code comments, README text, templates, prompts, and code-facing documentation in English.

Do not add repository content in Spanish or any other non-English language.

If a user requests non-English repository content, explain that this repository only accepts English content and offer to write the requested content in English.

Use concise, practical language and copy-pasteable commands.

---

## Documentation Rules

Keep root documentation minimal.

The root may contain:

- `README.md`
- `AGENTS.md`

Do not create a root-level `docs/` directory.

Do not add extra root Markdown files such as `CODING_STANDARDS.md`, migration guides, workflow guides, or notes unless the user explicitly asks for a new root document.

Put target-project documentation only inside the relevant template:

- `templates/java8/docs/java8-best-practices.md`
- `templates/java21/docs/java21-best-practices.md`
- `templates/java21-migration/docs/java21-migration-best-practices.md`

Keep `templates/README.md` short. Put main devkit usage, Compose examples, environment variables, container contents, OpenCode configuration, and template inventory in the root `README.md`.

---

## Template Rules

Each target-project template owns its own `AGENTS.md`:

- `templates/java8/AGENTS.md`
- `templates/java21/AGENTS.md`
- `templates/java21-migration/AGENTS.md`

Do not reintroduce a shared `templates/AGENTS.md`.

For target projects, `AGENTS.md` is the authoritative instruction file for OpenCode and oh-my-openagent agents.

Do not reintroduce `opencode/instructions.md`.

---

## Command Style

Use this command style in documentation:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/java/project
```

Do not document a `devkit` shell shortcut or symlink unless the user explicitly asks for that workflow.

Java 8 is the default runtime.

Use Java 21 only when the target project already runs on Java 21 or when validating a Java 8 to Java 21 migration candidate.

---

## Cross-Platform Rules

This devkit must work for developers using Docker Desktop on macOS and Windows.

When changing Dockerfiles, Docker Compose examples, container startup scripts, shell scripts, path handling, environment variables, or documented commands, validate the command flow for both macOS and Windows/WSL2.

Prefer commands, paths, quoting, environment variables, and Docker volume examples that work on both platforms.

Do not introduce macOS-only assumptions such as `${HOME}` in Windows Compose examples, `/Users/...` paths as the only documented path shape, BSD-only command flags, or host-specific Docker behavior unless the platform difference is documented.

If a command cannot be executed on the current host platform, state the limitation and document the equivalent command or expected behavior for the other platform.

For Dockerfile changes, consider both Docker Desktop for macOS and Docker Desktop for Windows when validating build context, file copy paths, line endings, executable bits, user permissions, and mounted workspace behavior.

---

## Validation

After editing JSON, validate it with `jq` when available.

After editing shell scripts, run `bash -n` on touched scripts.

After editing Dockerfiles, prefer:

```bash
docker build --check -f .devcontainer/Dockerfile .
```

When full builds are expensive, run the cheapest check that can catch the changed slice.
