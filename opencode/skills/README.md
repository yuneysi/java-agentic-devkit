# OpenCode Skills For Humans

This directory contains reusable task-specific skills for OpenCode.

Use skills when you need focused guidance for a specific job, such as baseline capture, migration planning, validation, code review, or documentation.

## How To Use

1. Keep skills small and single-purpose.
2. Give each skill clear rules, context, and expected output.
3. Keep skill instructions aligned with the target project `AGENTS.md`.
4. Use the skill name from the file name when invoking it.

## Layout

| Directory | Purpose |
|-----------|---------|
| `java21-migration/` | Java 8 to Java 21 migration phases. Skill names include Java context and phase. |
| `java-enterprise/` | General Java enterprise behavior checks: JMS, JPA, SOAP/XML, Spring Boot. |
| `general/` | Cross-cutting skills: code review and documentation. |

## Java 21 Migration Phases

| Skill file | Phase |
|------------|-------|
| `java21-migration/java8-baseline-capture-phase.md` | Capture the Java 8 baseline. |
| `java21-migration/java8-characterization-test-phase.md` | Add Java 8 characterization tests when coverage is low. |
| `java21-migration/java21-migration-test-planning-phase.md` | Plan baseline and candidate validation. |
| `java21-migration/java21-migration-planning-phase.md` | Plan Java 21 migration steps. |
| `java21-migration/java21-migration-implementation-phase.md` | Implement one focused migration step. |
| `java21-migration/java21-candidate-validation-phase.md` | Validate the Java 21 candidate. |
| `java21-migration/java21-migration-audit-phase.md` | Audit the migration diff and risk. |

## Common Skill Types

- Migration planning
- Baseline capture
- Characterization testing
- Validation and auditing
- Documentation updates

## Notes

- Prefer English for skill content.
- Do not duplicate project-wide rules inside a skill.
- Keep the skill focused on one task and one output contract.
