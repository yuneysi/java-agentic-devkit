# Java 8 to Java 21 Migration Best Practices

## Purpose

This document defines the standard human workflow for migrating Java projects from Java 8 to Java 21 using `java-agentic-devkit`.

Use it as both the migration best-practices reference and the migration tracker for the target project.

Every migration must start from the standardized containerized environment provided by `java-agentic-devkit` so the team uses the same Java versions, Maven setup, and shell helpers.

Do not start the migration directly from an ad-hoc local environment.

For the recommended Compose workflow and the manual script workflow, use the root `README.md` in `java-agentic-devkit`.

---

## Project

Project name:

```text
<project-name>
```

Source branch:

```text
feature/migrate_to_java21
```

Target branch:

```text
branch/java21
```

Migration environment:

```text
java-agentic-devkit
```

---

## Migration Goal

Migrate the project from Java 8 to Java 21 while preserving Java 8 behavior.

Java 8 is the behavioral source of truth.

Java 21 must preserve Java 8 behavior unless a change is explicitly requested and approved.

---

## Migration Workflow

Use this sequence after the migration template has been copied into this project.

### 1. Commit the Migration Template Files

Before making migration changes, commit the template files as a baseline migration setup commit:

```bash
git add AGENTS.md .github/copilot-instructions.md docs/java21-migration-best-practices.md
git commit -m "chore: add agent instructions for Java 21 migration"
```

### 2. Capture the Java 8 Baseline

Start the project in Java 8 mode using the workflow from the root `README.md`.

Inside the container, capture the baseline with the real validation command:

```bash
mkdir -p docs/migration-results/java8-baseline
mvn clean verify 2>&1 | tee docs/migration-results/java8-baseline/mvn-clean-verify.log
```

Measure Java 8 test coverage as part of the baseline. Use the project's existing coverage command when available, for example:

```bash
mvn test jacoco:report 2>&1 | tee docs/migration-results/java8-baseline/mvn-test-jacoco.log
```

If Java 8 coverage is below 90%, create focused characterization or regression tests until coverage reaches at least 90% before making Java 21 migration changes.

If the project has integration tests or required Maven profiles, run that command and store its output:

```bash
mvn clean verify -Pintegration-tests 2>&1 | tee docs/migration-results/java8-baseline/mvn-clean-verify-integration.log
```

Record the baseline result in the Java 8 Baseline section below. This baseline is the behavioral source of truth for the migration.

### 3. Plan the First Migration Step

Inspect the project before editing production code.

Record risks in the Migration Risk Register.

Plan small commits. Each planned change must include:

- affected files
- why the change is required for Java 21
- how Java 8 behavior will be preserved
- the validation command
- the expected commit boundary

Do not migrate the whole project at once.

### 4. Implement One Small Change at a Time

For each migration step:

1. Make the smallest safe change.
2. Run the narrowest useful validation command.
3. Update this tracker with what changed, what was validated, and any remaining risk.
4. Commit only after review.

If Java 8 or Java 21 coverage is below 90%, add or repair focused tests before treating the step as complete.

### 5. Validate With Java 21

When there is a small migration change to validate, restart the project in Java 21 mode using the workflow from the root `README.md`.

Inside the Java 21 container, start with the smallest useful validation:

```bash
mkdir -p docs/migration-results/java21-candidate
mvn clean compile 2>&1 | tee docs/migration-results/java21-candidate/mvn-clean-compile.log
```

Then increase validation gradually:

```bash
mvn test 2>&1 | tee docs/migration-results/java21-candidate/mvn-test.log
mvn verify 2>&1 | tee docs/migration-results/java21-candidate/mvn-verify.log
```

Measure Java 21 test coverage with the project's coverage command, for example:

```bash
mvn test jacoco:report 2>&1 | tee docs/migration-results/java21-candidate/mvn-test-jacoco.log
```

If Java 21 coverage is below 90%, add or repair tests before considering candidate validation complete.

Compare Java 8 and Java 21 results:

```bash
diff -ru docs/migration-results/java8-baseline docs/migration-results/java21-candidate | tee docs/migration-results/java8-vs-java21.diff || true
```

