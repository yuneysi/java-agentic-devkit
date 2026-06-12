# java-agentic-devkit

`java-agentic-devkit` is a reusable Docker-based development kit for teams working on Java 8 projects, Java 21 projects, and Java 8 to Java 21 migrations. It provides templates for different work modes, including Java 8 legacy maintenance, modern Java development, and structured migration work.

When the container starts, it automatically copies the files agents need into the mounted target project, including `AGENTS.md`, `.github/copilot-instructions.md`, and the template documentation under `docs/`. The generated `AGENTS.md` points agents to the relevant documentation so migration notes, validation evidence, and day-to-day work can be documented in the target project.

The devkit stays outside the target Java project. Developers build or run the devkit from this repository and mount the target project at `/workspace`.

Java 8 is the default runtime. Use Java 21 only when the target project already runs on Java 21 or when validating a Java 8 to Java 21 migration candidate.


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

## Recommended Integration

The recommended way to use this devkit is to integrate it into each target Java project with a project-owned `docker-compose.yml`.

This keeps the development entrypoint close to the application code, makes the selected Java mode explicit, and gives the team one shared command for local work, OpenCode sessions, tests, and migration validation.

See [Docker Compose](#docker-compose) for the recommended setup. The devkit can also be started manually from this repository when a target project does not have Compose integration yet; see [Manual Script Workflow](#manual-script-workflow).

## Docker Compose

Add a `docker-compose.yml` file to the target Java project.

The `Publish DevKit Image` GitHub Actions workflow builds and publishes `ghcr.io/yuneysi/java-agentic-devkit:latest` automatically after changes are pushed to `main`.

The example below starts the target project in `java21-migration` mode. On macOS, keep `platform: linux/amd64` so Docker Desktop runs the published image with the expected Linux AMD64 platform.

```yaml
services:
  devkit:
    image: ghcr.io/yuneysi/java-agentic-devkit:latest
    platform: linux/amd64
    working_dir: /workspace
    environment:
      DEVKIT_PROJECT_DIR: /workspace
      DEVKIT_JAVA_TEMPLATE: java21-migration
      MAVEN_OPTS: -Dmaven.repo.local=/home/vscode/.m2/repository
    volumes:
      - .:/workspace
      - ${HOME}/.m2:/home/vscode/.m2
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

On Windows, when running Compose from PowerShell or Command Prompt, use the `USERPROFILE` environment variable through Compose interpolation instead of `${HOME}`:

```yaml
    volumes:
      - .:/workspace
      - ${USERPROFILE}/.m2:/home/vscode/.m2
      - /var/run/docker.sock:/var/run/docker.sock
```

When running from Git Bash or WSL, `${HOME}/.m2:/home/vscode/.m2` usually works as shown in the main example.

Use one of these values for `DEVKIT_JAVA_TEMPLATE` in the Compose `environment` block:

| Value | Use when |
|-------|----------|
| `java8` | The project runs on Java 8. |
| `java21` | The project already runs on Java 21. |
| `java21-migration` | The project is migrating from Java 8 to Java 21 and needs the Java 8 baseline first. |

### VS Code

If the target project uses VS Code Dev Containers, add `.devcontainer/devcontainer.json`:

```json
{
  "name": "Java Agentic DevKit",
  "dockerComposeFile": "../docker-compose.yml",
  "service": "devkit",
  "workspaceFolder": "/workspace"
}
```

Then run `Dev Containers: Reopen in Container` from VS Code.

### IntelliJ IDEA

For IntelliJ IDEA, keep `docker-compose.yml` in the target project root and start the devkit from IntelliJ's terminal or any host terminal:

```bash
docker compose pull
docker compose run --rm devkit
```

Inside the container, run project commands from `/workspace`, such as `mvn clean verify` or `opencode`.

The `java21-migration` mode starts with Java 8 so the team can capture the Java 8 behavioral baseline before validating the Java 21 candidate.

On first start, the container copies missing template files into the target project and preserves existing files.

## Manual Script Workflow

Use the manual script when the target project does not have a `docker-compose.yml` integration yet.

| Script | Purpose |
|--------|---------|
| `scripts/create-image.sh` | Builds the Docker image. |
| `scripts/container/start-devkit-container.sh` | Builds the image if needed and starts a target project container. |
| `scripts/docker-utils.sh` | Shared Docker availability checks used by the scripts. |

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
| `DEVKIT_JAVA_TEMPLATE` | `java8` | Selects the runtime and template. Supported values: `java8`, `java21`, `java21-migration`. |
| `DEFAULT_JAVA_VERSION` | `java8` | Container fallback when `DEVKIT_JAVA_TEMPLATE` is not set. |

### AI Providers

| Variable | Purpose |
|----------|---------|
| `OPENAI_API_KEY` | Used by the bundled OpenCode OpenAI provider. |
| `GITHUB_TOKEN` | Passed to the GitHub MCP server as `GITHUB_PERSONAL_ACCESS_TOKEN`. |
| `GITHUB_PERSONAL_ACCESS_TOKEN` | Internal MCP environment variable populated from `GITHUB_TOKEN` by `opencode/opencode.json`. |
| `ANTHROPIC_API_KEY` | Optional for Anthropic-compatible tools if enabled by the user. |
| `OLLAMA_API_BASE` | Optional for local Ollama clients. Use `http://host.docker.internal:11434` on Docker Desktop for Windows/macOS. The bundled OpenCode config points to `http://host.docker.internal:11434/v1` by default. |

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
| `MAVEN_OPTS` | `-Dmaven.repo.local=/home/vscode/.m2/repository` | Maven JVM options and local repository location. Mount host `~/.m2` to `/home/vscode/.m2` in Compose. |
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

`opencode/opencode.json` and `opencode/oh-my-openagent.jsonc` are copied into the container as the default OpenCode and oh-my-openagent configuration.

It configures:

- `instructions`: OpenCode reads `{file:/workspace/AGENTS.md}` by default. The container entrypoint rewrites this path to `${DEVKIT_PROJECT_DIR}/AGENTS.md` at startup.
- `plugin`: enables `oh-my-openagent` and `opencode-codebase-index`.
- `lsp`: enables language server support.
- `mcp`: configures local MCP servers for Context7, GitHub, and Playwright.
- `model`: uses `github-copilot/gpt-5.3-codex` as the default OpenCode model.
- `permission`: uses `ask`, so tool actions require confirmation.
- `provider`: configures local Ollama models and OpenAI models.

`opencode/oh-my-openagent.jsonc` sets the main oh-my-openagent agents and orchestration categories to GitHub Copilot GPT models by default. The bundled defaults use `github-copilot/gpt-5.5` for Sisyphus, Hephaestus, Oracle, Prometheus, deep work, and ultrabrain work, with faster Copilot models for quick exploration.

`opencode/tui.json` enables the `oh-my-openagent/tui` plugin for OpenCode's TUI setup.

The GitHub MCP server receives `GITHUB_TOKEN` as `GITHUB_PERSONAL_ACCESS_TOKEN`.

OpenAI models use `OPENAI_API_KEY`.

For GitHub Copilot, authenticate the Copilot provider in OpenCode. When the login flow prints a public URL and device code, open the public URL in your browser and enter the code shown in the terminal.

For Ollama, make sure Ollama is running on the host machine. Use `ollama` as the API key when a client asks for one. The bundled OpenCode config uses:

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

### `templates/java21-migration/`

This template installs three pieces into the Java project being migrated:

1. `AGENTS.md` contains the main instructions for OpenCode, oh-my-opencode, and agents. It defines the migration rules, work order, change limits, and validation discipline.
2. `docs/java21-migration-best-practices.md` is the human guide and also acts as the migration tracker. It documents the Java 8 baseline, Java 21 candidate results, dependency changes, risks, and validation evidence.
3. OpenCode skills support that guide and should be used in this recommended order:

| Order | Skill | Use when |
|-------|-------|----------|
| 1 | `migration-test-planner` | Plan characterization, regression, baseline, and candidate validation tests. |
| 2 | `java8-baseline-capturer` | Capture the Java 8 baseline under `docs/migration-results/java8-baseline/` and update the tracker. |
| 3 | `java21-first-migration-step-planner` | Inspect the project and plan the first small Java 21 migration step. |
| 4 | `java21-small-change-implementer` | Apply one small, focused migration change with validation and tracker updates. |
| 5 | `java21-candidate-validator` | Validate Java 21 results under `docs/migration-results/java21-candidate/` and compare them with the Java 8 baseline. |
| 6 | `migration-auditor` | Review the migration branch, classify risks, and confirm evidence before closing the work. |

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

## Local AI Minimum Setup

This section is the minimum practical setup for teams using OpenCode, oh-my-openagent, GitHub Copilot, and optional Ollama fallback models with Java 8, Java 21, and Java 8 to Java 21 migration projects.

### Required Tools

Install these tools on the host machine:

| Tool | Required for |
|------|--------------|
| Docker Desktop | Running the devkit container on Windows or macOS. |
| GitHub Copilot subscription | Default hosted model access for OpenCode and oh-my-openagent. |
| Ollama Desktop | Optional local fallback models for OpenCode. |
| VS Code Dev Containers or IntelliJ IDEA | Opening or driving the target project workflow. |

Inside the devkit container, OpenCode and oh-my-openagent are already installed. The container also installs OpenCode skills from `opencode/skills/` and configures OpenCode from `opencode/opencode.json` plus `opencode/oh-my-openagent.jsonc`.

### Default Copilot Models

The devkit defaults to GitHub Copilot because it is the common corporate subscription for this team. OpenCode starts with `github-copilot/gpt-5.3-codex`, and oh-my-openagent maps its main orchestrator and deep-work agents to Copilot GPT models.

Before first use, authenticate Copilot from inside the container:

```bash
opencode auth login
```

Select the GitHub Copilot provider, then complete the browser device-code flow.

### Optional Ollama Models

Pull only the models that fit the workstation. Larger models can be better for legacy analysis, but they are slower and need more memory.

| Host RAM | Recommended local models | Best use |
|----------|--------------------------|----------|
| 16 GB | `qwen2.5-coder:7b`, `qwen2.5:7b` | Daily Java 8 or Java 21 edits, Maven help, small JSP/JavaScript changes, focused test fixes. |
| 32 GB | `qwen2.5-coder:7b`, `qwen2.5:7b`, optionally `llama3.1:8b` | Daily implementation work plus broader explanations, reviews, and migration planning on medium projects. |
| 64 GB | `qwen2.5-coder:32b`, `deepseek-r1:32b`, `deepseek-coder:33b`, plus the 7B models | Legacy monolith analysis, Java 8 to Java 21 migration planning, large JPA/Maven/Oracle/JMS work, multi-file reviews. |

Recommended pulls:

```bash
ollama pull qwen2.5-coder:7b
ollama pull qwen2.5:7b
ollama pull llama3.1:8b
ollama pull qwen2.5-coder:32b
ollama pull deepseek-r1:32b
ollama pull deepseek-coder:33b
```

For 16 GB machines, start with only the 7B models. For 32 GB machines, avoid 32B or 33B models unless the machine is mostly idle and has enough free memory. For 64 GB machines, use 32B or 33B models for planning, auditing, and large legacy analysis, then switch to a smaller model for quick edits.

### Model Recommendations By Work Type

| Work type | First choice | Larger workstation choice | Notes |
|-----------|--------------|----------------------------|-------|
| Java 8 maintenance | `qwen2.5-coder:7b` | `qwen2.5-coder:32b` | Good for Java 8-compatible edits, tests, and Maven work. |
| Java 21 maintenance | `qwen2.5-coder:7b` | `qwen2.5-coder:32b` | Use for modern Java syntax, refactoring, and test repair. |
| Java 8 to Java 21 migration | `qwen2.5-coder:7b` | `deepseek-r1:32b` for planning, `qwen2.5-coder:32b` for implementation | Keep migration work small and validate each step. |
| Legacy monolith analysis | `qwen2.5:7b` | `deepseek-r1:32b` | Use the reasoning model for architecture, risk, and dependency analysis. |
| JPA and Hibernate | `qwen2.5-coder:7b` | `qwen2.5-coder:32b` | Ask for characterization tests before changing persistence behavior. |
| Maven and build plugins | `qwen2.5-coder:7b` | `qwen2.5-coder:32b` | Keep dependency changes isolated and documented. |
| Oracle SQL and JDBC | `qwen2.5-coder:7b` | `deepseek-coder:33b` | Validate SQL behavior, transaction boundaries, and generated keys. |
| JSP and servlet code | `qwen2.5-coder:7b` | `qwen2.5-coder:32b` | Preserve tag library, servlet, encoding, and rendering behavior. |
| JavaScript inside legacy apps | `qwen2.5-coder:7b` | `qwen2.5-coder:32b` | Prefer focused browser-visible changes and small validation steps. |
| JMS and messaging | `qwen2.5-coder:7b` | `deepseek-coder:33b` | Validate acknowledgement, retry, redelivery, transaction, and listener behavior. |

### OpenCode Configuration

The bundled OpenCode configuration is copied to the container at startup:

```text
/home/vscode/.config/opencode/opencode.json
```

The devkit configures:

- `instructions`: points OpenCode at the target project's `AGENTS.md`.
- `plugin`: enables `oh-my-openagent` and `opencode-codebase-index`.
- `provider.ollama`: points to `http://host.docker.internal:11434/v1` for optional Ollama Desktop fallback models on Windows and macOS.
- `model`: defaults to `github-copilot/gpt-5.3-codex`.
- `permission`: uses `ask`, so tool actions require confirmation.
- `mcp`: enables Context7, GitHub, and Playwright MCP servers.
- `oh-my-openagent`: maps main agents and deep-work categories to GitHub Copilot GPT models.

Start OpenCode from inside the devkit container:

```bash
opencode
```

If Ollama is running on the host and the model exists, OpenCode can also use it through the configured Ollama provider.

### Agents And Skills

The target project's `AGENTS.md` is the main instruction file for OpenCode, oh-my-openagent, and agentic workflows. For Java 21 migration work, use the `templates/java21-migration/` template and follow this order:

| Order | Agent or skill | Purpose |
|-------|----------------|---------|
| 1 | `AGENTS.md` | Read the project rules, migration constraints, and validation expectations. |
| 2 | `migration-test-planner` | Plan baseline, regression, and candidate validation tests. |
| 3 | `java8-baseline-capturer` | Capture the Java 8 baseline before Java 21 changes. |
| 4 | `java21-first-migration-step-planner` | Plan the first small migration step. |
| 5 | `java21-small-change-implementer` | Implement one small migration change and update the tracker. |
| 6 | `java21-candidate-validator` | Validate the Java 21 candidate and compare it with the baseline. |
| 7 | `migration-auditor` | Review the final migration branch and risk evidence. |

Use specialized characterization skills when the affected area needs extra protection:

| Skill | Use for |
|-------|---------|
| `jpa-characterization-test-writer` | JPA, Hibernate, lazy loading, flush, and transaction behavior. |
| `jms-characterization-test-writer` | JMS acknowledgement, retry, redelivery, listener, and transaction behavior. |
| `soap-contract-test-writer` | SOAP/XML namespaces, payloads, ordering, and contract behavior. |

### Orchestrator Setup

In this devkit, the orchestrator is the top-level OpenCode session running with oh-my-openagent, the target project's `AGENTS.md`, the installed skills, and the configured model provider.

Configure it through these files:

| File | Purpose |
|------|---------|
| `opencode/opencode.json` | Default OpenCode provider, model, MCP, permissions, plugins, and instruction path. |
| `opencode/oh-my-openagent.jsonc` | Default oh-my-openagent agent and category model mapping. |
| `opencode/tui.json` | Enables the oh-my-openagent TUI plugin. |
| `templates/java21-migration/AGENTS.md` | Target-project orchestration rules for migration work. |
| `opencode/skills/*.md` | Reusable task-specific agent instructions. |

Recommended orchestrator defaults:

| Setting | Recommended value | Reason |
|---------|-------------------|--------|
| Default OpenCode model | `github-copilot/gpt-5.3-codex` | Uses the team's corporate Copilot subscription with a Codex model by default. |
| Main oh-my-openagent orchestrator | `github-copilot/gpt-5.5` | Keeps orchestration on Copilot GPT by default. |
| Deep-work agent | `github-copilot/gpt-5.5` | Matches Hephaestus and deep categories to a GPT-native coding model. |
| Quick exploration | `github-copilot/gpt-5.4-mini` | Fast code search and repository scanning. |
| Local fallback on 16 GB or 32 GB | `ollama/qwen2.5-coder:7b` | Optional local fallback for daily code work. |
| Local planning fallback on 64 GB | `ollama/deepseek-r1:32b` | Optional local fallback for migration planning and legacy risk analysis. |
| Local implementation fallback on 64 GB | `ollama/qwen2.5-coder:32b` | Optional local fallback for larger Java implementation tasks. |
| Permission mode | `ask` | Keeps file edits, shell commands, and tool use reviewable. |
| Instructions file | `{file:/workspace/AGENTS.md}` | Keeps orchestration tied to the mounted target project. |

To change the default OpenCode model, edit the `model` field in `opencode/opencode.json` before rebuilding the devkit image, or edit `/home/vscode/.config/opencode/opencode.json` inside a running container for a local experiment. To change oh-my-openagent orchestration models, edit `opencode/oh-my-openagent.jsonc` before rebuilding, or edit `/home/vscode/.config/opencode/oh-my-openagent.jsonc` inside a running container.
