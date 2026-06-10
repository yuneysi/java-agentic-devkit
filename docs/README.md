# java-agentic-devkit Documentation

## What This Project Is For

`java-agentic-devkit` is a reusable Docker-based development kit for Java teams.

It gives developers one standard environment for working with Java projects that need Java 8, Java 21, Maven, Tomcat, ActiveMQ, IBM MQ tooling, OpenCode, oh-my-opencode, and GitHub Copilot guidance.

Use this project when you want to:

1. Work on an existing Java 8 project.
2. Work on an existing Java 21 project.
3. Start a Java 8 to Java 21 migration using the migration template.

The devkit itself stays outside the target Java project. Developers start the devkit and pass the target project path to it.

---

## Basic Usage

From the developer machine:

```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh /path/to/java/project
```

Java 8 is the default runtime.

Use Java 21 explicitly when needed:

```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh /path/to/java/project java21
```

Inside the container, the target project is mounted at:

```text
/workspaces/project
```

---

## macOS

Open Docker Desktop first and wait until Docker is running. Then run:

```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh ~/cip/27801_arus
```

If Docker Desktop is installed but stopped, the scripts try to start it automatically.

---

## Windows

Use Docker Desktop with the WSL2 backend and run the devkit from a WSL terminal:

```bash
cd ~/github/java-agentic-devkit
./scripts/dev.sh ~/cip/27801_arus
```

If the target project is on the Windows `C:` drive, use the WSL path:

```bash
cd ~/github/java-agentic-devkit
./scripts/dev.sh /mnt/c/Users/YOUR_NAME/cip/27801_arus
```

Keeping both the devkit and Java projects inside the WSL home folder, such as `~/github` and `~/cip`, is usually faster than working from `/mnt/c`.

---

## DevKit Scripts

Run these scripts from the `java-agentic-devkit` directory.

| Script | Purpose | Typical use |
|--------|---------|-------------|
| `./scripts/dev.sh` | Recommended entry point. Builds the image if needed and starts the container. | Daily development. |
| `./scripts/devkit.sh` | Full startup script used by `dev.sh`. It accepts the project path and Java version. | Advanced debugging or direct control. |
| `./scripts/create-image.sh` | Builds the Docker image only. | Rebuild the devkit image without starting a project. |
| `./scripts/run-image.sh` | Runs an existing image. | Manual container startup. |

Recommended command style:

```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh /path/to/java/project
```

Use this same style in examples and team documentation. Do not rely on a `devkit` shell shortcut or symlink.

---

## Java Version Selection

Java 8 is the default:

```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh /path/to/java8-project
```

You can also request Java 8 explicitly:

```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh /path/to/java8-project java8
```

Use Java 21 explicitly:

```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh /path/to/java21-project java21
```

---

## Templates

Templates are files that developers copy into a target Java project when that project needs project-specific agent instructions or migration tracking.

Available templates:

```text
templates/java8/
templates/java21/
templates/java21-migration/
```

Use `templates/java8/` when a target project will continue running on Java 8 and needs standard agent instructions plus Java 8 best practices.

Use `templates/java21/` when a target project already runs on Java 21 and needs standard agent instructions plus Java 21 best practices.

Use `templates/java21-migration/` when a target project is being migrated from Java 8 to Java 21.

| Template | Use when | Main documentation copied |
|----------|----------|---------------------------|
| `templates/java8/` | The project stays on Java 8. | `docs/java8-best-practices.md` |
| `templates/java21/` | The project already runs on Java 21. | `docs/java21-best-practices.md` |
| `templates/java21-migration/` | The project is migrating from Java 8 to Java 21. | `docs/java21-migration.md` |

### Java 8 Template

The Java 8 template copies these files into the target project:

```text
target-java-project/
├── AGENTS.md
├── .github/
│   └── copilot-instructions.md
└── docs/
    └── java8-best-practices.md
```

Copy command from the target project root:

```bash
mkdir -p .github docs
cp /path/to/java-agentic-devkit/templates/java8/AGENTS.md AGENTS.md
cp /path/to/java-agentic-devkit/templates/java8/.github/copilot-instructions.md .github/copilot-instructions.md
cp /path/to/java-agentic-devkit/templates/java8/docs/java8-best-practices.md docs/java8-best-practices.md
```

### Java 21 Template

The Java 21 template copies these files into the target project:

```text
target-java-project/
├── AGENTS.md
├── .github/
│   └── copilot-instructions.md
└── docs/
    └── java21-best-practices.md
```

Copy command from the target project root:

```bash
mkdir -p .github docs
cp /path/to/java-agentic-devkit/templates/java21/AGENTS.md AGENTS.md
cp /path/to/java-agentic-devkit/templates/java21/.github/copilot-instructions.md .github/copilot-instructions.md
cp /path/to/java-agentic-devkit/templates/java21/docs/java21-best-practices.md docs/java21-best-practices.md
```

### Java 8 to Java 21 Migration Template

The migration template copies these files into the target project:

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

Copy command from the target project root:

```bash
mkdir -p .github docs scripts
cp /path/to/java-agentic-devkit/templates/java21-migration/AGENTS.md AGENTS.md
cp /path/to/java-agentic-devkit/templates/java21-migration/.github/copilot-instructions.md .github/copilot-instructions.md
cp /path/to/java-agentic-devkit/templates/java21-migration/docs/java21-migration.md docs/java21-migration.md
cp /path/to/java-agentic-devkit/templates/java21-migration/scripts/*.sh scripts/
chmod +x scripts/run-java8-baseline.sh scripts/run-java21-candidate.sh scripts/compare-behavior.sh
```

For the migration workflow, see [JAVA8_TO_JAVA21_MIGRATION.md](JAVA8_TO_JAVA21_MIGRATION.md).

---

## Common Examples

### Work on `~/cip/27801_arus` with Java 8

```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh ~/cip/27801_arus
```

Inside the container:

```bash
java -version
mvn clean verify
opencode
```

### Work on a Java 21 project

```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh /path/to/java21-project java21
```

Inside the container:

```bash
java -version
mvn clean verify
```

### Rebuild the devkit image

```bash
cd /path/to/java-agentic-devkit
./scripts/create-image.sh
```

---

## More Information

- [JAVA8_TO_JAVA21_MIGRATION.md](JAVA8_TO_JAVA21_MIGRATION.md) explains the Java 8 to Java 21 migration workflow.
- [../templates/README.md](../templates/README.md) lists template files and copy commands.
- [../CODING_STANDARDS.md](../CODING_STANDARDS.md) defines repository coding standards.
