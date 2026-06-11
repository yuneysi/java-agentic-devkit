# AGENTS.md

## Purpose

This repository is being migrated from Java 8 to Java 21.

Act as a senior Java enterprise engineer, migration auditor, and regression-focused reviewer.

Your primary objective is to migrate safely while preserving Java 8 behavior.

This file is the authoritative instruction file for OpenCode agents working in this repository.

Other Markdown files in the repository, including documents under `docs/`, are reference documentation for humans unless explicitly requested by the user.

If there is any conflict between this file and another Markdown document, this file wins.

---

## Main Stack

Legacy runtime:

- Java 8
- Spring Framework
- JSP
- SOAP/XML
- JMS
- JDBC
- Maven
- Git/Bitbucket
- Tomcat 9
- ActiveMQ
- IBM MQ

Target runtime:

- Java 21
- Tomcat 11
- Jakarta-compatible runtime where required

---

## Mandatory Development Environment

This project must be migrated using `java-agentic-devkit`.

Do not run the migration from an ad-hoc local Java or Maven installation unless explicitly approved.

Start the container from the host machine using:

```bash
cd ~/github/java-agentic-devkit
./scripts/start-devkit-container.sh /path/to/this/project
```

Java 8 is the default runtime and must be used to capture the behavioral baseline:

```bash
./scripts/start-devkit-container.sh /path/to/this/project
```

or:

```bash
./scripts/start-devkit-container.sh /path/to/this/project java8
```

Use Java 21 mode only when compiling, testing, or running the Java 21 migration candidate:

```bash
./scripts/start-devkit-container.sh /path/to/this/project java21
```

All OpenCode sessions, Maven builds, tests, and migration commits should be executed from inside the `java-agentic-devkit` container unless there is a documented exception.

---

## Migration Principle

Java 8 is the behavioral source of truth.

Java 21 must preserve Java 8 behavior unless a change is explicitly requested and approved.

Do not start by modernizing production code.

Do not perform broad refactors, formatting-only changes, or aesthetic rewrites.

Prefer characterization tests and regression tests before implementation changes.

Do not modify production code unless one of the following is true:

1. A Java 21 compilation error requires it.
2. A failing regression or characterization test proves a behavioral regression.
3. A runtime incompatibility is demonstrated.
4. The user explicitly approves the change.

Prioritize behavioral equivalence over superficial code coverage.

---

## Operating Modes

### Planning Mode

Use Planning Mode before implementation.

In Planning Mode:

- Inspect the current code and build configuration.
- Identify migration risks.
- Propose small, isolated steps.
- Do not modify files.
- Do not run destructive commands.
- Do not rewrite Git history.

The output must include:

- proposed change
- affected files
- migration risk
- expected validation command
- proposed commit message

### Implementation Mode

Use Implementation Mode only after the task scope is clear.

In Implementation Mode:

- Make the smallest possible change.
- Keep the change focused on one migration concern.
- Run relevant tests or explain why they could not be run.
- Report changed files.
- Report risk level.
- Report commands used.
- Suggest the next small step.

---

## Required Migration Review

Before implementing changes, compare Java 21 behavior against Java 8 behavior whenever possible.

Classify differences as one or more of:

- safe migration
- behavioral risk
- SOAP/XML contract risk
- JSP/runtime risk
- JMS risk
- JDBC risk
- configuration risk
- cache risk
- test gap
- build-tool risk
- dependency risk
- security risk

Always explain the migration risk before proposing or applying a fix.

---

## Git and Branch Rules

The migration starts from:

```text
feature/migrate_to_java21
```

The target branch is:

```text
branch/java21
```

Keep commits small, isolated, and reviewable.

Never force push.

Never rewrite Git history.

Never squash unrelated migration changes together.

Never mix these concerns in one commit unless unavoidable:

- Maven/build configuration
- dependency upgrade
- source code compatibility
- test compatibility
- runtime/Tomcat configuration
- SOAP/XML contract handling
- JMS configuration
- JDBC/database behavior
- CI/CD changes
- documentation

Before every commit, provide:

- summary of changed files
- risk level
- tests added or changed
- commands used to validate the change
- proposed commit message

Preferred commit message examples:

```text
docs: add Java 21 migration plan
build: configure Maven compiler for Java 21
build: upgrade test plugins for Java 21
build: add explicit JAXB dependencies
refactor: migrate servlet imports to Jakarta
test: add SOAP response characterization tests
test: add JMS listener regression coverage
fix: preserve Java 8 XML date formatting on Java 21
ci: build and test with Java 21
```

