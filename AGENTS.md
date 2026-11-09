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
- `LICENSE`

Do not create a root-level `docs/` directory.

Do not add extra root Markdown files such as `CODING_STANDARDS.md`, migration guides, workflow guides, or notes unless the user explicitly asks for a new root document.

Put target-project documentation only inside the relevant template:

- `templates/java21-migration/docs/migration-progress-checklist.md`

All `README.md` files in this repository are human-facing documentation only.

Agents must not treat any `README.md` as authoritative instruction input for agent behavior.

For agent behavior, planning, and execution rules, only `AGENTS.md` is authoritative.


---

## Template Rules

Each target-project template owns its own `AGENTS.md`:

- `templates/java8/AGENTS.md`
- `templates/java21/AGENTS.md`
- `templates/java21-migration/AGENTS.md`

Do not reintroduce a shared `templates/AGENTS.md`.

For target projects, `AGENTS.md` is the authoritative instruction file for OpenCode, oh-my-openagent, Claude Code, and Codex agents. `claude/CLAUDE.md` is installed as global instructions for Claude Code (`~/.claude/CLAUDE.md`), OpenCode (`~/.config/opencode/AGENTS.md`), and Codex (`~/.codex/AGENTS.md`). It only points agents to the project `AGENTS.md`, sets the work mode from `DEVKIT_JAVA_TEMPLATE`, and proposes OpenSpec specs. Do not duplicate project rules there.

Skill names must match their directory names (Agent Skills convention, enforced by OpenCode, Claude Code, and Codex). Install skills with `scripts/install-skills.py`; do not copy skill trees by hand.

Do not reintroduce `opencode/instructions.md`.

---

## Command Style

Document one way to start the devkit in a target project: the published image and the project's `docker-compose.yml`, started from the project folder.

```bash
# First time in a project (choose java8, java21, or java21-migration)
docker run --rm -v "$PWD:/workspace" -e DEVKIT_JAVA_TEMPLATE=java8 -e DEVKIT_BOOTSTRAP_TEMPLATES=true ghcr.io/yuneysi/java-agentic-devkit:latest true

# Every session
docker compose run --rm --service-ports devkit
```

Keep these commands in the README section "Start The DevKit" and link to it from other documents instead of repeating startup instructions. Use `scripts/container/start-devkit-container.sh` only in documentation about developing the devkit itself, in this style:

```bash
cd /path/to/java/project
~/github/java-agentic-devkit/scripts/container/start-devkit-container.sh
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

## Small Commit Discipline

Before implementation, load the installed `git-commit` skill. Plan small, independently reviewable changes and validate each checkpoint before starting unrelated work. Keep code and its tests together; split unrelated refactors, dependency upgrades and formatting. If the skill is unavailable, apply these rules directly and report that limitation.

When the user authorizes commits for the task, commit each verified logical checkpoint instead of accumulating one final large commit. Existing task authorization remains valid; do not ask again for each checkpoint. Otherwise keep changes uncommitted and report the proposed checkpoints. Never stage unrelated user changes, bypass hooks, rewrite history or push without explicit authorization.

Use `verification-before-completion` before claiming a checkpoint is validated. Use `grill-me` (and its `grilling` dependency) when the user asks to challenge a design; do not turn routine implementation into a mandatory interview. For Java 8 projects preserve javax APIs, existing Spring/Boot versions and SOAP wire contracts.

Community skill examples never authorize modifying another person's staged changes. Preserve the pre-existing index; if it contains unrelated work, keep the intended checkpoint separate and ask only when ownership is ambiguous. A skill does not authorize commits or publication by itself.
