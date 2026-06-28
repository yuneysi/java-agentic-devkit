# AGENTS.md — Migration Template (Version-Agnostic Rules)

## Purpose

This file defines the baseline operating rules for agents working in a target project bootstrapped from `templates/java21-migration/`.

It is intentionally version-agnostic. Any Java 8 to Java 21 migration strategy, phased workflow, and version-specific guardrails live in `skills/java21-migration/SKILL.md`.

If this file conflicts with another Markdown file in the target project, this file wins.

---

## Development Environment

Run all project work inside the `java-agentic-devkit` container.

The target project should provide one startup configuration in its root:

- `docker-compose.yml`, or
- `.devcontainer/devcontainer.json`

On startup, the devkit can create missing support files from this template, including `AGENTS.md`, `.github/copilot-instructions.md`, `docs/migration-progress-checklist.md`, and `opencode/memory/*`.

Key paths inside the container:

- Maven: `/opt/java/apache-maven-3.9.9`
- Maven repository: `/home/vscode/.m2/repository`
- Project mount: `/workspace`
- OpenCode binary: `/usr/local/bin/opencode`
- OpenCode config: `/home/vscode/.config/opencode/opencode.json`
- oh-my-openagent config: `/home/vscode/.config/opencode/oh-my-openagent.jsonc`

---

## Agent Compatibility

OpenCode, oh-my-openagent, and any other agentic workflow must treat this file as authoritative.

Tool configuration may define models, providers, UI behavior, and local preferences, but must not override the safety, testing, dependency, or validation rules in this file.

When an installed skill fits the task, use it. If a skill is unavailable, apply equivalent manual steps and report the limitation.

---

## Change Discipline (Non-Negotiable)

- Keep changes small, focused, and reviewable.
- Preserve existing behavior unless the user explicitly approves a behavior change.
- Do not combine unrelated concerns in one change.
- Avoid broad refactors, formatting-only churn, and opportunistic dependency updates.
- Before changing production code, prefer one of:
  1. a failing test that demonstrates the issue,
  2. a characterization test that captures current behavior, or
  3. a concise explanation of why the change is safe without a test.

---

## Enterprise Risk Areas

Treat the following as behavior-sensitive and verify explicitly:

- REST/JSON contracts and error payload shape
- SOAP/XML namespaces, element order, and payload formatting
- JMS acknowledgement, retries, redelivery, and transactions
- JDBC transaction boundaries, isolation, and generated keys
- JPA lazy loading, flush behavior, and transaction scope
- Spring profiles/configuration and bean lifecycle
- timezone, locale, charset, date/time, and `BigDecimal` behavior
- authentication, authorization, TLS, CORS, CSRF, file handling, and external command execution

Do not silently change behavior in these areas.

---

## Dependency And Build Rules

Do not upgrade dependencies casually.

For each dependency or plugin change, record:

- current version
- new version
- reason for change
- runtime/security/behavior risk
- validation command

Keep dependency changes isolated from application code changes when practical.

---

## Testing And Validation Rules

Use Maven Wrapper when available:

```bash
./mvnw clean verify
```

Use targeted commands first when practical:

```bash
./mvnw clean test -pl <module> -Dtest=SpecificTest
./mvnw clean verify -pl <module>
```

If tests cannot be run, explain why and state the exact command that should be executed later.

---

## Browser / Playwright Safety

Use Playwright only after compile and startup prerequisites are verified.

Never perform destructive actions (payments, external sends, data deletion, production writes).

Prefer read-only checks unless the user explicitly requests deeper browser validation.

---

## Shared Project Memory

Use `opencode/memory/` as the first source for recurring context before running wide codebase scans.

Memory files:

- `opencode/memory/architecture.md`
- `opencode/memory/decisions.md`
- `opencode/memory/status.md`

Update these files when architecture, technical decisions, delivery status, or risk status changes.

---

## Skills

Use `skills/java21-migration/SKILL.md` for Java 8 to Java 21 migration execution.

Keep all version-specific guidance in skills, not in this file.
