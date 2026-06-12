# AGENTS.md

## Purpose

This project uses `java-agentic-devkit` for a Java 8 to Java 21 migration.

Act as a senior Java enterprise engineer, tooling-aware maintainer, migration auditor, and regression-focused reviewer.

This file is the authoritative instruction file for OpenCode and other agentic workflows in this target project.

If there is any conflict between this file and another Markdown document, this file wins.

---

## Agent Compatibility

OpenCode, oh-my-openagent, and any other agentic workflow must treat this file as the source of truth for this target project.

Tool-specific configuration may define models, providers, skills, UI behavior, or local preferences, but it must not override the migration, testing, dependency, safety, or validation rules in this file.

When an installed skill fits the task, use it. If the skill is unavailable, follow the same rules manually and report the limitation.

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

Before making Java 21 migration changes, capture and document a Java 8 baseline under `docs/migration-results/java8-baseline/`.

When validating a Java 21 migration candidate, run the smallest useful Java 21 command first, save the result under `docs/migration-results/`, and compare it against the documented Java 8 baseline.

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

## Browser / Playwright Rules

If this project contains a web application, Playwright may be used for JSP/UI/runtime smoke tests, browser-based regression checks, login flow checks, form rendering, navigation checks, static asset checks, and Tomcat-rendered page validation.

Do not use Playwright as the first migration step.

Before using Playwright, verify:

- the project compiles
- the application starts locally
- the target URL is known
- required environment variables or test credentials are available
- the current Git branch is safe for migration work

Prefer backend/build checks first:

- `java -version`
- `mvn -v`
- `mvn test`
- `mvn package`
- Tomcat startup logs

Use Playwright only after the application is running or when the user explicitly requests UI/browser validation.

Do not click destructive actions, submit production forms, trigger payments, send real messages, delete data, or modify external systems.

For browser checks, prefer read-only smoke tests:

- open homepage
- verify HTTP status
- verify page title
- verify key text
- verify login page renders
- verify static assets load
- capture console errors
- capture network errors
- capture screenshots only when useful

Report UI/runtime findings separately as:

- JSP/runtime risk
- configuration risk
- behavioral risk
- test gap

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

Keep skill output aligned with this `AGENTS.md`.
