# Architecture And Migration Decisions

Use this file as the shared decision log for humans and agents.

## Decision Entries

| Date | ID | Decision | Why | Impact | Status |
|------|----|----------|-----|--------|--------|
| 2026-06-21 | D-001 | Use `opencode/memory/` as first source for recurring project context | Reduce repeated scanning and token usage | All agents and contributors | accepted |
| 2026-06-21 | D-002 | Keep three memory files: architecture, decisions, status | Separate stable structure, rationale, and progress | Team workflow and onboarding | accepted |
| 2026-06-21 | D-003 | Update memory on every meaningful architecture or build/testing change | Keep answers fresh and auditable | Ongoing maintenance | accepted |

## Conventions

- Keep entries short and explicit.
- One decision per row.
- Update status instead of deleting old decisions.
- Add links to evidence paths when available (files, commands, reports).
