# OpenCode Guide For Humans

This folder contains the OpenCode configuration that ships with the devkit.

Use this guide when you want to understand or adjust the default OpenCode setup:

- `opencode/opencode.json` for the default OpenCode configuration
- `opencode/oh-my-openagent.jsonc` for planner/executor orchestration
- `opencode/tui.json` for the TUI plugin
- `opencode/skills/` for reusable task-specific skills

## What It Does

- `instructions` points OpenCode at the mounted project `AGENTS.md`.
- `plugin` enables `oh-my-openagent` and `opencode-codebase-index`.
- `mcp` enables Context7, GitHub, and Playwright.
- `model` defaults to `github-copilot/gpt-5.3-codex`.
- `agent` keeps planning read-only and execution reviewable.
- `permission` uses `ask` so tool actions require confirmation.
- `provider` supports Copilot, OpenAI, and local Ollama models.

## Agent Mapping

| Area | Default |
|------|---------|
| Orchestrator | `sisyphus` with `github-copilot/gpt-5.5` high |
| Planner | `prometheus` with `github-copilot/gpt-5.5` high |
| Executor | `hephaestus` with `github-copilot/gpt-5.3-codex` medium |
| Reviewer | `momus` with `github-copilot/gpt-5.5` xhigh |
| Explorer | `explore` with `github-copilot/gpt-5.4-mini` |

## MCP Servers

| Server | Use for |
|--------|---------|
| GitHub | Branches, PRs, issues, and code search. |
| Context7 | Library docs and code examples. |
| Playwright | Browser smoke tests for web apps. |

## Skills

| Area | Skill file | Use for |
|------|------------|---------|
| Java 21 migration | `opencode/skills/java21-migration/java8-baseline-capture-phase.md` | Phase 2 Java 8 baseline capture. |
| Java 21 migration | `opencode/skills/java21-migration/java8-characterization-test-phase.md` | Java 8 characterization tests before migration changes. |
| Java 21 migration | `opencode/skills/java21-migration/java21-migration-test-planning-phase.md` | Baseline and candidate validation planning. |
| Java 21 migration | `opencode/skills/java21-migration/java21-migration-planning-phase.md` | Java 21 migration sequencing and next-step planning. |
| Java 21 migration | `opencode/skills/java21-migration/java21-migration-implementation-phase.md` | One focused Java 21 migration implementation step. |
| Java 21 migration | `opencode/skills/java21-migration/java21-candidate-validation-phase.md` | Java 21 candidate validation against the Java 8 baseline. |
| Java 21 migration | `opencode/skills/java21-migration/java21-migration-audit-phase.md` | Final migration diff review and risk classification. |
| Java enterprise | `opencode/skills/java-enterprise/jms-characterization-test-writer.md` | JMS behavior tests. |
| Java enterprise | `opencode/skills/java-enterprise/jpa-characterization-test-writer.md` | JPA behavior tests. |
| Java enterprise | `opencode/skills/java-enterprise/jpa-performance-advisor.md` | JPA query and lazy-loading analysis. |
| Java enterprise | `opencode/skills/java-enterprise/soap-contract-test-writer.md` | SOAP/XML contract tests. |
| Java enterprise | `opencode/skills/java-enterprise/spring-boot-smoke-tester.md` | Basic Spring Boot smoke tests. |
| General | `opencode/skills/general/code-reviewer.md` | Diff review and risk classification. |
| General | `opencode/skills/general/confluence-doc-writer.md` | Human-facing documentation and Confluence exports. |
| General | `opencode/skills/general/readme-writer.md` | README updates. |

## For Human Setup

If you are configuring a target project:

1. Put `AGENTS.md` in the project root.
2. Let the devkit copy the relevant Compose file on first container start.
3. Use the appropriate template folder under `templates/`.

If the target project already has `docker-compose.yml`, the devkit writes the template as `docker-compose-devkit.yml` instead.

For the migration template, the checklist lives at `docs/migration-progress-checklist.md`.

For humans, the container contents and environment variables live in `container-and-env.md`.
