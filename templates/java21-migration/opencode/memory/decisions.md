# Architecture And Migration Decisions

Use this file as the shared decision log for humans and agents.

Template state: initialization required. Preserve applicable devkit conventions below and add project-specific decisions from verified evidence.

## Decision Entries

| Date | ID | Decision | Why | Impact | Status |
|------|----|----------|-----|--------|--------|
| Template | D-001 | Use `opencode/memory/` as first source for recurring migration context | Reduce repeated scanning while retaining source evidence | All agents and contributors | accepted |
| Template | D-002 | Treat Java 8 behavior as baseline truth and document approved deltas explicitly | Preserve behavior and reduce regression risk | Migration validation and sign-off | accepted |

## Conventions

- Keep entries short and explicit.
- One decision per row.
- Update status instead of deleting old decisions.
- Add migration-safe validation commands for each accepted decision.
- Link each accepted decision to evidence paths and checklist updates.
