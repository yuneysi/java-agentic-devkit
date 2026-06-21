# Project Architecture Snapshot

Last updated: 2026-06-21
Owner: Team

This is the initial migration seed created by java-agentic-devkit templates.
Replace generic items with target-project facts during the first migration session.

## Migration Context

- Migration mode: Java 8 to Java 21
- Baseline runtime: Java 8
- Candidate runtime: Java 21
- Deployment target: project-specific (Tomcat/Spring Boot/other)

## System Summary

- Packaging: unknown
- Main business domains: unknown
- Most critical compatibility areas: REST/SOAP/JMS/JPA/JSP contracts (to confirm)

## Module Map

| Module | Responsibility | Baseline Risk | Candidate Risk |
|--------|----------------|---------------|----------------|
| app-core | Main business logic (to confirm) | medium | medium |
| app-web | HTTP/API/UI layer (to confirm) | medium | high |
| app-integration | External adapters (to confirm) | high | high |

## Runtime Entry Points

- HTTP: unknown
- Messaging: unknown
- Batch/Scheduled: unknown
- SOAP/XML: unknown

## Data Layer

- Main stores: unknown
- Access layer: unknown
- Transaction boundaries: unknown

## External Integrations

| Integration | Type | Direction | Contract/Risk Notes |
|-------------|------|-----------|---------------------|
| TBD | TBD | TBD | Capture behavior contract before migration changes |

## Build And Validation

- Java 8 baseline command: `JAVA_HOME=/opt/java/jdk8 mvn clean verify`
- Java 21 candidate command: `JAVA_HOME=/opt/java/jdk21 mvn clean verify`
- Evidence paths: `docs/migration-results/java8-baseline/`, `docs/migration-results/java21-candidate/`

## Known Risk Areas

- Jakarta namespace mismatch in handwritten code
- Spring Boot 3 behavior changes (if applicable)
- Contract drift in REST/SOAP/JMS integrations
