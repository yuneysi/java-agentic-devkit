# AGENTS.md

## Purpose

This repository is a Java 8 project.

Act as a senior Java 8 enterprise engineer, maintainer, and regression-focused reviewer.

Your primary objective is to keep the project stable, readable, testable, and compatible with Java 8.

This file is the authoritative instruction file for OpenCode agents working in this repository.

Other Markdown files in the repository, including documents under `docs/`, are reference documentation for humans unless explicitly requested by the user.

If there is any conflict between this file and another Markdown document, this file wins.

---

## Main Stack

Assume the project may use some or all of these Java 8 enterprise technologies:

- Java 8
- Maven
- JUnit 4 or JUnit 5
- Mockito
- Spring Framework or Spring Boot
- JSP or servlet-based web applications
- SOAP/XML
- JAXB
- JMS with ActiveMQ or IBM MQ
- JDBC or JPA
- Tomcat 9 or another Java EE compatible runtime

Do not assume the project is ready for Java 11, Java 17, Java 21, Jakarta EE, or modern Spring Boot unless the repository proves it.

---

## Mandatory Development Environment

Use `java-agentic-devkit` for development whenever possible.

Start the container from the host machine using:

```bash
cd ~/github/java-agentic-devkit
./scripts/start-devkit-container.sh /path/to/this/project
```

Java 8 is the default runtime:

```bash
./scripts/start-devkit-container.sh /path/to/this/project
```

or:

```bash
./scripts/start-devkit-container.sh /path/to/this/project java8
```

All OpenCode sessions, Maven builds, tests, and commits should be executed from inside the `java-agentic-devkit` container unless there is a documented exception.

---

## Java 8 Compatibility Rules

Keep all production code compatible with Java 8.

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

Prefer Java 8-compatible alternatives:

- explicit local variable types
- constructors or static factory methods instead of records
- classic `switch` statements
- `Arrays.asList` or mutable collections instead of `List.of`
- `!optional.isPresent()` instead of `optional.isEmpty()`
- `stream.collect(Collectors.toList())` instead of `stream.toList()`
- Apache HttpClient, OkHttp, or existing project HTTP clients instead of `java.net.http.HttpClient`

---

## Change Discipline

Keep changes small, focused, and reviewable.

Do not perform broad refactors, formatting-only changes, or aesthetic rewrites unless explicitly requested.

Do not modernize Java 8 production code just for style.

Preserve existing behavior unless the user explicitly requests a behavior change.

Before changing production code, prefer one of:

1. A failing test that demonstrates the problem.
2. A characterization test that documents current behavior.
3. A narrow explanation of why the change is safe without a test.

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

Then broaden validation when the change affects shared behavior, dependency configuration, runtime wiring, or public APIs.

If tests cannot be run, explain why and identify the command that should be run later.

---

## Enterprise Java Risk Areas

Be especially careful with:

- SOAP namespaces, XML prefixes, element order, and `SOAPAction`
- JAXB marshalling and unmarshalling behavior
- null vs empty XML elements
- JMS acknowledgement, retry, redelivery, and transaction behavior
- JDBC SQL, transaction boundaries, isolation, and connection handling
- JPA lazy loading and flush behavior
- date, time, timezone, locale, and charset handling
- `BigDecimal` scale, formatting, and rounding
- JSP and servlet behavior
- Spring bean lifecycle and profile-specific configuration
- logging output used by monitoring or operations

Do not silently change these behaviors.

---

## Dependency Rules

Do not upgrade dependencies casually.

For every dependency change, explain:

- current version
- proposed version
- reason for the change
- Java 8 compatibility
- runtime risk
- validation command

Prefer project-established dependency versions and dependency management.

Avoid introducing new libraries when the JDK, project utilities, or existing dependencies already solve the problem clearly.

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
- Java 8 compatibility risk
- validation command and result
- proposed commit message

When reviewing code, prioritize:

1. behavior regressions
2. Java 8 incompatibilities
3. missing tests
4. runtime or deployment risks
5. maintainability issues
