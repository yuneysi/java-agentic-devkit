# java21-migration skill

This folder contains the Java 8 to Java 21 migration workflow for projects bootstrapped from `templates/java21-migration/`.

All paths in this document are relative to the bootstrapped target project root.

`SKILL.md` is the authoritative orchestrator. It defines phase order, shared gates, evidence locations, and status transitions. Each phase skill defines only the procedure and exit criteria for that phase.

## Structure

- `SKILL.md`: top-level orchestrator for migration phase flow.
- `phases/java21-migration-baseline/SKILL.md`: baseline and readiness responsibility.
- `phases/java21-migration-characterization/SKILL.md`: optional regression-lock tests for risky or under-covered behavior.
- `phases/java21-migration-planning/SKILL.md`: staged migration planning responsibility.
- `phases/java21-migration-implementation/SKILL.md`: execution of approved migration slices.
- `phases/java21-migration-validation/SKILL.md`: candidate validation and drift detection.
- `phases/java21-migration-audit/SKILL.md`: final audit and go/no-go recommendation.

## Design goals

- clear ownership per migration phase,
- behavior-preserving incremental execution,
- explicit gate outcomes and evidence,
- reusable enterprise migration workflow.

Developers can start the orchestrator with `Start the Java 21 migration.` It determines the next valid phase from project memory and evidence.
