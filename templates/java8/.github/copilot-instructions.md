# GitHub Copilot Instructions

This repository is a Java 8 project.

Keep all production code compatible with Java 8.

Preserve existing behavior unless the user explicitly requests a behavior change.

Do not modernize code for style reasons.

Do not perform broad refactors.

Prefer small, reviewable changes.

Before changing production code, prefer characterization or regression tests.

Avoid Java features and APIs introduced after Java 8, including:

- `var`
- records
- text blocks
- switch expressions
- pattern matching
- sealed classes
- `List.of`, `Set.of`, `Map.of`
- `Optional.isEmpty`
- `Stream.toList`
- `java.net.http.HttpClient`
- `Files.readString` and `Files.writeString`

Pay special attention to:

- SOAP/XML contracts
- JAXB behavior
- JMS behavior with ActiveMQ and IBM MQ
- JDBC and transaction boundaries
- JPA lazy loading and flush behavior
- JSP and servlet behavior
- Spring configuration and bean lifecycle
- date/time formatting
- timezone behavior
- locale behavior
- charset behavior
- BigDecimal formatting and rounding

Do not silently change:

- SOAP namespaces
- XML element order
- XML prefixes
- SOAPAction
- null vs empty XML elements
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
- Java 8 compatibility risk
- behavior risk
- files affected
- tests to run

---

# Recommended Prompts

## 1. Maintenance audit

```text
Read AGENTS.md first and follow it strictly.

Inspect this Java 8 project for maintenance risks.

Do not modify files.

Focus on build health, tests, dependency risk, Java 8 compatibility, runtime configuration, SOAP/XML, JMS, JDBC, JPA, JSP, and Spring configuration.

Return a prioritized plan with small, reviewable steps.
```

## 2. Focused bug fix

```text
Read AGENTS.md first and follow it strictly.

Fix only the current bug.

Do not refactor unrelated code.

Preserve existing Java 8 behavior.

Add or update the narrowest relevant test when possible.

Run the smallest relevant validation command.

Report changed files, risk level, validation result, and proposed commit message.
```

## 3. Characterization test

```text
Read AGENTS.md first and follow it strictly.

Add a characterization test for the current Java 8 behavior.

Do not modify production code.

Preserve current output exactly, including formatting, null handling, date/time behavior, XML namespaces, and BigDecimal scale where relevant.

Run only the relevant test.

Report changed files, validation result, and proposed commit message.
```

## 4. Review current diff

```text
Read AGENTS.md first and follow it strictly.

Review the current Git diff as a Java 8 maintainer.

Do not modify files.

Check for behavior regressions, Java 8 incompatibilities, missing tests, dependency risk, and runtime risk.

Report blocking issues, non-blocking issues, missing tests, and whether the change is safe to commit.
```
