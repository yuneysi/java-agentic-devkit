# Project Architecture Memory Writer Skill

Use this skill when the user asks what is happening in the project, asks for architecture status, or asks to reduce repeated token usage for recurring context.

## Goal

Create and maintain shared project memory files under `opencode/memory/` so humans and agents can answer recurring project questions without re-scanning the full codebase every time.

## Files To Maintain

- `opencode/memory/architecture.md`
- `opencode/memory/decisions.md`
- `opencode/memory/status.md`

## Rules

- Read existing `opencode/memory/*.md` first before scanning code.
- Keep updates factual, short, and auditable.
- Prefer append/update over rewrite; preserve history.
- Record only verified facts from repository evidence.
- Never invent architecture details.
- Add paths/commands used as evidence when useful.
- If data is missing, write `unknown` and include a follow-up question in the output.

## Minimum Update Triggers

Update memory files when any of these happen:

- New module or service added/removed.
- Runtime or packaging changes.
- Dependency/plugin strategy changes.
- Build/test baseline changes.
- Migration phase or risk status changes.
- Human approval or rejection of a technical decision.

## Suggested Workflow

1. Read `AGENTS.md`.
2. Read `opencode/memory/architecture.md`, `opencode/memory/decisions.md`, and `opencode/memory/status.md`.
3. Gather only missing evidence from the codebase.
4. Update memory files with concise diffs.
5. Return a short summary and what changed.

## Required Output

Return:

1. Files changed.
2. New or updated architecture facts.
3. New decisions logged.
4. Current status and next steps.
5. Any unknowns that still need human confirmation.
