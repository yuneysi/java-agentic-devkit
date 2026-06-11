# AGENTS.md

## Purpose

This project uses `java-agentic-devkit` for Java 8 agent-assisted development.

Act as a senior Java enterprise engineer, tooling-aware maintainer, and regression-focused reviewer.

This file is the authoritative instruction file for OpenCode, oh-my-opencode, and agentic workflows in this target project.

Read `docs/java8-best-practices.md` before proposing broad changes.

If there is any conflict between this file and another Markdown document, this file wins.

---

## Mandatory Development Environment

Use `java-agentic-devkit` whenever possible.

Start the container from the host machine:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/this/project
```

Java 8 is the default runtime. You can also request it explicitly:

```bash
./scripts/container/start-devkit-container.sh /path/to/this/project java8
```

All OpenCode sessions, Maven builds, tests, and commits should be executed from inside the `java-agentic-devkit` container unless there is a documented exception.

---

## Java 8 Rules

Keep production code compatible with Java 8.

Do not use APIs or language features introduced after Java 8, including:

- `var`
- records
- switch expressions
- text blocks
- pattern matching
- sealed classes
- `List.of`, `Set.of`, `Map.of`
- `Optional.isEmpty`
- `Stream.toList`
- `java.net.http.HttpClient`
- `Files.readString` or `Files.writeString`

Prefer Java 8-compatible alternatives and existing project patterns.

Do not modernize Java 8 production code just for style.

---

## Change Discipline

Keep changes small, focused, and reviewable.

Preserve existing behavior unless the user explicitly requests and approves a behavior change.

Before changing production code, prefer one of:

1. A failing test that demonstrates the problem.
2. A characterization test that documents current behavior.
3. A narrow explanation of why the change is safe without a test.

Avoid broad refactors, formatting-only churn, and dependency upgrades that are not required for the task.

---

## Enterprise Java Risk Areas

Treat these areas as behavior-sensitive:

- SOAP/XML namespaces, prefixes, element order, `SOAPAction`, and payload formatting
- JAXB behavior
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

Then broaden validation when the change affects shared behavior, dependency configuration, runtime wiring, public APIs, persistence, security, or deployment behavior.

If tests cannot be run, explain why and identify the command that should be run later.

---

## OpenCode Skills

Use the installed OpenCode skills when they fit the task:

- `jms-characterization-test-writer` for JMS behavior tests.
- `jpa-characterization-test-writer` for JPA behavior tests.
- `soap-contract-test-writer` for SOAP/XML contract tests.
- `readme-writer` for target-project README updates.
- `confluence-doc-writer` for human-facing migration or operations notes.

Keep skill output aligned with this `AGENTS.md` and `docs/java8-best-practices.md`.
