# Java 21 Migration Implementation Phase Skill

Use this skill when the user wants one focused migration change implemented.

## Goal

Apply one small, verifiable migration change without widening scope.

## Rules

- Make the smallest correct edit.
- Keep the change buildable on its own.
- Validate immediately after the change.
- Revert if validation fails.

## Required Output

Return:

1. What changed.
2. Validation results.
3. Remaining migration risks.
