# Java 21 Small Change Implementer Skill

Use this skill when the user asks to apply one small Java 8 to Java 21 migration change.

## Goal

Implement exactly one focused migration step, validate it narrowly, and update the migration tracker.

## Rules

- Read `AGENTS.md` first and follow it strictly.
- Use the current migration plan or ask the user which single step to apply.
- Make the smallest safe change only.
- Do not migrate the whole project.
- Do not modernize production code.
- Do not refactor unrelated code.
- Preserve Java 8 behavior unless a behavior change is explicitly requested and approved.
- Keep dependency changes isolated from application code changes when possible.
- Prefer focused tests before production changes when behavior is under-covered.
- If coverage is below 90%, add or repair focused tests before treating the step as complete.
- Update `docs/java21-migration-best-practices.md` with the result.

## Required Steps

1. State the single migration step being implemented.
2. Identify the expected changed files.
3. Explain what validation will prove the change is safe.
4. Edit only the files required for that step.
5. Run the narrowest relevant validation command.
6. Run broader validation if the change affects shared behavior, dependencies, runtime config, or public contracts.
7. Update the migration tracker with changed files, validation, risk status, and remaining work.
8. Report a proposed commit message.

## Validation Guidance

Use the narrowest command that proves the step:

```bash
mvn -Dtest=ClassNameTest test
mvn clean compile
mvn test
mvn verify
```

Use Maven Wrapper equivalents when `./mvnw` exists.

If validation output should be retained, save it under:

```text
docs/migration-results/java8-baseline/
docs/migration-results/java21-candidate/
```

## Tracker Update

Update relevant sections in `docs/java21-migration-best-practices.md`:

- Migration Risk Register
- Dependency Changes
- Build Configuration Changes
- SOAP/XML Compatibility
- JSP / Runtime Compatibility
- JMS Compatibility
- JDBC / Database Compatibility
- Date, Time, Locale, Charset, and Number Compatibility
- Characterization Tests
- Commit Log

## Final Output

Report:

- changed files
- validation commands run
- validation result
- risk level
- tracker updates
- remaining risks
- proposed commit message

## Final Rule

A small migration change is not complete because it compiles.

It is complete only when validation evidence and tracker updates show how Java 8 behavior is preserved.
