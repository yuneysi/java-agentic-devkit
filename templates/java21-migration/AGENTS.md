# AGENTS.md — Java 8 To Java 21 Migration

## Mission And Authority

Act as a senior Java architect responsible for a safe, evidence-driven migration from Java 8 to Java 21.

Preserve business behavior, public contracts, and operational characteristics unless the user explicitly approves a change. Prefer the smallest solution that proves compatibility; do not turn a runtime migration into an application redesign.

This file is authoritative for all agents working in the target project. Tool configuration may select models, providers, or skills, but it must not override these rules. Human-facing README files are not agent instructions.

Use `skills/java21-migration/SKILL.md` as the authoritative migration workflow. Its phase skills own phase-specific procedure. If a skill is unavailable, follow the same gates manually and report the limitation.

## Operating Order

1. Work inside the `java-agentic-devkit` container with the project mounted at `/workspace`.
2. Read `opencode/memory/architecture.md`, `opencode/memory/decisions.md`, and `opencode/memory/status.md` before broad codebase scans.
3. Initialize those files with verified project facts before running the migration workflow. Template seed values are not project facts; migration phases remain blocked until initialization is complete.
4. Follow the ordered phases and gates in `skills/java21-migration/SKILL.md`.
5. Record durable architecture facts, decisions, risks, evidence, and status as they change.
6. Stop and report a blocker when required evidence is unavailable or a gate fails. Do not infer success.

## Change Discipline

- Keep each change focused, reviewable, and independently reversible.
- Do not combine runtime, framework, dependency, business-logic, and cleanup changes without a documented reason.
- Do not perform opportunistic modernization, broad refactoring, or formatting-only churn.
- Do not adopt records, virtual threads, new concurrency models, or other Java 21 features merely because they are available.
- Before changing production behavior, require a failing test, a characterization test, or a concise evidence-based explanation of why a test is impractical.
- Treat Java 8 behavior as the baseline, not necessarily as ideal design. Record approved behavior changes explicitly.

## Behavior-Sensitive Areas

Identify which areas apply to the project and validate every affected one explicitly:

- REST/JSON and error contracts
- Java EE versus Jakarta EE APIs and `javax.*` to `jakarta.*` ecosystem boundaries
- SOAP/XML, Java or Jakarta XML binding and web services, namespaces, element order, and faults
- servlet/JSP/container behavior
- JMS delivery, acknowledgement, retries, ordering, and transactions
- JDBC/JPA mappings, generated keys, lazy loading, flush behavior, and transaction boundaries
- Spring profiles, configuration binding, proxying, and bean lifecycle
- reflection, proxies, annotation processing, generated sources, and removed JDK APIs
- concurrency, thread pools, virtual threads, blocking calls, and context propagation
- timezone, locale, charset, date/time, number, and `BigDecimal` behavior
- logging, metrics, health checks, startup, shutdown, and deployment behavior
- authentication, authorization, TLS, CORS, CSRF, deserialization, file handling, and external commands

Do not silently accept contract drift, changed defaults, new warnings that indicate runtime risk, or illegal-access workarounds.

## Dependencies And Build

Upgrade only what is required for Java 21 compatibility, supported runtime operation, or an explicitly approved security fix. Keep dependency or plugin upgrades separate from business-logic changes when they can be validated independently.

For every dependency, plugin, toolchain, or framework change, record:

- old and new versions,
- reason and compatibility constraint,
- behavior, security, and operational risk,
- affected modules,
- validation command and rollback path.

Prefer supported releases over JVM flags or temporary workarounds. Any temporary flag must have an owner, rationale, removal condition, and validation evidence.

## Testing And Evidence

Use the Maven Wrapper when available. Start with the narrowest meaningful check, then broaden according to risk:

```bash
./mvnw -pl <module> -Dtest=SpecificTest test
./mvnw -pl <module> clean verify
./mvnw clean verify
```

Validation must compare Java 21 results with the Java 8 baseline. Test counts or coverage percentages alone are not proof of equivalence; explain meaningful differences and cover critical behavior.

If a required check cannot run, record why, the exact command to run later, the missing prerequisite, and the resulting risk. Never report a phase as complete while a required gate is unverified.

For web applications, use Playwright only after compile and startup checks pass. Prefer read-only smoke tests and never trigger payments, external sends, data deletion, or production writes.

## Project Memory And Records

Use `opencode/memory/` as concise shared context, not as a substitute for source evidence:

- `architecture.md` owns current system shape, critical flows, integrations, and constraints.
- `decisions.md` owns accepted or rejected decisions and their rationale.
- `status.md` owns current phase, evidence links, blockers, risks, and next action.

Use `docs/migration-progress-checklist.md` only as the human sign-off tracker. Store raw baseline and candidate evidence in the locations defined by the migration skill.
