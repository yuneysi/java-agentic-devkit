# Java 8 to Java 21 Migration with OpenCode, oh-my-opencode and Copilot

## Purpose

This document defines the standard workflow for migrating Java projects from Java 8 to Java 21 using `java-agentic-devkit`, OpenCode, oh-my-opencode and GitHub Copilot.

This document belongs in:

```text
java-agentic-devkit/docs/JAVA8_TO_JAVA21_MIGRATION.md
```

Every developer should use this document before starting a Java 8 to Java 21 migration.

For general devkit usage, Java 8-only work, Java 21-only work, templates, and devkit scripts, see [README.md](README.md).

---

## Mandatory Starting Point: `java-agentic-devkit`

Every developer must start the migration from the `java-agentic-devkit` project.

`java-agentic-devkit` is the standard development kit used to configure OpenCode, oh-my-opencode, Copilot-related instructions, Docker, Java, Maven, Tomcat, ActiveMQ, IBM MQ, and the rest of the migration tooling.

Do not start the Java 8 to Java 21 migration directly from an ad-hoc local environment.

The migration must be executed from the standardized containerized environment provided by `java-agentic-devkit` so that every developer uses the same toolchain, Java versions, Maven setup, shell helpers, and agent configuration.

---

## Standard Developer Flow

From the developer machine:

```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh /path/to/your/java/project
```

By default, the container starts with Java 8.

Use Java 8 mode to capture the legacy baseline behavior:

```bash
./scripts/dev.sh /path/to/your/java/project
```

or explicitly:

```bash
./scripts/dev.sh /path/to/your/java/project java8
```

Use Java 21 only when the project needs to be compiled, tested, or executed with Java 21:

```bash
./scripts/dev.sh /path/to/your/java/project java21
```

The target project is passed to `java-agentic-devkit` through `./scripts/dev.sh`.

Do not manually clone or mount the target project inside the devkit workspace unless there is a specific documented reason.

## Inside the Container

Once inside the container, verify the toolchain:

```bash
java -version
javac -version
mvn -version
git --version
opencode --version
```

Then move to the mounted project directory if the container did not open there automatically.

Check Git state:

```bash
git status
git branch --show-current
```

Create or switch to the migration branch:

```bash
git checkout feature/migrate_to_java21
git pull
git checkout -b branch/java21
```

From this point onward, all migration commands, OpenCode sessions, Maven builds, tests, and commits should be executed from inside the `java-agentic-devkit` container unless there is an explicit reason to do otherwise.

---

## Recommended High-Level Migration Flow

```text
1. Clone or update java-agentic-devkit.
2. Start the devkit using ./scripts/dev.sh /path/to/your/java/project.
3. Use Java 8 first to capture the behavioral baseline.
4. Verify Java, Maven, Git, OpenCode, oh-my-opencode, and Copilot-related configuration inside the container.
5. Create or switch to branch/java21 from feature/migrate_to_java21.
6. Add AGENTS.md and .github/copilot-instructions.md to the target project.
7. Run OpenCode from inside the container.
8. Perform one small migration step at a time.
9. Validate inside the same container.
10. Commit only isolated and reviewed changes.
11. Restart the devkit with java21 when Java 21 compilation or runtime validation is required.
```

---

## Template Files to Copy Into the Target Project

The migration template lives in:

```text
java-agentic-devkit/templates/java21-migration/
```

Copy these files into the root of the target Java project before starting migration work:

```bash
mkdir -p .github docs scripts
cp /path/to/java-agentic-devkit/templates/java21-migration/AGENTS.md AGENTS.md
cp /path/to/java-agentic-devkit/templates/java21-migration/.github/copilot-instructions.md .github/copilot-instructions.md
cp /path/to/java-agentic-devkit/templates/java21-migration/docs/java21-migration.md docs/java21-migration.md
cp /path/to/java-agentic-devkit/templates/java21-migration/scripts/*.sh scripts/
chmod +x scripts/run-java8-baseline.sh scripts/run-java21-candidate.sh scripts/compare-behavior.sh
```

Commit them as the first migration commit:

