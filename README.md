# java-agentic-devkit

`java-agentic-devkit` is a reusable Docker-based development kit for teams working on Java 8 projects, Java 21 projects, and Java 8 to Java 21 migrations. It provides templates for different work modes, including Java 8 legacy maintenance, modern Java development, and structured migration work.

Created and maintained by Yuneysi Gerat Gil.

License: MIT. See [LICENSE](LICENSE).

When the container starts, it automatically copies the files agents need into the mounted target project, including `AGENTS.md`, `.github/copilot-instructions.md`, and the template documentation under `docs/`. The generated `AGENTS.md` points agents to the relevant documentation so migration notes, validation evidence, and day-to-day work can be documented in the target project.

The devkit stays outside the target Java project. Developers build or run the devkit from this repository and mount the target project at `/workspace`.

Java 8 is the default runtime. Use Java 21 only when the target project already runs on Java 21 or when validating a Java 8 to Java 21 migration candidate.


## Repository Structure

```text
java-agentic-devkit/
├── .devcontainer/
│   └── Dockerfile
├── opencode/
│   ├── README.md
│   ├── container-and-env.md
│   ├── opencode.json
│   ├── oh-my-openagent.jsonc
│   ├── tui.json
│   └── skills/
│       └── README.md
├── scripts/
│   ├── create-image.sh
│   ├── docker-utils.sh
│   └── container/
│       └── start-devkit-container.sh
├── templates/
│   ├── README.md
│   ├── java21/
│   │   ├── AGENTS.md
│   │   └── .github/copilot-instructions.md
│   ├── java21-ak4/
│   │   ├── AGENTS.md
│   │   ├── docker-compose.yml
│   │   └── .github/copilot-instructions.md
│   └── java21-migration/
│       ├── AGENTS.md
│       ├── README.md
│       ├── docker-compose.yml
│       ├── .github/copilot-instructions.md
│       └── docs/migration-progress-checklist.md
├── AGENTS.md
├── LICENSE
└── README.md
```

## Recommended Integration

The recommended way to use this devkit is to integrate it into each target Java project with a project-owned Compose file.

This keeps the development entrypoint close to the application code, makes the selected Java mode explicit, and gives the team one shared command for local work, tests, and migration validation.

On first container start, the devkit copies the template Compose file as `docker-compose.yml` when missing, or as `docker-compose-devkit.yml` when the project already has `docker-compose.yml`.

See `templates/java21-migration/README.md` for Docker Compose setup used for Java 8 to Java 21 migration projects.

## Guides

| Guide | Use for |
|-------|---------|
| `opencode/README.md` | OpenCode and local AI setup. |
| `opencode/container-and-env.md` | Container contents and environment variables. |
| `opencode/skills/README.md` | Human guidance on OpenCode skills. |
| `templates/java21-migration/README.md` | Java 8 to Java 21 migration setup and workflow. |

**Workflow**:
1. Host: `docker compose up -d` -> container starts
2. Host: `docker compose exec devkit bash` -> enter the container
3. Inside container: all tools available
4. All build/test commands run inside the container

## Manual Script Workflow

Use the manual script when the target project does not have a `docker-compose.yml` integration yet.

```bash
cd ~/github/java-agentic-devkit
./scripts/container/start-devkit-container.sh /path/to/java/project
./scripts/container/start-devkit-container.sh /path/to/java/project java21
./scripts/container/start-devkit-container.sh /path/to/java/project java21-ak4
./scripts/container/start-devkit-container.sh /path/to/java/project java21-migration
```

See `opencode/README.md` for the human-friendly OpenCode and local AI setup guide.
