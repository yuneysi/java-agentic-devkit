# java-agentic-devkit

`java-agentic-devkit` is a reusable Docker-based development kit for teams working on Java 8 projects, Java 21 projects, and Java 8 to Java 21 migrations. It provides templates for different work modes, including Java 8 legacy maintenance, modern Java development, and structured migration work.

Created and maintained by Yuneysi Gerat Gil.

License: MIT. See [LICENSE](LICENSE).

When the container starts, it automatically copies the files agents need into the mounted target project, including `AGENTS.md`, `.github/copilot-instructions.md`, and the template documentation under `docs/`. The generated `AGENTS.md` points agents to the relevant documentation and skill flow, so agents can choose the right migration skill with short user prompts instead of long, repeated instructions.

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

## How To Start The DevKit In Your Project

The recommended way to use this devkit is to integrate it into each target Java project with a project-owned Compose file.

This keeps the development entrypoint close to the application code, makes the selected Java mode explicit, and gives the team one shared command for local work, tests, and migration validation.

Template READMEs for integration and workflow:

- `templates/java21-migration/README.md` for Java 8 to Java 21 migration setup and workflow.

Use one of these two flows.

### 1) Recommended: Project-owned `docker-compose.yml`

Keep `docker-compose.yml` in the root of the target project and start the devkit from there.

This is the recommended flow because it keeps container startup, ports, and team commands inside the target project.

For full setup details, expected environment values, and migration prompts, use:

- `templates/java21-migration/README.md`

### 2) Alternative: Build locally and run with scripts

Clone this repository, build the image locally, and start a mounted target project with the provided scripts:

```bash
cd ~/github/java-agentic-devkit
./scripts/create-image.sh
./scripts/container/start-devkit-container.sh /path/to/java/project
```

Template options:

```bash
./scripts/container/start-devkit-container.sh /path/to/java/project java21
./scripts/container/start-devkit-container.sh /path/to/java/project java21-ak4
./scripts/container/start-devkit-container.sh /path/to/java/project java21-migration
```

## Guides

Each template has its own `AGENTS.md` with template-specific agent rules.

| Guide | Use for |
|-------|---------|
| `opencode/README.md` | AI stack guide: OpenCode, oh-my-openagent (OMO), and skills. |
| `opencode/container-and-env.md` | Container contents and environment variables. |
| `templates/java8/AGENTS.md` | Agent rules for Java 8 target projects. |
| `templates/java21/AGENTS.md` | Agent rules for Java 21 target projects. |
| `templates/java21-ak4/AGENTS.md` | Agent rules for Java 21 + Redis target projects. |
| `templates/java21-migration/AGENTS.md` | Agent rules for Java 8 to Java 21 migration projects. |
| `templates/java21-migration/README.md` | Java 8 to Java 21 migration setup and workflow. |
