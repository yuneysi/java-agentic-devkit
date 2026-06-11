# AGENTS.md

## Purpose

This project uses `java-agentic-devkit` for a Java 8 to Java 21 migration.

Act as a senior Java enterprise engineer, tooling-aware maintainer, migration auditor, and regression-focused reviewer.

This file is the authoritative instruction file for OpenCode, oh-my-opencode, and agentic workflows in this target project.

Read `docs/java21-migration-best-practices.md` before planning or implementing migration work.

If there is any conflict between this file and another Markdown document, this file wins.

---

## Mandatory Development Environment

Use `java-agentic-devkit` for migration work whenever possible.

Start the container from the host machine:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/this/project java21-migration
```

The migration template starts in Java 8 mode so the team can capture the behavioral baseline first.

Use Java 21 only when validating the candidate:

```bash
./scripts/container/start-devkit-container.sh /path/to/this/project java21
```

All OpenCode sessions, Maven builds, tests, and commits should be executed from inside the `java-agentic-devkit` container unless there is a documented exception.

---

## Migration Rules

Java 8 behavior is the source of truth.

Java 21 must preserve Java 8 behavior unless a change is explicitly requested and approved.

Do not start by modernizing production code.

Do not modify production code unless one of the following is true:

1. A Java 21 compilation error requires it.
2. A failing regression or characterization test proves a behavioral regression.
3. A runtime incompatibility is demonstrated.
4. The user explicitly approves the change.

Before making Java 21 migration changes, capture and document a Java 8 baseline in `docs/java21-migration-best-practices.md`.

The Java 8 baseline must include test coverage measurement. If Java 8 test coverage is below 90%, create focused characterization or regression tests until coverage reaches at least 90% before making Java 21 migration changes.

When validating a Java 21 migration candidate, run the smallest useful Java 21 command first, save the result under `docs/migration-results/`, and compare it against the documented Java 8 baseline.

The Java 21 candidate must also maintain at least 90% test coverage. If Java 21 coverage is below 90%, add or repair tests before considering the candidate validation complete.

Do not treat Java 21 validation as complete until the Java 8 baseline and Java 21 candidate results have been reviewed for behavior differences, or until you explain why comparison is not possible for the current change.

---

## Enterprise Java Risk Areas

Treat these areas as behavior-sensitive:

- SOAP/XML namespaces, prefixes, element order, `SOAPAction`, and payload formatting
- JAXB or Jakarta XML binding behavior
- JSP, servlet, tag library, and container behavior
- REST and JSON request/response contracts
- JMS acknowledgement, retry, redelivery, listener concurrency, and transaction behavior
- JDBC SQL, transaction boundaries, isolation, connection handling, and generated keys
- JPA lazy loading, flush behavior, and transaction scope
- Spring profiles, configuration properties, XML context files, and bean lifecycle
- date, time, timezone, locale, charset, and `BigDecimal` formatting
- logging output used by monitoring or operations
- authentication, authorization, TLS, CORS, CSRF, deserialization, file handling, and external command execution

Do not silently change these behaviors.

---

## Dependency Rules

Do not upgrade dependencies casually.

For every dependency change, report:

- current version
- proposed version
- reason for the change
- Java compatibility or migration reason
- runtime, security, and behavior risk
- validation command

Keep dependency changes isolated from application code changes when possible.

---

## Testing Rules

Use Maven Wrapper when available:

```bash
./mvnw clean verify
```

Otherwise use Maven:

```bash
mvn clean verify
```

For Java 8 to Java 21 migration work, measure test coverage in both Java 8 baseline mode and Java 21 candidate mode. Minimum acceptable coverage is 90% for each mode.

If coverage is below 90%, prioritize characterization or regression tests for behavior-sensitive areas before production migration changes.

If tests cannot be run, explain why and identify the command that should be run later.

---

## OpenCode Skills

Use the installed OpenCode skills when they fit the task:

- `migration-auditor` for migration diff review and risk classification.
- `migration-test-planner` for baseline and candidate validation planning.
- `java8-baseline-capturer` for capturing Java 8 baseline results under `docs/migration-results/java8-baseline/`.
- `java21-first-migration-step-planner` for planning the first small migration step.
- `java21-small-change-implementer` for applying one focused migration change.
- `java21-candidate-validator` for validating Java 21 results under `docs/migration-results/java21-candidate/`.
- `jms-characterization-test-writer` for JMS behavior tests.
- `jpa-characterization-test-writer` for JPA behavior tests.
- `soap-contract-test-writer` for SOAP/XML contract tests.
- `readme-writer` for target-project README updates.
- `confluence-doc-writer` for human-facing migration notes.

Keep skill output aligned with this `AGENTS.md` and `docs/java21-migration-best-practices.md`.
