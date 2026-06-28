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
4. Classify gaps as blocker/non-blocker with rationale.
5. Store evidence and update project memory status.
6. Update `docs/migration-progress-checklist.md` with validation phase status.

## Exit criteria

- all required validation gates are green, or blockers are explicit,
- no unexplained behavior drift remains,
- candidate evidence is complete enough for audit.
