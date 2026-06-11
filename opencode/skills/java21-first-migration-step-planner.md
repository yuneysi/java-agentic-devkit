# Java 21 First Migration Step Planner Skill

Use this skill when the user asks to plan the first Java 8 to Java 21 migration step.

## Goal

Inspect the project, identify migration risks, and propose the first small safe migration step.

Do not edit files while planning.

## Rules

- Read `AGENTS.md` first and follow it strictly.
- Use `docs/java21-migration-best-practices.md` as the human migration tracker.
- Confirm the Java 8 baseline exists before planning production changes.
- Do not modify files unless the user explicitly asks to update the tracker.
- Do not propose a broad migration.
- Do not modernize production code.
- Prefer test or build-configuration steps before production code changes when baseline coverage is weak.
- Keep the first step small enough for one focused commit.

## Inspect

Review:

- Maven configuration.
- Java source, target, and release settings.
- Dependency and plugin versions.
- Spring Framework or Spring Boot usage.
- Tomcat, servlet, JSP, and tag library usage.
- SOAP, XML, JAXB, JAX-WS, and SAAJ usage.
- JMS usage, including ActiveMQ and IBM MQ.
- JDBC and JPA/Hibernate usage.
- Runtime configuration and profiles.
- Existing tests and coverage command.
- Baseline files under `docs/migration-results/java8-baseline/`.

## Recommended Search Commands

```bash
rg "maven-compiler-plugin|<source>|<target>|<release>|java.version|maven.compiler"
rg "javax\.|jakarta\."
rg "JAXB|Marshaller|Unmarshaller|XmlElement|XmlRootElement|QName|SOAPAction"
rg "JmsTemplate|MessageListener|ActiveMQ|IBM|MQQueue|MQConnection"
rg "JdbcTemplate|DataSource|getConnection|ResultSet|PreparedStatement|CallableStatement"
rg "@Entity|EntityManager|JpaRepository|Hibernate|javax\.persistence|jakarta\.persistence"
rg "SimpleDateFormat|DateTimeFormatter|BigDecimal|DecimalFormat|TimeZone|Locale|Charset"
```

## Required Output

Return a plan with:

1. Java 8 baseline status.
2. Coverage status.
3. Top migration risks.
4. Recommended first migration step.
5. Files likely affected.
6. Why the step is required for Java 21.
7. How Java 8 behavior will be preserved.
8. Narrow validation command.
9. Broader validation command.
10. Proposed commit message.
11. Risks to record in the tracker.

## Tracker Update

If asked to update the tracker, add or update:

- Migration Risk Register entries.
- Dependency Changes entries.
- Build Configuration Changes entries.
- Characterization Tests entries.

Do not add implementation results before the step has been executed.

## Final Rule

The first migration step should reduce uncertainty or enable Java 21 validation without changing unrelated behavior.
