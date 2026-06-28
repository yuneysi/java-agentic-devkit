# Contributing Guide

Thanks for your interest in contributing.

## Ground Rules

- Keep changes small and focused.
- Open an issue first for large or architectural changes.
- Follow the repository `AGENTS.md` and template-level `AGENTS.md` rules.
- Use English for repository-facing content.

## Pull Requests

- Use a feature branch (do not target direct pushes to `main`).
- Explain what changed, why, and how you validated it.
- Include screenshots/logs only when they add review value.

## Validation Expectations

- JSON changes: validate with `jq` when available.
- Shell script changes: run `bash -n` on touched scripts.
- Dockerfile changes: run the cheapest relevant check (for example `docker build --check`).

## Licensing

By contributing, you agree your contributions are licensed under this repository's MIT License.
