# JPA Characterization Test Writer Skill

Use this skill when the user asks to create or improve JPA/Hibernate tests for a Java 8 to Java 21 migration.

## Goal

Create characterization tests that prove Java 21 preserves the current Java 8 persistence behavior.

Java 8 is the behavioral source of truth.

## Rules

- Do not modify production code unless a failing characterization test proves a behavioral regression.
- Do not change entity mappings without explicit approval.
- Do not change transaction boundaries without tests.
- Do not change SQL, JPQL, HQL, or native queries without tests.
- Prefer deterministic test data.
- Test exact behavior, not only that data exists.
- Report database or dialect differences explicitly.

## Inspect For

- `javax.persistence.*`
- `@Entity`
- `@Table`
- `@Column`
- `@Id`
- `@GeneratedValue`
- `@OneToMany`
- `@ManyToOne`
- `@ManyToMany`
- `@OneToOne`
- `@Query`
- `EntityManager`
- `JpaRepository`
- `CrudRepository`
- `JdbcTemplate`
- Hibernate-specific annotations.
- Native queries.
- Named queries.
- Transaction annotations.

## Useful Search Commands

```bash
rg "javax\.persistence|@Entity|@Table|@Column|@Repository|JpaRepository|CrudRepository|EntityManager|@Query"
rg "NamedQuery|NativeQuery|createQuery|createNativeQuery|@Transactional"
rg "Hibernate|FetchType|CascadeType|orphanRemoval|LockMode|Version"
```

## Test Areas

Create tests for:

- Custom JPQL/HQL queries.
- Native SQL queries.
- Entity relationships.
- Lazy loading behavior.
- Eager loading behavior.
- Cascade behavior.
- Orphan removal.
- Pagination.
- Sorting.
- Enum mapping.
- Date/time column mapping.
- BigDecimal column mapping.
- Null handling.
- Transaction boundaries.
- Flush behavior.
- Dirty checking.
- Optimistic locking.
- Database dialect behavior.

## Test Quality Rules

Tests should verify:

- Exact result count.
- Exact ordering.
- Exact field values.
- Boundary cases.
- Empty results.
- Null behavior.
- Transaction behavior.
- Lazy loading expectations.

Avoid tests that only verify that a query returns “something”.

## Database Strategy

Prefer the same database engine as production.

If Testcontainers is available, prefer it.

If using H2 or another substitute database, document the difference and do not assume it proves production database behavior.

## Required Output

When writing tests, provide:

- Files added or changed.
- Entities and repositories covered.
- Queries covered.
- Fixtures added.
- Commands to run the tests.
- Remaining persistence risks.
