# Security Policy

## Supported Scope

This repository distributes:

- Docker-based Java development tooling
- project templates
- OpenCode/oh-my-openagent configuration and skills

Security reports are accepted for all repository content and published container images.

## Supported Versions

| Version | Supported |
| --- | --- |
| `ghcr.io/yuneysi/java-agentic-devkit:latest` and the newest `0.1.<run>` tag | Yes |
| Older `0.1.<run>` tags | No. Pull the newest tag; the image is rebuilt weekly with security updates. |

## Reporting A Vulnerability

Please do not open public issues for potential vulnerabilities.

Use one of these private channels:

1. GitHub private vulnerability reporting (preferred): https://github.com/yuneysi/java-agentic-devkit/security/advisories/new
2. Maintainer contact via repository owner profile

Include:

- affected file(s), image tag(s), or workflow(s)
- reproduction steps
- impact assessment
- suggested remediation if available

## Response Targets

- Initial acknowledgment: within 5 business days
- Triage decision: within 10 business days
- Remediation timeline: communicated after triage

## Supply Chain Practices

- GitHub Actions are pinned to full commit SHAs, and Dependabot proposes updates.
- The base image is pinned by digest. Tools and packages are pinned to exact versions.
- Downloads are verified: Temurin JDKs by the published SHA-256, and Apache Maven, Tomcat, and ActiveMQ by their `.sha512` files.
- Every image build is scanned with Grype. The fixable findings are published in the workflow summary and as a build artifact.
- Published images carry build provenance and an SBOM attestation. Verify an image with `gh attestation verify oci://ghcr.io/yuneysi/java-agentic-devkit:latest --owner yuneysi`.
- The Docker socket is not mounted by default, so AI agents in the container cannot control the host Docker engine unless a user opts in.

## Known Residual Findings

A Grype scan of the image on 2026-11-09 reported 6 critical and 23 high findings, down from 398 critical and 1,460 high before the hardening release. The remaining findings are:

| Component | Findings | Status |
|---|---|---|
| `grype` 0.121.0 and `syft` 1.55.0 binaries (Go stdlib 1.26.8, `brotli`, `go-jose`, `compress`) | 6 critical, 20 high | Fixed in releases published in November 2026. The devkit adopts a release after it has been public for 14 days, so the pins move to the fixed versions on the next update after 2026-11-19. The tools only run when you invoke them. |
| Guava 33.6.0 in Maven 3.9.16 | 1 high | Fixed in Guava 33.7.2. It ships inside the Maven distribution and is updated with the next Maven release. |
| `ecdsa` (transitive dependency of Checkov) | 1 high | No upstream fix. The devkit does not use it for cryptographic operations. |

The bundled headless Chromium for the Playwright MCP server follows the Playwright release that `@playwright/mcp` pins, so it can lag behind the newest Chrome security fixes. Use it only against local applications under test, not against untrusted websites.

## Disclosure

Please allow time for validation and remediation before public disclosure.