```bash
git add AGENTS.md .github/copilot-instructions.md docs/java21-migration.md scripts/run-java8-baseline.sh scripts/run-java21-candidate.sh scripts/compare-behavior.sh
git commit -m "chore: add agent instructions for Java 21 migration"
```

---

## Agent Instruction Files in the Target Project

For OpenCode and oh-my-opencode, use a root-level `AGENTS.md` file as the main instruction file.

For GitHub Copilot, also create `.github/copilot-instructions.md` with shorter repository-level instructions.

These files belong in the Java project being migrated, not only in `java-agentic-devkit`.

Recommended target project structure:

```text
target-java-project/
├── AGENTS.md
├── .github/
│   └── copilot-instructions.md
├── docs/
│   └── java21-migration.md
└── scripts/
    ├── run-java8-baseline.sh
    ├── run-java21-candidate.sh
    └── compare-behavior.sh
```

---

## What the Migration Scripts Do

The migration template includes three helper scripts. They are copied into the target Java project so every developer captures and compares migration results in the same way.

| Script | When to run it | What it does |
|--------|----------------|--------------|
| `scripts/run-java8-baseline.sh` | In Java 8 mode, before migration changes. | Runs the current project validation and stores Java 8 baseline logs under `docs/migration-results/java8-baseline-<timestamp>/`. |
| `scripts/run-java21-candidate.sh` | In Java 21 mode, after or during migration changes. | Runs Java 21 validation and stores candidate logs under `docs/migration-results/java21-candidate-<timestamp>/`. |
| `scripts/compare-behavior.sh` | After at least one baseline run and one candidate run. | Compares Java 8 and Java 21 logs and writes a diff under `docs/migration-results/comparison-<timestamp>/`. |

Both run scripts use `mvn clean verify` by default. You can pass a smaller or project-specific command when needed:

```bash
scripts/run-java8-baseline.sh mvn clean test
scripts/run-java21-candidate.sh mvn clean compile
```

The comparison script finds the latest baseline and candidate automatically:

```bash
scripts/compare-behavior.sh
```

---

## Examples

### Example 1: Start a Java 8 to Java 21 Migration

Start in Java 8 mode and copy the migration template into the target project:

```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh ~/cip/27801_arus java8
```

Inside the container:

```bash
mkdir -p .github docs scripts
cp /path/to/java-agentic-devkit/templates/java21-migration/AGENTS.md AGENTS.md
cp /path/to/java-agentic-devkit/templates/java21-migration/.github/copilot-instructions.md .github/copilot-instructions.md
cp /path/to/java-agentic-devkit/templates/java21-migration/docs/java21-migration.md docs/java21-migration.md
cp /path/to/java-agentic-devkit/templates/java21-migration/scripts/*.sh scripts/
chmod +x scripts/run-java8-baseline.sh scripts/run-java21-candidate.sh scripts/compare-behavior.sh
scripts/run-java8-baseline.sh
```

After baseline behavior is captured, restart the devkit with Java 21 only when Java 21 validation is required:

```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh ~/cip/27801_arus java21
```

Inside the container:

```bash
scripts/run-java21-candidate.sh mvn clean compile
scripts/compare-behavior.sh
```

### Example 2: Ask OpenCode for the First Migration Plan

From the host machine:

```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh ~/cip/27801_arus
```

Inside the container:

```bash
java -version
mvn -version
git status
git checkout feature/migrate_to_java21
git pull
git checkout -b branch/java21
```

Copy the migration instruction files to the target project:

```bash
mkdir -p .github docs scripts
cp /path/to/java-agentic-devkit/templates/java21-migration/AGENTS.md AGENTS.md
cp /path/to/java-agentic-devkit/templates/java21-migration/.github/copilot-instructions.md .github/copilot-instructions.md
cp /path/to/java-agentic-devkit/templates/java21-migration/docs/java21-migration.md docs/java21-migration.md
cp /path/to/java-agentic-devkit/templates/java21-migration/scripts/*.sh scripts/
chmod +x scripts/run-java8-baseline.sh scripts/run-java21-candidate.sh scripts/compare-behavior.sh
```

Start OpenCode:

```bash
opencode
```

Recommended first OpenCode prompt:

