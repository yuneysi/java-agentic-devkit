# Java 8 Baseline Capture Phase Skill

Use this skill when the user asks to capture the Java 8 baseline at the start of a Java 8 to Java 21 + Jakarta EE migration.

## Goal

Run the Java 8 validation commands, store raw results under `docs/migration-results/java8-baseline/`, record every metric and behavioral observation so the Java 21 candidate can be compared against a known starting point. Do not modify any code.

## Rules

- Use Java 8 mode (`JAVA_HOME=/opt/java/jdk8`). Fail if Java 21 is detected.
- Do not modify production code, tests, or configuration.
- Store ALL output as raw files under `docs/migration-results/java8-baseline/`.
- Do not summarize away warnings or pre-existing failures — they are evidence.
- If the project needs special Maven profiles, run each profile separately and save output.
- If coverage is below 90%, report the gap as a blocker for production migration changes.

## Context Needed

Before this skill runs, confirm:

- `JAVA_HOME` points to a Java 8 JDK: `java -version`
- `./mvnw` or `mvn` is available
- Project directory is writable for creating `docs/migration-results/`
- No other migration changes are in progress (clean working tree)

## Inspect / Search

Review these project areas:

- `pom.xml` — parent, root, child module structure
- Java source/target/release settings in compiler plugin
- Spring Boot version and starters
- SOAP/XML/JAXB/SAAJ dependencies
- JMS, JDBC, JPA/Hibernate usage
- Date/time/BigDecimal formatting patterns
- Existing test structure and coverage tool (JaCoCo)
- Checkstyle, FindBugs, PMD configuration in parent POM

### Recommended search commands

```bash
rg "javax\.persistence|javax\.validation|javax\.servlet|javax\.xml\.bind" --type java
rg "spring-boot-starter|spring-boot.version" --type xml
rg "SimpleDateFormat|DateTimeFormatter|BigDecimal|DecimalFormat" --type java
rg "JAXB|Marshaller|Unmarshaller|@XmlElement|SOAPAction" --type java
```

## Required Output

Return:

1. Build status (SUCCESS/FAILURE) and test results (`Tests run: N, Failures: F, Errors: E, Skipped: S`)
2. Coverage percentage (instruction/branch/line), or why it could not be measured
3. Pre-existing failures, warnings, or gaps (checkstyle, findbugs, PMD, dependency analysis)
4. Key behavioral observations that the migration must preserve (REST endpoints, SOAP namespaces, error response format, date/number formats)
5. Whether baseline capture is complete or blocked
6. Recommended next phase (characterization if coverage < 90%, else plan migration)

## Validation

After applying this skill, verify the output files exist:

```bash
ls -la docs/migration-results/java8-baseline/
cat docs/migration-results/java8-baseline/jdk-version.log
cat docs/migration-results/java8-baseline/compile-and-test-output.log | grep "BUILD\|Tests run:"
```

## Final Rule

A migration without a documented baseline is untrustworthy. Do not proceed to migration planning until baseline metrics are saved.
