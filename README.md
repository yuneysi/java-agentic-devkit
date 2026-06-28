# java-agentic-devkit

`java-agentic-devkit` is focused on helping teams migrate Java 8 projects to Java 21 in a controlled, evidence-driven way.

It provides a reusable Docker-based development environment, migration templates, built-in skills, and a containerized workflow designed for OpenCode + oh-my-openagent orchestration. It is for developers who want to work with agents, use skills, and run OpenCode, oh-my-openagent, and related plugins out of the box without installing those tools locally.

It can also be used for Java 8 legacy maintenance and Java 21 target projects, but the primary workflow is Java 8 to Java 21 migration.

Recommended skill for most users: `java21-migration` under `templates/java21-migration/skills/java21-migration/`. This is the canonical migration skill set used by the templates in this repository.

Created and maintained by Yuneysi Gerat Gil.

License: MIT. See [LICENSE](LICENSE).

Feedback is welcome. If you use this devkit, please open GitHub Issues with bugs, migration pain points, improvement ideas, or comments about what worked well in your Java migration workflow.

When the container starts, it automatically copies the files agents need into the mounted target project, including `AGENTS.md`, `.github/copilot-instructions.md`, shared project memory under `opencode/memory/`, and the template documentation under `docs/`. The generated `AGENTS.md` points agents to the relevant documentation and skill flow, so agents can choose the right migration skill with short user prompts instead of long, repeated instructions.

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
│   ├── java8/
│   │   ├── AGENTS.md
│   │   ├── docker-compose.yml
│   │   └── .github/copilot-instructions.md
│   ├── java21/
│   │   ├── AGENTS.md
│   │   ├── docker-compose.yml
│   │   └── .github/copilot-instructions.md
│   └── java21-migration/
│       ├── AGENTS.md
│       ├── README.md
│       ├── docker-compose.yml
│       ├── .github/copilot-instructions.md
│       ├── docs/migration-progress-checklist.md
│       └── skills/java21-migration/
├── AGENTS.md
├── LICENSE
└── README.md
```

## How To Start The DevKit In Your Project

This bootstrap behavior is controlled by `DEVKIT_BOOTSTRAP_TEMPLATES`. The default is `true`, which copies missing files from the selected template into the mounted project. Set `DEVKIT_BOOTSTRAP_TEMPLATES=false` only when you want to use the image without modifying the mounted workspace, such as when developing this devkit repository itself inside a VS Code Dev Container.

The local helper script `scripts/container/start-devkit-container.sh` intentionally starts containers with `DEVKIT_BOOTSTRAP_TEMPLATES=false` by default. This keeps ad hoc script runs from writing template files into the mounted workspace. To enable template copying for a script run, set `DEVKIT_BOOTSTRAP_TEMPLATES=true` before running the script.

The devkit stays outside the target Java project. Developers build or run the devkit from this repository and mount the target project at `/workspace`.

Java 8 is the default runtime. Use Java 21 only when the target project already runs on Java 21 or when validating a Java 8 to Java 21 migration candidate.

For Java 8 to Java 21 migrations, start with:

- `templates/java21-migration/README.md`

It contains the full migration-specific workflow and prompt flow.

### Quick Start

Ensure Docker Desktop is running. Then choose one startup flow:

1) Running in Docker Container.

1.1) Recommended: project-owned `docker-compose.yml` in the target project.

- Set `DEVKIT_JAVA_TEMPLATE` to `java8`, `java21`, or `java21-migration`.
- If the target project does not have a compose file yet, copy the template compose for the selected mode (`templates/<mode>/docker-compose.yml`) to the target project root.
- For migration mode, use `templates/java21-migration/README.md` for full setup and prompt flow.

1.2) Alternative: project-owned `.devcontainer/devcontainer.json` in the target project.

- Use this when your team works directly with VS Code Dev Containers instead of Compose.
- Set `DEVKIT_JAVA_TEMPLATE` and `DEVKIT_BOOTSTRAP_TEMPLATES=true` in container environment values.
- Full example and platform-specific config are below.

2) Manual: checkout this devkit repository and run scripts.

- Use this when you want to build/run the devkit from this repository instead of adding container config to the target project.
- Script commands are below.

After startup, verify runtime and tooling inside the container:

```bash
java -version
mvn -v
```

#### 1) Running in Docker Container

##### 1.1) Recommended: Project-owned `docker-compose.yml`

Keep `docker-compose.yml` in the target project root and start the devkit from there.

This is the recommended flow because it keeps container startup, ports, and team commands close to the target project.

##### 1.2) Alternative: Project-owned `.devcontainer/devcontainer.json` (no Compose)

If you prefer VS Code Dev Containers without `docker-compose.yml`, create `.devcontainer/devcontainer.json` in the target project root.

The following examples are for this `1.2` `.devcontainer/devcontainer.json` flow.

Linux and macOS example:

```json
{
	"name": "Java Agentic DevKit - Java 8",
	"image": "ghcr.io/yuneysi/java-agentic-devkit:latest",
	"remoteUser": "vscode",
	"workspaceFolder": "/workspace",
	"overrideCommand": false,
	"containerEnv": {
		"DEVKIT_PROJECT_DIR": "/workspace",
		"DEVKIT_JAVA_TEMPLATE": "java8",
		"DEVKIT_BOOTSTRAP_TEMPLATES": "true",
		"MAVEN_OPTS": "-Dmaven.repo.local=/home/vscode/.m2/repository"
	},
	"forwardPorts": [8080, 5005],
	"mounts": [
		"source=${localEnv:HOME}/.m2,target=/home/vscode/.m2,type=bind",
		"source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind"
	],
	"postStartCommand": "bash -lc 'use-java8 && java -version && mvn -v'"
}
```

Windows example using `USERPROFILE`:

```json
{
	"name": "Java Agentic DevKit - Java 8",
	"image": "ghcr.io/yuneysi/java-agentic-devkit:latest",
	"remoteUser": "vscode",
	"workspaceFolder": "/workspace",
	"overrideCommand": false,
	"containerEnv": {
		"DEVKIT_PROJECT_DIR": "/workspace",
		"DEVKIT_JAVA_TEMPLATE": "java8",
		"DEVKIT_BOOTSTRAP_TEMPLATES": "true",
		"MAVEN_OPTS": "-Dmaven.repo.local=/home/vscode/.m2/repository"
	},
	"forwardPorts": [8080, 5005],
	"mounts": [
		"source=${localEnv:USERPROFILE}/.m2,target=/home/vscode/.m2,type=bind",
		"source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind"
	],
	"postStartCommand": "bash -lc 'use-java8 && java -version && mvn -v'"
}
```

#### 2) Manual: Checkout this devkit repository and run scripts

Clone this repository, build the image locally, and start a mounted target project with the provided scripts:

```bash
cd ~/github/java-agentic-devkit
./scripts/create-image.sh
./scripts/container/start-devkit-container.sh /path/to/java/project
```

The script sets `DEVKIT_BOOTSTRAP_TEMPLATES=false` by default. To copy missing files from the selected template into the mounted project during startup, run:

```bash
DEVKIT_BOOTSTRAP_TEMPLATES=true ./scripts/container/start-devkit-container.sh /path/to/java/project java21-migration
```

Template options:

```bash
./scripts/container/start-devkit-container.sh /path/to/java/project java21
./scripts/container/start-devkit-container.sh /path/to/java/project java21-migration
```

## Memory-First Context (Token Saving)

This devkit uses shared memory files under `opencode/memory/`: `architecture.md`, `decisions.md`, and `status.md`.

Agents read these concise files first, so they avoid repeating wide codebase scans for recurring context. This reduces token usage and usually improves response speed for follow-up questions.

Keep these files updated whenever architecture, decisions, or project status changes.

## Guides

Each template has its own `AGENTS.md` with template-specific agent rules.

| Guide | Use for |
|-------|---------|
| `opencode/README.md` | AI stack guide: OpenCode, oh-my-openagent (OMO), and skills. |
| `opencode/container-and-env.md` | Container contents and environment variables. |
| `templates/java8/AGENTS.md` | Agent rules for Java 8 target projects. |
| `templates/java21/AGENTS.md` | Agent rules for Java 21 target projects. |
| `templates/java21-migration/AGENTS.md` | Agent rules for Java 8 to Java 21 migration projects. |
| `templates/java21-migration/README.md` | Java 8 to Java 21 migration setup and workflow. |
