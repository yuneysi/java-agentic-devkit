# java-agentic-devkit

This project is a reusable Java development kit and template for agentic AI development.

Developers use it to work on Java 8 projects, Java 21 projects, and Java 8 to Java 21 migrations from the same Docker-based toolchain. For migrations, developers copy the template instruction files into their target Java project so OpenCode, oh-my-opencode, and GitHub Copilot follow the same rules.

## Quick Start

There are two supported ways to use this devkit with another Java project.

### Option 1: Build the DevKit Image, Then Start the Target Project Compose File

This is the preferred workflow when the target project owns its own `compose.yml`.

First build the shared devkit image from this repository:

```bash
cd ~/github/java-agentic-devkit
./scripts/create-image.sh
```

Then start Docker Compose from the target project:

```bash
cd /path/to/your/java/project
docker compose -f compose.yml up -d
```

The target project's Compose service should use the `java-agentic-devkit:latest` image, mount the project at `/workspace`, and set `DEVKIT_PROJECT_DIR=/workspace`. A typical service also mounts `/var/run/docker.sock`, exposes the Java, debug, ActiveMQ, and web console ports, and starts with `command: /bin/bash`; see [docs/README.md](docs/README.md) for a complete example.

### Option 2: Start a Project Manually with the DevKit Scripts

```bash
# Start from the devkit directory
cd ~/github/java-agentic-devkit

# Build the image and start developing with your project
./scripts/create-image.sh
./scripts/container/start-devkit-container.sh /path/to/your/java/project
```

After the container starts, the project is ready for AI-assisted development.
Java 8 is the default runtime. Use `java21` only when a project needs Java 21.

On first start, the devkit mounts the target project at `/workspace` and creates missing template files from the selected Java template. Existing project files are preserved. This includes `AGENTS.md`, `.github/copilot-instructions.md`, and template docs. This works on macOS and Windows WSL because generation runs inside the Linux container.

## Documentation

- **[docs/README.md](docs/README.md)** - General devkit usage, templates, and script reference
- **[JAVA8_TO_JAVA21_MIGRATION.md](docs/JAVA8_TO_JAVA21_MIGRATION.md)** - Java 8 to Java 21 migration workflow
- **[templates/README.md](templates/README.md)** - Template inventory and generated files
- **[CODING_STANDARDS.md](CODING_STANDARDS.md)** - Development standards and conventions

## Templates for Target Projects

Templates are files that the devkit applies to a target Java project so agents and Copilot use the right project rules.

| Template | Use when | Copies |
|----------|----------|--------|
| `templates/AGENTS.md` | All target projects. | `AGENTS.md` |
| `templates/java8/` | The target project stays on Java 8. | `.github/copilot-instructions.md`, `docs/java8-best-practices.md` |
| `templates/java21/` | The target project already runs on Java 21. | `.github/copilot-instructions.md`, `docs/java21-best-practices.md` |
| `templates/java21-migration/` | The target project is migrating from Java 8 to Java 21. | `.github/copilot-instructions.md`, `docs/java21-migration.md` |

Source files in this repository:

```text
templates/
├── AGENTS.md
├── java8/
│   ├── .github/copilot-instructions.md
│   └── docs/java8-best-practices.md
├── java21/
│   ├── .github/copilot-instructions.md
│   └── docs/java21-best-practices.md
└── java21-migration/
    ├── .github/copilot-instructions.md
    └── docs/java21-migration.md
```

Templates are applied automatically when the devkit container starts. Select the template with `DEVKIT_JAVA_VERSION` in Compose or with the Java version argument in the manual script workflow. Existing target-project files are preserved.

`AGENTS.md` must exist at the root of the target project. The devkit creates it from `templates/AGENTS.md` when it is missing. It is the authoritative instruction file for OpenCode / oh-my-opencode agents.

## Example: Using with Your Project

