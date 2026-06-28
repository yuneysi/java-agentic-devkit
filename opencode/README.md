# OpenCode And oh-my-openagent Guide For Humans

This file explains how this devkit configures the OpenCode harness stack for human users.

## OpenCode

OpenCode is the base coding agent runtime used in this devkit.

- Official site: `https://opencode.ai`
- Official docs: `https://opencode.ai/docs`

In this repository, OpenCode behavior is mainly controlled by:

- `opencode/opencode.json`
- `opencode/tui.json`

Default OpenCode plugins enabled in this devkit:

- `oh-my-openagent`
- `opencode-codebase-index`
- `@warp-dot-dev/opencode-warp`

## oh-my-openagent

`oh-my-openagent` is the orchestration layer on top of OpenCode (agent roles, routing, and execution flow).

- GitHub: `https://github.com/code-yeongyu/oh-my-openagent`
- Docs: `https://omo.vibetip.help/docs`

In this repository, harness behavior is controlled by:

- `opencode/oh-my-openagent.jsonc`

## Why This DevKit Uses oh-my-openagent

Using OpenCode with oh-my-openagent is practical for migration and enterprise projects because it gives:

- a default orchestrator (`sisyphus`) for multi-step work
- stable role separation (planner/executor/reviewer)
- faster execution from short prompts when `AGENTS.md` and skills are already defined
- predictable handoff between planning and implementation

Default mapping in this devkit:

| Role | Agent | Model |
|------|-------|-------|
| Orchestrator | `sisyphus` | `github-copilot/gpt-5.5` (high) |
| Planner | `prometheus` | `github-copilot/gpt-5.5` (high) |
| Executor | `hephaestus` | `github-copilot/gpt-5.3-codex` (medium) |
| Reviewer | `momus` | `github-copilot/gpt-5.5` (xhigh) |
| Explorer | `explore` | `github-copilot/gpt-5.4-mini` |

Very short role summary:

- `sisyphus`: main orchestrator that coordinates the work
- `prometheus`: planning agent that prepares steps before execution
- `hephaestus`: execution agent that implements changes
- `momus`: reviewer agent for risk and quality checks
- `explore`: fast codebase exploration and discovery agent

Important UI note:

- `sisyphus` is the default run agent.
- After you connect a provider and select another agent in the UI, the active label can switch accordingly (it can look like it moved back to OpenCode/base mode).
- This is expected behavior. Select `sisyphus` again from the agent picker when you want to return to default orchestration.

Provider labels you may see in the UI:

- `OpenCode Zen`: OpenCode's curated provider of tested coding models (`https://opencode.ai/zen`).
- `Big Pickle`: a provider/model label shown by the selected provider setup in the UI; it is not an oh-my-openagent role and not a harness mode.

## How This Repository Configures Them In Docker

Both OpenCode and oh-my-openagent are installed and configured in `.devcontainer/Dockerfile`.

In target projects, the devkit supports both startup modes:

- project-owned `docker-compose.yml`
- project-owned `.devcontainer/devcontainer.json`

In both modes, mount the target project at `/workspace` so OpenCode reads and indexes the active workspace automatically.

For Windows host Maven cache mounts, use `USERPROFILE` in place of `HOME`.

Container paths:

| Item | Path in container |
|------|-------------------|
| OpenCode binary | `/usr/local/bin/opencode` |
| OpenCode config | `/home/vscode/.config/opencode/opencode.json` |
| oh-my-openagent config | `/home/vscode/.config/opencode/oh-my-openagent.jsonc` |
| TUI config | `/home/vscode/.config/opencode/tui.json` |
| Skills root | `/home/vscode/.config/opencode/skills/` |

## Skills In This Container

Skill source in this repository:

- `opencode/skills/java21-migration/`
- `opencode/skills/java-enterprise/`
- `opencode/skills/general/`

Installed location inside the container:

- `/home/vscode/.config/opencode/skills/`

Skill organization:

| Directory | Purpose |
|-----------|---------|
| `java21-migration/` | Baseline, planning, implementation, validation, and audit phases for Java 8 to Java 21 migrations. |
| `java-enterprise/` | Enterprise behavior checks and test helpers (JMS, JPA, SOAP/XML, Spring Boot). |
| `general/` | Cross-cutting tasks such as code review and documentation updates. |

How to use skills in this devkit:

- Keep prompts short and explicit, for example: `Use the java8-baseline-capture-phase skill.`
- Use one focused skill per step when possible.
- Keep skill output aligned with the target project `AGENTS.md`.
- Do not duplicate project-wide rules inside prompts.

Java 21 migration phase skills:

| Skill | Use for |
|------|---------|
| `java8-baseline-capture-phase` | Capture Java 8 baseline evidence. |
| `java8-characterization-test-phase` | Add Java 8 characterization tests when coverage is low. |
| `java21-migration-test-planning-phase` | Plan baseline and candidate validation commands and evidence. |
| `java21-migration-planning-phase` | Plan the migration sequence and next small step. |
| `java21-migration-implementation-phase` | Apply one focused migration implementation step. |
| `java21-candidate-validation-phase` | Validate the Java 21 candidate against baseline behavior. |
| `java21-migration-audit-phase` | Audit the migration diff and classify risks. |

Enterprise and general skills:

- `java-enterprise/jms-characterization-test-writer.md`
- `java-enterprise/jpa-characterization-test-writer.md`
- `java-enterprise/jpa-performance-advisor.md`
- `java-enterprise/soap-contract-test-writer.md`
- `java-enterprise/spring-boot-smoke-tester.md`
- `general/code-reviewer.md`
- `general/confluence-doc-writer.md`
- `general/readme-writer.md`
- `general/project-architecture-memory-writer.md`

The `project-architecture-memory-writer` skill updates shared project memory in:

- `opencode/memory/architecture.md`
- `opencode/memory/decisions.md`
- `opencode/memory/status.md`

This memory-first flow reduces repeated codebase scans and token usage for recurring project context questions.

## Related Docs In This Repository

- `templates/java21-migration/README.md` for migration workflow in a target project
- `opencode/container-and-env.md` for full container tool and environment details
