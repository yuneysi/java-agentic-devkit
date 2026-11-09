---
name: legacy-spec-baseline
description: "Use this skill when a legacy project has no OpenSpec spec for a capability that a change will touch, or when the user asks to capture, document, or reverse-engineer the current behavior into openspec/specs/. Produces evidence-based baseline specs without changing code."
---

# Legacy Spec Baseline Skill

Use this skill before the first OpenSpec change that touches a capability without a spec in `openspec/specs/`, or when the user asks to capture the current behavior of a legacy project.

## Goal

Write the behavior that the system has today as OpenSpec specs, so that later changes are deltas against a verified baseline instead of guesses.

## Preconditions

- `openspec/` exists. If it does not exist, ask the user to run `openspec init --tools opencode,claude` first. Do not run it without approval, because it writes files into the project.
- Read `AGENTS.md`, `openspec/config.yaml`, and the existing specs in `openspec/specs/` before you scan code. In projects that keep `opencode/memory/` (the java21-migration template), also read `opencode/memory/architecture.md`.

## Scope One Capability At A Time

A capability is one cohesive behavior area that a reviewer can own, for example `order-soap-api`, `api-key-authentication`, `mfc-rules-query`, or `nightly-export-job`. Name it in kebab-case. Do not try to capture the whole system in one pass.

## Evidence Sources

Read only what defines observable behavior:

- Contracts: WSDL/XSD, OpenAPI, JMS destinations and message formats, database tables and constraints.
- Entry points: controllers, endpoints, listeners, schedulers, and filters.
- Behavior rules: validation, error mapping, security filters, and transaction boundaries.
- Existing tests: they are the strongest evidence of intended behavior.
- Configuration that changes behavior: Spring profiles, properties, and feature flags.

## Writing Rules

- Write `openspec/specs/<capability>/spec.md` with a `## Purpose` section and `## Requirements`.
- Write each requirement as `### Requirement: <name>` with a SHALL or MUST statement and at least one `#### Scenario:` that uses **WHEN** and **THEN** bullets.
- Under each requirement, cite the evidence as `path:line`.
- Describe observable behavior (inputs, outputs, errors, side effects), not implementation classes.
- Mark behavior that is inferred and not confirmed by a test or contract with "(unverified)". List these items under `## Open Questions`.
- Record known defects as current behavior with the note "(current behavior, possibly a defect)". Do not fix them in a baseline.
- Never copy secrets, API keys, passwords, hostnames of production systems, or personal data into specs.
- Do not modify production code, tests, or build files.

## Validation

1. Run `openspec validate <capability> --type spec --strict` and fix every finding.
2. Check every requirement against its cited evidence.
3. If there are no tests for a requirement, propose a characterization test for it (for example with `soap-contract-test-writer` or `jpa-characterization-test-writer`) and do not write the test in this skill.

## Memory Integration

Add one line per new capability to `opencode/memory/architecture.md` through the `project-architecture-memory-writer` skill, with a link to the spec. Do not copy requirements into memory.

## Required Output

Return:

1. Capabilities captured and their spec paths.
2. Validation result.
3. Requirements marked "(unverified)" and possible defects.
4. Suggested characterization tests.
