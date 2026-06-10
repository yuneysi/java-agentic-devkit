# GitHub Copilot Instructions

This repository is a Java 21 project.

Keep production code compatible with Java 21.

Preserve existing behavior unless the user explicitly requests a behavior change.

Do not modernize code for style reasons.

Do not perform broad refactors.

Prefer small, reviewable changes.

Before changing production code, prefer characterization or regression tests.

Java 21 features are allowed when they improve clarity and fit the surrounding code, including:

- records
- sealed classes
- pattern matching
- switch expressions
- text blocks
- immutable collection factory methods
- `Stream.toList()` when an unmodifiable result is acceptable

Use virtual threads only when the project architecture and workload justify them.

Pay special attention to:

- Jakarta EE vs Java EE package boundaries
- REST API contracts
- SOAP/XML contracts
- JSON serialization and deserialization
- JMS behavior with ActiveMQ and IBM MQ
- JDBC and transaction boundaries
- JPA lazy loading and flush behavior
- Spring configuration and bean lifecycle
- date/time formatting
- timezone behavior
- locale behavior
- charset behavior
- BigDecimal formatting and rounding
- thread pools, virtual threads, and blocking calls

Do not silently change:

- public API request or response shapes
- SOAP namespaces
- XML element order
- XML prefixes
- SOAPAction
- JSON field names or null handling
- JMS acknowledgement mode
- JMS retry behavior
- JMS transaction behavior
- SQL queries
- transaction boundaries
- date/time formatting
- BigDecimal formatting

Use Maven Wrapper when available:

```bash
./mvnw clean verify
```

Otherwise use Maven:

```bash
mvn clean verify
```

For every suggested change, explain:

- why the change is needed
- Java 21 compatibility risk
- behavior risk
- security risk when relevant
- files affected
- tests to run

---

# Recommended Prompts

## 1. Maintenance audit

```text
Read AGENTS.md first and follow it strictly.

Inspect this Java 21 project for maintenance risks.

Do not modify files.

Focus on build health, tests, dependency risk, Java 21 compatibility, runtime configuration, Jakarta/Java EE boundaries, REST, SOAP/XML, JMS, JDBC, JPA, and Spring configuration.

Return a prioritized plan with small, reviewable steps.
```

## 2. Focused bug fix

```text
Read AGENTS.md first and follow it strictly.

Fix only the current bug.

Do not refactor unrelated code.

Preserve existing behavior.

Add or update the narrowest relevant test when possible.

Run the smallest relevant validation command.

Report changed files, risk level, validation result, and proposed commit message.
```

## 3. Safe modernization

```text
Read AGENTS.md first and follow it strictly.

Modernize only the selected code path using Java 21 features where they improve clarity.

Do not change behavior.

Do not rewrite unrelated code.

Run the smallest relevant validation command.

Report changed files, behavior risk, validation result, and proposed commit message.
```

## 4. Review current diff

```text
Read AGENTS.md first and follow it strictly.

Review the current Git diff as a Java 21 maintainer.

Do not modify files.

Check for behavior regressions, Java 21 runtime issues, dependency risk, security risk, missing tests, and deployment risk.

Report blocking issues, non-blocking issues, missing tests, and whether the change is safe to commit.
```
