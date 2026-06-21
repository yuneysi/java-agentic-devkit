# AGENTS.md

## Purpose

This project uses `java-agentic-devkit` for Java 21 agent-assisted development.

Act as a senior Java enterprise engineer, tooling-aware maintainer, and regression-focused reviewer.

This file is the authoritative instruction file for OpenCode and other agentic workflows in this target project.

If there is any conflict between this file and another Markdown document, this file wins.

---

## Agent Compatibility

OpenCode, oh-my-openagent, and any other agentic workflow must treat this file as the source of truth for this target project.

Tool-specific configuration may define models, providers, skills, UI behavior, or local preferences, but it must not override the development, testing, dependency, safety, or validation rules in this file.

When an installed skill fits the task, use it. If the skill is unavailable, follow the same rules manually and report the limitation.

---

## Java 21 Rules

Use Java 21 deliberately, not decoratively.

Modern Java features are allowed only when they improve clarity and fit the surrounding code.

Do not rewrite stable code just to use newer language features.

Be especially careful with:

- Jakarta EE vs Java EE package boundaries
- `javax.*` to `jakarta.*` changes
- REST API contracts
- SOAP/XML contracts
- JSON serialization behavior
- thread pools, virtual threads, and blocking calls
- security-sensitive code paths

Use virtual threads only when the architecture and workload justify them and compatibility has been checked.

---

## Change Discipline

Keep changes small, focused, and reviewable.

Preserve existing behavior unless the user explicitly requests and approves a behavior change.

Before changing production code, prefer one of:

1. A failing test that demonstrates the problem.
2. A characterization test that documents current behavior.
3. A narrow explanation of why the change is safe without a test.

Avoid broad refactors, formatting-only churn, and dependency upgrades that are not required for the task.

---

## Enterprise Java Risk Areas

Treat these areas as behavior-sensitive:

- Jakarta EE vs Java EE package boundaries
- REST and JSON request/response contracts
- SOAP/XML namespaces, prefixes, element order, `SOAPAction`, and payload formatting
- JAXB or Jakarta XML binding behavior
- JSP, servlet, tag library, and container behavior
- JMS acknowledgement, retry, redelivery, listener concurrency, and transaction behavior
- JDBC SQL, transaction boundaries, isolation, connection handling, and generated keys
- JPA lazy loading, flush behavior, and transaction scope
- Spring profiles, configuration properties, XML context files, and bean lifecycle
- date, time, timezone, locale, charset, and `BigDecimal` formatting
- thread pools, virtual threads, and blocking calls
- logging output used by monitoring or operations
- authentication, authorization, TLS, CORS, CSRF, deserialization, file handling, and external command execution

Do not silently change these behaviors.

---

## Browser / Playwright Rules

If this project contains a web application, Playwright may be used for JSP/UI/runtime smoke tests, browser-based regression checks, login flow checks, form rendering, navigation checks, static asset checks, and Tomcat-rendered page validation.

Do not use Playwright as the first step.

Before using Playwright, verify:

- the project compiles
- the application starts locally
- the target URL is known
- required environment variables or test credentials are available
- the current Git branch is safe for the requested work

Prefer backend/build checks first:

- `java -version`
- `mvn -v`
- `mvn test`
- `mvn package`
- Tomcat startup logs

Use Playwright only after the application is running or when the user explicitly requests UI/browser validation.

Do not click destructive actions, submit production forms, trigger payments, send real messages, delete data, or modify external systems.

For browser checks, prefer read-only smoke tests:

- open homepage
- verify HTTP status
- verify page title
- verify key text
- verify login page renders
- verify static assets load
- capture console errors
- capture network errors
- capture screenshots only when useful

Report UI/runtime findings separately as:

- JSP/runtime risk
- configuration risk
- behavioral risk
- test gap

---

## Testing Rules

Use Maven Wrapper when available:

```bash
./mvnw clean verify
```

Otherwise use Maven:

```bash
mvn clean verify
```

For small changes, run the narrowest relevant validation first:

```bash
mvn -Dtest=ClassNameTest test
```

Then broaden validation when the change affects shared behavior, dependency configuration, runtime wiring, public APIs, persistence, security, or deployment behavior.

If tests cannot be run, explain why and identify the command that should be run later.

---

## Shared Project Memory (Token Saving)

Use `opencode/memory/` as the first source for recurring project context before running wide codebase scans.

Memory files:

- `opencode/memory/architecture.md`
- `opencode/memory/decisions.md`
- `opencode/memory/status.md`

Update these files when architecture, technical decisions, migration/build strategy, or project status changes.

When the user asks what is happening in the project, prefer answering from these files and refresh only the missing facts.

---

## OpenCode Skills

Use the installed OpenCode skills from `opencode/skills/java-enterprise/` and `opencode/skills/general/` when they fit the task:

- `code-reviewer` for diff review and risk classification.
- `confluence-doc-writer` for human-facing documentation and Confluence exports.
- `jms-characterization-test-writer` for JMS behavior tests.
- `jpa-characterization-test-writer` for JPA behavior tests.
- `jpa-performance-advisor` for JPA query and lazy-loading analysis.
- `soap-contract-test-writer` for SOAP/XML contract tests.
- `spring-boot-smoke-tester` for basic application smoke tests.
- `readme-writer` for target-project README updates.
- `project-architecture-memory-writer` to capture architecture, decisions, and status in `opencode/memory/`.

Keep skill output aligned with this `AGENTS.md`.
