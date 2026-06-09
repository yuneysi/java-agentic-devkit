# Java Agentic DevKit - Getting Started Guide

**For Humans** 🤖 A complete guide to building and running the java-agentic-devkit container.

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [What is This Container?](#what-is-this-container)
3. [Scripts Overview](#scripts-overview)
4. [Building the Docker Image](#building-the-docker-image)
5. [Running the Container](#running-the-container)
6. [Working with Your Project](#working-with-your-project)
7. [Using Agents](#using-agents)
8. [Oh-My-OpenCode Agent Framework](#oh-my-opencode-agent-framework)
9. [Connecting AI Services](#connecting-ai-services)
10. [Troubleshooting](#troubleshooting)

---

## Quick Start

### The Fastest Way to Get Started

```bash
# One command to build image + start container with your project
./scripts/dev.sh /path/to/your/java/project
```

That's it! The script will:
1. Build the image (only once)
2. Mount your project
3. Start an interactive container
4. Show you all available commands

### Real Example: Using devkit with a Specific Project

Let's say you have a Java project at `~/projects/project1`:

```bash
# From your devkit directory
cd /path/to/java-agentic-devkit

# Option 1: Use absolute path to your project
./scripts/dev.sh ~/projects/project1

# Option 2: Use absolute path with Java 8
./scripts/dev.sh ~/projects/project1 java8

# Option 3: Navigate to your project first, then use relative path
cd ~/cip/27801_arus
/path/to/java-agentic-devkit/scripts/dev.sh

# Option 4: Create symlink for quick access (one-time)
ln -s /path/to/java-agentic-devkit/scripts/dev.sh /usr/local/bin/devkit
# Then use from anywhere
devkit ~/cip/27801_arus
```

### What Happens Inside the Container

When you run the command, inside the container you'll have:

```bash
# Your project mounted at /workspaces/project
cd /workspaces/project

# See your project files
ls -la
# Output: pom.xml, src/, target/, etc.

# Build your project
mvn clean install

# Start AI agents
opencode
```

### Even Faster with Current Directory

```bash
cd ~/cip/27801_arus
/path/to/java-agentic-devkit/scripts/dev.sh
```

Now you're inside the container, ready to work!

---

## What is This Container?

The **java-agentic-devkit** is a Docker container pre-configured with:

- ✅ **Java 8 & Java 21** - Multiple Java versions for backward compatibility
- ✅ **Maven** - Build automation
- ✅ **Tomcat 9 & 11** - Application servers
- ✅ **ActiveMQ** - Message broker
- ✅ **IBM MQ** - Enterprise messaging
- ✅ **Node.js + Bun** - JavaScript runtime
- ✅ **Python 3** - Data science tools
- ✅ **SonarScanner** - Code quality analysis
- ✅ **OpenCode + oh-my-opencode** - AI agent framework

### Container Name
**`java-agentic-devkit:latest`**

### Reusability
This container is **designed for multiple projects** with the same Java version requirements. You can:
- Use it across different Java 8 or Java 21 projects
- Mount different project directories without rebuilding
- Scale to multiple team members using the same base image

---

## Scripts Overview

We provide multiple scripts for different use cases:

### 1. **`dev.sh`** - Fastest Way to Start (Recommended)

One-command solution that builds and runs everything:

```bash
./scripts/dev.sh [project-path] [java-version]
```

**Examples:**
```bash
# Use current directory
./scripts/dev.sh

# Mount specific project
./scripts/dev.sh /path/to/my-project

# Specify Java version (java8 or java21)
./scripts/dev.sh /path/to/my-project java8
```

### 2. **`devkit.sh`** - Full Control Version

Same as `dev.sh` but with more detailed output:

```bash
./scripts/devkit.sh [project-path] [java-version]
```

### 3. **`create-image.sh`** - Build Only

If you only want to build the image without starting container:

```bash
./scripts/create-image.sh
# Or with custom name/tag
./scripts/create-image.sh my-image my-tag
```

### 4. **`run-image.sh`** - Run Only

If you only want to run an existing image:

```bash
./scripts/run-image.sh java-agentic-devkit:latest
```

---

## Building the Docker Image

### Prerequisites
- Docker Desktop installed and running
- Bash shell access
- ~10-15 minutes for first build (subsequent runs use cache)

### Automatic Build

The `dev.sh` script automatically builds the image if it doesn't exist:

```bash
./scripts/dev.sh
# Image builds automatically on first run
```

### Manual Build

To explicitly build the image:

```bash
./scripts/create-image.sh
```

This will:
1. Find the Dockerfile in `.devcontainer/Dockerfile`
2. Build the image with all dependencies
3. Tag it as `java-agentic-devkit:latest`
4. Display useful commands when complete

### Verify the Build

```bash
# List all images
docker images | grep java-agentic-devkit

# Expected output:
# java-agentic-devkit    latest    7d3cdc955051    2 hours ago   2.15GB
```

---

## Running the Container

### Recommended: Use dev.sh Script

The simplest way to run the container:

```bash
# Basic usage
./scripts/dev.sh

# Mount a specific project
./scripts/dev.sh /path/to/your/project

# Select Java version
./scripts/dev.sh . java8
```

The script automatically:
- ✅ Builds the image if needed
- ✅ Mounts your project to `/workspaces/project`
- ✅ Configures the Java version
- ✅ Shows welcome message with available commands
- ✅ Starts interactive bash shell

### What You See Inside

When you start the container, you'll see:

```
╔════════════════════════════════════════════════════════════╗
║  Java Agentic DevKit - Ready to Work                       ║
╚════════════════════════════════════════════════════════════╝

📁 Project: /workspaces/project
☕ Java: 21.0.1

Available Commands:
  use-java8         - Switch to Java 8
  use-java21        - Switch to Java 21
  mvn clean install - Build with Maven
  opencode          - Start AI agent framework
  start-tomcat9     - Start Tomcat 9
  start-activemq    - Start ActiveMQ

AI Providers:
  Claude           - export ANTHROPIC_API_KEY=...
  OpenAI           - export OPENAI_API_KEY=...
  GitHub Copilot   - export GITHUB_TOKEN=...
  Ollama           - http://host.docker.internal:11434
```

### Manual Docker Commands

If you prefer manual commands:

```bash
# Basic container
docker run -it --rm \
  -v /path/to/your/project:/workspaces/project \
  java-agentic-devkit:latest \
  /bin/bash

# With port mapping (for Tomcat)
docker run -it --rm \
  -v /path/to/your/project:/workspaces/project \
  -p 8080:8080 \
  -p 8161:8161 \
  java-agentic-devkit:latest \
  /bin/bash

# With AI environment variables
docker run -it --rm \
  -v /path/to/your/project:/workspaces/project \
  -e ANTHROPIC_API_KEY="sk-ant-your-key" \
  -e OPENAI_API_KEY="sk-your-key" \
  java-agentic-devkit:latest \
  /bin/bash
```

---

## Working with Your Project

### Using devkit with Your Java Projects

Your Java projects stay on your host machine. The devkit container simply mounts them for development.

#### Project Location Examples

**Your actual projects (on host machine):**
```
~/projects/
├── project1/             ← Project 1
├── project2/             ← Project 2
├── project3/             ← Project 3
└── spring-boot-app/      ← Project 4
```

**Using devkit with each project:**

```bash
# Project 1: Start devkit with project1
./scripts/dev.sh ~/projects/project1

# Project 2: Start devkit with project2  
./scripts/dev.sh ~/projects/project2

# Project 3: Start devkit with project3
./scripts/dev.sh ~/projects/project3

# Project 4: Start devkit with spring-boot-app
./scripts/dev.sh ~/projects/spring-boot-app
```

#### Inside the Container

Once inside, the project is always at `/workspaces/project`:

```bash
# Inside container (all projects use same path)
cd /workspaces/project
pwd
# Output: /workspaces/project

# Regardless of where the actual project is on host
# You always access it at the same location inside container
```

#### Real Workflow with project1

```bash
# Step 1: Navigate to devkit
cd /path/to/java-agentic-devkit

# Step 2: Start with your project
./scripts/dev.sh ~/projects/project1

# Step 3: Inside container, you're ready to work
# ✅ Java is configured
# ✅ Maven is ready
# ✅ Your project is mounted
# ✅ AI agents are available

# Step 4: Build and develop
cd /workspaces/project
mvn clean install
opencode  # Start AI agent
mvn test

# Step 5: Exit when done
exit
```

### Inside the Container

Once inside the container, navigate to your mounted project:

```bash
# Navigate to your project
cd /workspaces/project

# Check Java version
java -version

# Switch to Java 8 (if needed)
use-java8

# Switch back to Java 21
use-java21

# Build with Maven
mvn clean install

# Run tests
mvn test

# Check code quality
sonar-scanner -Dsonar.projectKey=my-project
```

### Available Shortcuts

| Command | Purpose |
|---------|---------|
| `use-java8` | Switch to Java 8 runtime |
| `use-java21` | Switch to Java 21 runtime |
| `start-tomcat9` | Start Apache Tomcat 9 |
| `stop-tomcat9` | Stop Apache Tomcat 9 |
| `start-tomcat11` | Start Apache Tomcat 11 |
| `stop-tomcat11` | Stop Apache Tomcat 11 |
| `start-activemq` | Start ActiveMQ broker |
| `jdtls` | Start Java Language Server |

### Port Mapping

To expose services, use port mapping:

```bash
docker run -it --rm \
  -v $(pwd):/workspaces/app \
  -p 8080:8080 \
  -p 8161:8161 \
  java-agentic-devkit:latest \
  /bin/bash
```

Then inside the container, start Tomcat:
```bash
start-tomcat9
# Application available at http://localhost:8080
```

---

## Using Agents

### What is an Agent?

Agents are AI-powered assistants that help with development tasks like:
- Code generation
- Testing
- Documentation
- Refactoring
- Debugging

### Starting the Agent Framework

Inside the container, start the agent interactive mode:

```bash
opencode
```

This launches the **oh-my-opencode** framework where you can:
1. Select your AI provider (Claude, OpenAI, Copilot)
2. Choose an agent role
3. Describe your task in natural language
4. Let the agent execute code changes

### Agent Roles

The framework supports multiple roles:
- **Architect** - System design and architecture decisions
- **Developer** - Implementation and coding
- **Tester** - Test generation and quality assurance
- **DevOps** - Container and infrastructure tasks
- **Security** - Security analysis and hardening
- **Analyst** - Code analysis and optimization

### Interactive Agent Session

```bash
# Start opencode
opencode

# Example interaction:
# > Select agent: Developer
# > Task: Create a Spring Boot REST controller for user management
# > The agent generates code and applies changes automatically
```

---

## Oh-My-OpenCode Agent Framework

### What Does It Do?

**oh-my-opencode** is an agent orchestration framework that:

✅ **Provides multiple AI backends**
- Claude (Anthropic)
- OpenAI (GPT-4, GPT-3.5)
- GitHub Copilot
- Ollama (local models)
- Google Gemini

✅ **Agent Capabilities**
- Code generation with TDD workflow
- Codebase analysis and exploration
- Multi-file editing with traceability
- Test generation and execution
- Documentation creation
- Refactoring assistance

✅ **Project Context Awareness**
- Scans project structure automatically
- Understands dependencies
- Maintains code consistency
- Generates files with proper formatting

### Features

```
┌─────────────────────────────────────────┐
│    oh-my-opencode Framework             │
├─────────────────────────────────────────┤
│ Agent Selection ────────────────────────→ Choose role
│ Task Description ──────────────────────→ Natural language
│ Context Analysis ──────────────────────→ Auto-scan project
│ AI Generation ─────────────────────────→ Multiple providers
│ Code Review ───────────────────────────→ Quality checks
│ Apply Changes ─────────────────────────→ With traceability
└─────────────────────────────────────────┘
```

### Configuration Files

Inside the container, configuration is stored in:
```
/home/vscode/.config/opencode/
├── opencode.json          # Main configuration
├── tui.json              # Terminal UI settings
└── instructions.md       # Custom instructions
```

### Example Usage

```bash
# Start the interactive interface
opencode

# Or use command-line mode
opencode --agent architect --task "Redesign the API layer"

# View available agents
opencode --list-agents

# Check configuration
opencode --show-config
```

---

## Connecting AI Services

### GitHub Copilot Integration

1. **Inside the container:**
   ```bash
   # Configure GitHub token
   export GITHUB_TOKEN="ghp_your_token_here"
   
   # Start opencode
   opencode
   
   # Select: GitHub Copilot as AI provider
   ```

2. **In VS Code (on host machine):**
   - Install GitHub Copilot extension
   - Authenticate with your GitHub account
   - Mount your project and work as usual

### Claude (Anthropic) Integration

1. **Get your API key:**
   - Visit https://console.anthropic.com
   - Create an API key

2. **Inside the container:**
   ```bash
   # Set environment variable
   export ANTHROPIC_API_KEY="sk-ant-your-key-here"
   
   # Start opencode
   opencode
   
   # Select: Claude as AI provider
   ```

### OpenAI Integration

1. **Get your API key:**
   - Visit https://platform.openai.com/api-keys
   - Create new secret key

2. **Inside the container:**
   ```bash
   # Set environment variable
   export OPENAI_API_KEY="sk-your-key-here"
   
   # Start opencode
   opencode
   
   # Select: OpenAI as AI provider
   ```

### Ollama Local Models

**Ollama** allows you to run AI models locally on your machine.

1. **On your host machine (outside container):**
   ```bash
   # Install Ollama from https://ollama.ai
   # Pull a model
   ollama pull llama2
   
   # Start Ollama server (runs on localhost:11434 by default)
   ollama serve
   ```

2. **Inside the container:**
   ```bash
   # Connect to Ollama on host machine
   export OLLAMA_API_BASE="http://host.docker.internal:11434"
   
   # Configure which model to use
   export OLLAMA_MODEL="llama2"
   
   # Start opencode
   opencode
   
   # Select: Ollama as AI provider
   ```

3. **Example Ollama setup:**
   ```bash
   # Available models
   ollama pull llama2          # General purpose
   ollama pull mistral         # Code generation
   ollama pull neural-chat     # Conversational
   ollama pull codeup          # Code specialization
   
   # List installed models
   ollama list
   ```

### Multi-AI Configuration

Configure multiple providers at once:

```bash
# In container ~/.config/opencode/opencode.json
{
  "ai_providers": {
    "primary": "claude",
    "fallback": "ollama",
    "experimental": "copilot"
  },
  "claude": {
    "api_key": "${ANTHROPIC_API_KEY}",
    "model": "claude-opus"
  },
  "ollama": {
    "base_url": "http://host.docker.internal:11434",
    "model": "llama2"
  },
  "copilot": {
    "enabled": true
  }
}
```

---

## Complete Workflow Example

### Scenario: Add a new feature to your Spring Boot project

```bash
# 1. Start the devkit (builds image automatically if needed)
cd /path/to/my-spring-boot-project
/path/to/devkit/scripts/dev.sh

# 2. Inside the container: Set up AI provider
export ANTHROPIC_API_KEY="sk-ant-your-key-here"

# 3. Build the project
mvn clean install

# 4. Start the AI agent framework
opencode

# 5. Agent interaction:
# > Select agent: Developer
# > AI Provider: Claude  
# > Task: "Create a REST API endpoint for user registration with validation"
# > The agent generates code, tests, and documentation

# 6. Review generated code
git diff

# 7. Run tests
mvn test

# 8. Start your application
start-tomcat9

# 9. Test the new endpoint
curl http://localhost:8080/api/users/register

# 10. When done, exit container
exit
```

---

## Frequently Asked Questions (FAQ)

### Q: I have multiple Java projects. Do I need to rebuild the image for each one?

**A: No!** The image is built once and reused for all projects:

```bash
# First project (builds image automatically)
./scripts/dev.sh ~/cip/27801_arus

# Second project (reuses same image - super fast)
./scripts/dev.sh ~/cip/45678_myapp

# Same image for 10+ projects with no rebuilding
```

### Q: Can I use the devkit from anywhere, or must I be in the devkit directory?

**A: Both ways work!**

```bash
# Method 1: From anywhere with absolute path
/path/to/java-agentic-devkit/scripts/dev.sh ~/cip/27801_arus

# Method 2: Create symlink for convenience (one-time setup)
ln -s /path/to/java-agentic-devkit/scripts/dev.sh /usr/local/bin/devkit

# Then use from anywhere:
devkit ~/cip/27801_arus

# Method 3: From devkit directory
cd /path/to/java-agentic-devkit
./scripts/dev.sh ~/cip/27801_arus
```

### Q: How is my code kept safe?

**A: Your code stays on your host machine.** The container only mounts and reads it:

```
Host Machine (your actual files)          Container
~/cip/27801_arus/                    ─→  /workspaces/project/
├── pom.xml                                 ├── pom.xml
├── src/                                    ├── src/
└── target/                                 └── target/
```

Changes you make in `/workspaces/project` automatically update on your host.

### Q: Can I switch between different Java versions easily?

**A: Yes, instantly!**

```bash
# Start with Java 21 (default)
./scripts/dev.sh ~/cip/27801_arus

# Inside container, check version
java -version

# Switch to Java 8
use-java8

# Check again
java -version

# Switch back to Java 21
use-java21
```

### Q: How do I use different Java versions for different projects?

**A: Specify when starting:**

```bash
# Project that needs Java 8
./scripts/dev.sh ~/cip/old_legacy_app java8

# Project that needs Java 21 (default)
./scripts/dev.sh ~/cip/modern_app java21

# Or omit java version (defaults to java21)
./scripts/dev.sh ~/cip/modern_app
```

### Q: Can I have multiple containers running at the same time?

**A: Yes!** Open multiple terminals:

```bash
# Terminal 1: Project 1
./scripts/dev.sh ~/cip/27801_arus

# Terminal 2: Project 2 (in a new terminal)
./scripts/dev.sh ~/cip/45678_myapp

# Both containers run simultaneously
# Each has its own environment
```

### Q: What if I need to run Tomcat or ActiveMQ?

**A: They're pre-installed and ready to use:**

```bash
# Inside container
start-tomcat9
start-activemq

# To expose ports to host machine, start with port mapping:
# (Close current container first, then:)
docker run -it --rm \
  -v ~/cip/27801_arus:/workspaces/project \
  -p 8080:8080 \
  -p 8161:8161 \
  java-agentic-devkit:latest \
  /bin/bash
```

### Q: How do I connect to Claude or other AI services?

**A: Set environment variable before running:**

```bash
# Export your API key before starting container
export ANTHROPIC_API_KEY="sk-ant-your-actual-key-here"

# Start devkit
./scripts/dev.sh ~/cip/27801_arus

# Inside container, use AI agents
opencode
# It will automatically use your Claude API key
```

### Q: Can I persist my Maven cache to speed up builds?

**A: Yes! Use named volumes:**

```bash
# Create volume once
docker volume create devkit-m2-cache

# Then in devkit.sh or manual docker command, add:
# -v devkit-m2-cache:/home/vscode/.m2
```

---

## Troubleshooting

## Troubleshooting

### Dev.sh Script Not Working

```bash
# Make sure script is executable
chmod +x ./scripts/dev.sh

# Run with bash explicitly
bash ./scripts/dev.sh /path/to/project

# Check for errors
bash -x ./scripts/dev.sh /path/to/project
```

### Image Build Fails

```bash
# Clear Docker cache and rebuild
docker system prune
./scripts/dev.sh  # Rebuilds image

# Or rebuild explicitly
./scripts/create-image.sh

# Check Dockerfile syntax
docker run --rm -i hadolint/hadolint < .devcontainer/Dockerfile
```

### Container Won't Start

```bash
# Check Docker daemon
docker ps

# Pull base image
docker pull ubuntu:24.04

# Verify image exists
docker images | grep java-agentic-devkit

# Try manual run with verbose output
docker run -it --rm -v $(pwd):/workspaces/app java-agentic-devkit:latest /bin/bash
```

### Permission Errors

```bash
# Fix volume mount permissions
chmod -R 755 /path/to/your/project

# Or run with vscode user
docker run -it --rm \
  -v /path/to/project:/workspaces/project \
  --user vscode \
  java-agentic-devkit:latest \
  /bin/bash
```

### Java Version Issues

```bash
# Inside container: check current version
java -version

# Switch Java version
use-java8
use-java21

# Verify switch worked
java -version
```

### Agent Framework Not Starting

```bash
# Check oh-my-opencode installation
which opencode

# View logs
cat /home/vscode/.config/opencode/logs/*

# Reinstall if needed
bunx oh-my-openagent install --force
```

### Port Already in Use

```bash
# Use different port
docker run -it --rm \
  -v $(pwd):/workspaces/app \
  -p 8888:8080 \
  java-agentic-devkit:latest \
  /bin/bash

# Inside container, app available at http://localhost:8888
```

---

## Performance Tips

## Performance Tips

### Memory Management

```bash
# Use dev.sh with manual memory settings
# First, modify the docker run command in devkit.sh, or use manual command:

docker run -it --rm \
  -v $(pwd):/workspaces/project \
  -m 8g \
  java-agentic-devkit:latest \
  /bin/bash

# Inside container: Configure Maven heap
export MAVEN_OPTS="-Xmx6G"
mvn clean install
```

### Build Caching

```bash
# Docker automatically caches layers, so subsequent builds are fast
# First run: ~15-30 minutes (full build)
./scripts/dev.sh

# Second run: ~10 seconds (uses cache)
./scripts/dev.sh /different/project
```

### Volume Performance on macOS

Use named volumes for Maven cache to improve performance:

```bash
# Create named volume
docker volume create devkit-m2-cache

# Manual docker command with cache volume
docker run -it --rm \
  -v $(pwd):/workspaces/project \
  -v devkit-m2-cache:/home/vscode/.m2 \
  java-agentic-devkit:latest \
  /bin/bash
```

---

## Next Steps

1. ✅ Start the devkit: `./scripts/dev.sh /path/to/your/project`
2. ✅ Inside container: Set up AI service (Claude, OpenAI, etc.)
3. ✅ Build your project: `mvn clean install`
4. ✅ Start agent framework: `opencode`
5. ✅ Generate code with natural language
6. ✅ Run tests: `mvn test`
7. ✅ Deploy and iterate

---

## Additional Resources

- [Docker Documentation](https://docs.docker.com)
- [Docker Hub - Ubuntu Images](https://hub.docker.com/_/ubuntu)
- [Apache Maven](https://maven.apache.org/)
- [Apache Tomcat](https://tomcat.apache.org/)
- [OpenCode Project](https://github.com/opencode-ai)
- [oh-my-opencode Documentation](https://oh-my-opencode.dev)
- [Ollama Models Library](https://ollama.ai/library)
- [Java 21 Documentation](https://docs.oracle.com/en/java/javase/21/)
- [GitHub Copilot](https://github.com/features/copilot)
- [Claude API Documentation](https://docs.anthropic.com)
- [OpenAI API Documentation](https://platform.openai.com/docs)

---

## Quick Reference Card

### Most Common Commands

```bash
# START development with your project (e.g., 27801_arus)
./scripts/dev.sh ~/cip/27801_arus

# Or if using symlink
devkit ~/cip/27801_arus

# Or from your project directory
cd ~/cip/27801_arus
/path/to/java-agentic-devkit/scripts/dev.sh
```

### Inside the Container (with project1)

```bash
# Check where your project is mounted
pwd
# Output: /workspaces/project

# See your project files
ls -la
# Shows: pom.xml, src/, target/, etc from project1

# Check Java version
java -version

# Build your project
mvn clean install

# Run tests
mvn test

# Start AI agents
opencode

# Exit container
exit
```

### Switching Between Projects

```bash
# Host Machine - Terminal 1
./scripts/dev.sh ~/projects/project1

# Host Machine - Terminal 2 (new terminal window)
./scripts/dev.sh ~/projects/project2

# Both run simultaneously with different projects
```

### Common Workflow with project1

```bash
# 1. Start devkit
./scripts/dev.sh ~/projects/project1

# 2. Inside container - build
mvn clean install

# 3. Run tests
mvn test

# 4. Start agent for code generation
opencode
# Select: Developer agent
# Task: "Add new feature..."

# 5. Exit
exit
```

---

**Happy Coding! 🚀**
