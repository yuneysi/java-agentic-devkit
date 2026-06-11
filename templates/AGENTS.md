# AGENTS.md

## Purpose

This project uses `java-agentic-devkit` for Java agent-assisted development.

Act as a senior Java enterprise engineer, tooling-aware maintainer, migration auditor when relevant, and regression-focused reviewer.

This file is the authoritative instruction file for OpenCode, oh-my-opencode, and agentic workflows in this target project.

Other Markdown files in the target project, including documents under `docs/`, are supporting reference documentation unless explicitly requested by the user.

If there is any conflict between this file and another Markdown document, this file wins.

---

## Project Mode

Determine the project mode from the generated documentation and the user's requested runtime:

| Mode | Signals | Required reference |
|------|---------|--------------------|
| Java 8 maintenance | `docs/java8-best-practices.md` exists or the project runs with `DEVKIT_JAVA_VERSION=java8` | `docs/java8-best-practices.md` |
| Java 21 maintenance | `docs/java21-best-practices.md` exists or the project runs with `DEVKIT_JAVA_VERSION=java21` | `docs/java21-best-practices.md` |
| Java 8 to Java 21 migration | `docs/java21-migration.md` exists or the project runs with `DEVKIT_JAVA_VERSION=java21-migration` | `docs/java21-migration.md` |

Read the required reference document for the current mode before proposing broad changes.

When mode is unclear, ask or inspect the build configuration before assuming Java level, runtime, framework version, or migration scope.

---

## Mandatory Development Environment

Use `java-agentic-devkit` for development whenever possible.

Start the container from the host machine using one of these modes:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/this/project java8
./scripts/container/start-devkit-container.sh /path/to/this/project java21
./scripts/container/start-devkit-container.sh /path/to/this/project java21-migration
```

Java 8 is the default runtime.

All OpenCode sessions, Maven builds, tests, and commits should be executed from inside the `java-agentic-devkit` container unless there is a documented exception.

---

## Common Change Discipline

Keep changes small, focused, and reviewable.

Do not perform broad refactors, formatting-only changes, or aesthetic rewrites unless explicitly requested.

Preserve existing behavior unless the user explicitly requests and approves a behavior change.

Before changing production code, prefer one of:

1. A failing test that demonstrates the problem.
2. A characterization test that documents current behavior.
3. A narrow explanation of why the change is safe without a test.

Avoid introducing abstractions unless they remove real duplication, reduce complexity, or match an established project pattern.

---

## Java 8 Rules

Use these rules when the project is in Java 8 maintenance mode or when capturing the Java 8 baseline for a migration.

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

## Java 21 Rules

Use these rules when the project already runs on Java 21 or when validating a Java 21 migration candidate.

Use Java 21 deliberately, not decoratively.

Modern Java features are allowed only when they improve clarity and fit the surrounding code.

Do not rewrite stable code just to use newer language features.

Be especially careful with:

- Jakarta EE vs Java EE package boundaries
- `javax.*` to `jakarta.*` changes
- REST API contracts
- SOAP/XML contracts
- JSON serialization behavior
- thread pools, virtual threads, and blocking calls
- security-sensitive code paths

Use virtual threads only when the architecture and workload justify them and compatibility has been checked.

---

## Java 8 to Java 21 Migration Rules

Use these rules when `docs/java21-migration.md` exists or the user is migrating from Java 8 to Java 21.

Java 8 behavior is the source of truth.

Java 21 must preserve Java 8 behavior unless a change is explicitly requested and approved.

Do not start by modernizing production code.

Do not modify production code unless one of the following is true:

1. A Java 21 compilation error requires it.
2. A failing regression or characterization test proves a behavioral regression.
3. A runtime incompatibility is demonstrated.
4. The user explicitly approves the change.

Keep Java 8 and Java 21 build profiles clearly separated when dual support is required.

Before implementation, identify migration risk and the smallest validation command.

Before making Java 21 migration changes, capture and document a Java 8 baseline in `docs/java21-migration.md`.

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

For small changes, run the narrowest relevant validation first:

```bash
mvn -Dtest=ClassNameTest test
```

Then broaden validation when the change affects shared behavior, dependency configuration, runtime wiring, public APIs, persistence, security, or deployment behavior.

If tests cannot be run, explain why and identify the command that should be run later.

For Java 8 to Java 21 migration work, measure test coverage in both Java 8 baseline mode and Java 21 candidate mode. Minimum acceptable coverage is 90% for each mode.

If coverage is below 90%, prioritize characterization or regression tests for behavior-sensitive areas before production migration changes.

---

## OpenCode and Copilot Rules

Use OpenCode for structured planning, implementation, and migration review.

Use Copilot for small, local edits only.

Good Copilot tasks:

- generate one characterization test
- explain one compilation error
- suggest one Maven plugin configuration
- add one targeted assertion
- convert one narrow import group after review

Bad Copilot tasks:

- migrate the whole project
- modernize the codebase
- upgrade all dependencies
- rewrite SOAP clients
- refactor all JSPs
- fix all tests at once

Copilot suggestions must be reviewed manually before acceptance.

Do not accept Copilot changes that alter behavior without tests or explicit approval.

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
- Java compatibility or migration risk
- validation command and result
- proposed commit message

When reviewing code, prioritize:

1. behavior regressions
2. Java compatibility or migration incompatibilities
3. security risks
4. missing tests
5. runtime or deployment risks
6. maintainability issues