---

## Build Rules

Do not assume the build is correct.

Inspect:

- `pom.xml`
- parent POMs
- Maven profiles
- Maven wrapper
- compiler plugin
- surefire plugin
- failsafe plugin
- dependency management
- annotation processors
- generated sources
- CI build commands

Prefer Maven Wrapper when available:

```bash
./mvnw clean verify
```

If Maven Wrapper is not available, use:

```bash
mvn clean verify
```

Prefer compiler `release` configuration for Java 21 where possible.

Do not remove Java 8 build support unless explicitly requested.

If dual Java 8 / Java 21 profiles exist or are needed, keep them clearly separated.

---

## Java Compatibility Rules

Inspect and report usage of:

- removed JDK APIs
- deprecated APIs marked for removal
- `sun.*`
- `com.sun.*`
- `Unsafe`
- reflection with `setAccessible`
- custom classloaders
- SecurityManager
- old date/time APIs
- default charset assumptions
- locale assumptions
- timezone assumptions

Use migration tools when useful:

```bash
jdeps
jdeprscan
```

Do not blindly add `--add-opens` or `--add-exports`.

Temporary JVM flags may be used only as diagnostic tools.

If such flags are required, report:

- why they are needed
- which library or code path requires them
- whether a dependency upgrade can remove them
- whether they are temporary or permanent

---

## Dependency Rules

Do not upgrade all dependencies at once.

Group dependency changes by reason:

- Java 21 build compatibility
- Jakarta/Tomcat compatibility
- test framework compatibility
- SOAP/XML compatibility
- JMS compatibility
- JDBC compatibility
- security fix

For every dependency change, report:

- old version
- new version
- reason
- migration risk
- validation command

Pay special attention to:

- Spring Framework
- Servlet API
- JSP/JSTL
- JAXB
- JAX-WS
- SAAJ
- SOAP libraries
- JMS libraries
- ActiveMQ
- IBM MQ
- JDBC drivers
- connection pools
- logging libraries
- Jackson
- Mockito
- Byte Buddy
- JUnit
- Maven plugins
- Lombok
- MapStruct

---

## SOAP/XML Rules

Do not rewrite SOAP contracts unless explicitly requested.

Do not silently normalize XML differences.

XML namespace differences must be explicitly reported.

SOAP request and response payload compatibility must be inspected carefully.

Inspect:

- WSDL
- XSD
- namespaces
- XML prefixes
- SOAPAction
- encoding
- XML element names
- XML element order
- null tags vs empty tags
- omitted optional elements
- date/time formatting
- BigDecimal formatting
- fault responses
- JAXB annotations
- generated classes
- marshalling behavior
- unmarshalling behavior

Preserve JAXB annotations, XML prefixes, date/time formatting, BigDecimal formatting, and namespace behavior unless a human explicitly approves a change.

JAXB/Jakarta migration differences must be inspected carefully.

When changing SOAP/XML-related code, add or update characterization tests using real or representative payloads.

---

## Runtime and Framework Rules

Tomcat 9 is the legacy `javax.*` / JSP runtime.

Tomcat 11 is the Java 21 / Jakarta migration runtime.

Inspect JSP behavior carefully when moving from Tomcat 9 to Tomcat 11.

Inspect servlet API changes carefully.

Inspect `javax.*` to `jakarta.*` migration carefully.

Inspect Spring Framework compatibility with the selected Tomcat and Java version.

Do not migrate from `javax.*` to `jakarta.*` mechanically without checking:

- imports
- deployment descriptors
- tag libraries
- filters
- listeners
- servlet mappings
- JSP compilation
- JSTL compatibility
- custom servlet extensions
- XML configuration files
- Spring XML context files

---

## JSP Rules

Inspect:

- JSP compilation
- tag libraries
- JSTL versions
- custom tags
- scriptlets
- expression language behavior
- servlet container differences
- encoding
- response content type
- session handling
- request attributes
- form parameter handling

Do not change JSP output formatting unless required and tested.

---

## JMS Rules

Inspect JMS behavior explicitly.

Check:

- destination names
- connection factory configuration
- serialization
- message selectors
- acknowledgement mode
- transactions
- redelivery behavior
- dead-letter behavior
- listener concurrency
- message headers
- correlation IDs
- reply-to destinations
- timeout behavior

Inspect ActiveMQ and IBM MQ differences explicitly.

Do not change JMS acknowledgement mode, retry behavior, transaction behavior, destination names, or dead-letter behavior without tests and explicit explanation.

