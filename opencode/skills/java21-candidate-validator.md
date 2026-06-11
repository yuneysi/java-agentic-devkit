# Java 21 Candidate Validator Skill

Use this skill when the user asks to validate the Java 21 migration candidate.

## Goal

Run Java 21 candidate validation, store raw results under `docs/migration-results/java21-candidate/`, compare them with the Java 8 baseline, and update `docs/java21-migration-best-practices.md`.

## Rules

- Read `AGENTS.md` first and follow it strictly.
- Use Java 21 mode.
- Do not modify production code while validating.
- Prefer Maven Wrapper when `./mvnw` exists.
- Store command output under `docs/migration-results/java21-candidate/`.
- Compare Java 21 results with `docs/migration-results/java8-baseline/`.
- If Java 21 coverage is below 90%, report the gap and recommend focused tests before candidate validation is considered complete.
- Update only migration tracking documentation unless the user explicitly asks for fixes.

## Required Steps

1. Confirm the project is running with Java 21.
2. Confirm Java 8 baseline files exist.
3. Create the Java 21 candidate results directory.
4. Capture Java and Maven versions.
5. Run `clean compile`.
6. Run tests.
7. Run `verify`.
8. Run coverage when available.
9. Compare Java 8 baseline and Java 21 candidate results.
10. Update the Java 21 Candidate section in `docs/java21-migration-best-practices.md`.
11. Summarize pass/fail status, coverage status, differences, and blockers.

## Recommended Commands

Use Maven Wrapper when available:

```bash
mkdir -p docs/migration-results/java21-candidate
java -version 2>&1 | tee docs/migration-results/java21-candidate/java-version.log
./mvnw -version 2>&1 | tee docs/migration-results/java21-candidate/maven-version.log
./mvnw clean compile 2>&1 | tee docs/migration-results/java21-candidate/mvn-clean-compile.log
./mvnw test 2>&1 | tee docs/migration-results/java21-candidate/mvn-test.log
./mvnw verify 2>&1 | tee docs/migration-results/java21-candidate/mvn-verify.log
./mvnw test jacoco:report 2>&1 | tee docs/migration-results/java21-candidate/mvn-test-jacoco.log
diff -ru docs/migration-results/java8-baseline docs/migration-results/java21-candidate | tee docs/migration-results/java8-vs-java21.diff || true
```

Otherwise use Maven:

```bash
mkdir -p docs/migration-results/java21-candidate
java -version 2>&1 | tee docs/migration-results/java21-candidate/java-version.log
mvn -version 2>&1 | tee docs/migration-results/java21-candidate/maven-version.log
mvn clean compile 2>&1 | tee docs/migration-results/java21-candidate/mvn-clean-compile.log
mvn test 2>&1 | tee docs/migration-results/java21-candidate/mvn-test.log
mvn verify 2>&1 | tee docs/migration-results/java21-candidate/mvn-verify.log
mvn test jacoco:report 2>&1 | tee docs/migration-results/java21-candidate/mvn-test-jacoco.log
diff -ru docs/migration-results/java8-baseline docs/migration-results/java21-candidate | tee docs/migration-results/java8-vs-java21.diff || true
```

If the project has integration tests or required Maven profiles, run the project-specific command and save it under `docs/migration-results/java21-candidate/`.

## Tracker Update

Update these fields in `docs/java21-migration-best-practices.md`:

- Java 21 Candidate Java Version
- Java 21 Candidate Maven Version
- First Java 21 Compile
- First Java 21 Test Run
- First Java 21 Verify Run
- Java 21 Coverage
- Java 21 Result
- Migration Risk Register
- Final Acceptance Checklist, when applicable

## Final Output

Report:

- commands run
- result file paths
- Java 21 pass/fail status
- coverage percentage or why it could not be measured
- Java 8 vs Java 21 differences
- whether candidate validation is complete
- next recommended step
