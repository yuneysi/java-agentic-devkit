# Using DevKit with Your Project

Quick guide to get started with your specific project.

## Your Situation

You have a Java project at: `~/projects/project1`

You want to develop it with AI assistance using the java-agentic-devkit.

## Solution - Three Options

### Option 1: Use Full Path (Recommended)

```bash
# From anywhere, use the full path to devkit script
/path/to/java-agentic-devkit/scripts/dev.sh ~/projects/project1

# Example with your specific paths:
~/projects/java-agentic-devkit/scripts/dev.sh ~/projects/project1
```

### Option 2: Run from Your Project Directory

```bash
cd ~/projects/project1
/path/to/java-agentic-devkit/scripts/dev.sh
```

### Option 3: Run from DevKit Directory

```bash
# Navigate to devkit
cd /path/to/java-agentic-devkit

# Run the script
./scripts/dev.sh ~/projects/project1
```

## What Happens

When you run the command:

```bash
/path/to/java-agentic-devkit/scripts/dev.sh ~/projects/project1
```

The script will:

1. ✅ Check if Docker image exists (build if needed)
# Mount your project: `~/projects/project1` → `/workspaces/project` (inside container)
3. ✅ Configure Java (default: Java 8)
4. ✅ Show welcome message
5. ✅ Enter interactive bash shell

## Inside the Container

Now you're inside the container with your project ready:

```bash
# Your project is here
cd /workspaces/project

# Verify it's your project
ls -la
# Shows: pom.xml, src/, target/, etc. from project1

# Build your project
mvn clean install

# Run tests
mvn test

# Set up AI provider
export ANTHROPIC_API_KEY="sk-ant-your-key"

# Start AI agents
opencode
# Select: Developer agent
# Task: describe what you want to build/fix

# When done
exit
```

## Real-World Workflow

### Session 1: First Time Setup

```bash
# From your home directory
/path/to/java-agentic-devkit/scripts/dev.sh ~/projects/project1

# Inside container - first build (2-3 minutes)
mvn clean install

# Everything builds fine? Good!
exit
```

### Session 2: Next Day Development

```bash
# Start devkit again (much faster - uses cache)
devkit ~/projects/project1

# Inside container - ready immediately
# Your changes from yesterday are still there
mvn test
opencode
# Use AI to add new feature

exit
```

### Session 3: Work on Different Project

```bash
# Same devkit, different project
devkit ~/projects/project2

# Same tools available
# Different project mounted
mvn clean install

exit
```

## Using Specific Java Version

### For Legacy Projects (Java 8)

```bash
devkit ~/projects/project1 java8

# Inside container
java -version
# Output: openjdk version "1.8.0_372"
```

### For Modern Projects (Java 21)

```bash
# Default or explicit
devkit ~/projects/project1
devkit ~/projects/project1 java21

# Inside container
java -version
# Output: openjdk version "21.0.1"
```

## Port Mapping (For Tomcat/Web Apps)

If your project runs a web server:

```bash
# Manual docker command (instead of dev.sh) with port mapping
docker run -it --rm \
  -v ~/projects/project1:/workspaces/project \
  -p 8080:8080 \
  java-agentic-devkit:latest \
  /bin/bash

# Inside container
start-tomcat9

# On host machine
curl http://localhost:8080
```

## Connecting to AI Services

### Using Claude

```bash
# Before starting devkit, set your API key
export ANTHROPIC_API_KEY="sk-ant-your-actual-key"

# Start devkit
devkit ~/projects/project1

# Inside container
opencode
# It will automatically use your Claude key
```

### Using OpenAI

```bash
export OPENAI_API_KEY="sk-your-actual-key"
/path/to/java-agentic-devkit/scripts/dev.sh ~/cip/27801_arus
```

### Using Local Ollama (Free)

```bash
# On host machine - start Ollama first
ollama serve

# In another terminal
ollama pull llama2

# Then start devkit
/path/to/java-agentic-devkit/scripts/dev.sh ~/projects/project1

# Inside container
export OLLAMA_API_BASE="http://host.docker.internal:11434"
opencode  # Uses local llama2 (free!)
```

## Troubleshooting

### Script Not Found

```bash
# Make sure the devkit path is correct
ls -la /path/to/java-agentic-devkit/scripts/dev.sh
```

### Permission denied

```bash
# Make scripts executable
chmod +x /path/to/java-agentic-devkit/scripts/*.sh
```

### Image build fails

```bash
# Clear Docker cache
docker system prune

# Try again
/path/to/java-agentic-devkit/scripts/dev.sh ~/cip/27801_arus
```

### Project files not visible

```bash
# Make sure path is correct
ls -la ~/projects/project1

# Use absolute path
/path/to/java-agentic-devkit/scripts/dev.sh /Users/yuneysi/projects/project1
```

## Summary

**To develop your project1:**

```bash
/path/to/java-agentic-devkit/scripts/dev.sh ~/projects/project1

# Done! You're inside the container with:
# ✅ Your project mounted
# ✅ Java configured
# ✅ Maven ready
# ✅ AI agents available
```

See [GETTING_STARTED.md](GETTING_STARTED.md) for complete documentation and [EXAMPLES.md](EXAMPLES.md) for more scenarios.
