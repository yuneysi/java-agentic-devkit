# Java 8 To Java 21 Migration Skill

## Purpose

Orchestrate a behavior-preserving Java 8 to Java 21 migration. Decide the next valid phase from recorded evidence, enforce its entry and exit gates, and report one clear next action.

`AGENTS.md` owns project-wide rules. This file owns migration order and shared gates. Each phase skill owns only its phase procedure.

## Preflight

Before baseline, verify that the following files contain project-specific facts rather than untouched template seeds:

- `opencode/memory/architecture.md`
- `opencode/memory/decisions.md`
- `opencode/memory/status.md`

If not, invoke the project architecture memory writer, initialize the files from repository evidence, and then continue with baseline. Do not perform a wide migration scan before this initialization.

## Phase Flow

1. **Baseline** — establish reproducible Java 8 build, test, runtime, and risk evidence.
2. **Characterization, when needed** — lock critical behavior that baseline evidence does not protect.
3. **Planning** — define ordered, reversible migration slices and proof commands.
4. **Implementation** — execute one approved slice.
5. **Validation** — compare that slice or candidate with the Java 8 baseline on Java 21.
6. **Audit** — issue the evidence-backed release recommendation after all slices pass validation.

Repeat implementation and validation for each approved slice. Run characterization when critical behavior is uncovered, unreliable, or understood only from production. It may be skipped when baseline evidence already protects all applicable high-risk behavior; record the reason.

Return to an earlier phase when new evidence invalidates one of its gates. Never preserve phase order at the expense of correctness.

## Migration Guardrails

- Target Java 21 directly; use intermediate JDKs only as diagnostic tools, not as undocumented migration targets.
- Separate JDK/build-tool enablement, dependency or framework upgrades, source compatibility, and behavior changes whenever each can be validated independently.
- Treat `javax.*` to `jakarta.*` as an ecosystem or framework migration, not an automatic consequence of running on Java 21.
- Prefer supported dependency and plugin versions over `--add-opens`, illegal-access workarounds, or internal JDK APIs.
- Do not introduce records, virtual threads, new concurrency models, or unrelated language modernization during compatibility work.
- Preserve public contracts and operational behavior unless an approved decision documents the intended delta.

## Shared Gates

Apply only gates relevant to the affected slice, but never omit an applicable gate:

| Gate | Proof |
|---|---|
| Build | Clean compile/package succeeds on the intended runtime and toolchain. |
| Test | Targeted tests pass first; affected module and repository tests pass at the required scope. |
| Contract | Affected REST, SOAP, messaging, persistence, file, or serialization behavior matches baseline or an approved delta. |
| Runtime | Startup, critical flow, shutdown, and operational checks pass where runtime wiring changed. |
| Evidence | Commands, runtime versions, outputs, differences, and unresolved risks are recorded. |
| Rollback | The slice can be reverted without depending on unrelated changes; data/config rollback is defined when applicable. |

A failed or unverified required gate blocks the slice. Do not mark it complete because another gate passed.

## State And Evidence

Use only `Not started`, `In progress`, `Blocked`, or `Done` for phase status in `docs/migration-progress-checklist.md`.

After each phase run:

1. update the human tracker,
2. update `opencode/memory/status.md`,
3. update `architecture.md` or `decisions.md` only when their owned facts changed,
4. report evidence, blockers, and the next valid action.

Store raw evidence under:

- Java 8 baseline: `docs/migration-results/java8-baseline/`
- Java 21 candidate: `docs/migration-results/java21-candidate/`

Do not duplicate raw logs in memory files.

## Phase Skills

- `phases/baseline/SKILL.md`
- `phases/characterization/SKILL.md`
- `phases/planning/SKILL.md`
- `phases/implementation/SKILL.md`
- `phases/validation/SKILL.md`
- `phases/audit/SKILL.md`

For a high-level request such as `Start the Java 21 migration`, inspect recorded state and run or recommend the next valid phase. Do not require the user to know the phase names.
