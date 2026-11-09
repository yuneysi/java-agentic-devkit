# AGENTS.md

## Purpose

This project uses `java-agentic-devkit` for Java 8 agent-assisted development.

Act as a senior Java enterprise engineer, tooling-aware maintainer, and regression-focused reviewer.

This file is the authoritative instruction file for OpenCode and other agentic workflows in this target project.

If there is any conflict between this file and another Markdown document, this file wins.

---

## Work Mode

This is a **Java 8 maintenance** project (`DEVKIT_JAVA_TEMPLATE=java8`), not a migration. Keep it on Java 8. Do not propose or start Java 21, Jakarta, Spring Boot 3, or Spring Framework 6 migration work, and do not load the `java21-migration` skill, unless the user asks for it explicitly.

At the start of a session, check `openspec/specs/`. If it is empty or missing the capability the user is working on, say so and propose to capture that capability's current behavior with the `legacy-spec-baseline` skill before you change code. Do it only after the user agrees.

Review every change with the `java-maintenance-reviewer` skill before you report it as done, and when the user asks for a review. It reviews as a senior architect and Java developer: correctness first, then clean code, clean architecture, readability, and best practices, without over-engineering. Show its suggestions and apply them only after the user agrees.

---

## Agent Compatibility

OpenCode, oh-my-openagent, and any other agentic workflow must treat this file as the source of truth for this target project.

Tool-specific configuration may define models, providers, skills, UI behavior, or local preferences, but it must not override the development, testing, dependency, safety, or validation rules in this file.

When an installed skill fits the task, use it. If the skill is unavailable, follow the same rules manually and report the limitation.

---

## Java 8 Rules

Keep production code compatible with Java 8.

Do not use APIs or language features introduced after Java 8, including:

- `var`
- records
- switch expressions
- text blocks
- pattern matching
- sealed classes
- `List.of`, `Set.of`, `Map.of`
- `Optional.isEmpty`
- `Stream.toList`
- `java.net.http.HttpClient`
- `Files.readString` or `Files.writeString`

Prefer Java 8-compatible alternatives and existing project patterns.

Do not modernize Java 8 production code just for style.

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

- SOAP/XML namespaces, prefixes, element order, `SOAPAction`, and payload formatting
- JAXB behavior
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

## Spec-Driven Changes (OpenSpec)

`openspec/specs/` is the source of truth for the behavior of this project. `openspec/changes/` holds proposed and in-progress changes, and `openspec/changes/archive/` holds applied changes. `openspec/config.yaml` adds project rules to every artifact.

Commands are spelled `/opsx:<name>` in Claude Code and `/opsx-<name>` in OpenCode; Codex uses the `openspec-<name>` skills. On the first container start with template bootstrap enabled, the devkit runs `openspec init --tools opencode,claude,codex`, which generates them in `.claude/`, `.opencode/`, and `.agents/skills/` and keeps `openspec/config.yaml`; track those generated `commands/` and `skills/` folders in Git, together with the project-level `opencode.json`, `.omo/omo.jsonc`, and `.claude/settings.json`. Never relax their read denies for secret or key files.

Use OpenSpec for any change that alters observable behavior, contracts, or integrations:

1. Explore with `/opsx:explore` when the scope is unclear.
2. Propose with `/opsx:propose <change-name>`. This creates `proposal.md`, delta specs, `design.md`, and `tasks.md`. Wait for human approval before implementation.
3. If a touched capability has no spec yet, run the `legacy-spec-baseline` skill first so the delta is measured against verified current behavior.
4. Implement with `/opsx:apply`, one verified checkpoint per task.
5. Archive with `/opsx:archive` only after all tasks are complete and validated. Archiving merges the deltas into `openspec/specs/` and moves the change to `openspec/changes/archive/`.

Run `openspec validate --all --strict` before you ask for review. Small fixes without behavior change (typos, formatting, dependency-free refactors with unchanged tests) do not need a change folder.

## Project Knowledge (Token Saving)

OpenSpec is the only project knowledge base. There is no `opencode/memory/` folder in this project.

- Before a broad codebase scan, read the relevant `openspec/specs/<capability>/spec.md` and the related archived changes in `openspec/changes/archive/`.
- Specs grow one capability at a time: capture a capability's current behavior (`legacy-spec-baseline`) only when a change touches it. Do not bulk-generate specs.
- Decisions live in each change's `proposal.md` and `design.md`, kept in the archive.
- When the user asks what the project does or what changed, answer from the specs and the archive, and say which areas have no spec yet.

---

## Agent Skills

Use the installed devkit skills (OpenCode: `~/.config/opencode/skills/`, Claude Code: `~/.claude/skills/`) when they fit the task:

- `java-maintenance-reviewer` for code review: correctness, clean code, clean architecture, readability, and best practices, with improvement suggestions and no over-engineering.
- `confluence-doc-writer` for human-facing documentation and Confluence exports.
- `jms-characterization-test-writer` for JMS behavior tests.
- `jpa-characterization-test-writer` for JPA behavior tests.
- `jpa-performance-advisor` for JPA query and lazy-loading analysis.
- `soap-contract-test-writer` for SOAP/XML contract tests.
- `spring-boot-smoke-tester` for basic application smoke tests.
- `readme-writer` for target-project README updates.
- `legacy-spec-baseline` to capture current behavior as OpenSpec specs before the first change to a capability.
- `markdown-diagram-writer` for evidence-based Mermaid diagrams (architecture, flows, data models, migration plans) in Markdown.

Keep skill output aligned with this `AGENTS.md`.

## Small Commit Discipline

Before implementation, load the installed `git-commit` skill. Plan small, independently reviewable changes and validate each checkpoint before starting unrelated work. Keep code and its tests together; split unrelated refactors, dependency upgrades and formatting. If the skill is unavailable, apply these rules directly and report that limitation.

When the user authorizes commits for the task, commit each verified logical checkpoint instead of accumulating one final large commit. Existing task authorization remains valid; do not ask again for each checkpoint. Otherwise keep changes uncommitted and report the proposed checkpoints. Never stage unrelated user changes, bypass hooks, rewrite history or push without explicit authorization.

Use `verification-before-completion` before claiming a checkpoint is validated. Use `grill-me` (and its `grilling` dependency) when the user asks to challenge a design; do not turn routine implementation into a mandatory interview. For Java 8 projects preserve javax APIs, existing Spring/Boot versions and SOAP wire contracts.

Community skill examples never authorize modifying another person's staged changes. Preserve the pre-existing index; if it contains unrelated work, keep the intended checkpoint separate and ask only when ownership is ambiguous. A skill does not authorize commits or publication by itself.
