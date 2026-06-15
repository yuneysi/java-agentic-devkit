# AGENTS.md — Java 21 + Migration (Template)

## Purpose

This project is in **Java 8 to Java 21 migration mode**.

Act as a senior Java enterprise engineer, migration auditor, and regression-focused reviewer. Prioritize behavior preservation, Jakarta EE correctness, and practical progress.

This file is the authoritative instruction file for agent behavior in this target project. If this file conflicts with another Markdown file, this file wins.

---

## Development Environment (Container)

Run all migration work inside the **java-agentic-devkit** container.

The target project should provide `docker-compose.yml` in its root. On startup, the devkit creates missing migration support files from this template (for example `AGENTS.md`, `.github/copilot-instructions.md`, and `docs/migration-progress-checklist.md`).

Key paths inside the container:

- JDK 21: `/opt/java/jdk21` (default `java` is 1.8)
- Maven: `/opt/java/apache-maven-3.9.9`
- Maven repo: `/home/vscode/.m2/repository`
- Project mount: `/workspace`
- OpenCode binary: `/usr/local/bin/opencode`
- OpenCode config: `/home/vscode/.config/opencode/opencode.json`
- oh-my-openagent config: `/home/vscode/.config/opencode/oh-my-openagent.jsonc`

---

## Agent Compatibility

Treat this file as the source of truth for migration behavior.

Tool configuration can define model/provider/UI preferences, but it must not override migration safety, testing, dependency, or validation rules in this file.

Use installed skills when they fit. If a skill is unavailable, follow the same rules manually and report the limitation.

---

## Core Migration Guardrails (Non-Negotiable)

- **Java 8 behavior is the source of truth.** Java 21 output must preserve Java 8 behavior unless the user explicitly approves a change.
- **Do not modernize first.** Change production code only when required by:
  1. Java 21/Jakarta compilation errors,
  2. failing regression or characterization tests,
  3. runtime incompatibility, or
  4. explicit user approval.
- **Do not break passing behavior.** If behavior changes, update and justify tests first.
- **Use focused, buildable commits.** One concern per commit; each commit compiles.
- **Validate after each change** with the narrowest command that proves the change (compile -> test -> verify).

---

## Namespace Rules (Jakarta Migration)

- Hand-written application code must use `jakarta.*` for Jakarta EE APIs.
- Keep JDK namespaces that remain `javax.*` (for example `javax.sql.*`, `javax.net.ssl.*`, `javax.xml.datatype.*`, `javax.xml.transform.*`, `javax.xml.namespace.*`, `javax.xml.xpath.*`).
- Generated code can stay split:
  - OpenAPI-generated code should use Jakarta annotations.
  - JAXB/WSDL-generated code may still use `javax.xml.bind.*` depending on generator/plugin versions.
- Do not force Jakarta rewrites on generated sources.
- If production code uses generated JAXB types (`JAXBElement`, `ObjectFactory`, etc.), match the generated namespace.

---

## High-Risk Enterprise Areas

Treat these as behavior-sensitive and avoid silent changes:

- SOAP/XML contracts: namespaces, element order, `SOAPAction`, payload formatting
- REST/JSON contracts and error body formats
- JSP/Servlet/container behavior
- JMS ack/retry/redelivery/concurrency/transactions
- JDBC transactions/isolation/generated keys
- JPA lazy loading/flush/transaction scope
- Spring profiles/config/property binding
- Timezone/locale/charset/date-time/`BigDecimal` behavior
- Security-sensitive code paths (auth, authz, TLS, CORS, CSRF, file handling, external command execution)

---

## Dependency And Build Change Rules

Do not upgrade dependencies casually.

For each dependency/plugin change, record:

- current version
- new version
- migration reason
- runtime/security/behavior risk
- validation command

Keep dependency changes isolated from application code changes when practical.

---

## Testing And Validation Rules

Use Maven Wrapper when available:

```bash
./mvnw clean verify
```

Use targeted commands when possible:

```bash
./mvnw clean test -pl <module> -Dtest=SpecificTest
./mvnw clean verify -pl <module>
```

For Java 21 candidate validation, use JDK 21 explicitly when needed:

```bash
JAVA_HOME=/opt/java/jdk21 ./mvnw clean verify
```

Evidence locations:

- Java 8 baseline: `docs/migration-results/java8-baseline/`
- Java 21 candidate: `docs/migration-results/java21-candidate/`

Spring Boot 3 note: 4xx/5xx responses often use RFC 7807 Problem Details JSON. Tests that expected empty bodies may need migration-aware assertions.

---

## Browser / Playwright Safety

Use Playwright only after compile/startup prerequisites are verified.

Never trigger destructive actions (payments, external sends, data deletion, production writes).

---

## Code Review Priorities

When reviewing migration changes:

1. Check regressions and runtime risks before style.
2. Verify Jakarta namespace correctness in hand-written code.
3. Verify API/contract compatibility (REST, SOAP/XML, JMS, JPA).
4. Verify SB3 error response expectations.
5. Reject untested behavior changes.

---

## OpenCode Skills

Primary migration skills:

- `java8-baseline-capture-phase`
- `java8-characterization-test-phase`
- `java21-migration-test-planning-phase`
- `java21-migration-planning-phase`
- `java21-migration-implementation-phase`
- `java21-candidate-validation-phase`
- `java21-migration-audit-phase`

Additional enterprise/general skills:

- `jms-characterization-test-writer`
- `jpa-characterization-test-writer`
- `soap-contract-test-writer`
- `readme-writer`
- `confluence-doc-writer`

Keep skill output aligned with this `AGENTS.md`.

---

## Java 21 Usage Guidance

The codebase targets Java 21, but do not refactor working code just to introduce newer syntax. Prefer modern features only when they improve readability or safety without behavior risk.