```bash
# Navigate to devkit
cd ~/github/java-agentic-devkit

# Start with your project using the default Java 8 runtime
./scripts/container/start-devkit-container.sh ~/cip/27801_arus

# Inside container - build and develop
mvn clean install
opencode  # Start AI agents
mvn test
```

See [docs/README.md](docs/README.md) for Java 8, Java 21, Mac, Windows, template, and script examples.

## What's Included

- ✅ **Java 8 & Java 21** - Multiple versions, easy switching
- ✅ **Maven** - Build automation
- ✅ **Tomcat 9 & 11** - Application servers
- ✅ **ActiveMQ** - Message broker
- ✅ **IBM MQ** - Enterprise messaging
- ✅ **Node.js + Bun** - JavaScript runtime
- ✅ **Python 3** - Data science tools
- ✅ **SonarScanner** - Code quality analysis
- ✅ **OpenCode + oh-my-opencode** - AI agent framework
- ✅ **Multiple AI Backends** - Claude, OpenAI, Copilot, Ollama

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/container/start-devkit-container.sh` | Recommended entry point. Builds the image if needed and starts the project container. |
| `scripts/container/devkit.sh` | Full control version with detailed output. |
| `scripts/container/run-image.sh` | Runs an existing image manually. |
| `scripts/create-image.sh` | Builds the image only. |

## AI Integration

Configure your preferred AI service:

```bash
# Claude (Anthropic)
export ANTHROPIC_API_KEY="sk-ant-..."

# OpenAI
export OPENAI_API_KEY="sk-..."

# GitHub Copilot
export GITHUB_TOKEN="ghp_..."

# Ollama (local models - free!)
export OLLAMA_API_BASE="http://host.docker.internal:11434"
```

## Directory Structure

```
java-agentic-devkit/
├── .devcontainer/
│   ├── Dockerfile
│   └── ...
├── scripts/
│   ├── container/
│   │   ├── start-devkit-container.sh          # Main script (USE THIS)
│   │   ├── devkit.sh
│   │   └── run-image.sh
│   └── create-image.sh
├── docs/
│   ├── README.md
│   └── JAVA8_TO_JAVA21_MIGRATION.md
├── opencode/               # AI configuration
├── templates/              # Files applied to target projects
│   ├── README.md
│   ├── AGENTS.md
│   ├── java8/
│   │   ├── .github/copilot-instructions.md
│   │   └── docs/java8-best-practices.md
│   ├── java21/
│   │   ├── .github/copilot-instructions.md
│   │   └── docs/java21-best-practices.md
│   └── java21-migration/
│       ├── .github/copilot-instructions.md
│       └── docs/java21-migration.md
└── README.md
```

## Common Tasks

### Work on Multiple Projects
```bash
# Terminal 1
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh ~/cip/project1

# Terminal 2 (new window)
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh ~/cip/project2
```

### Use with Tomcat
```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/project
# Inside container
start-tomcat9
```

### Use AI Agents
```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/project
# Inside container
export ANTHROPIC_API_KEY="your-key"
opencode  # Select agent and task
```

### Switch Java Version
```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/project         # Java 8 (default)
./scripts/container/start-devkit-container.sh /path/to/project java8   # Java 8 explicitly
./scripts/container/start-devkit-container.sh /path/to/project java21  # Java 21 when needed
```

## Reuse Across Projects

The same image is used for all your Java projects. No rebuilding needed:

```bash
# First project (builds image)
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh ~/cip/27801_arus

# Second project (reuses image - instant start)
./scripts/container/start-devkit-container.sh ~/cip/45678_myapp

# 10th project (still reuses image)
./scripts/container/start-devkit-container.sh ~/projects/another-app
```

## For More Information

See [docs/README.md](docs/README.md) for general devkit usage and [JAVA8_TO_JAVA21_MIGRATION.md](docs/JAVA8_TO_JAVA21_MIGRATION.md) for the migration workflow.
