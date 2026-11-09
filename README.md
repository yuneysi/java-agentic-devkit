# java-agentic-devkit: Java 8 → 21 Migration

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Publish DevKit Image](https://github.com/yuneysi/java-agentic-devkit/actions/workflows/publish-image.yml/badge.svg)](https://github.com/yuneysi/java-agentic-devkit/actions/workflows/publish-image.yml)
[![Java 8 to 21](https://img.shields.io/badge/Java-8%20%E2%86%92%2021-orange.svg)](templates/java21-migration/README.md)

[Quick start](#start-in-three-commands) · [Migration evidence](#what-a-migration-produces) · [How it works](#how-the-devkit-works) · [Detailed setup](templates/java21-migration/README.md) · [Contributing](.github/CONTRIBUTING.md)

**Migrate legacy Java 8 applications to Java 21 with small, reversible changes, evidence gates, and human sign-off.**

`java-agentic-devkit` gives Java teams a repeatable migration environment and an AI-assisted workflow that treats the existing Java 8 application as the behavioral baseline. It does not ask an agent to rewrite the project in one large change. It guides the migration through explicit phases:

**Baseline → Characterization → Planning → Implementation → Validation → Audit**

Each implementation slice is reviewed and validated before the next one begins. Java 21 results are compared with captured Java 8 evidence, and unresolved risks remain visible instead of being hidden behind a successful compile.

This is not a one-click source rewrite. It is a controlled migration workflow for teams that need reviewable changes, reproducible evidence, and an explicit release decision.

## Why Use It?

Compiling on Java 21 does not prove that an application is safe to release. Enterprise Java migrations can change API payloads, XML contracts, persistence behavior, transactions, messaging, security, startup, and operational behavior without producing a compilation error.

This devkit makes those risks part of the workflow.

| Typical migration | With `java-agentic-devkit` |
|---|---|
| One large upgrade that is difficult to review | Small migration slices that can be reviewed and reverted independently |
| “The tests pass” | Java 8 baseline evidence compared with Java 21 candidate evidence |
| Compatibility risks discovered late | Risk map and test gaps captured from the baseline |
| Runtime, dependency, and source changes mixed together | Build, dependency, source, and behavior changes isolated when practical |
| Informal decisions scattered across chats and commits | Architecture, decisions, status, evidence, and human sign-off recorded in the project |
| Ad hoc upgrade process | Baseline → plan → implementation → validation → audit |

## What You Get

- A Docker-based environment with Java 8, Java 21, Maven, OpenCode, and oh-my-openagent ready to use.
- A migration orchestrator that selects the next valid phase from project state and evidence.
- Focused skills for baseline capture, characterization tests, planning, implementation, validation, and audit.
- Guardrails against broad refactors, opportunistic modernization, and unapproved behavior changes.
- Explicit build, test, contract, runtime, evidence, and rollback gates.
- Shared project memory for architecture, decisions, risks, blockers, and next actions.
- A concise human sign-off tracker for the final `Go`, `Go with conditions`, or `No-go` decision.

The primary use case is Java 8 to Java 21 migration. The devkit also includes templates for Java 8 maintenance and Java 21 development.

### Best Fit

- Maven-based Java applications with behavior that must remain stable.
- Enterprise systems using REST, SOAP, JMS, JDBC, JPA, Spring, JSP, or external integrations.
- Teams that need an auditable migration record rather than a single generated patch.
- Developers who want AI assistance while retaining human control over scope and release decisions.

## Start In Three Commands

Docker Desktop must be running, and the target project must contain the migration [docker-compose.yml](templates/java21-migration/docker-compose.yml). No clone is needed: [Use The Published Image Without Cloning](#use-the-published-image-without-cloning) shows how to get that file from the image.

From the target project root:

```bash
docker compose pull
docker compose run --rm --service-ports devkit
opencode
```

The second command opens the devkit shell. Run the third command inside that shell, then use one prompt:

```text
Start the Java 21 migration.
```

The workflow first establishes what the Java 8 application does, identifies risks and missing evidence, and then proposes the next safe action. It does not modify production code during baseline capture.

For setup details, Windows and macOS notes, and alternative VS Code Dev Container usage, see the [Java 8 to Java 21 migration guide](templates/java21-migration/README.md).

## Use The Published Image Without Cloning

The devkit is published as `ghcr.io/yuneysi/java-agentic-devkit` for `linux/amd64` and `linux/arm64`, so it runs natively on Intel and AMD machines, Apple Silicon Macs, and Windows on Arm. You only need Docker Desktop (on Windows, with the WSL2 backend). Every push to `main` publishes `latest` and a version tag such as `0.1.42`.

### 1. First Time In A Project

From the project folder, let the image copy its template files into the project. Existing files are never overwritten. Choose the template that fits the project: `java8`, `java21`, or `java21-migration`.

macOS, Linux, WSL2, or Git Bash:

```bash
cd /path/to/java/project
docker run --rm -v "$PWD:/workspace" -e DEVKIT_JAVA_TEMPLATE=java8 -e DEVKIT_BOOTSTRAP_TEMPLATES=true ghcr.io/yuneysi/java-agentic-devkit:latest true
```

Windows PowerShell:

```powershell
cd C:\path\to\java\project
docker run --rm -v "${PWD}:/workspace" -e DEVKIT_JAVA_TEMPLATE=java8 -e DEVKIT_BOOTSTRAP_TEMPLATES=true ghcr.io/yuneysi/java-agentic-devkit:latest true
```

This creates the missing files: `docker-compose.yml`, `AGENTS.md`, `opencode.json`, `.omo/omo.jsonc`, `openspec/config.yaml`, `opencode/memory/*.md`, and `.github/copilot-instructions.md`. Review them with `git status` and commit the ones your team wants.

### 2. Every Session

```bash
cd /path/to/java/project
docker compose run --rm --service-ports devkit
```

Then, in the container shell, run `opencode` or `claude`. The first time, also run `openspec init --tools opencode,claude` there.

`--service-ports` publishes the application port (`8080`) and the debug port (`5005`) on `127.0.0.1`. When the application uses another port, set it before you start:

| Shell | Command |
| --- | --- |
| macOS, Linux, WSL2 | `DEVKIT_APP_PORT=8083 docker compose run --rm --service-ports devkit` |
| PowerShell | `$env:DEVKIT_APP_PORT=8083; docker compose run --rm --service-ports devkit` |

The Compose file mounts the project at `/workspace` and your Maven folder (`~/.m2`, or `%USERPROFILE%\.m2` in Windows shells) at `/home/vscode/.m2`, so `settings.xml` and repository credentials are available. Set `GITHUB_TOKEN` on the host to enable the GitHub MCP server.

### 3. Update Or Pin The Image

```bash
docker compose pull
```

For reproducible team sessions, pin a version instead of `latest`: set `DEVKIT_IMAGE=ghcr.io/yuneysi/java-agentic-devkit:0.1.42`, or write that tag into the project's `docker-compose.yml`. The available tags are listed on the package page: `https://github.com/yuneysi/java-agentic-devkit/pkgs/container/java-agentic-devkit`.

### Without A Compose File

```bash
cd /path/to/java/project
docker run -it --rm -v "$PWD:/workspace" -v "$HOME/.m2:/home/vscode/.m2" -p 127.0.0.1:8080:8080 -p 127.0.0.1:5005:5005 -e GITHUB_TOKEN -e DEVKIT_BOOTSTRAP_TEMPLATES=false ghcr.io/yuneysi/java-agentic-devkit:latest
```

In PowerShell, use `"${PWD}:/workspace"` and `"$env:USERPROFILE\.m2:/home/vscode/.m2"`.

### Notes

- The container runs as user `vscode` (UID 1000). Docker Desktop on macOS and Windows maps file ownership automatically, and WSL2 users are UID 1000 by default. On native Linux with a different UID, files created in the project can be owned by UID 1000.
- Sign-ins for OpenCode and Claude Code do not persist, because each session container is removed (`--rm`).
- The Docker socket is not mounted by default, because it gives the container and its AI agents root-equivalent control of the host Docker engine. Uncomment the line in `docker-compose.yml` only when you need Testcontainers.
- To work with unreleased devkit changes, clone the repository and follow [Start The DevKit From Your Project Folder](#start-the-devkit-from-your-project-folder).

## Start The DevKit From Your Project Folder

Work from your Java project folder and start the devkit from there. The devkit checkout stays in its own folder; the container mounts the folder you are in at `/workspace`.

### One-Time Setup

Clone the devkit and build the image:

```bash
git clone https://github.com/yuneysi/java-agentic-devkit.git ~/github/java-agentic-devkit
cd ~/github/java-agentic-devkit
docker build -t java-agentic-devkit:latest -f .devcontainer/Dockerfile .
```

Rebuild the image after you pull devkit changes. The start script builds the image only when it does not exist, so it does not update an old image.

### Every Session

```bash
cd /path/to/java/project
~/github/java-agentic-devkit/scripts/container/start-devkit-container.sh
```

Without arguments, the script mounts the current folder and uses the `java8` template. Then, in the container shell:

```bash
opencode    # or: claude
```

Options. Pass `.` as the first argument when you set a template:

| Need | Command from the project folder |
| --- | --- |
| Java 21 project | `~/github/java-agentic-devkit/scripts/container/start-devkit-container.sh . java21` |
| Java 8 to Java 21 migration | `~/github/java-agentic-devkit/scripts/container/start-devkit-container.sh . java21-migration` |
| Application on another port | `DEVKIT_PORTS="8083 5005" ~/github/java-agentic-devkit/scripts/container/start-devkit-container.sh` |
| No published ports (second container) | `DEVKIT_PORTS="" ~/github/java-agentic-devkit/scripts/container/start-devkit-container.sh` |
| GitHub MCP server | `export GITHUB_TOKEN=<fine-grained token>` before you start |
| Docker socket for Testcontainers (opt-in; gives agents control of the host Docker engine) | `DEVKIT_DOCKER_SOCKET=true ~/github/java-agentic-devkit/scripts/container/start-devkit-container.sh` |

The script publishes ports `8080` (application) and `5005` (remote debugging) on `127.0.0.1` by default. On Java 8, start the debug agent with `address=5005`. On Java 9 and later, use `address=*:5005` so that the host can connect. The host `~/.m2` folder is mounted, so your Maven `settings.xml` and repository credentials are available in the container.

### First Session In A Project

Copy the template files that are missing (`AGENTS.md`, `opencode/memory/`, `openspec/config.yaml`, `opencode.json`, `.omo/omo.jsonc`, `docker-compose.yml`, `.github/copilot-instructions.md`). Existing files are never overwritten:

```bash
cd /path/to/java/project
DEVKIT_BOOTSTRAP_TEMPLATES=true ~/github/java-agentic-devkit/scripts/container/start-devkit-container.sh
```

Then set up OpenSpec once, inside the container:

```bash
openspec init --tools opencode,claude
```

Review the new files with `git status`. Delete the files your team does not want, and commit the rest.

### Platform Notes

- macOS: use the commands above in Terminal with Docker Desktop running.
- Windows: run the same commands in a WSL2 terminal (for example Ubuntu) with Docker Desktop WSL integration enabled. Keep the project and the devkit checkout in the WSL file system (`~/...`) for fast file access. Projects under `/mnt/c/...` work, but they are slower. Inside WSL, `~/.m2` is the WSL home folder, not `%USERPROFILE%\.m2`.
- Git Bash on Windows: the script also accepts Windows paths such as `C:/Git/project` as the first argument.
- Logins: the container is removed when the session ends (`--rm`), so OpenCode and Claude Code sign-ins do not persist between sessions.

## Designed For Real Java Migration Risk

The workflow explicitly checks affected areas such as:

- Java EE and Jakarta EE boundaries, including `javax.*` to `jakarta.*` decisions
- Maven plugins, annotation processors, generated sources, and removed JDK APIs
- REST/JSON and SOAP/XML contracts
- JMS delivery, retries, ordering, acknowledgement, and transactions
- JDBC/JPA mappings, lazy loading, flush behavior, and transaction boundaries
- Spring configuration, proxying, and bean lifecycle
- concurrency, thread pools, virtual threads, and blocking calls
- timezone, locale, charset, date/time, numbers, and `BigDecimal`
- authentication, authorization, TLS, deserialization, and external commands
- startup, shutdown, logging, metrics, health checks, and deployment behavior

Only checks relevant to the target project are applied. The goal is evidence, not ceremony.

## What A Migration Produces

| Phase | Reviewable output |
|---|---|
| Baseline | Reproducible Java 8 commands, raw build/test output, known failures, risk map, and readiness verdict |
| Characterization | Focused tests that lock critical behavior not protected by the existing suite |
| Planning | Ordered migration slices with affected modules, proof commands, stop conditions, and rollback steps |
| Implementation | One focused compatibility change with its diff and gate evidence |
| Validation | Java 8 vs. Java 21 comparison across applicable build, test, contract, and runtime behavior |
| Audit | Traceable residual risks and a human-reviewed `Go`, `Go with conditions`, or `No-go` recommendation |

Raw baseline and candidate outputs stay in the target repository under `docs/migration-results/`. Concise architecture, decision, and status records stay under `opencode/memory/`, making the work reviewable by developers who did not participate in every agent session.

## How The DevKit Works

The target Java project is mounted at `/workspace`; the devkit remains outside it. On startup, migration templates bootstrap the agent rules, workflow, human tracker, and shared memory required by the target project. OpenCode and oh-my-openagent then execute the migration using the project-local rules and evidence.

The canonical workflow is the [Java 21 migration skill](templates/java21-migration/skills/java21-migration/SKILL.md). The [migration agent rules](templates/java21-migration/AGENTS.md) define behavior preservation, change discipline, risk handling, dependency policy, and validation standards.

Created and maintained by Yuneysi Gerat Gil. Licensed under the [MIT License](LICENSE).

If you use the devkit, open a GitHub Issue with the project type, what worked, what failed, and how long the migration took. Real migration feedback drives the roadmap.

## Repository Structure

<details>
<summary>View the repository tree</summary>

```text
java-agentic-devkit/
├── .devcontainer/
│   ├── devcontainer.json
│   └── Dockerfile
├── .github/
│   ├── workflows/
│   │   └── publish-image.yml
│   └── PRIVACY.md, SECURITY.md, CONTRIBUTING.md, ...
├── claude/
│   └── CLAUDE.md                  # Claude Code instructions copied into the image
├── opencode/
│   ├── opencode.json              # OpenCode user config copied into the image
│   ├── omo.jsonc                  # oh-my-openagent user config
│   ├── tui.json
│   ├── community-skills.lock.json # Pinned upstream skills with checksums
│   └── skills/                    # community/, general/, java-enterprise/
├── scripts/
│   ├── container/
│   │   └── start-devkit-container.sh
│   ├── install-skills.py          # Installs skills for OpenCode or Claude Code
│   ├── create-image.sh
│   └── docker-utils.sh
├── templates/
│   ├── java8/                     # AGENTS.md, opencode.json, .omo/, openspec/, memory seeds
│   ├── java21/
│   └── java21-migration/          # Adds the java21-migration skill and checklist
├── AGENTS.md
├── LICENSE
└── README.md
```

</details>

## Setup Options

| Option | Use when | Start here |
|---|---|---|
| Published image, no clone | Recommended for a shared team workflow | Follow [Use The Published Image Without Cloning](#use-the-published-image-without-cloning) |
| VS Code Dev Container | The team works directly in VS Code containers | Follow the platform-specific examples in the migration guide |
| Start from the project folder | You work inside your project and keep a local devkit checkout | Follow [Start The DevKit From Your Project Folder](#start-the-devkit-from-your-project-folder) |

Template bootstrapping is controlled by `DEVKIT_BOOTSTRAP_TEMPLATES`. Container-based target-project flows enable it so required files are copied when missing. The start script disables it by default to avoid modifying an arbitrary mounted workspace.

See the [migration setup guide](templates/java21-migration/README.md) for complete macOS, Windows, Compose, and Dev Container instructions.

## Shared Project Memory

The devkit maintains three concise target-project files:

| File | Purpose |
|---|---|
| `opencode/memory/architecture.md` | Current system shape, critical flows, integrations, and constraints |
| `opencode/memory/decisions.md` | Accepted or rejected migration decisions and rationale |
| `opencode/memory/status.md` | Current phase, evidence, blockers, risks, and next action |

Bootstrap files are seeds, not verified project facts. The migration workflow initializes them from repository evidence before baseline execution and updates them only when their owned information changes.

## Documentation

| Guide | Use for |
|---|---|
| [Migration setup guide](templates/java21-migration/README.md) | Full Java 8 to Java 21 setup and startup options |
| [Migration agent rules](templates/java21-migration/AGENTS.md) | Behavior preservation, change discipline, and validation standards |
| [Migration workflow](templates/java21-migration/skills/java21-migration/SKILL.md) | Phase order, shared gates, evidence, and state transitions |
| [Human sign-off tracker](templates/java21-migration/docs/migration-progress-checklist.md) | Migration slices, risks, evidence, and release decision |
| [OpenCode guide](opencode/README.md) | OpenCode, oh-my-openagent, configuration, and installed skills |
| [Container reference](opencode/container-and-env.md) | Runtime tools, paths, and environment variables |

## Contributing

Issues and pull requests are welcome. Before contributing, read the [contribution guide](.github/CONTRIBUTING.md), [code of conduct](.github/CODE_OF_CONDUCT.md), and [security policy](.github/SECURITY.md).

## Memory-First Context (Token Saving)

This devkit uses shared memory files under `opencode/memory/`: `architecture.md`, `decisions.md`, and `status.md`.

The files under `templates/*/opencode/memory/` are only seed files. Users should not edit those template files in normal target-project work. After the devkit bootstraps a target project, users should update the target project's own files:

- `opencode/memory/architecture.md`
- `opencode/memory/decisions.md`
- `opencode/memory/status.md`

To initialize or refresh them, start OpenCode inside the target project container and use this prompt:

```text
Use the project-architecture-memory-writer skill.
Initialize or refresh opencode/memory/architecture.md, opencode/memory/decisions.md, and opencode/memory/status.md for this target project.
Read AGENTS.md first, inspect only the evidence needed, replace template seed values with verified project facts, keep unknowns explicit, and summarize the files changed.
```

For Java 8 to Java 21 migrations, run this prompt before starting the migration. Refresh memory after a phase only when architecture, decisions, risks, or delivery status changed.

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
