# Project Architecture Snapshot

Last updated: not initialized
Owner: unassigned

Template state: initialization required.

Replace this seed with verified target-project facts before starting the migration. Keep unknowns explicit; do not infer modules or integrations from this template.

## Migration Context

- Migration mode: Java 8 to Java 21
- Baseline runtime: Java 8
- Candidate runtime: Java 21
- Deployment target: unknown

## System Summary

- Packaging: unknown
- Main business domains: unknown
- Most critical compatibility areas: unknown

## Module Map

| Module | Responsibility | Baseline Risk | Candidate Risk |
|--------|----------------|---------------|----------------|
| Unknown | Inspect project build structure | unknown | unknown |

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

- Unknown until project inspection.
