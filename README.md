# java-agentic-devkit

`java-agentic-devkit` is a reusable Docker-based development kit for teams working on Java 8 projects, Java 21 projects, and Java 8 to Java 21 migrations.

The devkit stays outside the target Java project. Developers build or run the devkit from this repository and mount the target project at `/workspace`.

Java 8 is the default runtime. Use Java 21 only when the target project already runs on Java 21 or when validating a Java 8 to Java 21 migration candidate.

## Quick Start

Start a Java 8 target project:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/java/project
```

Start a Java 21 target project:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/java/project java21
```

Start a Java 8 to Java 21 migration baseline:

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/java/project java21-migration
```

The startup script builds `java-agentic-devkit:latest` if the image does not exist, mounts the target project at `/workspace`, selects the requested Java mode, and opens a shell inside the container.

On first start, the container copies missing template files into the target project and preserves existing files.

## Repository Structure

```text
java-agentic-devkit/
├── .devcontainer/
│   └── Dockerfile
├── opencode/
│   ├── opencode.json
│   ├── tui.json
│   └── skills/
├── scripts/
│   ├── create-image.sh
│   ├── docker-utils.sh
│   └── container/
│       └── start-devkit-container.sh
├── templates/
│   ├── README.md
│   ├── java8/
│   │   ├── AGENTS.md
│   │   ├── .github/copilot-instructions.md
│   │   └── docs/java8-best-practices.md
│   ├── java21/
│   │   ├── AGENTS.md
│   │   ├── .github/copilot-instructions.md
│   │   └── docs/java21-best-practices.md
│   └── java21-migration/
│       ├── AGENTS.md
│       ├── .github/copilot-instructions.md
│       └── docs/java21-migration-best-practices.md
├── AGENTS.md
└── README.md
```

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/create-image.sh` | Builds the Docker image. |
| `scripts/container/start-devkit-container.sh` | Builds the image if needed and starts a target project container. |
| `scripts/docker-utils.sh` | Shared Docker availability checks used by the scripts. |

Build or rebuild the image manually:

```bash
cd ~/github/java-agentic-devkit
./scripts/create-image.sh
```

Override the image name, tag, or Dockerfile when needed:

```bash
cd ~/github/java-agentic-devkit
./scripts/create-image.sh java-agentic-devkit latest .devcontainer/Dockerfile
```

## Docker Compose

Teams can also keep a `docker-compose.yml` file in the target Java project.

```yaml
services:
  devkit:
    image: java-agentic-devkit:latest
    working_dir: /workspace
    environment:
      DEVKIT_PROJECT_DIR: /workspace
      DEVKIT_JAVA_VERSION: ${DEVKIT_JAVA_VERSION:-java8}
    volumes:
      - .:/workspace
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

If the Compose file lives in a subdirectory such as `.devcontainer/`, use `..:/workspace` instead of `.:/workspace`.

Start a Java 8 project:

```bash
cd /path/to/java/project
DEVKIT_JAVA_VERSION=java8 docker compose run --rm devkit
```

Start a Java 21 project:

```bash
cd /path/to/java/project
DEVKIT_JAVA_VERSION=java21 docker compose run --rm devkit
```

Start a Java 8 to Java 21 migration:

```bash
cd /path/to/java/project
DEVKIT_JAVA_VERSION=java21-migration docker compose run --rm devkit
```

The `java21-migration` mode starts with Java 8 so the team can capture the Java 8 behavioral baseline before validating the Java 21 candidate.

## Container Contents

The Docker image is built from `.devcontainer/Dockerfile`. It includes:

- Java 8 and Java 21
- Maven
- Tomcat 9 and Tomcat 11
- ActiveMQ Classic
- IBM MQ tooling path placeholders
- Node.js, npm, Bun, TypeScript, and TypeScript language server
- Python 3
- `jq`, `ripgrep`, `fd`, `xmlstarlet`, `xmllint`, `xsltproc`, `fzf`, `tmux`, and common shell tools
- Semgrep, Checkov, Hadolint, Syft, Grype, and SonarScanner
- OpenCode, oh-my-openagent, `opencode-codebase-index`, and OpenCode skills from `opencode/skills/`
- MCP tooling for Context7, GitHub, and Playwright

Useful commands inside the container:

```bash
use-java8
use-java21
mvn clean verify
opencode
start-tomcat9
start-tomcat11
start-activemq
```

The shell also provides aliases:

```bash
java8
java21
mvn8
mvn21
t9
t11
```

## Environment Variables

Use these variables from the target project's `docker-compose.yml`, from the manual startup script, or inside the running container.

### DevKit Runtime

| Variable | Default | Purpose |
|----------|---------|---------|
| `DEVKIT_PROJECT_DIR` | `/workspace` | Mounted target project path inside the container. OpenCode instructions are rewritten to read `${DEVKIT_PROJECT_DIR}/AGENTS.md`. |
| `DEVKIT_JAVA_VERSION` | `java8` | Selects the runtime and template. Supported values: `java8`, `java21`, `java21-migration`. |
| `DEFAULT_JAVA_VERSION` | `java8` | Container fallback when `DEVKIT_JAVA_VERSION` is not set. |

### AI Providers

| Variable | Purpose |
|----------|---------|
| `OPENAI_API_KEY` | Used by the bundled OpenCode OpenAI provider. |
| `GITHUB_TOKEN` | Passed to the GitHub MCP server as `GITHUB_PERSONAL_ACCESS_TOKEN`. |
| `GITHUB_PERSONAL_ACCESS_TOKEN` | Internal MCP environment variable populated from `GITHUB_TOKEN` by `opencode/opencode.json`. |
| `ANTHROPIC_API_KEY` | Optional for Anthropic-compatible tools if enabled by the user. |
| `OLLAMA_API_BASE` | Optional for local Ollama clients. Use `http://host.docker.internal:11434` on Docker Desktop for Windows/macOS. The bundled OpenCode config points to `http://host.containers.internal:11434/v1` by default. |