Review the comparison before committing migration changes.

### 6. Commit Only Reviewed Migration Steps

Before each migration commit, review the current diff against the Java 8 baseline.

Commit only when the change is small, reviewed, validated, and recorded in this tracker.

## Java 8 Baseline

Use this section to record the current Java 8 behavior before Java 21 changes.

### Baseline Date

```text
<YYYY-MM-DD>
```

### Java Version

```text
<output of java -version>
```

### Maven Version

```text
<output of mvn -version or ./mvnw -version>
```

### Baseline Commands

```bash
mvn clean test
mvn clean verify
mvn test jacoco:report
```

or:

```bash
./mvnw clean test
./mvnw clean verify
./mvnw test jacoco:report
```

### Java 8 Coverage

```text
Coverage percentage: <percent>
Coverage command: <command>
Coverage report path: <path>
Status: Passed >= 90% | Failed < 90% | Not measured
```

If coverage is below 90%, record the missing areas and create characterization or regression tests before starting Java 21 production changes.

### Baseline Result

```text
Passed | Failed | Partially passed | Not run
```

### Known Java 8 Failures

```text
<List existing failures before migration>
```

### Baseline Notes

```text
<Important runtime, test, SOAP, JMS, JDBC, JSP, or deployment observations>
```

---

## Java 21 Candidate

Use this section to record Java 21 validation results.

### Java Version

```text
<output of java -version>
```

### Maven Version

```text
<output of mvn -version or ./mvnw -version>
```

### First Java 21 Compile

```bash
mvn clean compile
```

or:

```bash
./mvnw clean compile
```

### First Java 21 Test Run

```bash
mvn test
```

or:

```bash
./mvnw test
```

### First Java 21 Verify Run

```bash
mvn verify
```

or:

```bash
./mvnw verify
```

### Java 21 Coverage

```bash
mvn test jacoco:report
```

or:

```bash
./mvnw test jacoco:report
```

```text
Coverage percentage: <percent>
Coverage command: <command>
Coverage report path: <path>
Status: Passed >= 90% | Failed < 90% | Not measured
```

If coverage is below 90%, add or repair tests before considering Java 21 candidate validation complete.

### Java 21 Result

```text
Passed | Failed | Partially passed | Not run
```

---

## Migration Risk Register

Use this table to track every risk found during the migration.

| ID | Area | Risk Classification | Description | Evidence | Status | Owner |
|----|------|---------------------|-------------|----------|--------|-------|
| R-001 | Build | dependency risk | TBD | TBD | Open | TBD |

Allowed classifications:

- safe migration
- behavioral risk
- SOAP/XML contract risk
- JSP/runtime risk
- JMS risk
- JDBC risk
- configuration risk
- cache risk
- test gap
- build-tool risk
- dependency risk
- security risk

---

## Dependency Changes

Track each dependency or plugin change separately.

| ID | Dependency / Plugin | Old Version | New Version | Reason | Risk | Validation |
|----|---------------------|-------------|-------------|--------|------|------------|
| D-001 | TBD | TBD | TBD | TBD | TBD | TBD |

Rules:

- Do not upgrade all dependencies at once.
- Group dependency changes by reason.
- Explain why each change is required for Java 21.
- Validate after each focused dependency change.

---

## Build Configuration Changes

Track changes to:

- `pom.xml`
- parent POMs
- Maven profiles
- Maven Wrapper
- compiler plugin
- surefire plugin
- failsafe plugin
- dependency management
- annotation processors
- generated sources
- CI build commands

| ID | File | Change | Reason | Validation |
|----|------|--------|--------|------------|
| B-001 | TBD | TBD | TBD | TBD |

---

## SOAP/XML Compatibility

Inspect and document:

- WSDL
- XSD
- namespaces
- XML prefixes
- SOAPAction
- encoding
- XML element names
- XML element order
- null tags vs empty tags
- omitted optional elements
- date/time formatting
- BigDecimal formatting
- fault responses
- JAXB annotations
- generated classes
- marshalling behavior
- unmarshalling behavior

| ID | Contract / Class | Java 8 Behavior | Java 21 Behavior | Difference | Risk | Status |
|----|------------------|-----------------|------------------|------------|------|--------|
| S-001 | TBD | TBD | TBD | TBD | TBD | Open |

