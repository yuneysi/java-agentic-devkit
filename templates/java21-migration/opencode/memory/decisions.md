# Architecture And Migration Decisions

Use this file as the shared decision log for humans and agents.

## Decision Entries

| Date | ID | Decision | Why | Impact | Status |
|------|----|----------|-----|--------|--------|
| 2026-06-21 | D-001 | Use `opencode/memory/` as first source for recurring migration context | Reduce repeated scanning and token usage | All agents and contributors | accepted |
| 2026-06-21 | D-002 | Keep migration memory in architecture, decisions, and status files | Separate system shape, rationale, and progress | Migration workflow and audits | accepted |
| 2026-06-21 | D-003 | Treat Java 8 behavior as baseline truth and document approved deltas explicitly | Preserve behavior and reduce regression risk | Migration validation and sign-off | accepted |

## Conventions

- Keep entries short and explicit.
- One decision per row.
- Update status instead of deleting old decisions.
- Add migration-safe validation commands for each accepted decision.
- Link each accepted decision to evidence paths and checklist updates.
