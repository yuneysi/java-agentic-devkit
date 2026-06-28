# java21-migration skill

This folder contains an organized Java 8 to Java 21 migration skill system for projects bootstrapped from `templates/java21-migration/`.

## Structure

- `SKILL.md`: top-level orchestrator for migration phase flow.
- `phases/INDEX.md`: quick phase table (when to use, inputs, outputs, done criteria).
- `phases/baseline/SKILL.md`: baseline and readiness responsibility.
- `phases/characterization/SKILL.md`: optional regression-lock tests for risky or under-covered behavior.
- `phases/planning/SKILL.md`: staged migration planning responsibility.
- `phases/implementation/SKILL.md`: execution of approved migration slices.
- `phases/validation/SKILL.md`: candidate validation and drift detection.
- `phases/audit/SKILL.md`: final audit and go/no-go recommendation.

## Design goals

- clear ownership per migration phase,
- behavior-preserving incremental execution,
- explicit gate outcomes and evidence,
- reusable enterprise migration workflow.

## Invocation examples

Natural start prompt (recommended):

```text
Start the Java 21 migration.
```

Expected behavior from the orchestrator:

- return the full phase sequence,
- indicate the next phase to execute now,
- remind that each phase must write status in `docs/migration-progress-checklist.md`.

Phase-specific prompts:

```text
Use the java21-migration skill and run baseline.
```

```text
Use the java21-migration skill and run optional characterization for high-risk gaps.
```

```text
Use the java21-migration skill and produce direct Java 8 -> Java 21 planning output.
```

```text
Use the java21-migration skill and execute the next approved implementation slice.
```

```text
Use the java21-migration skill and run validation for the Java 21 candidate.
```

```text
Use the java21-migration skill and generate the audit recommendation.
```
