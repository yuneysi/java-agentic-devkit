# java21-migration-baseline phase skill

## Responsibility

Establish a trustworthy Java 8 baseline before migration execution starts.

## Inputs

- build entrypoints (`mvnw` or `mvn`)
- module boundaries
- critical business flows to preserve
- current test inventory

## Outputs

- readiness scoring (0-10)
- baseline risk map by area
- baseline evidence stored under `docs/migration-results/java8-baseline/`
- initial migration status entry in `opencode/memory/status.md`

## Mandatory steps

1. Confirm reproducible Java 8 build and test entry commands.
2. Run baseline compile and relevant tests.
3. Identify high-risk areas (contracts, persistence, messaging, security, temporal/locale).
4. Produce readiness scoring and explain blockers.
5. Record baseline evidence and decisions.
6. Update `docs/migration-progress-checklist.md` with baseline phase status.

## Exit criteria

- baseline commands are reproducible,
- high-risk areas are explicitly listed,
- readiness score is documented,
- evidence paths are present and referenced in memory files.
