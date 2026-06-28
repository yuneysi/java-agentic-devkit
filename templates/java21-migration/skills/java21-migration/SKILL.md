# Java 8 To Java 21 Migration Skill (Orchestrator)

## Intent

This is the top-level migration orchestrator skill for Java 8 to Java 21.

Use it to decide the next phase, enforce flow order, and keep outputs consistent across all migration responsibilities.

When the developer uses a natural prompt such as `Start the Java 21 migration`, respond with the phase sequence, the next phase to run now, and the checklist writeback rule.

---

## Sub-skill structure

Phase skills are organized by responsibility:

- `phases/baseline/SKILL.md`
- `phases/planning/SKILL.md`
- `phases/implementation/SKILL.md`
- `phases/validation/SKILL.md`
- `phases/audit/SKILL.md`

---

## Execution order

Always run in this sequence:

1. baseline
2. planning
3. implementation
4. validation
5. audit

Do not skip a phase unless the user explicitly requests it and the risk is documented.

---

## Natural prompt behavior

If the input is a high-level start command (for example `start migration`, `begin Java 21 migration`, `let's migrate to Java 21`):

1. Return the full ordered phase list:
   - baseline
   - planning
   - implementation
   - validation
   - audit
2. State the immediate next phase to execute.
3. Remind that each completed phase must write its status to `docs/migration-progress-checklist.md` using only: `Not started`, `In progress`, `Blocked`, or `Done`.
4. Point to `skills/java21-migration/phases/INDEX.md` for quick operator guidance.

---

## Cross-phase invariants

- preserve behavior unless explicit approval exists,
- keep slices small and reversible,
- require evidence for gate outcomes,
- keep decisions and status synchronized in `opencode/memory/*`,
- write phase status updates in `docs/migration-progress-checklist.md` after every phase run using only: `Not started`, `In progress`, `Blocked`, or `Done`.

---

## Evidence locations

- `docs/migration-results/java8-baseline/`
- `docs/migration-results/java21-candidate/`
- `opencode/memory/architecture.md`
- `opencode/memory/decisions.md`
- `opencode/memory/status.md`

---

## Suggested prompt starters

- `Use the java21-migration skill and run the baseline phase.`
- `Use the java21-migration skill and produce the direct Java 8 -> Java 21 planning output.`
- `Use the java21-migration skill and execute the next implementation slice.`
- `Use the java21-migration skill and run validation for the Java 21 candidate.`
- `Use the java21-migration skill and generate the final audit recommendation.`
