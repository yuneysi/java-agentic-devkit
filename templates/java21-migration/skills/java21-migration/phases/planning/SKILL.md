# java21-migration-planning phase skill

## Responsibility

Turn baseline findings into a direct, reversible Java 8 -> Java 21 migration plan.

## Inputs

- baseline readiness score
- dependency and plugin inventory
- known failing tests or fragile modules
- team constraints (timeline, risk appetite, release windows)

## Outputs

- direct migration plan: Java 8 -> Java 21
- migration slices with one primary risk bucket each
- gate checklist per slice (compile/test/contract/runtime/evidence)
- rollback notes for each slice

## Mandatory steps

1. Partition direct Java 8 -> Java 21 migration work into the smallest reversible slices.
2. Classify each slice into one primary risk bucket.
3. Define explicit gate criteria and proof commands per slice.
4. Define rollback condition for each slice.
5. Record approved plan in `opencode/memory/decisions.md`.
6. Update `docs/migration-progress-checklist.md` with planning phase status.

## Exit criteria

- no oversized slice crossing multiple high-risk buckets,
- each slice has measurable gate checks,
- rollback path exists for each slice,
- migration sequence is ready for implementation phase.