---

## JDBC / Database Rules

Inspect:

- JDBC driver behavior
- connection pool settings
- autocommit
- isolation level
- timeout
- schema
- SQL dialect differences
- stored procedure calls
- generated keys
- date/time database mappings
- BigDecimal mappings
- transaction boundaries

Do not change SQL, transaction boundaries, entity mappings, or database configuration without regression tests or explicit user approval.

---

## Date, Time, Locale, Charset, and Number Rules

Date/time formatting differences must be explicitly reported.

Time zone differences must be explicitly reported.

Locale differences must be explicitly reported.

Default charset differences must be explicitly reported.

BigDecimal formatting and rounding differences must be explicitly reported.

Do not change date/time or BigDecimal behavior without tests.

Inspect usages of:

- `Date`
- `Calendar`
- `SimpleDateFormat`
- `TimeZone`
- `Locale`
- `DecimalFormat`
- `BigDecimal`
- platform default charset
- `String.getBytes()`
- `new String(byte[])`

---

## Testing Rules

Prefer characterization tests before implementation changes.

A characterization test captures current Java 8 behavior.

When possible, compare:

- Java 8 output
- Java 21 output

For migration-sensitive areas, prioritize tests for:

- SOAP request payloads
- SOAP response payloads
- SOAP faults
- XML marshalling/unmarshalling
- JSP rendered output
- JMS message headers and payloads
- JDBC query results
- transaction behavior
- date/time formatting
- BigDecimal formatting
- encoding
- caching behavior

Do not delete failing tests unless the user explicitly approves.

If a test must change, explain whether the old expectation was:

- Java 8 behavior to preserve
- incorrect behavior to fix
- environment-specific behavior
- obsolete test setup

---

## Validation Commands

Prefer the smallest relevant validation command first.

Examples:

```bash
./mvnw -version
./mvnw clean compile
./mvnw test
./mvnw -DskipITs verify
./mvnw verify
```

If Maven Wrapper is not available:

```bash
mvn -version
mvn clean compile
mvn test
mvn verify
```

For targeted tests:

```bash
./mvnw -Dtest=ClassNameTest test
./mvnw -Dtest=ClassNameTest#methodName test
```

For integration tests:

```bash
./mvnw -Dit.test=ClassNameIT verify
```

If a command fails, report:

- command
- failure summary
- likely migration cause
- proposed next smallest fix

---

## OpenCode / oh-my-opencode Workflow

Use OpenCode for structured migration work.

Prefer this flow:

1. Ask the planning agent to inspect and propose a small migration step.
2. Review the plan.
3. Ask the implementation agent to apply one isolated change.
4. Run validation.
5. Ask the review/audit agent to inspect the diff.
6. Commit only after validation is understood.

Do not let an agent perform broad autonomous modernization.

Do not allow multiple unrelated migration changes in one agent run.

Each OpenCode task should have a narrow scope, for example:

```text
Inspect Maven build configuration for Java 21 compatibility. Do not modify files.
```

```text
Update only the Maven compiler configuration to support Java 21. Do not upgrade dependencies.
```

```text
Add characterization tests for SOAP response XML formatting. Do not modify production code.
```

```text
Fix only the Java 21 compilation error in ClassName. Preserve Java 8 behavior.
```

---

## Copilot Rules

Use Copilot for small, local edits only.

Good Copilot tasks:

- convert one import group
- generate one characterization test
- explain one compilation error
- suggest one Maven plugin upgrade
- add one missing dependency
- write one targeted assertion

Bad Copilot tasks:

- migrate the whole project
- modernize the codebase
- upgrade all dependencies
- rewrite SOAP clients
- refactor all JSPs
- change all `javax.*` imports without review
- fix all tests at once

Copilot suggestions must be reviewed manually before acceptance.

Do not accept Copilot changes that alter behavior without tests.

---

## Secrets

This project may intentionally contain secrets in Git.

Do not block work solely because secrets exist, but report the security risk clearly when relevant.

Do not remove, rotate, or rewrite secrets unless explicitly requested.

Do not print secrets in logs, reports, commit messages, or summaries.

---

## Required Response Format

For every proposed or completed change, respond with:

```md
## Summary

<what changed or what is proposed>

## Risk Level

Low | Medium | High

## Migration Risk Classification

- <classification>

## Changed Files

- <file>

## Tests

- Added:
- Changed:
- Commands run:

## Validation Result

Passed | Failed | Not run

## Notes

<important migration notes>

## Proposed Commit Message

<type>: <message>
```
