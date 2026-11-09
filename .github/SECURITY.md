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

The bundled headless Chromium for the Playwright MCP server follows the Playwright release that `@playwright/mcp` pins, so it can lag behind the newest Chrome security fixes. Use it only against local applications under test, not against untrusted websites. The `ecdsa` Python package, a transitive dependency of Checkov, has an advisory without an upstream fix; the devkit does not use it for cryptographic operations.

## Disclosure

Please allow time for validation and remediation before public disclosure.
