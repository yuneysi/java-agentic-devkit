# java-agentic-devkit: Java 8 → 21 Migration

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Validate](https://github.com/yuneysi/java-agentic-devkit/actions/workflows/validate.yml/badge.svg)](https://github.com/yuneysi/java-agentic-devkit/actions/workflows/validate.yml)
[![Publish DevKit Image](https://github.com/yuneysi/java-agentic-devkit/actions/workflows/publish-image.yml/badge.svg)](https://github.com/yuneysi/java-agentic-devkit/actions/workflows/publish-image.yml)
[![Image: amd64 | arm64](https://img.shields.io/badge/image-amd64%20%7C%20arm64-2496ED.svg)](https://github.com/yuneysi/java-agentic-devkit/pkgs/container/java-agentic-devkit)
[![Java 8 to 21](https://img.shields.io/badge/Java-8%20%E2%86%92%2021-orange.svg)](templates/java21-migration/README.md)

[Quick start](#start-the-devkit) · [Migration evidence](#what-a-migration-produces) · [How it works](#how-the-devkit-works) · [Detailed setup](templates/java21-migration/README.md) · [Contributing](.github/CONTRIBUTING.md)

**Migrate legacy Java 8 applications to Java 21 with small, reversible changes, evidence gates, and human sign-off.**

`java-agentic-devkit` gives Java teams a repeatable migration environment and an AI-assisted workflow that treats the existing Java 8 application as the behavioral baseline. It does not ask an agent to rewrite the project in one large change. It guides the migration through explicit phases:

**Baseline → Characterization → Planning → Implementation → Validation → Audit**

Each implementation slice is reviewed and validated before the next one begins. Java 21 results are compared with captured Java 8 evidence, and unresolved risks remain visible instead of being hidden behind a successful compile.

This is not a one-click source rewrite. It is a controlled migration workflow for teams that need reviewable changes, reproducible evidence, and an explicit release decision.

The image is built with a pinned and verified supply chain, scanned on every build, rebuilt weekly, and published with provenance and SBOM attestations. AI agents in the container get no access to the host Docker engine unless you opt in. See the [security policy](.github/SECURITY.md).

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

## Start The DevKit

There is one way to start the devkit: from your project folder, with the published image and the project's `docker-compose.yml`. You do not need to clone this repository. You only need Docker Desktop (on Windows, with the WSL2 backend).

The image `ghcr.io/yuneysi/java-agentic-devkit` is published for `linux/amd64` and `linux/arm64`, so it runs natively on Intel and AMD machines, Apple Silicon Macs, and Windows on Arm.

### 1. First Time In A Project

Choose the template that matches the work. It sets how the agents behave:

| Template | Use when | Agents |
|---|---|---|
| `java8` | Maintaining a Java 8 application, with no migration now | Keep Java 8 and do not propose migration work |
| `java21` | Maintaining an application that already runs on Java 21 | Keep the current platform |
| `java21-migration` | Migrating from Java 8 to Java 21 | Follow the phased migration workflow |

From the project folder, copy the template files into the project (macOS, Linux, WSL2, or Git Bash):

```bash
cd /path/to/java/project
docker run --rm -v "$PWD:/workspace" -e DEVKIT_JAVA_TEMPLATE=java8 -e DEVKIT_BOOTSTRAP_TEMPLATES=true ghcr.io/yuneysi/java-agentic-devkit:latest true
```

In Windows PowerShell, use `-v "${PWD}:/workspace"`.

This creates only the missing files and never overwrites existing ones: `docker-compose.yml`, `AGENTS.md`, `opencode.json`, `.omo/omo.jsonc`, `.claude/settings.json`, `openspec/config.yaml`, and `.github/copilot-instructions.md`. It also runs `openspec init` once. The template choice is stored in `docker-compose.yml`, so you do not repeat it. Review the files with `git status` and commit the ones your team wants.

### 2. Every Session

```bash
cd /path/to/java/project
docker compose run --rm --service-ports devkit
```

Then, in the container shell, run `claude`, `opencode`, or `codex`. The agents read `AGENTS.md`, check `openspec/specs/`, and propose capturing the spec of the part you work on when it is missing.

| Need | Command |
|---|---|
| Application on another port | `DEVKIT_APP_PORT=8083 docker compose run --rm --service-ports devkit` (PowerShell: `$env:DEVKIT_APP_PORT=8083` first) |
| GitHub MCP server | Set `GITHUB_TOKEN` on the host before you start |
| Release version check (`check-release-version <version>`) | Set `NEXUS_REPOSITORY_URL` (release repository), `NEXUS_REPOSITORY_ID` (server id in `settings.xml`), and `RELEASE_ARTIFACT` (`groupId:artifactId`) on the host. Run `git fetch` on the host first: the container has no SSH keys, so it checks the refs from your last fetch |
| Testcontainers | Uncomment the Docker socket line in `docker-compose.yml` (gives agents control of the host Docker engine) |
| Use the newest image | `docker compose pull` |
| Pin a version | Set `DEVKIT_IMAGE=ghcr.io/yuneysi/java-agentic-devkit:<version>`; tags are on the [package page](https://github.com/yuneysi/java-agentic-devkit/pkgs/container/java-agentic-devkit) |

`--service-ports` publishes the application port (`8080`) and the debug port (`5005`) on `127.0.0.1` only. On Java 8, start the debug agent with `address=5005`; on Java 9 and later, use `address=*:5005`. Your Maven folder (`~/.m2`, or `%USERPROFILE%\.m2` in Windows shells) is mounted, so `settings.xml` and repository credentials are available.

### Notes

- Sign-ins for Claude Code, OpenCode, and Codex do not persist, because each session container is removed (`--rm`). For Codex, use `codex login --device-auth` (the browser callback cannot reach the container) or set `OPENAI_API_KEY` on the host.
- The container runs as user `vscode` (UID 1000). Docker Desktop maps file ownership on macOS and Windows, and WSL2 users are UID 1000 by default.
- On Windows, keep the project in the WSL file system (`~/...`) for fast file access.
- VS Code users can open the same image as a Dev Container; see the [migration guide](templates/java21-migration/README.md#option-b-devcontainerdevcontainerjson-no-compose).

### Developing The DevKit Itself

Only to test unreleased devkit changes: clone this repository, build the image locally, and start it with the script. The script uses the local `java-agentic-devkit:latest` image, not the published one.

```bash
git clone https://github.com/yuneysi/java-agentic-devkit.git ~/github/java-agentic-devkit
docker build -t java-agentic-devkit:latest -f ~/github/java-agentic-devkit/.devcontainer/Dockerfile ~/github/java-agentic-devkit
cd /path/to/java/project
~/github/java-agentic-devkit/scripts/container/start-devkit-container.sh
```

The script options (`DEVKIT_PORTS`, `DEVKIT_DOCKER_SOCKET`, template argument) are listed in the [container reference](opencode/container-and-env.md).

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

## Migration Project Memory

The java21-migration template maintains three concise target-project files, because its phase gates read and write them:

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

## Project Knowledge With OpenSpec

For Java 8 and Java 21 projects, OpenSpec is the project knowledge base. The devkit does not seed generic architecture or decision files, because every project is different.

- On the first start with template bootstrap, the devkit copies `openspec/config.yaml` and runs `openspec init --tools opencode,claude,codex`.
- `openspec/specs/` starts empty and grows one capability at a time: when a change touches a capability without a spec, the agent first captures its current behavior with the `legacy-spec-baseline` skill.
- Decisions stay in each change's `proposal.md` and `design.md`, in `openspec/changes/archive/`.

The java21-migration template additionally keeps `opencode/memory/` for its phase status and evidence. See [Migration Project Memory](#migration-project-memory).
