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

## Planner Integration Contract

- The planner is a router for memory handling.
- Planner responsibility is limited to detecting whether required memory files are missing.
- Content validation, initialization, and updates are owned by this skill.

If planner detects any missing file in:

- `opencode/memory/architecture.md`
- `opencode/memory/decisions.md`
- `opencode/memory/status.md`

then this skill must create/initialize missing files first, then continue normal memory update flow.

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
