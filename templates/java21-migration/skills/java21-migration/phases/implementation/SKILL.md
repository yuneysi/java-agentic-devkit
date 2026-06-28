# java21-migration-implementation phase skill

## Responsibility

Execute one approved migration slice with minimal, behavior-preserving changes.

## Inputs

- selected migration slice from planning
- gate commands and acceptance criteria
- impacted modules and dependency changes (if any)

## Outputs

- implemented slice with focused diff
- passing compile/test evidence for the slice
- updated migration memory with what changed and why

## Mandatory steps

1. Execute only the current approved slice.
2. Apply minimal changes required for compatibility.
3. Keep dependency changes isolated from business logic when practical.
4. Run compile and targeted tests immediately after changes.
5. Update `opencode/memory/status.md` and `opencode/memory/decisions.md`.
6. Update `docs/migration-progress-checklist.md` with implementation phase status.

## Must not do

- no opportunistic modernization,
- no broad refactors,
- no unrelated cleanups,
- no untracked behavioral changes.

## Exit criteria

- slice scope is fully completed,
- compile and targeted tests pass,
- no unresolved blockers remain inside slice scope,
- evidence and decisions are documented.
