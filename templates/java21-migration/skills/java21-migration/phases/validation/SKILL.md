# java21-migration-validation phase skill

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
4. Compare candidate results against Java 8 baseline evidence and classify differences.
5. Classify gaps as `safe migration`, `behavioral risk`, `regression`, or `needs investigation` with rationale.
6. Store evidence and update project memory status.
7. Update `docs/migration-progress-checklist.md` with validation phase status.

## Exit criteria

- all required validation gates are green, or blockers are explicit,
- no unexplained behavior drift remains,
- candidate evidence is complete enough for audit.

## Suggested evidence checks

- compare `Tests run` counts between Java 8 baseline and Java 21 candidate logs
- confirm expected framework-level differences are documented (for example SB3 Problem Details JSON behavior)
- report a clear go/no-go recommendation for audit input
