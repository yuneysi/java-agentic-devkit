# Migration Auditor Skill

Use this skill when the user asks to review a Java 21 migration branch against the Java 8 baseline.

## Goal

Audit the migration for behavioral compatibility.

Java 8 is the behavioral source of truth.

## Rules

- Do not modify production code during the audit.
- Do not approve changes only because they compile.
- Do not ignore contract changes.
- Do not silently normalize XML differences.
- Classify all meaningful differences.
- Prefer evidence from tests, diffs, configuration, and generated outputs.
- Report uncertainty clearly.

## Difference Categories

Classify each difference as one of:

- safe migration
- behavioral risk
- SOAP/XML contract risk
- JSP/runtime risk
- JMS risk
- JDBC risk
- JPA/Hibernate risk
- configuration risk
- cache risk
- test gap

## Audit Areas

Inspect:

- `pom.xml` dependency changes.
- Maven plugin changes.
- Java compiler source/target/release settings.
- Spring Framework / Spring Boot changes.
- Tomcat 9 to Tomcat 11 runtime changes.
- `javax.*` to `jakarta.*` changes.
- SOAP/XML code.
- WSDL/XSD files.
- JAXB/JAX-WS/SAAJ dependencies.
- JPA/Hibernate dependencies and mappings.
- JDBC drivers and datasource config.
- JMS config for ActiveMQ and IBM MQ.
- Date/time and BigDecimal logic.
- Configuration files and profiles.
- Test changes.
- Removed tests.
- Skipped tests.
- Changed assertions.

## Required Output

Produce an audit report with:

1. Summary.
2. Branches or commits compared.
3. Safe changes.
4. High-risk changes.
5. SOAP/XML risks.
6. JPA/Hibernate risks.
7. JMS risks.
8. JDBC risks.
9. Configuration risks.
10. Test gaps.
11. Required follow-up tests.
12. Recommended next steps.
13. Questions for human confirmation.

## Commands to Consider

```bash
git status
git branch --show-current
git diff --stat java8...HEAD
git diff java8...HEAD -- pom.xml
git diff java8...HEAD -- '**/*.java'
git diff java8...HEAD -- '**/*.xml'
git diff java8...HEAD -- '**/*.properties'
git diff java8...HEAD -- '**/*.yml'
```

## Final Rule

A migration is not safe because it compiles.

It is safer only when the Java 21 branch passes characterization tests that describe Java 8 production behavior.
