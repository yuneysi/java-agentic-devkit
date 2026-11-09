# Java Agentic DevKit - Global Agent Instructions

The image installs this file for Claude Code (`~/.claude/CLAUDE.md`) and OpenCode (`~/.config/opencode/AGENTS.md`).

Before starting any task, read `AGENTS.md` at the root of the current project (normally `/workspace/AGENTS.md`). Treat it as the authoritative source for planning, coding, validation, and commit rules. If it conflicts with this file, `AGENTS.md` wins.

## Work Mode

Determine the work mode from the `DEVKIT_JAVA_TEMPLATE` environment variable before you plan anything:

| Value | Mode | Meaning |
|---|---|---|
| `java8` (default) | Java 8 maintenance | Keep the project on Java 8. This is not a migration. |
| `java21` | Java 21 maintenance | The project already runs on Java 21. This is not a migration. |
| `java21-migration` | Java 8 to Java 21 migration | Follow the `java21-migration` skill and its phase gates. |

In a maintenance mode, do not propose or start Java 21, Jakarta, Spring Boot 3, or Spring Framework 6 migration work, and do not load the `java21-migration` skill, unless the user asks for it explicitly.

## Specs With OpenSpec

In every mode, OpenSpec is the project knowledge base (`openspec/specs/`, `openspec/changes/archive/`).

- At the start of a session, check `openspec/specs/`. If it is empty or missing the capability the user is working on, say so and propose to capture that capability's current behavior with the `legacy-spec-baseline` skill. Do it only after the user agrees.
- Grow specs one capability at a time, as tasks touch them. Never bulk-generate specs for the whole codebase.
- For a change that alters behavior, contracts, or integrations, propose `/opsx:propose` (Claude Code) or `/opsx-propose` (OpenCode) before you write code.
- If `openspec/` does not exist, propose running `openspec init --tools opencode,claude`.

## Defaults When The Project Has No AGENTS.md

Say that the project has no `AGENTS.md`, then follow these defaults:

- Treat the code as legacy code that must keep its current behavior. Inspect before you edit, and add characterization tests before you refactor risky code.
- Java 8 is the default runtime. Use `use-java21` only in the `java21` mode or when you validate a migration candidate.
- For Java 8 projects, preserve javax APIs, the existing Spring and Spring Boot versions, and SOAP wire contracts.
- Before implementation, load the `git-commit` skill and plan small checkpoints that can be verified. Commit only when the user authorizes commits for the task. Never push without explicit authorization.
- Use `verification-before-completion` before you report that work is complete.

Write code, comments, and documentation in English.

The devkit skills are installed in `~/.claude/skills/` and `~/.config/opencode/skills/`.
