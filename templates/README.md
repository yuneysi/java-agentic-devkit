# Templates

This directory contains files that developers copy into target Java projects.

Do not copy the whole `java-agentic-devkit` repository into every project. Keep the devkit as a shared external tool and copy only the template files needed by the target project.

## Available Templates

| Template | Use when | Main files copied |
|----------|----------|-------------------|
| `java8/` | The target project stays on Java 8. | `AGENTS.md`, `.github/copilot-instructions.md`, `docs/java8-best-practices.md` |
| `java21/` | The target project already runs on Java 21. | `AGENTS.md`, `.github/copilot-instructions.md`, `docs/java21-best-practices.md` |
| `java21-migration/` | The target project is migrating from Java 8 to Java 21. | `AGENTS.md`, `.github/copilot-instructions.md`, `docs/java21-migration.md`, `scripts/*.sh` |

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
templates/java8/
├── AGENTS.md
├── .github/
│   └── copilot-instructions.md
└── docs/
    └── java8-best-practices.md
```

Recommended command from macOS, Linux, or Windows WSL:

```bash
~/github/java-agentic-devkit/scripts/copy-java8-template.sh /path/to/java8-project
```

Or run it from the target project root:

```bash
~/github/java-agentic-devkit/scripts/copy-java8-template.sh
```

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
templates/java21/
├── AGENTS.md
├── .github/
│   └── copilot-instructions.md
└── docs/
    └── java21-best-practices.md
```

Recommended command from macOS, Linux, or Windows WSL:

```bash
~/github/java-agentic-devkit/scripts/copy-java21-template.sh /path/to/java21-project
```

Or run it from the target project root:

```bash
~/github/java-agentic-devkit/scripts/copy-java21-template.sh
```

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
│   └── java21-migration.md
└── scripts/
    ├── run-java8-baseline.sh
    ├── run-java21-candidate.sh
    └── compare-behavior.sh
```

Source files:

```text
templates/java21-migration/
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

Recommended command from macOS, Linux, or Windows WSL:

```bash
~/github/java-agentic-devkit/scripts/copy-java21-migration-template.sh ~/cip/27801_arus
```

Or run it from the target project root:

```bash
~/github/java-agentic-devkit/scripts/copy-java21-migration-template.sh
```

On Windows, run these commands from WSL. If the target project is stored on the Windows `C:` drive, pass its WSL path:

```bash
~/github/java-agentic-devkit/scripts/copy-java21-migration-template.sh /mnt/c/Users/YOUR_NAME/cip/27801_arus
```

## Migration Helper Scripts

The migration template includes three helper scripts. They are copied into the target project so every developer captures and compares migration results in the same way.

### `scripts/run-java8-baseline.sh`

Run this script inside the devkit container while it is using Java 8.

It captures the current Java 8 behavior before migration changes are made. By default, it runs:

```bash
mvn clean verify
```

It writes results to:

```text
docs/migration-results/java8-baseline-<timestamp>/
```

Use it with the default command:

```bash
scripts/run-java8-baseline.sh
```

Or pass a project-specific Maven command:

```bash
scripts/run-java8-baseline.sh mvn clean verify -Pintegration-tests
```

### `scripts/run-java21-candidate.sh`

Run this script inside the devkit container while it is using Java 21.

It validates the migration candidate against Java 21. By default, it runs:

```bash
mvn clean verify
```

It writes results to:

```text
docs/migration-results/java21-candidate-<timestamp>/
```

Use it for small validation steps first:

```bash
scripts/run-java21-candidate.sh mvn clean compile
scripts/run-java21-candidate.sh mvn test
scripts/run-java21-candidate.sh mvn verify
```

### `scripts/compare-behavior.sh`

Run this script after there is at least one Java 8 baseline run and one Java 21 candidate run.

It compares the latest Java 8 and Java 21 logs and writes the comparison to:

```text
docs/migration-results/comparison-<timestamp>/
```

Use the latest available runs:

```bash
scripts/compare-behavior.sh
```

Or compare two specific result directories:

```bash
scripts/compare-behavior.sh docs/migration-results/java8-baseline-<timestamp> docs/migration-results/java21-candidate-<timestamp>
```

The comparison does not decide whether a difference is safe. Developers must review the diff and classify the result as migration-safe, behavior-changing, or requiring more tests.

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
