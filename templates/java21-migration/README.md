# Java 8 To Java 21 Migration Guide

This template is for Java 8 to Java 21 migration work. Use it when you want the migration instructions, checklist, and validation flow in one place.

If you are using the devkit container, the template provides `AGENTS.md`, a Compose file, and `docs/migration-progress-checklist.md`.

## Docker Compose

On first container start, the devkit copies the template Compose file into the target project:

- `docker-compose.yml` if the target project does not already have one.
- `docker-compose-devkit.yml` if the target project already has `docker-compose.yml`.

The `Publish DevKit Image` GitHub Actions workflow builds and publishes the image automatically after changes are pushed to `main`.

Published tags:

| Tag | Meaning |
|-----|---------|
| `ghcr.io/yuneysi/java-agentic-devkit:0.1.<n>` | Immutable incrementing build tag for each workflow run. Recommended for migration Compose files. |
| `ghcr.io/yuneysi/java-agentic-devkit:latest` | Latest published image. |

The example below starts the target project in `java21-migration` mode. On macOS, keep `platform: linux/amd64` so Docker Desktop runs the published image with the expected Linux AMD64 platform. On Windows PCs, remove `platform: linux/amd64` from the Compose file.

```yaml
services:
  devkit:
    image: ghcr.io/yuneysi/java-agentic-devkit:0.1.1
    working_dir: /workspace
    environment:
      DEVKIT_PROJECT_DIR: /workspace
      DEVKIT_JAVA_TEMPLATE: java21-migration
      MAVEN_OPTS: -Dmaven.repo.local=/home/vscode/.m2/repository
    volumes:
      - .:/workspace
      - ${HOME}/.m2:/home/vscode/.m2
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - "8080:8080"
      - "5005:5005"
      - "61616:61616"
      - "8161:8161"
    stdin_open: true
    tty: true
    command: /bin/bash
```

If the Compose file lives in a subdirectory such as `.devcontainer/`, use `..:/workspace` instead of `.:/workspace`.

The copied template includes the `devkit` service, so you only need to keep project-specific paths and ports.

**Workflow**:
1. Host: `docker compose up -d` -> container starts
2. Host: `docker compose exec devkit bash` -> enter the container
3. Inside container: all tools available (Java 21, Maven, OpenCode, OhMyOpenCode)
4. All build/test commands run inside the container

On Windows, when running Compose from PowerShell or Command Prompt, use the `USERPROFILE` environment variable through Compose interpolation instead of `${HOME}`:

```yaml
    volumes:
      - .:/workspace
      - ${USERPROFILE}/.m2:/home/vscode/.m2
      - /var/run/docker.sock:/var/run/docker.sock
```

When running from Git Bash or WSL, `${HOME}/.m2:/home/vscode/.m2` usually works as shown in the main example.

Use one of these values for `DEVKIT_JAVA_TEMPLATE` in the Compose `environment` block:

| Value | Use when |
|-------|----------|
| `java8` | The project runs on Java 8. |
| `java21` | The project already runs on Java 21. |
| `java21-ak4` | The project already runs on Java 21 and needs Redis. |
| `java21-migration` | The project is migrating from Java 8 to Java 21 and needs the Java 8 baseline first. |

### VS Code

If the target project uses VS Code Dev Containers, add `.devcontainer/devcontainer.json`:

```json
{
  "name": "Java Agentic DevKit",
  "dockerComposeFile": "../docker-compose.yml",
  "service": "devkit",
  "workspaceFolder": "/workspace"
}
```

Then run `Dev Containers: Reopen in Container` from VS Code.

### IntelliJ IDEA

For IntelliJ IDEA, keep `docker-compose.yml` in the target project root and start the devkit from IntelliJ's terminal or any host terminal:

```bash
docker compose pull
docker compose run --rm devkit
```

For the recommended Compose file in this template, the service name is `devkit`. If the target project uses `devkit-arus` or another service name, the `docker-compose.yml` must define that exact service under `services:`.

Inside the container, run project commands from `/workspace`, such as `mvn clean verify` or `opencode`.

The `java21-migration` mode starts with Java 8 so the team can capture the Java 8 behavioral baseline before validating the Java 21 candidate.

The `java21-ak4` mode starts with Java 21 and the Redis service from the `templates/java21-ak4/` compose template.

On first start, the container preserves existing files. Existing files are not overwritten.

## Phase 0: Prerequisites

- Decide Java 21 JDK distribution and path.
- Decide Maven version.
- Identify parent POM and child modules.
- Check parent POM `<build><plugins>` because those bindings override `<pluginManagement>`.

## Phase 1: OpenCode Setup

- Install OpenCode.
- Configure `~/.config/opencode/opencode.json`.
- Configure `~/.config/opencode/oh-my-opencode.jsonc`.
- Use the migration skills shipped in `opencode/skills/java21-migration/`.
- Create `AGENTS.md` in the project root from the template in this repository.
- Create `docs/migration-results/`.

`AGENTS.md` is the source of truth for agent behavior. Its rules should make it clear which skill to use for each step, so the agent can pick the right skill automatically without extra prompting.

## Phase 2: Java 8 Baseline

- Run with Java 8.
- Save full output to `docs/migration-results/java8-baseline/compile-and-test-output.log`.
- Record test count, coverage, known issues, and framework versions.

For the baseline step, the migration rules in `AGENTS.md` should already point the agent to `java8-baseline-capture-phase`.

## Phase 3: Root POM Migration

- Set Java 21 compiler settings.
- Update compiler, surefire, failsafe, PMD, dependency, JaCoCo, git-commit-id, and spring-boot plugin settings.
- Replace javax dependencies with Jakarta equivalents where required.
- Keep JAXB-generated `javax.xml.bind` code if the generator still emits it.

## Phase 4: Source Migration

- Migrate hand-written `javax.*` namespaces to `jakarta.*`.
- Do not migrate JDK-built-in `javax.*` packages.
- Respect the JAXB namespace split.
- Replace springfox with springdoc where needed.

## Phase 5: Test Fixes

- Update tests that assert blank 4xx bodies to expect Problem Details JSON.
- Adjust `JAXBElement` imports when they must match generated code.
- Replace deprecated `@MockBean` when convenient.

## Phase 6: Full Build Verification

- Run `JAVA_HOME=/opt/java/jdk21 ./mvnw clean verify`.
- Compare test count and coverage against the baseline.
- Save output under `docs/migration-results/java21-candidate/`.

## Phase 7: Documentation And Final Checks

- Update `AGENTS.md` if needed.
- Update `README.md` with the current migration state.
- Run final audit and verify no unsupported `javax.*` imports remain in hand-written code.

## Phase 8: Commit Strategy

- Keep commits atomic and independently buildable.

## Reference

For the checklist, use `docs/migration-progress-checklist.md`.
