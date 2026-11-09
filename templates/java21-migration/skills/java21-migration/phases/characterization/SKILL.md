---
name: java21-migration-characterization
description: "Use for the java21 migration characterization workflow, preserving behavior and following project migration gates."
---

# Characterization Phase

## Responsibility

Add focused characterization tests that lock current Java 8 behavior in high-risk or low-coverage areas before migration implementation expands.

## Inputs

- Java 8 baseline evidence
- coverage and risk gaps from baseline phase
- existing test framework and test inventory

## Outputs

- new characterization tests for critical behavior
- updated test evidence proving tests pass on Java 8

## Mandatory steps

1. Read baseline evidence and identify high-risk uncovered behavior.
2. Prioritize externally observable behavior and failure semantics over implementation details.
3. Add narrow tests for risky behavior (contracts, serialization, persistence, messaging, temporal/locale).
4. Keep tests focused on current behavior, not desired future behavior.
5. Validate new tests on Java 8 runtime.
6. Record characterization evidence and remaining gaps.

## Must not do

- do not modify production code in this phase,
- do not create large test harnesses when a focused unit, component, contract, or integration test is sufficient,
- do not proceed if new tests fail on Java 8.

## Exit criteria

- added tests pass on Java 8,
- each targeted risk has reproducible Java 8 evidence,
- remaining gaps are explicit,
- the baseline readiness verdict is refreshed if the new evidence changes it.
