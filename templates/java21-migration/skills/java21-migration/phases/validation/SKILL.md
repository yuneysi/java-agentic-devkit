# Java 21 Validation Phase

## Responsibility

Validate Java 21 candidate behavior against baseline expectations.

## Inputs

- completed migration slices
- baseline evidence from Java 8
- candidate build/test/runtime outputs

## Outputs

- validation report per gate: compile, test, contract, runtime
- explicit diff of approved vs unapproved behavior changes
- candidate evidence in `docs/migration-results/java21-candidate/`

## Mandatory steps

1. Run candidate compile and test commands with Java 21 runtime.
2. Re-check contract-sensitive endpoints and payload behavior.
3. Re-check high-risk runtime paths and startup behavior.
4. Compare candidate results, warnings, contracts, and operational behavior against Java 8 baseline evidence.
5. Classify every meaningful difference with rationale:
	- `approved delta`: intentionally accepted and linked to a decision,
	- `compatible`: different implementation or output with no relevant contract or operational impact,
	- `regression`: unapproved behavior or contract change,
	- `unresolved`: evidence is insufficient to decide.
6. Store evidence and update project memory status.

## Exit criteria

- all required validation gates are green, or blockers are explicit,
- no regression or unresolved difference remains in a completed slice,
- candidate evidence is complete enough for audit.

## Suggested evidence checks

- compare test inventory, results, warnings, and coverage of critical behavior; do not rely on totals alone,
- compare affected payloads, side effects, transaction behavior, startup, and operational signals,
- link every approved framework behavior change to its decision and contract evidence.
