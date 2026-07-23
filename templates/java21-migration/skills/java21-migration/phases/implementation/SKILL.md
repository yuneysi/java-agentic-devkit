# Migration Implementation Phase

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
3. Stop and return to planning if the slice requires unrelated work or its assumptions are false.
4. Keep dependency or plugin changes isolated from business logic when they can be validated independently.
5. Run the slice's narrowest proof command after each meaningful change.
6. Run every applicable planned gate before declaring the slice implemented.
7. Record scope changes and new decisions; do not rewrite the plan silently.

## Must not do

- no opportunistic modernization,
- no broad refactors,
- no unrelated cleanups,
- no untracked behavioral changes.

## Exit criteria

- slice scope is fully completed,
- all applicable planned gates have evidence,
- no unresolved blockers remain inside slice scope,
- the diff contains no unrelated modernization or cleanup.
