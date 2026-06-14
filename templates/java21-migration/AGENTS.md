# AGENTS.md — Java 21 + Migration (Template)

## Purpose

This project is part of a **Java 8 to Java 21 migration**. Every change must be made in migration context — treat all work as migration work unless explicitly told otherwise.

Act as a senior Java enterprise engineer, migration auditor, and regression-focused reviewer. Focus on behavior preservation, Jakarta EE correctness, and pragmatic migration progress.

This file is the authoritative instruction file for any agentic workflow in this project.

If there is any conflict between this file and another Markdown document, this file wins.

---

## Development Environment (Container)

This project runs entirely inside the **java-agentic-devkit** Docker container. The host only needs Docker (and optionally ollama for local models).

The devkit copies `AGENTS.md` and the migration checklist into the target project root. The checklist is copied as `docs/migration-progress-checklist.md`.

**Key paths inside the container**:
- JDK 21: `/opt/java/jdk21` (default `java` is 1.8 — use `JAVA_HOME=/opt/java/jdk21` explicitly)
- Maven: `/opt/java/apache-maven-3.9.9`
- Maven repo: `/home/vscode/.m2/repository` (mounted from host `~/.m2`)
- Project: `/workspace` (mounted from current directory)

---

## Agent Compatibility

This file is the source of truth for any agentic workflow in this project.

Tool-specific configuration may define models, providers, skills, UI behavior, or local preferences, but it must not override the migration, testing, dependency, safety, or validation rules in this file.

When an installed skill fits the task, use it. If the skill is unavailable, follow the same rules manually and report the limitation.

---

## Migration Rules (apply to ALL work)

This project is in migration mode at all times. The following rules always apply:

- **Java 8 behavior is the source of truth**. Java 21 + Jakarta EE must preserve Java 8 behavior unless a change is explicitly requested and approved.
- **Do not start by modernizing production code**. Do not modify production code unless:
  1. A Java 21 or Jakarta EE compilation error requires it.
  2. A failing regression or characterization test proves a behavioral regression.
  3. A runtime incompatibility is demonstrated.
  4. The user explicitly approves the change.
- **Do not break existing behavior**. If a test passes, keep it passing. If behavior changes, update the test first.
- **Zero `javax.*` imports in hand-written code**. The project targets Tomcat 11 compatibility. All hand-written Java source files must use `jakarta.*` namespace equivalents. JDK standard types (`javax.xml.datatype.*`, `javax.sql.*`, `javax.net.ssl.*`) are JDK APIs, not Jakarta EE — these remain `javax.*` in the JDK, but prefer `var` or FQN usage to avoid explicit imports when practical.
- **Generated code namespace split**: OpenAPI-generated code uses Jakarta annotations (generator 7.12.0+). JAXB/WSDL-generated code may still use `javax.xml.bind.*` depending on the XJC plugin version. Do NOT force Jakarta on generated code — `javax.xml.bind:jaxb-api` and `jakarta.xml.bind-api` can coexist.
- **Prefer small, focused commits**. One logical change per commit. Each commit must compile.
- **If you add a dependency**, document why.
- **Validate after every change**: compile → test → verify. Use the narrowest Maven command that proves the change.

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

## Browser / Playwright Rules

If this project contains a web application, Playwright may be used for smoke tests, browser-based regression checks, and UI validation.

Before using Playwright, verify:

- the project compiles
- the application starts locally
- the target URL is known
- required environment variables or test credentials are available
- the current Git branch is safe for migration work

Prefer backend/build checks first:

- `java -version`
- `mvn -v`
- `mvn test`
- `mvn package`
- Tomcat startup logs

Do not click destructive actions, submit production forms, trigger payments, send real messages, delete data, or modify external systems.

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

## Jakarta EE Migration Details

### javax → jakarta namespace mapping

