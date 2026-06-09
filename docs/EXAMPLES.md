# DevKit Usage Examples

Quick examples for common scenarios using the java-agentic-devkit.

---

## Example 1: Work on Project 1

You have a Java project at `~/projects/project1` and want to develop with AI assistance.

### Setup (One Time)

```bash
# Option A: Create symlink for global access
ln -s /path/to/java-agentic-devkit/scripts/dev.sh /usr/local/bin/devkit
```

### Start Development

```bash
# Using symlink (from anywhere)
devkit ~/projects/project1

# Or with full path
/path/to/java-agentic-devkit/scripts/dev.sh ~/projects/project1

# Or from devkit directory
cd /path/to/java-agentic-devkit
./scripts/dev.sh ~/projects/project1
```

### Inside Container

```bash
# You're automatically in your project
cd /workspaces/project
pwd
# Output: /workspaces/project (which is ~/projects/project1)

# Build
mvn clean install

# Set up Claude AI
export ANTHROPIC_API_KEY="sk-ant-your-key-here"

# Start agents
opencode
# Select: Developer
# Task: "Create a Spring Boot REST controller for user management"

# Run tests
mvn test

# Exit when done
exit
```

---

## Example 2: Work on Legacy App with Java 8

You have an older Java 8 project at `~/projects/legacy_app`.

```bash
# Start with Java 8 specified
./scripts/dev.sh ~/projects/legacy_app java8

# Inside container - verify Java version
java -version
# Output: openjdk version "1.8.0_372"

# Build with Java 8
mvn clean install

# Work as usual
opencode

exit
```

---

## Example 3: Work on Modern App with Java 21

You have a modern Spring Boot 3 app at `~/projects/modern-api`.

```bash
# Start with Java 21 (default)
./scripts/dev.sh ~/projects/modern-api

# Or explicit
./scripts/dev.sh ~/projects/modern-api java21

# Inside container
java -version
# Output: openjdk version "21.0.1"

# Build and test
mvn clean install
mvn test

# Use OpenAI for code generation
export OPENAI_API_KEY="sk-your-key"
opencode

exit
```

---

## Example 4: Work on Multiple Projects Simultaneously

You want to work on 2 projects at the same time.

```bash
# Terminal 1: Project A
devkit ~/projects/project1

# Terminal 2 (new window): Project B  
devkit ~/projects/project2

# Now both containers run
# Each has its own environment
# Changes in both projects are synced instantly
```

### Inside Container 1 (Project A)

```bash
cd /workspaces/project
# This is ~/projects/project1
mvn clean install
```

### Inside Container 2 (Project B)

```bash
cd /workspaces/project
# This is ~/projects/project2
mvn clean install
```

---

## Example 5: Use with Tomcat

You have a web application that needs Tomcat.

```bash
# Start devkit
devkit ~/projects/web-app

# Inside container - start Tomcat
start-tomcat9

# App runs on http://localhost:8080
curl http://localhost:8080

# Stop Tomcat
stop-tomcat9
```

**Note:** To access Tomcat from host machine, start container with port mapping:

```bash
# Manual docker command with port mapping
docker run -it --rm \
  -v ~/projects/web-app:/workspaces/project \
  -p 8080:8080 \
  java-agentic-devkit:latest \
  /bin/bash

# Now http://localhost:8080 works from host
```

---

## Example 6: Use with ActiveMQ

You have an app using ActiveMQ messaging.

```bash
# Start devkit
devkit ~/projects/messaging-app

# Inside container - start ActiveMQ
start-activemq

# ActiveMQ console: http://localhost:8161
# Broker: localhost:61616

# Work on your project
mvn clean install

# Stop ActiveMQ
# (Just exit the container)
```

---

## Example 7: Generate API Documentation

You want to generate API docs with an AI agent.

```bash
# Start devkit
devkit ~/projects/rest-api

# Inside container
export ANTHROPIC_API_KEY="sk-ant-your-key"

# Start agent
opencode

# Select: Architect agent
# Task: "Generate OpenAPI/Swagger documentation for all REST endpoints"
# Output: API documentation generated

exit
```

---

## Example 8: Refactor Code with AI

You have legacy code that needs refactoring.

```bash
# Start devkit with Java 8 (legacy code)
devkit ~/projects/legacy_system java8

# Inside container
export OPENAI_API_KEY="sk-your-key"

# Start code analysis
opencode

# Select: Architect agent  
# Task: "Analyze the current architecture and suggest refactoring to Spring Boot 3 with Java 21"
# Output: Refactoring plan generated

# View changes
git diff

exit
```

---

## Example 9: CI/CD Testing

Test your build pipeline locally before pushing.

```bash
# Start devkit
devkit ~/projects/my-project

# Inside container - run full pipeline
mvn clean
mvn test
mvn package
mvn verify

# If all passes, safe to commit
git status
git add .
git commit -m "Ready for CI/CD"

exit
```

---

## Example 10: Use Ollama for Local AI

You have Ollama running locally for free AI models.

### Setup Host Machine (One Time)

```bash
# Install Ollama from https://ollama.ai
# Start Ollama server
ollama serve

# In another terminal, pull a model
ollama pull llama2
```

### Use from DevKit Container

```bash
# Start devkit
devkit ~/cip/my-project

# Inside container
export OLLAMA_API_BASE="http://host.docker.internal:11434"
export OLLAMA_MODEL="llama2"

# Start agents
opencode

# Select: Developer
# Task: "Generate unit tests"
# Uses local llama2 model (free, no API key needed)

exit
```

---

## Cheat Sheet

```bash
# Most common commands
devkit ~/cip/27801_arus              # Start with project
java -version                        # Check Java
use-java8 / use-java21              # Switch Java version
mvn clean install                    # Build
mvn test                             # Run tests
opencode                             # Start AI agents
start-tomcat9 / start-activemq      # Start services
exit                                 # Leave container

# Setup (one-time)
ln -s /path/to/devkit/scripts/dev.sh /usr/local/bin/devkit
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-..."
export GITHUB_TOKEN="ghp_..."
```

---

## Troubleshooting

### Script not found
```bash
chmod +x /path/to/java-agentic-devkit/scripts/dev.sh
```

### Permission denied
```bash
chmod -R 755 ~/cip/27801_arus
```

### Docker not found
```bash
# Install Docker Desktop from https://www.docker.com/products/docker-desktop
```

### Port already in use
```bash
docker run -it --rm \
  -v ~/cip/my-project:/workspaces/project \
  -p 9080:8080 \
  java-agentic-devkit:latest \
  /bin/bash
# Use port 9080 instead
```

---

**Need more help? See GETTING_STARTED.md for complete documentation.**
