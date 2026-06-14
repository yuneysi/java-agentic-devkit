# Java 21 Migration Planning Phase Skill

Use this skill when baseline capture and characterization tests are complete and the user asks to plan or execute the migration from Java 8 + javax to Java 21 + Jakarta EE.

## Goal

Apply the migration in small, verifiable steps. Each step is independently buildable, preserves Java 8 behavior, and can be rolled back if validation fails.

## Rules

- Read `AGENTS.md` first — it contains the migration constraints.
- Read `docs/migration-results/java8-baseline/baseline-summary.md` — know what to preserve.
- Use Java 21 mode (`JAVA_HOME=/opt/java/jdk21`).
- One commit per step. Each commit must compile independently.
- Do not modernize code. If it compiles under Java 21, leave it alone.
- Keep dependency changes in a separate commit from source code changes.
- After each step, run compile, then tests, then verify.
- If validation fails, revert and report. Do not broaden scope to fix it.

## Context Needed

Before this skill runs, it needs:

- `docs/migration-results/java8-baseline/baseline-summary.md` — baseline test count, coverage, behavioral notes
- `docs/migration-progress-checklist.md` — tracker to update
- `AGENTS.md` — migration rules and Jakarta EE-specific constraints
- Knowledge of parent POM structure: `grep '<parent>' pom.xml` and check `~/.m2/repository/...` for parent POM plugin bindings

## Inspect / Search

Review these areas to plan the migration order:

- Parent POM `<build><plugins>` — find tooling that will break with JDK 21 (FindBugs, PMD, surefire)
- Root POM `<pluginManagement>` — which versions are overridable
- Child POMs — which modules exist, what they depend on
- `javax.*` usage — `rg "import javax\." --type java` to estimate migration scope
- Generated code directories — `target/generated-sources/` — do they use javax or jakarta?
- OpenAPI generator config and version
- Swagger/springfox dependencies — `rg "springfox|swagger" pom.xml`

### Recommended search commands

```bash
# Parent POM tooling that will break
grep -A5 "findbugs\|pmd\|surefire\|failsafe" ~/.m2/repository/.../bad-audi-pom/1.10/*.pom 2>/dev/null

# javax import count
rg "import javax\." --type java | wc -l

# Generated code namespace
head -20 target/generated-sources/annotations/**/*.java 2>/dev/null

# Check for springfox/swagger
rg "springfox\|swagger" pom.xml
rg "@ApiParam\|@ApiIgnore\|@ApiModelProperty" --type java
```

## Required Output

After each step, return:

1. Step completed and what changed (files, dependencies, configuration)
2. Validation command and result (compile, test, verify)
3. Test count vs baseline — must match exactly
4. Remaining steps in the migration order
5. Proposed commit message for this step

## Validation

After each step, run the narrowest validation:

```bash
JAVA_HOME=/opt/java/jdk21 ./mvnw clean compile -pl <affected-module>
JAVA_HOME=/opt/java/jdk21 ./mvnw clean test -pl <affected-module>
```

After all steps complete, run full validation:

```bash
JAVA_HOME=/opt/java/jdk21 ./mvnw clean verify 2>&1 | tee docs/migration-results/java21-candidate/compile-and-test-output.log
grep "Tests run:" docs/migration-results/java21-candidate/compile-and-test-output.log
```

## Final Rule

If a step cannot be validated independently, it is too large. Split it. A migration change is not complete because it compiles — it is complete only when the same test count passes and coverage is at or above baseline.
