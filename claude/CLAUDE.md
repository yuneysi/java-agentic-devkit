# Java Agentic DevKit - Claude Code Instructions

Before starting any task, read `AGENTS.md` at the root of the current project (normally `/workspace/AGENTS.md`). Treat it as the authoritative source for planning, coding, validation, and commit rules. If it conflicts with this file, `AGENTS.md` wins.

If the project has no `AGENTS.md`, say so and follow these defaults:

- Treat the code as legacy code that must keep its current behavior. Inspect before you edit, and add characterization tests before you refactor risky code.
- Java 8 is the default runtime. Use `use-java21` only when the project already runs on Java 21 or when you validate a Java 8 to Java 21 migration candidate.
- For Java 8 projects, preserve javax APIs, the existing Spring and Spring Boot versions, and SOAP wire contracts.
- Before implementation, load the `git-commit` skill and plan small checkpoints that can be verified. Commit only when the user authorizes commits for the task. Never push without explicit authorization.
- Use `verification-before-completion` before you report that work is complete.

Write code, comments, and documentation in English.

The devkit skills are installed in `~/.claude/skills/`. The `java21-migration` skill orchestrates migration phases. The phase instructions are in its `phases/` directory.
