# java-agentic-devkit

This project is a reusable Java development kit and template for agentic AI development.

Developers use it to work on Java 8 projects, Java 21 projects, and Java 8 to Java 21 migrations from the same Docker-based toolchain. For migrations, developers copy the template instruction files into their target Java project so OpenCode, oh-my-opencode, and GitHub Copilot follow the same rules.

## Quick Start

```bash
# Start from the devkit directory
cd /path/to/java-agentic-devkit

# Start developing with your project
./scripts/dev.sh /path/to/your/java/project
```

That's it! The container builds automatically and your project is ready for AI-assisted development.
Java 8 is the default runtime. Use `java21` only when a project needs Java 21.

## Documentation

- **[docs/README.md](docs/README.md)** - General devkit usage, templates, and script reference
- **[JAVA8_TO_JAVA21_MIGRATION.md](docs/JAVA8_TO_JAVA21_MIGRATION.md)** - Java 8 to Java 21 migration workflow
- **[templates/README.md](templates/README.md)** - Template inventory and copy commands
- **[CODING_STANDARDS.md](CODING_STANDARDS.md)** - Development standards and conventions

## Templates for Target Projects

Templates are files that developers copy into a target Java project so agents and Copilot use the right project rules.

| Template | Use when | Copies |
|----------|----------|--------|
| `templates/java8/` | The target project stays on Java 8. | `AGENTS.md`, `.github/copilot-instructions.md`, `docs/java8-best-practices.md` |
| `templates/java21/` | The target project already runs on Java 21. | `AGENTS.md`, `.github/copilot-instructions.md`, `docs/java21-best-practices.md` |
| `templates/java21-migration/` | The target project is migrating from Java 8 to Java 21. | `AGENTS.md`, `.github/copilot-instructions.md`, `docs/java21-migration.md`, migration helper scripts |

Source files in this repository:

```text
templates/
├── java8/
│   ├── AGENTS.md
│   ├── .github/copilot-instructions.md
│   └── docs/java8-best-practices.md
├── java21/
│   ├── AGENTS.md
│   ├── .github/copilot-instructions.md
│   └── docs/java21-best-practices.md
└── java21-migration/
    ├── AGENTS.md
    ├── .github/copilot-instructions.md
    ├── docs/java21-migration.md
    └── scripts/*.sh
```

### Java 8 Projects

Copy from the target project root:

```bash
mkdir -p .github docs
cp /path/to/java-agentic-devkit/templates/java8/AGENTS.md AGENTS.md
cp /path/to/java-agentic-devkit/templates/java8/.github/copilot-instructions.md .github/copilot-instructions.md
cp /path/to/java-agentic-devkit/templates/java8/docs/java8-best-practices.md docs/java8-best-practices.md
```

### Java 21 Projects

Copy from the target project root:

```bash
mkdir -p .github docs
cp /path/to/java-agentic-devkit/templates/java21/AGENTS.md AGENTS.md
cp /path/to/java-agentic-devkit/templates/java21/.github/copilot-instructions.md .github/copilot-instructions.md
cp /path/to/java-agentic-devkit/templates/java21/docs/java21-best-practices.md docs/java21-best-practices.md
```

### Java 8 to Java 21 Migrations

Copy from the target project root:

```bash
mkdir -p .github docs scripts
cp /path/to/java-agentic-devkit/templates/java21-migration/AGENTS.md AGENTS.md
cp /path/to/java-agentic-devkit/templates/java21-migration/.github/copilot-instructions.md .github/copilot-instructions.md
cp /path/to/java-agentic-devkit/templates/java21-migration/docs/java21-migration.md docs/java21-migration.md
cp /path/to/java-agentic-devkit/templates/java21-migration/scripts/*.sh scripts/
chmod +x scripts/run-java8-baseline.sh scripts/run-java21-candidate.sh scripts/compare-behavior.sh
```

`AGENTS.md` must be copied to the root of the target project. It is the authoritative instruction file for OpenCode / oh-my-opencode agents.

## Example: Using with Your Project

```bash
# Navigate to devkit
cd /path/to/java-agentic-devkit

# Start with your project using the default Java 8 runtime
./scripts/dev.sh ~/cip/27801_arus

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
| `dev.sh` | ⭐ Recommended - Build & run everything |
| `devkit.sh` | Full control version with detailed output |
| `create-image.sh` | Build only (manual mode) |
| `run-image.sh` | Run only (manual mode) |

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
│   ├── dev.sh              # Main script (USE THIS)
│   ├── devkit.sh
│   ├── create-image.sh
│   └── run-image.sh
├── docs/
│   ├── README.md
│   └── JAVA8_TO_JAVA21_MIGRATION.md
├── opencode/               # AI configuration
├── templates/              # Files copied into target projects
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
│       ├── docs/java21-migration.md
│       └── scripts/*.sh
└── README.md
```

## Common Tasks

### Work on Multiple Projects
```bash
# Terminal 1
cd /path/to/java-agentic-devkit
./scripts/dev.sh ~/cip/project1

# Terminal 2 (new window)
cd /path/to/java-agentic-devkit
./scripts/dev.sh ~/cip/project2
```

### Use with Tomcat
```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh /path/to/project
# Inside container
start-tomcat9
```

### Use AI Agents
```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh /path/to/project
# Inside container
export ANTHROPIC_API_KEY="your-key"
opencode  # Select agent and task
```

### Switch Java Version
```bash
cd /path/to/java-agentic-devkit
./scripts/dev.sh /path/to/project         # Java 8 (default)
./scripts/dev.sh /path/to/project java8   # Java 8 explicitly
./scripts/dev.sh /path/to/project java21  # Java 21 when needed
```

## Reuse Across Projects

The same image is used for all your Java projects. No rebuilding needed:

```bash
# First project (builds image)
cd /path/to/java-agentic-devkit
./scripts/dev.sh ~/cip/27801_arus

# Second project (reuses image - instant start)
./scripts/dev.sh ~/cip/45678_myapp

# 10th project (still reuses image)
./scripts/dev.sh ~/projects/another-app
```

## For More Information

See [docs/README.md](docs/README.md) for general devkit usage and [JAVA8_TO_JAVA21_MIGRATION.md](docs/JAVA8_TO_JAVA21_MIGRATION.md) for the migration workflow.
