# Java 8 Baseline Phase

## Responsibility

Establish a trustworthy Java 8 baseline before migration execution starts.

Baseline capture is evidence work. Do not change production code, tests, or build configuration in this phase.

## Inputs

- build entrypoints (`mvnw` or `mvn`)
- module boundaries
- critical business flows to preserve
- current test inventory

## Outputs

- readiness verdict: `Ready`, `Ready with risks`, or `Blocked`
- baseline risk map by area
- baseline evidence stored under `docs/migration-results/java8-baseline/`
- initial migration status entry in `opencode/memory/status.md`

## Mandatory steps

1. Confirm reproducible Java 8 build and test entry commands.
2. Verify Java runtime is Java 8 for baseline commands.
3. Run baseline compile and relevant tests.
4. Inventory applicable behavior-sensitive areas and the evidence protecting each one.
5. Produce the readiness verdict and explain risks or blockers.
6. Store raw command outputs under `docs/migration-results/java8-baseline/`.
7. Record baseline evidence, known failures, environment assumptions, and unresolved test gaps.

## Recommended checks

- `JAVA_HOME=/opt/java/jdk8 java -version`
- `JAVA_HOME=/opt/java/jdk8 ./mvnw clean test` (or module-scoped equivalent)
- capture build/test outputs without filtering away warnings or failures

## Exit criteria

- baseline commands are reproducible,
- applicable high-risk areas and evidence gaps are explicit,
- readiness verdict is documented,
- evidence paths are present and referenced in memory files,
- baseline outputs are saved in `docs/migration-results/java8-baseline/`.
