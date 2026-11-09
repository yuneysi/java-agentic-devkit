# OpenCode And oh-my-openagent Guide For Humans

This file explains how this devkit configures the OpenCode harness stack for human users.

Scope note:

- `opencode/...` paths are source paths in this repository.
- `/home/vscode/.config/opencode/...` and `/workspace/...` paths are runtime paths inside target-project containers.

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
- Docs: `https://github.com/code-yeongyu/oh-my-openagent/tree/dev/docs`

In this repository, harness behavior is controlled by:

- `opencode/omo.jsonc`

## Why This DevKit Uses oh-my-openagent

Using OpenCode with oh-my-openagent is practical for migration and enterprise projects because it gives:

- a default orchestrator (`sisyphus`) for multi-step work
- stable role separation (planner/executor/reviewer)
- faster execution from short prompts when `AGENTS.md` and skills are already defined
- predictable handoff between planning and implementation

Default mapping in this devkit:

| Role | Agent | Model |
|------|-------|-------|
| Orchestrator | `sisyphus` | `github-copilot/gpt-6.1-sol` (high) |
| Planner | `prometheus` | `github-copilot/gpt-6.1-sol` (high) |
| Executor | `hephaestus` | `github-copilot/gpt-6.1-sol` (high) |
| Specialist | `oracle` | `github-copilot/gpt-6-astra` (high) |
| Reviewer | `momus` | `github-copilot/gpt-6-astra` (high) |
| Explorer | `explore` | `github-copilot/gpt-6-luna` |

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
| oh-my-openagent config | `/home/vscode/.omo/omo.jsonc` |
| TUI config | `/home/vscode/.config/opencode/tui.json` |
| Skills root | `/home/vscode/.config/opencode/skills/` |

## Skills In This Container

Skill source in this repository:

- `opencode/skills/java-enterprise/`
- `opencode/skills/general/`
- `templates/java21-migration/skills/java21-migration/`

Installed location inside the container:

- `/home/vscode/.config/opencode/skills/`

Skill organization:

| Directory | Purpose |
|-----------|---------|
| `java21-migration/` | Baseline, planning, implementation, validation, and audit phases for Java 8 to Java 21 migrations. |
| `java-enterprise/` | Enterprise behavior checks and test helpers (JMS, JPA, SOAP/XML, Spring Boot). |
| `general/` | Cross-cutting tasks such as code review and documentation updates. |

How to use skills in this devkit:

- Keep prompts short and explicit, for example: `Use the java21-migration skill and run baseline.`
- Use one focused skill per step when possible.
- Keep skill output aligned with the target project `AGENTS.md`.
- Do not duplicate project-wide rules inside prompts.

Java 21 migration phase skills are now template-owned under:

- `templates/java21-migration/skills/java21-migration/`

Use the orchestrator entrypoint:

- `java21-migration/SKILL.md`

Phase responsibilities are documented under:

- `phases/java21-migration-baseline/SKILL.md`
- `phases/java21-migration-characterization/SKILL.md` (optional)
- `phases/java21-migration-planning/SKILL.md`
- `phases/java21-migration-implementation/SKILL.md`
- `phases/java21-migration-validation/SKILL.md`
- `phases/java21-migration-audit/SKILL.md`

Enterprise and general skills:

- `java-enterprise/jms-characterization-test-writer/SKILL.md`
- `java-enterprise/jpa-characterization-test-writer/SKILL.md`
- `java-enterprise/jpa-performance-advisor/SKILL.md`
- `java-enterprise/soap-contract-test-writer/SKILL.md`
- `java-enterprise/spring-boot-smoke-tester/SKILL.md`
- `general/code-reviewer/SKILL.md`
- `general/confluence-doc-writer/SKILL.md`
- `general/readme-writer/SKILL.md`
- `general/project-architecture-memory-writer/SKILL.md`

The `project-architecture-memory-writer` skill updates shared project memory in:

- `opencode/memory/architecture.md`
- `opencode/memory/decisions.md`
- `opencode/memory/status.md`

These memory files are expected in bootstrapped target projects (for example under `/workspace/opencode/memory/`). They are not required to exist as tracked files in this devkit source repository.

