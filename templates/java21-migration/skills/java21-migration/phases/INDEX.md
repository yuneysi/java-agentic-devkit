# Java 8 -> 21 migration phase table

Use this table to decide which phase skill to run next.

Preflight requirement: initialize `opencode/memory/architecture.md`, `opencode/memory/decisions.md`, and `opencode/memory/status.md` before running migration phases.

| Phase | Use when | Main inputs | Expected outputs | Done when | Recommended prompt |
|---|---|---|---|---|---|
| baseline | Migration has not started or baseline is stale | build/test entrypoints, critical flows, test inventory | readiness score, baseline risk map, Java 8 evidence | baseline evidence is reproducible and readiness is documented | `Use the java21-migration skill and run baseline.` Then write status in `docs/migration-progress-checklist.md`. |
| planning | Baseline is ready and work needs sequencing | readiness results, dependency inventory, constraints | direct Java 8 -> Java 21 plan, slice list, gate checks, rollback notes | each slice is small, measurable, and reversible | `Use the java21-migration skill and produce direct Java 8 -> Java 21 planning output.` Then write status in `docs/migration-progress-checklist.md`. |
| implementation | A specific slice is approved for execution | selected slice, gate commands, impacted modules | focused code/dependency changes, compile/test evidence | slice scope is complete and gate checks pass | `Use the java21-migration skill and execute the next approved implementation slice.` Then write status in `docs/migration-progress-checklist.md`. |
| validation | Candidate behavior must be checked on Java 21 | baseline evidence, candidate build/test/runtime outputs | validation report, drift classification, candidate evidence | required gates are green or blockers are explicit | `Use the java21-migration skill and run validation for the Java 21 candidate.` Then write status in `docs/migration-progress-checklist.md`. |
| audit | Team needs sign-off decision | all phase artifacts and unresolved risks | audit summary, risk register, go/no-go recommendation | recommendation is explicit and evidence-backed | `Use the java21-migration skill and generate the audit recommendation.` Then write status in `docs/migration-progress-checklist.md`. |

## Recommended flow

`baseline -> planning -> implementation -> validation -> audit`

Repeat `implementation -> validation` for each approved migration slice until candidate quality is sufficient for audit.
