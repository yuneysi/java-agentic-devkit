# Privacy And Usage Metrics

## Privacy Model

This repository follows a privacy-safe default:

- no personal tracking scripts in repository content
- no telemetry in templates or skills
- no mandatory user-level identification for usage

## Third-Party Tool Telemetry

Some tools in the container image send anonymous usage telemetry by default. The devkit keeps these upstream defaults and documents them here:

| Tool | Default in the image | How to opt out |
| --- | --- | --- |
| oh-my-openagent | enabled (`"telemetry": true` in `opencode/omo.jsonc`) | set `"telemetry": false` in `~/.omo/omo.jsonc` or in the project `.omo/omo.jsonc` |
| Claude Code | enabled (upstream default) | set the `DISABLE_TELEMETRY=1` environment variable in the container |
| OpenSpec | enabled (upstream default; command names and version only, disabled in CI) | set `OPENSPEC_TELEMETRY=0` or run `openspec config set telemetry.enabled false` |

Opting out does not break any devkit functionality.

## What Can Be Measured (Aggregate)

- GitHub repository traffic analytics (views, clones)
- GitHub Container Registry pull counts by image tag

These metrics are platform-provided and aggregate by default.

## Optional Signals

If the devkit itself introduces telemetry in the future, it must be:

- opt-in
- documented before use
- removable without breaking core functionality

## Data Retention And Sharing

This repository does not define additional personal-data storage beyond platform defaults unless explicitly documented in future updates.
