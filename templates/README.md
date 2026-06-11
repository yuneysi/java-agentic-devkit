# Templates

This directory contains files that the devkit applies to target Java projects.

Do not copy the whole `java-agentic-devkit` repository into every project. Keep the devkit as a shared external tool. The container creates missing template files in the target project on first start and preserves existing files.

## Available Templates

| Template | Use when | Main files copied |
|----------|----------|-------------------|
| `AGENTS.md` | All target projects. | `AGENTS.md` |
| `java8/` | The target project stays on Java 8. | `.github/copilot-instructions.md`, `docs/java8-best-practices.md` |
| `java21/` | The target project already runs on Java 21. | `.github/copilot-instructions.md`, `docs/java21-best-practices.md` |
| `java21-migration/` | The target project is migrating from Java 8 to Java 21. | `.github/copilot-instructions.md`, `docs/java21-migration.md` |

### `java8/`

Use this template when a project will continue running on Java 8 and needs standard agent instructions plus Java 8 maintenance best practices.

Copy its contents into the target project root:

```text
target-java-project/
├── AGENTS.md
├── .github/
│   └── copilot-instructions.md
└── docs/
    └── java8-best-practices.md
```

Source files:

```text
templates/AGENTS.md
templates/java8/
├── .github/
│   └── copilot-instructions.md
└── docs/
    └── java8-best-practices.md
```

Apply this template with the manual script workflow:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/java8-project java8
```

For Compose, set `DEVKIT_JAVA_VERSION=java8`.

Recommended first commit:

```bash
git add AGENTS.md .github/copilot-instructions.md docs/java8-best-practices.md
git commit -m "chore: add Java 8 development instructions"
```

Use the devkit with Java 8:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/java8-project
```

### `java21/`

Use this template when a project already runs on Java 21 and needs standard agent instructions plus Java 21 maintenance best practices.

Copy its contents into the target project root:

```text
target-java-project/
├── AGENTS.md
├── .github/
│   └── copilot-instructions.md
└── docs/
    └── java21-best-practices.md
```

Source files:

```text
templates/AGENTS.md
templates/java21/
├── .github/
│   └── copilot-instructions.md
└── docs/
    └── java21-best-practices.md
```

Apply this template with the manual script workflow:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/java21-project java21
```

For Compose, set `DEVKIT_JAVA_VERSION=java21`.

Recommended first commit:

```bash
git add AGENTS.md .github/copilot-instructions.md docs/java21-best-practices.md
git commit -m "chore: add Java 21 development instructions"
```

Use the devkit with Java 21:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/java21-project java21
```

### `java21-migration/`

Use this template when a project is being migrated from Java 8 to Java 21.

Copy its contents into the target project root:

```text
target-java-project/
├── AGENTS.md
├── .github/
│   └── copilot-instructions.md
├── docs/
    └── java21-migration.md
```

Source files:

```text
templates/AGENTS.md
templates/java21-migration/
├── .github/
│   └── copilot-instructions.md
├── docs/
    └── java21-migration.md
```

Apply this template with the manual script workflow:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh ~/cip/27801_arus java21-migration
```

For Compose, set `DEVKIT_JAVA_VERSION=java21-migration`. On Windows, run manual commands from WSL. If the target project is stored on the Windows `C:` drive, pass its WSL path to `start-devkit-container.sh`.

## Migration Result Capture

The migration template does not create helper scripts in the target project. Capture baseline and candidate results with direct Maven commands and store the logs under `docs/migration-results/`.

Example Java 8 baseline capture:

```bash
mkdir -p docs/migration-results/java8-baseline
mvn clean verify 2>&1 | tee docs/migration-results/java8-baseline/mvn-clean-verify.log
```

Example Java 21 candidate capture:

```bash
mkdir -p docs/migration-results/java21-candidate
mvn clean compile 2>&1 | tee docs/migration-results/java21-candidate/mvn-clean-compile.log
```

Compare captured logs when useful:

```bash
diff -ru docs/migration-results/java8-baseline docs/migration-results/java21-candidate | tee docs/migration-results/java8-vs-java21.diff || true
```

Developers must review differences and classify each result as migration-safe, behavior-changing, or requiring more tests.

## Java 8 Only and Java 21 Only Projects

Projects that are not doing a Java 8 to Java 21 migration do not need to copy the migration template.

They can still use the devkit container:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/java-project
```

Use Java 21 explicitly when needed:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/java-project java21
```
