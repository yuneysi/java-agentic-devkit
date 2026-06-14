# Java 21 Migration Test Planning Phase Skill

Use this skill when the user needs a test plan for Java 8 baseline capture, characterization tests, or Java 21 candidate validation.

## Goal

Plan the narrowest validation path that proves Java 21 preserves Java 8 behavior.

## Rules

- Start from the Java 8 baseline and known risk areas.
- Prefer compile, targeted tests, then full verify.
- Include characterization tests where coverage is low or behavior is risky.
- Do not suggest production code changes.

## Required Output

Return:

1. Planned validation steps.
2. Commands to run.
3. Expected evidence for success.
