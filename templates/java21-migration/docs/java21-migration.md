# Java 21 Migration Notes

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

## How To Migrate With OpenCode

Use this sequence after the migration template has been copied into this project.

### 1. Commit the Migration Template Files

Before making migration changes, commit the template files as a baseline migration setup commit:

```bash
git add AGENTS.md .github/copilot-instructions.md docs/java21-migration.md scripts/run-java8-baseline.sh scripts/run-java21-candidate.sh scripts/compare-behavior.sh
git commit -m "chore: add agent instructions for Java 21 migration"
```

### 2. Capture the Java 8 Baseline

Start the devkit with Java 8 from the developer machine:

```bash
cd ~/github/java-agentic-devkit
./scripts/dev.sh /path/to/this/project java8
```

Inside the container, run the baseline script:

```bash
scripts/run-java8-baseline.sh
```

If the project has integration tests or required Maven profiles, pass the real validation command:

```bash
scripts/run-java8-baseline.sh mvn clean verify -Pintegration-tests
```

Record the baseline result in the Java 8 Baseline section below. This baseline is the behavioral source of truth for the migration.

### 3. Ask OpenCode for a Plan Before Editing

Still inside the Java 8 container, start OpenCode:

```bash
opencode
```

Use this first prompt:

```text
Read AGENTS.md first and follow it strictly.

We are starting a Java 8 to Java 21 migration.

First, inspect the project without modifying files.

Use docs/java21-migration.md as the migration tracker.

Review the Maven configuration, Java source/target settings, dependency versions, plugins, Spring/Tomcat/JSP usage, SOAP/XML/JAXB usage, JMS, JDBC, tests, and runtime configuration.

Return a prioritized migration plan with small, safe commits.

For each risk, include:
- affected files
- why it matters for Java 21
- how to validate behavior
- the first small change you recommend

Do not edit files yet.
```

### 4. Implement One Small Change at a Time

After OpenCode returns the plan, ask it to work on only the first small item:

```text
Take the first item from the migration plan.

Make the smallest safe change only.

Before editing, explain what validation will prove the change is safe.

After editing, run the narrowest relevant validation command.

Update docs/java21-migration.md with what changed, what was validated, and any remaining risk.
```

Do not ask OpenCode to migrate the whole project at once.

### 5. Validate With Java 21

When there is a small migration change to validate, restart the devkit with Java 21 from the developer machine:

```bash
cd ~/github/java-agentic-devkit
./scripts/dev.sh /path/to/this/project java21
```

Inside the Java 21 container, start with the smallest useful validation:

```bash
scripts/run-java21-candidate.sh mvn clean compile
```

Then increase validation gradually:

```bash
scripts/run-java21-candidate.sh mvn test
scripts/run-java21-candidate.sh mvn verify
```

Compare Java 8 and Java 21 results:

```bash
scripts/compare-behavior.sh
```

Review the comparison before committing migration changes.

### 6. Commit Only Reviewed Migration Steps

Before each migration commit, ask OpenCode to review the current diff:

```text
Read AGENTS.md first and follow it strictly.

Review the current Git diff as a Java 8 to Java 21 migration auditor.

Do not modify files.

Check whether the diff preserves Java 8 behavior.

Classify migration risks.

Report blocking issues, non-blocking issues, missing tests, and whether the change is safe to commit.
```

Commit only when the change is small, reviewed, and validated.

---

## Standard Environment

All migration work should be performed through `java-agentic-devkit`.

From the host machine:

```bash
cd ~/github/java-agentic-devkit
./scripts/dev.sh /path/to/this/project
```

Java 8 baseline mode:

```bash
./scripts/dev.sh /path/to/this/project java8
```

Java 21 candidate mode:

```bash
./scripts/dev.sh /path/to/this/project java21
```

Inside the container:

```bash
java -version
javac -version
mvn -version
git --version
opencode --version
```

---

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
```

or:

```bash
./mvnw clean test
./mvnw clean verify
```

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

## OpenCode Prompts Used

Record important prompts used during the migration.

### Initial Audit Prompt

```text
Read AGENTS.md first and follow it strictly.

Inspect this project for Java 8 to Java 21 migration risks.

Do not modify files.

Focus on Maven, Java version configuration, Spring, Tomcat, JSP, SOAP/XML, JMS, JDBC, JAXB, and test setup.

Return a prioritized migration plan with small commits.
```

### Implementation Prompt Template

```text
Read AGENTS.md first and follow it strictly.

Apply only the proposed migration step.

Do not refactor unrelated code.

Do not modernize production code.

Preserve Java 8 behavior.

Run the smallest relevant validation command.

Report changed files, risk level, validation result, and proposed commit message.
```

### Review Prompt Template

```text
Read AGENTS.md first and follow it strictly.

Review the current Git diff as a Java 8 to Java 21 migration auditor.

Do not modify files.

Check whether the diff preserves Java 8 behavior.

Classify migration risks.

Report blocking issues, non-blocking issues, missing tests, and whether the change is safe to commit.
```

---

## Final Acceptance Checklist

The migration branch should not be considered ready until:

- [ ] Java 8 baseline behavior is documented.
- [ ] Java 21 compile passes.
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
- [ ] OpenCode review/audit has approved the final diff.
