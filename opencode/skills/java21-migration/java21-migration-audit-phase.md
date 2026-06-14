# Java 21 Migration Audit Phase Skill

Use this skill when the user asks to review a Java 8 to Java 21 migration diff, classify risk, or assess migration readiness.

## Goal

Audit migration changes for behavior preservation, Jakarta EE correctness, dependency risk, and release readiness.

## Rules

- Read the diff first.
- Focus on regressions, risky namespace changes, dependency changes, and validation gaps.
- Classify findings by severity and evidence.
- Do not approve changes that lack validation.

## Required Output

Return:

1. Migration state summary.
2. Findings ordered by severity.
3. Validation gaps and next actions.