| javax namespace | jakarta equivalent | Notes |
|----------------|-------------------|-------|
| `javax.persistence.*` | `jakarta.persistence.*` | JPA annotations |
| `javax.validation.*` | `jakarta.validation.*` | Bean Validation |
| `javax.servlet.*` | `jakarta.servlet.*` | Servlet API |
| `javax.xml.bind.*` | `jakarta.xml.bind.*` | Hand-written JAXB code ONLY |
| `javax.annotation.Generated` | `jakarta.annotation.Generated` | Or remove if JDK 21 deprecated |
| `javax.ws.rs.*` | `jakarta.ws.rs.*` | JAX-RS (if used) |
| `javax.inject.*` | `jakarta.inject.*` | CDI (if used) |
| `javax.annotation.PostConstruct/PreDestroy` | `jakarta.annotation.*` | Lifecycle annotations |

**Do NOT migrate** (JDK built-in, no Jakarta equivalent):
`javax.net.ssl.*`, `javax.sql.*`, `javax.xml.datatype.*`, `javax.xml.transform.*`, `javax.xml.namespace.*`, `javax.xml.xpath.*`

### JAXB namespace split (critical!)

- **JAXB-generated code** (from XJC, maven-jaxb2-plugin) likely uses `javax.xml.bind.*` — do NOT change it
- **Hand-written JAXB code** must use `jakarta.xml.bind.*`
- Production code referencing `JAXBElement` from `ObjectFactory` must match the generated code's namespace
- `javax.xml.bind:jaxb-api:2.3.1` and `jakarta.xml.bind-api:4.0.2` can coexist on classpath — Glassfish JAXB handles both

### Springfox → Springdoc migration

- Replace `@ApiParam` → `@Parameter`
- Replace `@ApiIgnore` → `@Parameter(hidden = true)`
- Replace `@ApiModelProperty` → `@Schema(description = "...")`
- Replace `io.swagger.annotations.*` → `io.swagger.v3.oas.annotations.*`
- Swagger UI moves from `/swagger-ui.html` to `/swagger-ui/index.html`

### Spring Boot 3 error response format

SB3 changes 4xx/5xx error bodies to **RFC 7807 Problem Details JSON**. Tests that assert blank/empty 4xx bodies will fail:

```java
// BEFORE (SB2): empty body on 400
mockMvc.perform(post("/endpoint"))
  .andExpect(content().string(isBlank()));

// AFTER (SB3): Problem Details JSON body
mockMvc.perform(post("/endpoint"))
  .andExpect(content().string(containsString("Bad Request")));
```

### JUnit 4 → 5 migration

| JUnit 4 | JUnit 5 |
|---------|---------|
| `org.junit.Test` | `org.junit.jupiter.api.Test` |
| `@RunWith(SpringRunner.class)` | `@ExtendWith(SpringExtension.class)` |
| `@Before` | `@BeforeEach` |
| `@After` | `@AfterEach` |
| `@BeforeClass` | `@BeforeAll` |
| `@Rule ExpectedException` | `assertThrows()` |
| `MockitoJUnitRunner` | `@ExtendWith(MockitoExtension.class)` |

### @MockBean deprecation

`@MockBean` is deprecated in SB3 — replace with `@MockitoBean` when convenient. Does NOT break compilation, only produces warnings.

---

## Common Migration Failures

| Symptom | Likely cause | Fix |
|---------|-------------|------|
| FindBugs fails on JDK 21 | Groovy `No signature of method: java.io.File.exists()` | `<skip>true</skip>` in `<build><plugins>`, NOT in `<pluginManagement>` |
| PMD: "Cannot load ruleset" | PMD 7 removed old `rulesets/java/` paths | Create custom PMD 7 ruleset with `category/java/` paths |
| Surefire: 0 tests run | Surefire < 3.x doesn't detect JUnit 5 on JDK 21 | Upgrade to 3.2.5+ |
| `/swagger-ui.html` 404 | springfox path vs springdoc path | Use `/swagger-ui/index.html` |
| JAXBException at runtime | Wrong JAXB namespace in production code | Match generated code's namespace |
| Test count decreased | Tests not discovered or skipped | Check surefire version and `<skipTests>` |

---

## Commit Strategy

Use atomic commits separated by concern. Each commit must be independently buildable:

