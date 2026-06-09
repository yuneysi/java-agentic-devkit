# Coding Standards

This document defines the coding standards for the java-agentic-devkit project.

## General Rules

### Language
- **All comments must be in English** - This includes:
  - Inline comments
  - Block comments
  - Function/method documentation
  - Script headers and usage descriptions

### File Headers
Every script should start with:
```bash
#!/bin/bash

# Script description in English
# Usage: command-line example
```

## Bash Scripts

### Comments
```bash
# Single line comment

# Multi-line comment
# continues here
# and here

# Function description
function my_function() {
  # Comment inside function
  code here
}
```

### Colors (consistent across all scripts)
```bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
```

### Error Handling
- Use `set -e` to exit on error
- Always provide error messages
- Use appropriate exit codes

### Output Messages
```bash
echo -e "${YELLOW}🔨 Building Docker image...${NC}"
echo -e "${GREEN}✅ Success${NC}"
echo -e "${RED}❌ Error message${NC}"
```

## Java Files

- Comments in English
- Follow standard Java conventions
- Use JavaDoc for public methods

## Other Languages

- Comments in English
- Follow language-specific conventions
- Document public APIs with appropriate tools

## File Naming

- Use kebab-case for scripts: `create-image.sh`
- Use camelCase for Java classes: `MyClass.java`
- Use lowercase for directories

## Version Control

- Commit messages in English
- Clear, descriptive messages
- Reference issue numbers when applicable