This memory-first flow reduces repeated codebase scans and token usage for recurring project context questions.

Planner-memory policy:

- planner only detects missing memory files,
- planner delegates memory creation/updates to `project-architecture-memory-writer`,
- memory content validation and updates are centralized in that skill.

## Related Docs In This Repository

- `templates/java21-migration/README.md` for migration workflow in a target project
- `opencode/container-and-env.md` for full container tool and environment details

## Privacy-Safe Usage Observability

This devkit follows a privacy-safe default usage model:

- no personal tracking scripts in skills or templates
- no mandatory telemetry to use skills or container images
- aggregate-only usage visibility through platform analytics

Recommended visibility sources:

- GitHub repository traffic analytics (aggregate views/clones)
- GitHub Container Registry image pull counts by tag

If you add custom telemetry in the future, keep it opt-in and document it in `.github/PRIVACY.md`.

## Reviewed Runtime And Community Skills

The image pins OpenCode **1.19.5** and Oh My OpenAgent **5.1.65**. OmO's V2 adapter currently loads without activating its agents, tools and hooks, so this devkit deliberately uses OpenCode V1. Model routing uses Copilot GPT-6.1 Sol for implementation/planning, GPT-6 Astra for deep review and GPT-6 Luna for exploration. Authenticate Copilot in the container; host credentials are not baked into the image. Other accounts can expose different model catalogs; verify with `opencode models github-copilot`.

OmO uses `opencode/omo.jsonc` copied to `~/.omo/omo.jsonc`. OpenCode discovers the target project's `AGENTS.md` from its working directory; no file-content substitution is used in the instructions path list.

| Skill | Upstream | Purpose |
| --- | --- | --- |
| `git-commit` | [GitHub Awesome Copilot](https://github.com/github/awesome-copilot/tree/main/skills/git-commit) | Review and stage one logical change, then make a Conventional Commit. |
| `grill-me` + `grilling` | [Matt Pocock](https://github.com/mattpocock/skills/tree/main/skills/productivity/grill-me) | Challenge architecture decisions before implementation; includes the required companion skill. |
| `verification-before-completion` | [Superpowers](https://github.com/obra/superpowers/tree/main/skills/verification-before-completion) | Verify outcomes before claiming success. |

Upstream content is bundled unchanged with MIT licenses and exact revisions/checksums in `community-skills.lock.json`. No full Superpowers orchestration plugin is enabled: OmO remains the coordinator. We chose GitHub's `git-commit` instead of a similarly named, less-adopted `git-commit-discipline` fork. Repository popularity is not a guarantee of correctness or Java compatibility.

The project `AGENTS.md` supplies small-checkpoint policy and Java constraints. Skills provide agent instructions, not mandatory Git hooks. An existing project keeps its own `AGENTS.md`; template changes do not overwrite it. Merge the Small Commit Discipline section deliberately if adopting this workflow in an existing project.

### Native OpenCode On macOS Or Windows/WSL2

Use the same skills with an existing host installation, without Docker:

```bash
cd ~/github/java-agentic-devkit
python3 scripts/install-opencode-skills.py
cd /path/to/java/project
opencode
```

On Windows PowerShell, use `py -3 scripts/install-opencode-skills.py` from the devkit directory. The installer preserves runtime configs and unrelated skills, and backs up replaced skill directories outside the discovery root. Restart OpenCode after installation. Host and container installations are separate; host model configuration is not changed by this installer.

Example task prompt:

```text
Use grill-me to challenge the proposed fix for this Java 8 / Spring / SOAP service.
After we agree on the design, implement one logical change at a time.
I authorize local commits for this task: use git-commit after each verified checkpoint,
and verification-before-completion before claiming success. Do not push.
```

For a routine fix with an agreed scope, skip the interview and ask directly for `git-commit` and `verification-before-completion`. Keep implementation and its tests together; isolate unrelated refactors and upgrades.

### Rebuild An Existing Container Image

Changing source files does not update a previously built `latest` image. Rebuild before starting a new container:

```bash
cd ~/github/java-agentic-devkit
docker build -t java-agentic-devkit:latest -f .devcontainer/Dockerfile .
./scripts/container/start-devkit-container.sh /path/to/java/project java8
```
