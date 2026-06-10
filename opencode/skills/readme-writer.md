# README Writer Skill

Use this skill when the user asks to create, update, simplify, or review the repository `README.md`.

## Goal

Create a concise `README.md` for human developers.

The README is not an agent instruction file.

## Rules

- Do not duplicate the full migration guide.
- Do not copy all OpenCode agent rules into the README.
- Keep the README short and practical.
- Link to detailed documentation instead of repeating it.
- Do not modify production code.
- Only create or update documentation files unless explicitly asked otherwise.
- Keep commands copy-paste friendly for macOS, Windows, Docker, Podman, and WSL users.
- Clearly separate human documentation from OpenCode agent instructions.

## README Should Include

- Project purpose.
- Development container setup.
- How to build the image.
- How to run OpenCode on macOS with Podman.
- How to run OpenCode on Windows with Docker Desktop and WSL2.
- Basic Java 8 commands.
- Basic Java 21 commands.
- Where to find the human migration guide.
- Where to find OpenCode agent instructions.
- Main migration rule: Java 8 behavior is the source of truth.

## Important Distinction

- `README.md` is for human developers.
- `docs/migration/*.md` is long-form human documentation.
- `AGENTS.md` in the target project root is the authoritative instruction file for OpenCode agents.

If there is any conflict, the target project's root-level `AGENTS.md` wins.

## Recommended Output Style

Use clear Markdown sections.

Prefer short explanations and practical commands.

Avoid long policy sections in the README. Link to the relevant document instead.

## Validation

After editing the README:

- Show the list of changed files.
- Summarize what changed.
- Confirm that no production code was modified.