```text
Read AGENTS.md first and follow it strictly.

Inspect this project for Java 8 to Java 21 migration risks.

Do not modify files.

Focus on Maven, Java version configuration, Spring, Tomcat, JSP, SOAP/XML, JMS, JDBC, JAXB, and test setup.

Return a prioritized migration plan with small commits.
```

---

## Java 8 Baseline First

Before making Java 21 changes, capture the Java 8 baseline.

Start the project in Java 8 mode:

```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh /path/to/your/java/project java8
```

Inside the container, run the current build and tests:

```bash
mvn -version
scripts/run-java8-baseline.sh
```

If available, run integration tests or project-specific validation:

```bash
scripts/run-java8-baseline.sh mvn clean verify -Pintegration-tests
```

Document the results in:

```text
docs/java21-migration.md
```

The Java 8 baseline is the behavioral source of truth.

---

## Java 21 Candidate Validation

When Java 8 baseline behavior is documented, restart the container in Java 21 mode:

```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh /path/to/your/java/project java21
```

Inside the container, run the smallest relevant Java 21 validation command first:

```bash
scripts/run-java21-candidate.sh mvn clean compile
```

Then proceed gradually:

```bash
scripts/run-java21-candidate.sh mvn test
scripts/run-java21-candidate.sh mvn verify
```

Compare the latest Java 8 and Java 21 logs:

```bash
scripts/compare-behavior.sh
```

Do not jump directly into broad fixes.

Every failure should be classified as one of:

- safe migration
- behavioral risk
- SOAP/XML contract risk
- JSP/runtime risk
- JMS risk
- JDBC risk
- configuration risk
- cache risk
- test gap
- build-tool risk
- dependency risk
- security risk

---

## OpenCode / oh-my-opencode Workflow

Use OpenCode for structured migration work.

Recommended flow:

```text
plan -> implement one small change -> test -> review -> commit
```

Use Planning Mode first:

```text
Read AGENTS.md first and follow it strictly.

Inspect the current project for the next smallest Java 8 to Java 21 migration step.

Do not modify files.

Return:
- proposed change
- affected files
- migration risk
- validation command
- proposed commit message
```

Use Implementation Mode only for one focused change:

```text
Read AGENTS.md first and follow it strictly.

Apply only the proposed migration step.

Do not refactor unrelated code.

Do not modernize production code.

Preserve Java 8 behavior.

Run the smallest relevant validation command.

Report changed files, risk level, validation result, and proposed commit message.
```

Use Review Mode before committing:

```text
Read AGENTS.md first and follow it strictly.

Review the current Git diff as a Java 8 to Java 21 migration auditor.

Do not modify files.

Check whether the diff preserves Java 8 behavior.

Classify migration risks.

Report blocking issues, non-blocking issues, missing tests, and whether the change is safe to commit.
```

---

## Copilot Usage

Use GitHub Copilot only for small local edits.

Good Copilot tasks:

- generate one characterization test
- explain one compilation error
- suggest one Maven plugin configuration
- add one missing dependency
- write one targeted assertion
- convert one small and reviewed import group

Bad Copilot tasks:

- migrate the whole project
- modernize the codebase
- upgrade all dependencies
- rewrite SOAP clients
- refactor all JSPs
- change all `javax.*` imports without review
- fix all tests at once

Copilot suggestions must be reviewed manually before acceptance.

Do not accept Copilot changes that alter behavior without tests.

---

## Recommended First Commit in Each Target Project

```bash
mkdir -p .github docs scripts
cp /path/to/java-agentic-devkit/templates/java21-migration/AGENTS.md AGENTS.md
cp /path/to/java-agentic-devkit/templates/java21-migration/.github/copilot-instructions.md .github/copilot-instructions.md
cp /path/to/java-agentic-devkit/templates/java21-migration/docs/java21-migration.md docs/java21-migration.md
cp /path/to/java-agentic-devkit/templates/java21-migration/scripts/*.sh scripts/
chmod +x scripts/run-java8-baseline.sh scripts/run-java21-candidate.sh scripts/compare-behavior.sh
git add AGENTS.md .github/copilot-instructions.md docs/java21-migration.md scripts/run-java8-baseline.sh scripts/run-java21-candidate.sh scripts/compare-behavior.sh
git commit -m "chore: add agent instructions for Java 21 migration"
```

---

