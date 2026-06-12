# Java 8 Baseline Capturer Skill

Use this skill when the user asks to capture the Java 8 baseline for a Java 8 to Java 21 migration.

## Goal

Run the Java 8 baseline validation commands, store the raw results under `docs/migration-results/java8-baseline/`, and update the human migration checklist when present.

Java 8 is the behavioral source of truth.

## Rules

- Read `AGENTS.md` first and follow it strictly.
- Use Java 8 mode.
- Do not modify production code.
- Do not start Java 21 migration changes.
- Prefer Maven Wrapper when `./mvnw` exists.
- Store command output under `docs/migration-results/java8-baseline/`.
- Update only migration tracking documentation or checklist notes unless the user explicitly asks for test changes.
- If coverage is below 90%, report the gap as a blocker for production migration changes and recommend characterization or regression tests.

## Required Steps

1. Confirm the project is running with Java 8.
2. Create the baseline results directory.
3. Capture Java and Maven versions.
4. Run the baseline test or verify command.
5. Run the coverage command when available.
6. Run integration-test profiles when the project requires them.
7. Update the Java 8 Baseline checklist section when `docs/java21-migration-best-practices.md` exists.
8. Summarize pass/fail status, coverage status, result files, and blockers.

## Recommended Commands

Use Maven Wrapper when available:

```bash
mkdir -p docs/migration-results/java8-baseline
java -version 2>&1 | tee docs/migration-results/java8-baseline/java-version.log
./mvnw -version 2>&1 | tee docs/migration-results/java8-baseline/maven-version.log
./mvnw clean verify 2>&1 | tee docs/migration-results/java8-baseline/mvn-clean-verify.log
```

Otherwise use Maven:

```bash
mkdir -p docs/migration-results/java8-baseline
java -version 2>&1 | tee docs/migration-results/java8-baseline/java-version.log
mvn -version 2>&1 | tee docs/migration-results/java8-baseline/maven-version.log
mvn clean verify 2>&1 | tee docs/migration-results/java8-baseline/mvn-clean-verify.log
```

Run the project's existing coverage command when available, and save the output under `docs/migration-results/java8-baseline/`.

Common examples:

```bash
./mvnw test jacoco:report 2>&1 | tee docs/migration-results/java8-baseline/mvn-test-jacoco.log
mvn test jacoco:report 2>&1 | tee docs/migration-results/java8-baseline/mvn-test-jacoco.log
```

If the project has integration tests or required Maven profiles, run the project-specific command and save it under `docs/migration-results/java8-baseline/`.

## Checklist Update

If `docs/java21-migration-best-practices.md` exists, update the Java 8 Baseline section as a human checklist:

- mark completed baseline items when evidence exists
- add concise baseline notes with commands, result files, and failures
- leave unchecked items that could not be completed
- do not invent coverage percentages or passing status

Also add entries to Characterization Tests or Migration Risk Register if the baseline exposes missing coverage or behavior-sensitive gaps.

## Final Output

Report:

- commands run
- result file paths
- pass/fail status
- coverage percentage or why it could not be measured
- whether Java 8 baseline capture is complete
- next recommended step
