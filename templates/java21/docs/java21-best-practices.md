# Java 21 Best Practices

## Purpose

This document provides practical best practices for maintaining a Java 21 project safely.

Use it for projects that already run on Java 21.

For Java 8 to Java 21 migrations, use the `java21-migration` template instead.

---

## Development Environment

Use `java-agentic-devkit` to keep the team on the same Java 21 toolchain.

From the developer machine:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/java21/project java21
```

Inside the container:

```bash
java -version
mvn -version
git status
```

---

## Java 21 Usage

Use Java 21 features when they make the code clearer, safer, or easier to maintain.

Good candidates:

- records for immutable data carriers
- sealed classes for closed domain hierarchies
- pattern matching when it simplifies type checks
- switch expressions for clear value selection
- text blocks for readable SQL, JSON, XML, or test fixtures
- immutable collection factory methods for small constants
- `Stream.toList()` when an unmodifiable result is intended

Do not rewrite stable code only to use newer syntax.

Do not introduce advanced features where the surrounding codebase uses a simpler established style.

---

## Virtual Threads

Virtual threads can be useful for blocking I/O workloads, but they are not a default answer for every performance problem.

Before using virtual threads, check:

1. Is the workload mostly blocking I/O?
2. Does the framework support virtual threads safely?
3. Are JDBC drivers, JMS clients, HTTP clients, and monitoring tools compatible?
4. Are thread-local assumptions documented and tested?
5. Is there a benchmark or production symptom justifying the change?

Keep virtual-thread changes isolated and validate them under realistic load when possible.

---

## Code Change Principles

Make the smallest change that solves the problem.

Preserve existing behavior unless a behavior change is explicitly requested.

Do not mix unrelated refactoring with bug fixes.

Avoid formatting-only churn in files that are otherwise unrelated.

Use existing project patterns before adding new frameworks, helpers, or dependencies.

---

## Testing

Use Maven Wrapper when available:

```bash
./mvnw clean verify
```

Otherwise use Maven:

```bash
mvn clean verify
```

For small changes, start with the narrowest relevant test:

```bash
mvn -Dtest=ClassNameTest test
```

Then run broader validation when the change affects shared code, runtime configuration, dependencies, public APIs, persistence behavior, or security behavior.

Add characterization tests before changing behavior that is poorly documented or risky.

---

## Enterprise Java Risk Areas

Treat these areas as behavior-sensitive:

- Jakarta EE vs Java EE package boundaries
- REST API request and response contracts
- SOAP/XML namespaces, prefixes, element order, and `SOAPAction`
- JSON serialization and deserialization
- JMS acknowledgement, redelivery, retry, and transaction behavior
- JDBC SQL, transaction boundaries, isolation, and connection handling
- JPA lazy loading, flush behavior, and transaction scope
- Spring profiles, bean lifecycle, and property resolution
- date, time, timezone, locale, and charset handling
- `BigDecimal` scale, formatting, and rounding
- thread pools, virtual threads, and blocking calls
- logging output consumed by monitoring or operations

When changing these areas, document the current behavior and run targeted tests.

---

## Dependencies

Do not upgrade dependencies without a clear reason.

Before adding or changing a dependency, check:

1. Is it compatible with Java 21?
2. Is it already managed by the parent POM or dependency management?
3. Does the project already have a library that solves the same problem?
4. What runtime behavior could change?
5. Does it affect security, deployment, observability, or performance?
6. What validation command proves the change is safe?

Keep dependency changes isolated from application code changes when possible.

---

## Security and Errors

Do not log secrets, tokens, passwords, personal data, or large payloads.

Preserve exception causes when wrapping exceptions.

Be careful with changes to authentication, authorization, TLS, CORS, CSRF, deserialization, file handling, and external command execution.

Do not weaken validation or error handling to make tests pass.

---

## Git Workflow

Before starting work:

```bash
git status
git branch --show-current
```

Before committing:

```bash
git diff
git status
```

Keep commits focused on one logical change.

Include tests or a short explanation when tests cannot be run.

---

## Recommended First Commit

After copying this template into a target Java 21 project, commit the instruction files first:

```bash
git add AGENTS.md .github/copilot-instructions.md docs/java21-best-practices.md
git commit -m "chore: add Java 21 development instructions"
```
