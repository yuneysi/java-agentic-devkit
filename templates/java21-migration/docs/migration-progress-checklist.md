# Java 8 To Java 21 Migration Human Checklist

Use this checklist to track human review of a Java 8 to Java 21 migration.

The devkit copies this template into the target project as `docs/migration-progress-checklist.md`.

## Project

Project name:

```text
<project-name>
```

Working branch:

```text
<branch-name>
```

Migration environment:

```text
java-agentic-devkit
```

## Migration Goal

- [ ] Java 8 behavior is treated as the behavioral source of truth.
- [ ] Java 21 behavior preserves Java 8 behavior unless a change was explicitly approved.
- [ ] The migration is tracked on one working branch.
- [ ] Migration work is split into small, reviewable commits.

## Human Prompts For OpenCode

Use short prompts to select the migration phase. `AGENTS.md` and the selected skill provide the detailed rules, so the prompt does not need to repeat them.

- [ ] Initial inspection prompt was used.

```text
Read AGENTS.md and inspect this project for migration readiness.
Do not edit files yet.
Tell me the current baseline status, likely validation commands, highest-risk areas, and the first skill I should use.
```

- [ ] Java 8 baseline prompt was used.

```text
Use the java8-baseline-capture-phase skill.
```

- [ ] Migration planning prompt was used.

```text
Use the java21-migration-planning-phase skill.
```

- [ ] Small migration change prompt was used.

```text
Use the java21-migration-implementation-phase skill.
Apply the next planned small migration step.
```

- [ ] Java 21 validation prompt was used.

```text
Use the java21-candidate-validation-phase skill.
```

- [ ] Migration review prompt was used before final acceptance.

```text
Use the java21-migration-audit-phase skill.
Review the current diff.
Do not modify files.
```

## Java 8 Baseline

- [ ] Java 8 version was recorded.
- [ ] Maven version was recorded.
- [ ] Java 8 baseline command was run.
- [ ] Java 8 baseline output was saved under `docs/migration-results/java8-baseline/`.
- [ ] Java 8 coverage command was run or marked as not available.
- [ ] Java 8 coverage is at least 90%, or gaps are documented.
- [ ] Known Java 8 failures are documented.
- [ ] Important runtime, SOAP, JMS, JDBC, JSP, or deployment observations are documented.

Baseline notes:

```text
<baseline notes>
```

## Java 21 Candidate

- [ ] Java 21 version was recorded.
- [ ] Maven version was recorded.
- [ ] Java 21 compile command was run.
- [ ] Java 21 test command was run.
- [ ] Java 21 verify command was run when applicable.
- [ ] Java 21 candidate output was saved under `docs/migration-results/java21-candidate/`.
- [ ] Java 21 coverage command was run or marked as not available.
- [ ] Java 21 coverage is at least 90%, or gaps are documented.
- [ ] Java 8 and Java 21 results were compared.
- [ ] Meaningful differences are classified and tracked.

Candidate notes:

```text
<candidate notes>
```

## Migration Risk Register

| ID | Area | Risk Classification | Description | Evidence | Status | Owner |
|----|------|---------------------|-------------|----------|--------|-------|
| R-001 | TBD | TBD | TBD | TBD | Open | TBD |

Risk classifications:

- safe migration
- behavioral risk
- SOAP/XML contract risk
- JSP/runtime risk
- JMS risk
- JDBC risk
- JPA/Hibernate risk
- configuration risk
- cache risk
- test gap
- build-tool risk
- dependency risk
- security risk

## Dependency Changes

| ID | Dependency / Plugin | Old Version | New Version | Reason | Risk | Validation |
|----|---------------------|-------------|-------------|--------|------|------------|
| D-001 | TBD | TBD | TBD | TBD | TBD | TBD |

- [ ] Each dependency or plugin change has a migration reason.
- [ ] Dependency changes are grouped by reason.
- [ ] Dependency changes are validated separately when possible.
- [ ] Runtime behavior risk is recorded.