```
1. "chore: upgrade to Spring Boot 3.5.15 with Jakarta EE dependencies"  (POM changes only)
2. "fix: migrate javax source files to Jakarta EE"                      (source code)
3. "fix: update test assertions for Spring Boot 3 behaviors"            (tests)
4. "chore: update build tooling for JDK 21 compatibility"              (PMD, surefire, findbugs)
5. "docs: update AGENTS.md, README, and migration results"             (documentation)
```

---

## Testing Rules

Use Maven Wrapper when available:

```bash
./mvnw clean verify
```

Otherwise use Maven directly:

```bash
mvn clean verify
```

For targeted testing:

```bash
./mvnw clean test -pl <module> -Dtest=SpecificTest
./mvnw clean verify -pl <module>
```

Minimum acceptable coverage is **60% instruction** (JaCoCo enforced). If you add new functionality, add tests that cover it. If you fix a bug, add a test that reproduces it first.

When changing error handling, REST endpoints, or SOAP services, verify the Spring Boot 3 error response format (RFC 7807 Problem Details JSON) is preserved or intentionally changed.

---

## Code Review Rules

When asked to review code:

1. Read the diff first. Understand what changed and why.
2. Identify bugs, behavioral regressions, and security issues before style or naming.
3. Check Jakarta EE namespace correctness (`jakarta.*` not `javax.*` for hand-written code).
4. Verify SB3 error response handling (Problem Details JSON awareness).
5. Check JPA usage for N+1 queries, lazy loading pitfalls, and transaction boundaries.
6. Check SOAP/XML for namespace, element order, and SOAPAction changes.
7. Check JMS for concurrency, redelivery, and transaction settings.
8. Report findings ordered by severity (bugs first, then risks, then style).
9. Do not approve changes that break existing tests or introduce untested code.

---

## OpenCode Skills

Use the installed OpenCode skills from `opencode/skills/java21-migration/`, `opencode/skills/java-enterprise/`, and `opencode/skills/general/` when they fit the task:

- `java21-migration-audit-phase` for migration diff review and risk classification.
- `java21-migration-test-planning-phase` for baseline and candidate validation planning.
- `java8-baseline-capture-phase` for capturing baseline results under `docs/migration-results/java8-baseline/`.
- `java8-characterization-test-phase` for focused characterization tests when coverage is low.
- `java21-migration-planning-phase` for planning the migration sequence and next step.
- `java21-migration-implementation-phase` for applying one focused migration change.
- `java21-candidate-validation-phase` for validating results under `docs/migration-results/java21-candidate/`.
- `jms-characterization-test-writer` for JMS behavior tests.
- `jpa-characterization-test-writer` for JPA behavior tests.
- `soap-contract-test-writer` for SOAP/XML contract tests.
- `readme-writer` for target-project README updates.
- `confluence-doc-writer` for human-facing migration notes.

Keep skill output aligned with this `AGENTS.md`.

---

## Commands Quick Reference

All commands run **inside the container** (`docker compose exec devkit bash`). The `./mvnw` wrapper uses Maven 3.9.9 from `/opt/java/apache-maven-3.9.9`. Default `java` in the container is JDK 8 — use `JAVA_HOME=/opt/java/jdk21` explicitly when running Maven outside the wrapper.

```bash
# Enter the container (from host)
docker compose exec devkit bash

# Build and test (inside container)
./mvnw clean verify                                          # full build
./mvnw clean test -pl <module> -Dtest=TestClass              # single test

# Coverage
./mvnw test jacoco:report -pl <module>
# open <module>/target/site/jacoco/index.html

# Run locally
cd <module> && ../mvnw spring-boot:run

# Regenerate OpenAPI code (if applicable)
./mvnw clean generate-sources -pl <module>

# Dependency analysis
./mvnw dependency:analyze -pl <module>
```

---

## Useful Java 21 Features Available

The project compiles with `<release>21</release>`. You can use:

- Pattern matching for `instanceof`
- Record classes
- Text blocks
- Sealed classes (if design allows)
- Virtual threads (if the runtime environment supports it — Spring Boot 3.5 + Tomcat)
- Sequenced collections (`SequencedCollection`, `SequencedSet`, `SequencedMap`)
- `switch` expressions and pattern matching

Do not refactor working code just to use new syntax. New code should prefer modern patterns where they improve readability or safety.
