# java-agentic-devkit

This project serves as a Java template for agentic AI development. Simply copy the .devcontainer directory, which contains all the necessary tools to run OpenCode, myOpenCode, Ollama, GitHub Copilot, etc. The entire environment runs inside a Docker container.

## Quick Start

```bash
# Start developing with your project
./scripts/dev.sh /path/to/your/java/project
```

That's it! The container builds automatically and your project is ready for AI-assisted development.
Java 8 is the default runtime. Use `java21` only when a project needs Java 21.

## Documentation

- **[GETTING_STARTED.md](docs/GETTING_STARTED.md)** - Complete guide with all features and configuration
- **[EXAMPLES.md](docs/EXAMPLES.md)** - Practical examples for real scenarios
- **[CODING_STANDARDS.md](CODING_STANDARDS.md)** - Development standards and conventions

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

See [EXAMPLES.md](docs/EXAMPLES.md) for more scenarios.

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
│   ├── GETTING_STARTED.md  # Full documentation
│   └── EXAMPLES.md         # Practical examples
├── opencode/               # AI configuration
└── README.md
```

## Common Tasks

### Work on Multiple Projects
```bash
# Terminal 1
./scripts/dev.sh ~/cip/project1

# Terminal 2 (new window)
./scripts/dev.sh ~/cip/project2
```

### Use with Tomcat
```bash
./scripts/dev.sh /path/to/project
# Inside container
start-tomcat9
```

### Use AI Agents
```bash
./scripts/dev.sh /path/to/project
# Inside container
export ANTHROPIC_API_KEY="your-key"
opencode  # Select agent and task
```

### Switch Java Version
```bash
./scripts/dev.sh /path/to/project         # Java 8 (default)
./scripts/dev.sh /path/to/project java8   # Java 8 explicitly
./scripts/dev.sh /path/to/project java21  # Java 21 when needed
```

## Reuse Across Projects

The same image is used for all your Java projects. No rebuilding needed:

```bash
# First project (builds image)
./scripts/dev.sh ~/cip/27801_arus

# Second project (reuses image - instant start)
./scripts/dev.sh ~/cip/45678_myapp

# 10th project (still reuses image)
./scripts/dev.sh ~/projects/another-app
```

## For More Information

See [GETTING_STARTED.md](docs/GETTING_STARTED.md) for comprehensive documentation and [EXAMPLES.md](docs/EXAMPLES.md) for practical examples.
