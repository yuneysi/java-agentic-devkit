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

Do not add Spanish text to repository files unless the user explicitly asks for Spanish content in a specific file.

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

For target projects, `AGENTS.md` is the authoritative instruction file for OpenCode and oh-my-opencode agents.

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

## Validation

After editing JSON, validate it with `jq` when available.

After editing shell scripts, run `bash -n` on touched scripts.

After editing Dockerfiles, prefer:

```bash
docker build --check -f .devcontainer/Dockerfile .
```

When full builds are expensive, run the cheapest check that can catch the changed slice.
