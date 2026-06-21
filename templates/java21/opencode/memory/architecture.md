# Project Architecture Snapshot

Last updated: 2026-06-21
Owner: Team

This is the initial seed created by java-agentic-devkit templates.
Replace generic items with target-project facts during the first implementation session.

## System Summary

- Primary runtime: Java 21
- Packaging: unknown
- Deployment target: Tomcat 11, Spring Boot, or project-specific runtime
- Main business domains: unknown

## Module Map

| Module | Responsibility | Depends On | Exposes |
|--------|----------------|------------|---------|
| app-core | Main business logic (to confirm) | project libs | internal services |
| app-web | HTTP/API layer (to confirm) | app-core | endpoints/views |
| app-integration | External adapters (to confirm) | app-core | REST/SOAP/JMS contracts |

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
| TBD | TBD | TBD | Capture contract and compatibility risk before changes |

## Build And Run

- Build command: `mvn clean verify`
- Narrow test command: `mvn -Dtest=ClassNameTest test`
- Runtime command(s): `use-java21`, `mvn clean verify`, `start-tomcat11` (if Tomcat project)

## Known Risk Areas

- Jakarta namespace mismatch in handwritten code
- Spring Boot 3 behavior changes
- API contract drift (REST/SOAP/JMS)
