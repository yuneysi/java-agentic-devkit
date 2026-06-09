# Migration Test Planner Skill

Use this skill when the user asks to plan tests for a Java 8 to Java 21 migration.

## Goal

Create a prioritized characterization and regression test plan that proves Java 21 preserves Java 8 behavior.

Java 8 is the behavioral source of truth.

## Rules

- Do not modify production code.
- Do not modernize code.
- Do not propose broad refactors.
- Prefer characterization tests before implementation changes.
- Prioritize behavioral equivalence over superficial code coverage.
- Focus on external contracts, persistence behavior, messaging behavior, and edge cases.
- Clearly separate test gaps from production defects.
- Report uncertainty instead of guessing.

## Risk Areas to Inspect

- SOAP/XML contracts using `javax.*`.
- JAXB / JAX-WS / SAAJ.
- WSDL and XSD compatibility.
- XML namespaces, SOAPAction, element names, element order, null vs empty tags.
- JSP and servlet behavior.
- Tomcat 9 to Tomcat 11 differences.
- `javax.*` to `jakarta.*` migration risk.
- Spring Framework and Spring Boot compatibility.
- JPA / Hibernate behavior.
- JDBC and SQL behavior.
- JMS with ActiveMQ and IBM MQ.
- Date/time formatting.
- BigDecimal formatting and rounding.
- Cache behavior.
- Configuration and profiles.
- Error responses and exception mapping.

## Required Output

Produce a test plan with these sections:

1. Current Java 8 baseline status.
2. Existing test coverage summary.
3. High-risk areas.
4. Recommended characterization tests.
5. Recommended regression tests.
6. Test data and fixture strategy.
7. Required local services.
8. Suggested execution commands.
9. Migration blockers.
10. Questions for human confirmation.

## Recommended Commands

Use these commands to inspect the project:

```bash
rg "javax\.xml|javax\.jws|javax\.soap|javax\.xml\.ws|javax\.xml\.bind"
rg "javax\.persistence|@Entity|@Repository|JpaRepository|EntityManager|@Query"
rg "javax\.jms|JmsTemplate|MessageListener|ActiveMQ|IBM|MQQueue|MQConnection"
rg "SimpleDateFormat|DateTimeFormatter|BigDecimal|setScale|RoundingMode|DecimalFormat|TimeZone|Calendar|LocalDate|LocalDateTime"
rg "JAXB|Marshaller|Unmarshaller|XmlElement|XmlRootElement|XmlType|QName|Namespace|SOAPAction"
rg "JdbcTemplate|NamedParameterJdbcTemplate|DataSource|getConnection|ResultSet|PreparedStatement|CallableStatement"
```

## Validation Commands

Recommend running:

```bash
java8
mvn8 clean test
```

Then later, on the Java 21 branch:

```bash
java21
mvn21 clean test
```

## Final Rule

Do not trust a migration because it compiles.

Trust it only when Java 21 passes the same behavioral tests that describe Java 8 production behavior.
