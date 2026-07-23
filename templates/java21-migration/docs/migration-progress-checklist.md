# Java 8 To Java 21 Migration Sign-Off

Use this file for human review and release decisions. Agent rules belong in `AGENTS.md`; migration procedure belongs in `skills/java21-migration/SKILL.md`.

## Project

| Field | Value |
|---|---|
| Project | TBD |
| Working branch | TBD |
| Technical owner | TBD |
| Business owner | TBD |
| Target release | TBD |

## Preconditions

- [ ] Java 8 behavior is the baseline unless a change is explicitly approved.
- [ ] Shared memory contains verified project facts, not untouched template seeds.
- [ ] Build and test entry points are known.
- [ ] Critical business flows and applicable behavior-sensitive areas are identified.

## Phase Status

Allowed values: `Not started`, `In progress`, `Blocked`, `Done`.

| Phase | Status | Evidence / Decision | Owner | Updated |
|---|---|---|---|---|
| Baseline | Not started | TBD | TBD | TBD |
| Characterization, if required | Not started | TBD | TBD | TBD |
| Planning | Not started | TBD | TBD | TBD |
| Implementation | Not started | TBD | TBD | TBD |
| Validation | Not started | TBD | TBD | TBD |
| Audit | Not started | TBD | TBD | TBD |

## Migration Slices

Keep one row per approved slice. A slice is complete only when all applicable gates pass.

| ID | Scope | Primary Risk | Status | Build | Test | Contract | Runtime | Rollback | Evidence |
|---|---|---|---|---|---|---|---|---|---|
| S-001 | TBD | TBD | Not started | N/A | N/A | N/A | N/A | TBD | TBD |

## Dependency And Build Changes

Record only changed dependencies, plugins, toolchains, frameworks, or temporary JVM flags.

| Component | Old | New | Reason | Risk | Validation | Rollback / Removal |
|---|---|---|---|---|---|---|
| TBD | TBD | TBD | TBD | TBD | TBD | TBD |

## Risks And Approved Deltas

| ID | Type | Description | Severity | Evidence / Decision | Owner | Status |
|---|---|---|---|---|---|---|
| R-001 | Risk | TBD | TBD | TBD | TBD | Open |

Use `Delta` for an intentional behavior change and `Risk` for unresolved exposure. Do not classify a regression as an approved delta without explicit human approval.

## Final Decision

- [ ] Java 8 baseline evidence is reproducible.
- [ ] Every approved slice is implemented and validated.
- [ ] Every applicable behavior-sensitive area has evidence or accepted residual risk.
- [ ] Java 21 clean build and required tests pass.
- [ ] Runtime and contract checks pass where applicable.
- [ ] Temporary workarounds have an owner and removal condition.
- [ ] CI/CD and deployment runtime changes are validated.
- [ ] Residual risks have owners and next actions.

| Decision | Select One |
|---|---|
| Go | [ ] |
| Go with conditions | [ ] |
| No-go | [ ] |

Conditions or blockers:

```text
TBD
```

Approved by:

| Role | Name | Date |
|---|---|---|
| Technical owner | TBD | TBD |
| Business owner | TBD | TBD |
