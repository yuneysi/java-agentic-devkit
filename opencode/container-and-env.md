# Container And Environment Guide

This page documents what the devkit container includes and which environment variables are useful when running it.

## Container Contents

The Docker image is built from `.devcontainer/Dockerfile`. It includes:

- Java 8 and Java 21
- Maven
- Tomcat 9 and Tomcat 11
- ActiveMQ Classic
- IBM MQ tooling path placeholders
- Node.js, npm, Bun, TypeScript, and TypeScript language server
- Python 3
- `jq`, `ripgrep`, `ag`, `fd`, `xmlstarlet`, `xmllint`, `xsltproc`, `fzf`, `tmux`, and common shell tools
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
| `DEVKIT_JAVA_TEMPLATE` | `java8` | Selects the runtime and template. Supported values: `java8`, `java21`, `java21-ak4`, `java21-migration`. |
| `DEFAULT_JAVA_TEMPLATE` | `java8` | Container fallback when `DEVKIT_JAVA_TEMPLATE` is not set. |

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
