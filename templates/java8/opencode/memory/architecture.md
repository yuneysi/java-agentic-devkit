# Project Architecture Snapshot

Last updated: 2026-06-21
Owner: Team

This is the initial seed created by java-agentic-devkit templates.
Replace generic items with target-project facts during the first implementation session.

## System Summary

- Primary runtime: Java 8
- Packaging: unknown
- Deployment target: Tomcat 9 or project-specific runtime
- Main business domains: unknown

## Module Map

| Module | Responsibility | Depends On | Exposes |
|--------|----------------|------------|---------|
| app-core | Main business logic (to confirm) | project libs | internal services |
| app-web | HTTP/JSP or API layer (to confirm) | app-core | endpoints/views |
| app-integration | External system adapters (to confirm) | app-core | SOAP/REST/JMS contracts |

## Runtime Entry Points

- HTTP: unknown (record servlet/controller entry points)
- Messaging: unknown (record JMS listeners and destinations)
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
- Runtime command(s): `use-java8`, `mvn clean package`, `start-tomcat9` (if WAR/Tomcat project)

## Known Risk Areas

- SOAP/XML contract drift
- JSP and Tomcat runtime behavior drift
- JMS retry/acknowledgement behavior drift
