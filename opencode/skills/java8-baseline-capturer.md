# Java 8 Baseline Capturer Skill

Use this skill when the user asks to capture the Java 8 baseline for a Java 8 to Java 21 migration.

## Goal

Run the Java 8 baseline validation commands, store the raw results under `docs/migration-results/java8-baseline/`, and update `docs/java21-migration-best-practices.md`.

Java 8 is the behavioral source of truth.

## Rules

- Read `AGENTS.md` first and follow it strictly.
- Use Java 8 mode.
- Do not modify production code.
- Do not start Java 21 migration changes.
- Prefer Maven Wrapper when `./mvnw` exists.
- Store command output under `docs/migration-results/java8-baseline/`.
- Update only migration tracking documentation unless the user explicitly asks for test changes.
- If coverage is below 90%, report the gap and recommend characterization or regression tests before production migration changes.

## Required Steps

1. Confirm the project is running with Java 8.
2. Create the baseline results directory.
3. Capture Java and Maven versions.
4. Run the baseline test or verify command.
5. Run the coverage command when available.
6. Run integration-test profiles when the project requires them.
7. Update the Java 8 Baseline section in `docs/java21-migration-best-practices.md`.
8. Summarize pass/fail status, coverage status, result files, and blockers.

## Recommended Commands

Use Maven Wrapper when available:

```bash
mkdir -p docs/migration-results/java8-baseline
java -version 2>&1 | tee docs/migration-results/java8-baseline/java-version.log
./mvnw -version 2>&1 | tee docs/migration-results/java8-baseline/maven-version.log
./mvnw clean verify 2>&1 | tee docs/migration-results/java8-baseline/mvn-clean-verify.log
./mvnw test jacoco:report 2>&1 | tee docs/migration-results/java8-baseline/mvn-test-jacoco.log
```

Otherwise use Maven:

```bash
mkdir -p docs/migration-results/java8-baseline
java -version 2>&1 | tee docs/migration-results/java8-baseline/java-version.log
mvn -version 2>&1 | tee docs/migration-results/java8-baseline/maven-version.log
mvn clean verify 2>&1 | tee docs/migration-results/java8-baseline/mvn-clean-verify.log
mvn test jacoco:report 2>&1 | tee docs/migration-results/java8-baseline/mvn-test-jacoco.log
```

If the project has integration tests or required Maven profiles, run the project-specific command and save it under `docs/migration-results/java8-baseline/`.

## Tracker Update

Update these fields in `docs/java21-migration-best-practices.md`:

- Baseline Date
- Java Version
- Maven Version
- Baseline Commands
- Java 8 Coverage
- Baseline Result
- Known Java 8 Failures
- Baseline Notes

Also add entries to Characterization Tests or Migration Risk Register if the baseline exposes missing coverage or behavior-sensitive gaps.

## Final Output

Report:

- commands run
- result file paths
- pass/fail status
- coverage percentage or why it could not be measured
- whether Java 8 baseline capture is complete
- next recommended step