Example:

```bash
export OPENAI_API_KEY="sk-..."
export GITHUB_TOKEN="ghp_..."
export ANTHROPIC_API_KEY="sk-ant-..."
export OLLAMA_API_BASE="http://host.docker.internal:11434"
```

### Container Runtime Paths

These are set inside the container by the Docker image or shell startup.

| Variable | Default | Purpose |
|----------|---------|---------|
| `DEBIAN_FRONTEND` | `noninteractive` | Keeps apt operations noninteractive while building the image. |
| `JAVA8_HOME` | `/opt/java/jdk8` | Java 8 installation path. |
| `JAVA21_HOME` | `/opt/java/jdk21` | Java 21 installation path. |
| `JAVA_HOME` | `/opt/java/jdk8` | Active Java runtime path. Updated by `use-java8` and `use-java21`. |
| `PATH` | Includes Java, Maven, and ActiveMQ bins | Command lookup path assembled by the image. |
| `MAVEN_HOME` | `/opt/maven` | Maven installation path. |
| `MAVEN_OPTS` | `-Dmaven.repo.local=/var/tmp/m2/repository` | Maven JVM options and local repository location. |
| `TOMCAT9_HOME` | `/opt/tomcat/tomcat9` | Tomcat 9 installation path. |
| `TOMCAT11_HOME` | `/opt/tomcat/tomcat11` | Tomcat 11 installation path. |
| `CATALINA_HOME` | `/opt/tomcat/tomcat9` | Default Tomcat home. Helper scripts override it for Tomcat 9 or 11. |
| `CATALINA_BASE` | Same as selected Tomcat home | Set by `start-tomcat9` and `start-tomcat11`. |
| `ACTIVEMQ_HOME` | `/opt/activemq` | ActiveMQ installation path. |
| `MQ_INSTALLATION_PATH` | `/opt/mqm` | IBM MQ installation path. |
| `IBM_MQ_HOME` | `/opt/mqm` | IBM MQ home path. |
| `LD_LIBRARY_PATH` | `/opt/mqm/lib64:/opt/mqm/lib` | IBM MQ native library lookup path. |
| `JDTLS_WORKSPACE` | `/var/tmp/jdtls-workspace` | Optional Eclipse JDT Language Server workspace path. |

### Docker Build Arguments

These are build arguments, not runtime environment variables. Override them only when rebuilding the image intentionally.

| Build argument | Default |
|----------------|---------|
| `USERNAME` | `vscode` |
| `USER_UID` | `1000` |
| `USER_GID` | `${USER_UID}` |
| `MAVEN_VERSION` | `3.9.11` |
| `TOMCAT9_VERSION` | `9.0.105` |
| `TOMCAT11_VERSION` | `11.0.7` |
| `ACTIVEMQ_VERSION` | `5.18.7` |

## OpenCode Configuration

`opencode/opencode.json` is copied into the container as the default OpenCode configuration.

It configures:

- `instructions`: OpenCode reads `{file:/workspace/AGENTS.md}` by default. The container entrypoint rewrites this path to `${DEVKIT_PROJECT_DIR}/AGENTS.md` at startup.
- `plugin`: enables `oh-my-openagent` and `opencode-codebase-index`.
- `lsp`: enables language server support.
- `mcp`: configures local MCP servers for Context7, GitHub, and Playwright.
- `model`: uses `ollama/qwen2.5:7b` as the default model.
- `permission`: uses `ask`, so tool actions require confirmation.
- `provider`: configures local Ollama models and OpenAI models.

`opencode/tui.json` enables the `oh-my-openagent/tui` plugin for OpenCode's TUI setup.

The GitHub MCP server receives `GITHUB_TOKEN` as `GITHUB_PERSONAL_ACCESS_TOKEN`.

OpenAI models use `OPENAI_API_KEY`.

For GitHub Copilot, select the Copilot provider in OpenCode or oh-my-opencode. When the login flow prints a public URL and device code, open the public URL in your browser and enter the code shown in the terminal.

For Ollama, make sure Ollama is running on the host machine. Use `ollama` as the API key when a client asks for one. The bundled OpenCode config uses:

```text
Base URL: http://host.containers.internal:11434/v1
API key: ollama
```

On Windows with Docker Desktop or WSL, the host URL is usually different:

```text
Base URL: http://host.docker.internal:11434/v1
API key: ollama
```

Inside the container, start OpenCode from the mounted target project:

```bash
opencode
```

## OpenCode Skills

The container installs reusable OpenCode skills from `opencode/skills/`. These skills are available when you run OpenCode from a target project mounted at `/workspace`.

| Skill | Use for |
|-------|---------|
| `confluence-doc-writer` | Create, clean up, or convert documentation for Confluence. |
| `java8-baseline-capturer` | Capture Java 8 baseline results under `docs/migration-results/java8-baseline/` and update the migration tracker. |
| `java21-first-migration-step-planner` | Inspect the project and plan the first small Java 21 migration step. |
| `java21-small-change-implementer` | Apply one focused migration change and update the tracker with validation evidence. |
| `java21-candidate-validator` | Validate Java 21 candidate results under `docs/migration-results/java21-candidate/` and compare with the Java 8 baseline. |
| `jms-characterization-test-writer` | Create JMS characterization tests for Java 21 or messaging migrations. |
| `jpa-characterization-test-writer` | Create JPA/Hibernate characterization tests. |
| `migration-auditor` | Review a Java 21 migration branch against the Java 8 baseline. |
| `migration-test-planner` | Plan characterization and regression tests for a Java 8 to Java 21 migration. |
| `readme-writer` | Create, update, simplify, or review a target project's README. |
| `soap-contract-test-writer` | Create SOAP/XML contract characterization tests. |

## Templates

Each template is self-contained and owns its target-project agent instructions, best-practices document, Copilot instructions, and template-specific guidance.

| Template | Use when | Main files copied |
|----------|----------|-------------------|
| `templates/java8/` | The target project stays on Java 8. | `AGENTS.md`, `.github/copilot-instructions.md`, `docs/java8-best-practices.md` |
| `templates/java21/` | The target project already runs on Java 21. | `AGENTS.md`, `.github/copilot-instructions.md`, `docs/java21-best-practices.md` |
| `templates/java21-migration/` | The target project is migrating from Java 8 to Java 21. | `AGENTS.md`, `.github/copilot-instructions.md`, `docs/java21-migration-best-practices.md` |

Generated target project structure:

```text
target-java-project/
├── AGENTS.md
├── .github/
│   └── copilot-instructions.md
└── docs/
    └── <template-best-practices>.md
```

Recommended first commit for a Java 8 target project:

```bash
git add AGENTS.md .github/copilot-instructions.md docs/java8-best-practices.md
git commit -m "chore: add Java 8 development instructions"
```

Recommended first commit for a Java 21 target project:

```bash
git add AGENTS.md .github/copilot-instructions.md docs/java21-best-practices.md
git commit -m "chore: add Java 21 development instructions"
```

Recommended first commit for a Java 8 to Java 21 migration target project:

```bash
git add AGENTS.md .github/copilot-instructions.md docs/java21-migration-best-practices.md
git commit -m "chore: add agent instructions for Java 21 migration"
```

The migration best-practices file also acts as the migration tracker for baseline results, candidate validation, dependency changes, risk classification, and final acceptance.
