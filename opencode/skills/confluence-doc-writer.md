# Confluence Documentation Writer Skill

Use this skill when the user asks to create, clean up, or convert documentation for Confluence.

## Goal

Create clean, copy-paste friendly documentation for Confluence.

## Rules

- Write for human developers.
- Do not create agent instruction files unless explicitly requested.
- Keep headings clear and hierarchical.
- Prefer practical commands and checklists.
- Avoid duplicating long rules that already exist in the target project's root-level `AGENTS.md`.
- When documenting agent behavior, clearly state that `AGENTS.md` is the authoritative source.
- Use code blocks for commands.
- Use tables only when they improve clarity.
- Keep Windows, macOS, Docker, Podman, and WSL instructions clearly separated.

## Recommended Sections

For setup documents, include:

1. Audience.
2. Architecture overview.
3. Prerequisites.
4. Windows users.
5. macOS users.
6. Build instructions.
7. Run instructions.
8. Project mounting explanation.
9. Common commands.
10. Troubleshooting.
11. Daily workflow.
12. Safety rules.

## Windows Rules

For Windows users:

- Recommend Docker Desktop with WSL2 backend.
- Recommend cloning the repository inside the WSL filesystem.
- Provide WSL/bash commands when possible.
- Provide PowerShell commands only as an alternative.
- Use `host.docker.internal` for host access from Docker containers.

## macOS Rules

For macOS users:

- Support Podman or Docker.
- Use `/workspace` as the mounted project path inside the container.
- Warn that shell commands using `\` must not contain blank lines between continued lines.
- Recommend a script for repeatable startup.

## Output Format

When asked for Confluence HTML:

- Produce HTML fragments suitable for Confluence.
- Use `<h1>`, `<h2>`, `<h3>`, `<p>`, `<ul>`, `<ol>`, `<pre><code>`.
- Do not include full HTML document wrappers unless requested.
- Escape code content correctly.

When asked for Markdown:

- Produce standard Markdown.
- Keep it compatible with Confluence Markdown import where possible.

## Validation

After creating documentation, summarize:

- File created or changed.
- Intended audience.
- Where it should live in the repository.
