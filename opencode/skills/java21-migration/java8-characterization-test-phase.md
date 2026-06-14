# Java 8 Characterization Test Phase Skill

Use this skill when baseline coverage is below 90% and the project needs characterization tests that document Java 8 behavior before migration changes begin.

## Goal

Write minimal, focused tests that capture current Java 8 behavior in areas with low coverage or high migration risk. Each test is a regression shield: it must pass on Java 8 AND on the Java 21 candidate. Do not write tests for obvious behavior — write them where migration is likely to break something.

## Rules

- Read `docs/migration-results/java8-baseline/` first. Know which areas have low coverage.
- Do not modify production code.
- Do not write tests for code that already has adequate coverage (instruction > 90%).
- One test class per risk area (SOAP, REST, JMS, JPA, date/number formatting).
- Tests must pass on Java 8. If they fail on Java 8, they are not characterization tests — revert them.
- Use the existing test framework (JUnit 4/5, Mockito, MockMvc, WebServiceTemplate).
- Prefer narrow, focused assertions over broad integration tests.

## Context Needed

Before this skill runs, it needs:

- `docs/migration-results/java8-baseline/baseline-summary.md` — coverage gaps and risk areas
- JaCoCo report (`target/site/jacoco/index.html` or XML report)
- Knowledge of which modules have low coverage: `rg "instructionCoverage" target/site/jacoco/*.csv`
- List of existing test classes to avoid duplication

## Inspect / Search

Review these areas for test gaps (prioritized by migration risk):

- SOAP/XML — namespaces, element order, SOAPAction header, fault handling, null vs empty tags
- REST — endpoint paths, HTTP status codes, error response body format, headers
- JAXB — marshalling/unmarshalling, `JAXBElement` wrapping, `ObjectFactory` behavior
- Date/Time — `SimpleDateFormat`, `GregorianCalendar`, XML date formats, timezone handling
- BigDecimal — scale, rounding mode, string formatting with `DecimalFormat`
- JPA — entity mappings, lazy loading behavior, flush order
- JMS — message format, destination naming, listener configuration

### Recommended search commands

```bash
rg "class.*Test" --type java --sort path | sort
rg "instructionCoverage" target/site/jacoco/*.csv 2>/dev/null
rg "javax\.xml|JAXB|SOAPAction|@XmlElement|ObjectFactory" --type java
rg "SimpleDateFormat|DateTimeFormatter|BigDecimal|setScale|RoundingMode" --type java
```

## Required Output

Return:

1. List of test classes created and what behavior each captures
2. Validation: all new tests pass on Java 8 (command + exit code)
3. Coverage improvement — instruction % before vs after characterization tests
4. Risks that remain uncovered and why (e.g., "cannot test without real database")
5. Recommended next phase (plan migration if coverage >= 90%, else continue characterization)

## Validation

```bash
JAVA_HOME=/opt/java/jdk8 ./mvnw clean test -pl <affected-module> 2>&1 | tee docs/migration-results/java8-baseline/characterization-test-output.log
```

Confirm the test count increased without breaking existing tests. Compare against original baseline:

```bash
grep "Tests run:" docs/migration-results/java8-baseline/compile-and-test-output.log
grep "Tests run:" docs/migration-results/java8-baseline/characterization-test-output.log
```

## Final Rule

Do not trust a migration because it compiles. Trust it only when characterization tests pass on both Java 8 and Java 21.