---

## JSP / Runtime Compatibility

Inspect and document:

- Tomcat 9 behavior
- Tomcat 11 behavior
- JSP compilation
- tag libraries
- JSTL versions
- custom tags
- scriptlets
- expression language behavior
- servlet container differences
- encoding
- response content type
- session handling
- request attributes
- form parameter handling

| ID | Area | Java 8 / Tomcat 9 Behavior | Java 21 / Tomcat 11 Behavior | Difference | Risk | Status |
|----|------|-----------------------------|-------------------------------|------------|------|--------|
| J-001 | TBD | TBD | TBD | TBD | TBD | Open |

---

## JMS Compatibility

Inspect and document:

- destination names
- connection factory configuration
- serialization
- message selectors
- acknowledgement mode
- transactions
- redelivery behavior
- dead-letter behavior
- listener concurrency
- message headers
- correlation IDs
- reply-to destinations
- timeout behavior

| ID | Area | Java 8 Behavior | Java 21 Behavior | Difference | Risk | Status |
|----|------|-----------------|------------------|------------|------|--------|
| M-001 | TBD | TBD | TBD | TBD | TBD | Open |

---

## JDBC / Database Compatibility

Inspect and document:

- JDBC driver behavior
- connection pool settings
- autocommit
- isolation level
- timeout
- schema
- SQL dialect differences
- stored procedure calls
- generated keys
- date/time database mappings
- BigDecimal mappings
- transaction boundaries

| ID | Area | Java 8 Behavior | Java 21 Behavior | Difference | Risk | Status |
|----|------|-----------------|------------------|------------|------|--------|
| DB-001 | TBD | TBD | TBD | TBD | TBD | Open |

---

## Date, Time, Locale, Charset, and Number Compatibility

Inspect and document:

- `Date`
- `Calendar`
- `SimpleDateFormat`
- `TimeZone`
- `Locale`
- `DecimalFormat`
- `BigDecimal`
- platform default charset
- `String.getBytes()`
- `new String(byte[])`

| ID | Area | Java 8 Behavior | Java 21 Behavior | Difference | Risk | Status |
|----|------|-----------------|------------------|------------|------|--------|
| T-001 | TBD | TBD | TBD | TBD | TBD | Open |

---

## Characterization Tests

Track tests that capture Java 8 behavior.

Coverage target for both Java 8 baseline and Java 21 candidate validation is at least 90%.

| ID | Test Class | Behavior Captured | Area | Status |
|----|------------|-------------------|------|--------|
| CT-001 | TBD | TBD | TBD | Planned |

Priority areas:

- SOAP request payloads
- SOAP response payloads
- SOAP faults
- XML marshalling/unmarshalling
- JSP rendered output
- JMS message headers and payloads
- JDBC query results
- transaction behavior
- date/time formatting
- BigDecimal formatting
- encoding
- caching behavior

---

## Commit Log

Use this table to keep a migration-level record of meaningful commits.

| Commit | Message | Area | Risk | Validation |
|--------|---------|------|------|------------|
| TBD | chore: add agent instructions for Java 21 migration | docs | Low | Not run |

---

## Final Acceptance Checklist

The migration branch should not be considered ready until:

- [ ] Java 8 baseline behavior is documented.
- [ ] Java 8 test coverage is at least 90%.
- [ ] Java 21 compile passes.
- [ ] Java 21 test coverage is at least 90%.
- [ ] Unit tests pass or known failures are documented.
- [ ] Integration tests pass or known failures are documented.
- [ ] SOAP/XML compatibility risks are reviewed.
- [ ] JSP/Tomcat compatibility risks are reviewed.
- [ ] JMS compatibility risks are reviewed.
- [ ] JDBC compatibility risks are reviewed.
- [ ] Date/time/locale/charset/BigDecimal risks are reviewed.
- [ ] Dependency upgrades are documented.
- [ ] Temporary JVM flags are removed or justified.
- [ ] CI/CD configuration is updated.
- [ ] Final validation command is documented.
- [ ] Final migration audit has approved the final diff.
