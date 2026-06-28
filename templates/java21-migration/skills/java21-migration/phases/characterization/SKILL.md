# java21-migration-characterization phase skill

## Responsibility

Add focused characterization tests that lock current Java 8 behavior in high-risk or low-coverage areas before migration implementation expands.

## Inputs

- Java 8 baseline evidence
- coverage and risk gaps from baseline phase
- existing test framework and test inventory

## Outputs

- new characterization tests for critical behavior
- updated test evidence proving tests pass on Java 8
- updated phase status in migration checklist

## Mandatory steps

1. Read baseline evidence and identify high-risk uncovered behavior.
2. Add narrow tests for risky behavior (contracts, serialization, persistence, messaging, temporal/locale).
3. Keep tests focused on current behavior, not desired future behavior.
4. Validate new tests on Java 8 runtime.
5. Record characterization evidence and remaining gaps.
6. Update `docs/migration-progress-checklist.md` with characterization phase status.

## Must not do

- do not modify production code in this phase,
- do not add broad integration tests that hide root behavior,
- do not proceed if new tests fail on Java 8.

## Exit criteria

- added tests pass on Java 8,
- critical high-risk behavior is better covered,
- remaining gaps are explicit,
- checklist status is updated.
