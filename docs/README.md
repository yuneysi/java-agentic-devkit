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

There are two supported ways to use `java-agentic-devkit` from another Java project.

### Option 1: Build the DevKit Image, Then Start the Target Project Compose File

This is the preferred workflow when the target project owns its own `compose.yml`.

From the developer machine, build or rebuild the shared devkit image:

```bash
cd ~/github/java-agentic-devkit
./scripts/create-image.sh
```

Then start Docker Compose from the target project:

```bash
cd /path/to/java/project
docker compose -f compose.yml up -d
```

The target project's Compose service should use the `java-agentic-devkit:latest` image, mount the project at `/workspace`, and set `DEVKIT_PROJECT_DIR=/workspace`.

Example `compose.yml` service:

```yaml
services:
    dev:
        image: java-agentic-devkit:latest
        working_dir: /workspace
        environment:
            DEVKIT_JAVA_VERSION: java8
            DEVKIT_PROJECT_DIR: /workspace
        volumes:
            - ..:/workspace
            - /var/run/docker.sock:/var/run/docker.sock
        ports:
            - "8080:8080"
            - "5005:5005"
            - "61616:61616"
            - "8161:8161"
        stdin_open: true
        tty: true
        command: /bin/bash
```

This example assumes the Compose file lives in a project subdirectory such as `.devcontainer/`, so `..:/workspace` mounts the target project root. If `compose.yml` lives at the target project root, use `.:/workspace` instead.

Example `devcontainer.json` for VS Code Dev Containers:

```json
{
    "name": "Java Agentic DevKit",
    "dockerComposeFile": "docker-compose.yml",
    "service": "dev",
    "workspaceFolder": "/workspace",
    "remoteUser": "vscode"
}
```

### Option 2: Start a Project Manually with the DevKit Scripts

Use this workflow when the target project does not provide its own Compose file or when you want a quick interactive container from the devkit repository:

```bash
cd ~/github/java-agentic-devkit
./scripts/create-image.sh
./scripts/container/start-devkit-container.sh /path/to/java/project
```

Java 8 is the default runtime.

Use Java 21 explicitly when needed:

```bash
cd ~/github/java-agentic-devkit
./scripts/create-image.sh
./scripts/container/start-devkit-container.sh /path/to/java/project java21
```

Inside the container, the target project is mounted at a stable path:

```text
/workspace
```

On first start, the devkit creates `AGENTS.md` in the target project from the selected Java template when the file does not already exist. Existing `AGENTS.md` files are preserved. This works for both the Compose workflow and the manual script workflow.

---

## macOS

Open Docker Desktop first and wait until Docker is running. Then run:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh ~/cip/27801_arus
```

If Docker Desktop is installed but stopped, the scripts try to start it automatically.

---

## Windows

Use Docker Desktop with the WSL2 backend and run the devkit from a WSL terminal:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh ~/cip/27801_arus
```

If the target project is on the Windows `C:` drive, use the WSL path:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /mnt/c/Users/YOUR_NAME/cip/27801_arus
```

Keeping both the devkit and Java projects inside the WSL home folder, such as `~/github` and `~/cip`, is usually faster than working from `/mnt/c`.

Template copy scripts also run from WSL. For example:

```bash
~/github/java-agentic-devkit/scripts/copy-java21-migration-template.sh ~/cip/27801_arus
```

If the target project is on the Windows `C:` drive, pass the WSL path:

```bash
~/github/java-agentic-devkit/scripts/copy-java21-migration-template.sh /mnt/c/Users/YOUR_NAME/cip/27801_arus
```

---

## DevKit Scripts

Run these scripts from the `java-agentic-devkit` directory.

| Script | Purpose | Typical use |
|--------|---------|-------------|
| `./scripts/container/start-devkit-container.sh` | Recommended entry point. Builds the image if needed and starts the container. | Daily development. |
| `./scripts/container/devkit.sh` | Full startup script used by `start-devkit-container.sh`. It accepts the project path and Java version. | Advanced debugging or direct control. |
| `./scripts/create-image.sh` | Builds the Docker image only. | Rebuild the devkit image without starting a project. |
| `./scripts/container/run-image.sh` | Runs an existing image. | Manual container startup. |
| `./scripts/copy-java8-template.sh` | Copies the Java 8 template into a target project. | Preparing a Java 8 project for agent-assisted work. |
| `./scripts/copy-java21-template.sh` | Copies the Java 21 template into a target project. | Preparing a Java 21 project for agent-assisted work. |
| `./scripts/copy-java21-migration-template.sh` | Copies the Java 8 to Java 21 migration template and helper scripts into a target project. | Starting a migration. |

Recommended command style:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/java/project
```

Use this same style in examples and team documentation. Do not rely on a `devkit` shell shortcut or symlink.

---

## Java Version Selection

Java 8 is the default:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/java8-project
```

You can also request Java 8 explicitly:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/java8-project java8
```

Use Java 21 explicitly:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/java21-project java21
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

Recommended command from macOS, Linux, or Windows WSL:

```bash
~/github/java-agentic-devkit/scripts/copy-java8-template.sh /path/to/java8-project
```

You can also run it from the target project root with no argument.

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

Recommended command from macOS, Linux, or Windows WSL:

```bash
~/github/java-agentic-devkit/scripts/copy-java21-template.sh /path/to/java21-project
```

You can also run it from the target project root with no argument.

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

Recommended command from macOS, Linux, or Windows WSL:

```bash
~/github/java-agentic-devkit/scripts/copy-java21-migration-template.sh ~/cip/27801_arus
```

You can also run it from the target project root with no argument.

For the migration workflow, see [JAVA8_TO_JAVA21_MIGRATION.md](JAVA8_TO_JAVA21_MIGRATION.md).

---

## Common Examples

### Work on `~/cip/27801_arus` with Java 8

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh ~/cip/27801_arus
```

Inside the container:

```bash
java -version
mvn clean verify
opencode
```

### Work on a Java 21 project

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/java21-project java21
```

Inside the container:

```bash
java -version
mvn clean verify
```

### Rebuild the devkit image

```bash
cd ~/github/java-agentic-devkit
./scripts/create-image.sh
```

---

## More Information

- [JAVA8_TO_JAVA21_MIGRATION.md](JAVA8_TO_JAVA21_MIGRATION.md) explains the Java 8 to Java 21 migration workflow.
- [../templates/README.md](../templates/README.md) lists template files and copy commands.
- [../CODING_STANDARDS.md](../CODING_STANDARDS.md) defines repository coding standards.
