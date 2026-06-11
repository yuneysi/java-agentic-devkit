# Java 8 Best Practices

## Purpose

This document provides practical best practices for maintaining a Java 8 project safely.

Use it for Java 8 projects that are not currently being migrated to Java 21.

For Java 8 to Java 21 migrations, use the `java21-migration` template instead.

---

## Development Environment

Use `java-agentic-devkit` to keep the team on the same Java 8 toolchain.

From the developer machine:

```bash
cd ~/github/java-agentic-devkit
./scripts/start-devkit-container.sh /path/to/java8/project
```

Java 8 is the default runtime. You can also request it explicitly:

```bash
cd ~/github/java-agentic-devkit
./scripts/start-devkit-container.sh /path/to/java8/project java8
```

Inside the container:

```bash
java -version
mvn -version
git status
```

---

## Java 8 Compatibility

Keep production code compatible with Java 8.

Avoid Java features and APIs introduced after Java 8:

| Do not use | Java 8 alternative |
|------------|--------------------|
| `var` | explicit variable type |
| records | class with fields, constructor, getters, `equals`, `hashCode`, `toString` |
| text blocks | regular string literals |
| switch expressions | classic `switch` statements |
| `List.of`, `Set.of`, `Map.of` | `Arrays.asList`, constructors, or project collection helpers |
| `Optional.isEmpty` | `!optional.isPresent()` |
| `Stream.toList` | `stream.collect(Collectors.toList())` |
| `java.net.http.HttpClient` | existing project HTTP client, Apache HttpClient, or OkHttp |
| `Files.readString` | `new String(Files.readAllBytes(path), charset)` |

---

## Code Change Principles

Make the smallest change that solves the problem.

Preserve existing behavior unless a behavior change is explicitly requested.

Do not mix unrelated refactoring with bug fixes.

Avoid formatting-only churn in files that are otherwise unrelated.

Prefer simple Java 8 code over clever abstractions.

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

Then run broader validation when the change affects shared code, runtime configuration, dependencies, public APIs, or persistence behavior.

Add characterization tests before changing behavior that is poorly documented or risky.

---

## Enterprise Java Risk Areas

Treat these areas as behavior-sensitive:

- SOAP/XML namespaces, prefixes, element order, and `SOAPAction`
- JAXB marshalling and unmarshalling
- JMS acknowledgement, redelivery, retry, and transaction behavior
- JDBC SQL, transaction boundaries, isolation, and connection handling
- JPA lazy loading, flush behavior, and transaction scope
- JSP and servlet runtime behavior
- Spring profiles, bean lifecycle, and property resolution
- date, time, timezone, locale, and charset handling
- `BigDecimal` scale, formatting, and rounding
- logging output consumed by monitoring or operations

When changing these areas, document the current behavior and run targeted tests.

---

## Dependencies

Do not upgrade dependencies without a clear reason.

Before adding or changing a dependency, check:

1. Is it compatible with Java 8?
2. Is it already managed by the parent POM or dependency management?
3. Does the project already have a library that solves the same problem?
4. What runtime behavior could change?
5. What validation command proves the change is safe?

Keep dependency changes isolated from application code changes when possible.

---

## Logging and Errors

Keep logs useful for operations.

Do not remove log messages that may be used by monitoring, support, or troubleshooting without checking their purpose.

When adding logs, include useful context but avoid secrets, tokens, passwords, personal data, and large payloads.

Preserve exception causes when wrapping exceptions.

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

After copying this template into a target Java 8 project, commit the instruction files first:

```bash
git add AGENTS.md .github/copilot-instructions.md docs/java8-best-practices.md
git commit -m "chore: add Java 8 development instructions"
```