## Build Configuration Changes

| ID | File | Change | Reason | Validation |
|----|------|--------|--------|------------|
| B-001 | TBD | TBD | TBD | TBD |

- [ ] `pom.xml` changes are recorded.
- [ ] Parent POM changes are recorded.
- [ ] Maven profile changes are recorded.
- [ ] Maven Wrapper changes are recorded.
- [ ] Compiler, surefire, failsafe, dependency management, annotation processor, generated source, and CI build changes are recorded when touched.

## Compatibility Checklist

- [ ] SOAP/XML WSDL, XSD, namespaces, prefixes, element order, `SOAPAction`, null/empty tags, dates, numbers, and faults were reviewed when touched.
- [ ] JAXB, JAX-WS, SAAJ, generated classes, marshalling, and unmarshalling were reviewed when touched.
- [ ] JSP, servlet, tag libraries, JSTL, custom tags, expression language, encoding, content type, sessions, request attributes, and form parameters were reviewed when touched.
- [ ] JMS destinations, connection factories, serialization, selectors, acknowledgements, transactions, redelivery, dead-letter behavior, listener concurrency, headers, correlation IDs, reply-to destinations, and timeouts were reviewed when touched.
- [ ] JDBC drivers, connection pools, autocommit, isolation, timeouts, schema, SQL dialect, stored procedures, generated keys, date/time mappings, number mappings, and transaction boundaries were reviewed when touched.
- [ ] JPA/Hibernate mappings, lazy loading, flush behavior, transaction scope, and query behavior were reviewed when touched.
- [ ] Date, time, timezone, locale, charset, `String.getBytes()`, `new String(byte[])`, `DecimalFormat`, and `BigDecimal` behavior were reviewed when touched.
- [ ] Cache behavior was reviewed when touched.
- [ ] Security-sensitive behavior was reviewed when touched.

Compatibility notes:

```text
<compatibility notes>
```

## Characterization Tests

| ID | Test Class | Behavior Captured | Area | Status |
|----|------------|-------------------|------|--------|
| CT-001 | TBD | TBD | TBD | Planned |

- [ ] SOAP request payloads are covered when relevant.
- [ ] SOAP response payloads are covered when relevant.
- [ ] SOAP faults are covered when relevant.
- [ ] XML marshalling and unmarshalling are covered when relevant.
- [ ] JSP rendered output is covered when relevant.
- [ ] JMS message headers and payloads are covered when relevant.
- [ ] JDBC query results and transaction behavior are covered when relevant.
- [ ] Date/time, number formatting, encoding, and caching behavior are covered when relevant.

## Commit Log

| Commit | Message | Area | Risk | Validation |
|--------|---------|------|------|------------|
| TBD | TBD | TBD | TBD | TBD |

## Final Acceptance Checklist

- [ ] Java 8 baseline behavior is documented.
- [ ] Java 8 test coverage is at least 90%, or uncovered risk is documented and accepted.
- [ ] Java 21 compile passes.
- [ ] Java 21 test coverage is at least 90%, or uncovered risk is documented and accepted.
- [ ] Unit tests pass or known failures are documented.
- [ ] Integration tests pass or known failures are documented.
- [ ] SOAP/XML compatibility risks are reviewed.
- [ ] JSP/Tomcat compatibility risks are reviewed.
- [ ] JMS compatibility risks are reviewed.
- [ ] JDBC compatibility risks are reviewed.
- [ ] JPA/Hibernate compatibility risks are reviewed.
- [ ] Date/time/locale/charset/BigDecimal risks are reviewed.
- [ ] Dependency upgrades are documented.
- [ ] Temporary JVM flags are removed or justified.
- [ ] CI/CD configuration is updated.
- [ ] Final validation command is documented.
- [ ] Final migration audit has approved the final diff.
