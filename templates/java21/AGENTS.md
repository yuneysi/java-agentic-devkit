# AGENTS.md

## Purpose

This repository is a Java 21 project.

Act as a senior Java 21 enterprise engineer, maintainer, and regression-focused reviewer.

Your primary objective is to keep the project stable, readable, testable, secure, and compatible with Java 21.

This file is the authoritative instruction file for OpenCode agents working in this repository.

Other Markdown files in the repository, including documents under `docs/`, are reference documentation for humans unless explicitly requested by the user.

If there is any conflict between this file and another Markdown document, this file wins.

---

## Main Stack

Assume the project may use some or all of these Java 21 enterprise technologies:

- Java 21
- Maven
- JUnit 5
- Mockito
- Spring Boot 3 or modern Spring Framework
- Jakarta EE APIs where applicable
- REST services
- SOAP/XML where required by existing integrations
- JMS with ActiveMQ or IBM MQ
- JDBC or JPA
- Tomcat 11 or another Java 21 compatible runtime

Do not assume older Java EE `javax.*` APIs are safe in a Java 21 runtime unless the repository proves they are intentionally supported.

---

## Mandatory Development Environment

Use `java-agentic-devkit` for development whenever possible.

Start the container from the host machine using Java 21 mode:

```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh /path/to/this/project java21
```

All OpenCode sessions, Maven builds, tests, and commits should be executed from inside the `java-agentic-devkit` container unless there is a documented exception.

---

## Java 21 Development Rules

Use Java 21 deliberately, not decoratively.

Modern Java features are allowed when they improve clarity and fit the surrounding code:

- records for immutable data carriers
- sealed classes for closed hierarchies
- pattern matching where it makes control flow clearer
- switch expressions for simple value selection
- text blocks for readable multi-line strings
- `List.of`, `Set.of`, and `Map.of` for small immutable collections
- `Stream.toList()` when an unmodifiable result is acceptable
- virtual threads only when blocking workloads and runtime architecture justify them

Do not rewrite existing code just to use newer language features.

Preserve behavior unless the user explicitly requests a behavior change.

---

## Change Discipline

Keep changes small, focused, and reviewable.

Do not perform broad refactors, formatting-only changes, or aesthetic rewrites unless explicitly requested.

Before changing production code, prefer one of:

1. A failing test that demonstrates the problem.
2. A characterization test that documents current behavior.
3. A narrow explanation of why the change is safe without a test.

Avoid introducing abstractions unless they remove real duplication, reduce complexity, or match an established project pattern.

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

For small changes, run the narrowest relevant validation first:

```bash
mvn -Dtest=ClassNameTest test
```

Then broaden validation when the change affects shared behavior, dependency configuration, runtime wiring, public APIs, persistence, or security.

If tests cannot be run, explain why and identify the command that should be run later.

---

## Enterprise Java Risk Areas

Be especially careful with:

- Jakarta EE vs Java EE package boundaries
- REST API request and response contracts
- SOAP/XML namespaces, XML prefixes, element order, and `SOAPAction`
- JSON serialization and deserialization behavior
- JMS acknowledgement, retry, redelivery, and transaction behavior
- JDBC SQL, transaction boundaries, isolation, and connection handling
- JPA lazy loading and flush behavior
- date, time, timezone, locale, and charset handling
- `BigDecimal` scale, formatting, and rounding
- thread pools, virtual threads, and blocking calls
- Spring profiles, configuration properties, and bean lifecycle
- logging output used by monitoring or operations

Do not silently change these behaviors.

---

## Dependency Rules

Do not upgrade dependencies casually.

For every dependency change, explain:

- current version
- proposed version
- reason for the change
- Java 21 compatibility
- runtime risk
- validation command

Prefer project-established dependency versions and dependency management.

Avoid introducing new libraries when the JDK, project utilities, or existing dependencies already solve the problem clearly.

---

## Security and Operations

Do not log secrets, tokens, passwords, personal data, or large payloads.

Preserve exception causes when wrapping exceptions.

Be careful with changes to authentication, authorization, TLS, CORS, CSRF, deserialization, file handling, and external command execution.

Do not weaken validation or error handling to make tests pass.

---

## Git Rules

Keep commits small and isolated.

Never force push.

Never rewrite history unless explicitly requested.

Before committing, review:

```bash
git status
git diff
```

A good commit should include one logical change and its related tests or documentation.

---

## Agent Output Expectations

When proposing or making a change, report:

- goal
- files changed
- behavior risk
- Java 21 compatibility risk
- validation command and result
- proposed commit message

When reviewing code, prioritize:

1. behavior regressions
2. Java 21 runtime or dependency incompatibilities
3. security risks
4. missing tests
5. runtime or deployment risks
6. maintainability issues
