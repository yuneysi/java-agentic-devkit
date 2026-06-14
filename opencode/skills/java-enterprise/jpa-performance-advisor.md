# JPA Performance Advisor Skill

Use this skill when the user asks to optimize JPA queries, find N+1 problems, review entity mappings, or troubleshoot lazy loading issues.

## Goal

Analyze JPA entities, repositories, and service-layer code for performance issues. Detect N+1 queries, unnecessary eager fetching, missing indexes, and transaction scope problems. Provide actionable fixes.

## Rules

- Do not modify production code without approval. Report findings first.
- Do not suggest schema changes without understanding the database (indexes, constraints, data volume).
- Distinguish between real performance problems and premature optimization.
- If the project uses query logging, enable it for analysis: `spring.jpa.show-sql=true` or a log-level change.

## Context Needed

- Entity classes — `rg "@Entity" --type java`
- Repository interfaces or `EntityManager` usage
- Service methods that call repositories in loops
- Known database volume (rows per table, joins, query complexity)

## Inspect / Search

### Find N+1 candidates

```bash
# Find looped repository calls
rg "for.*:" --type java -A2 | rg "repository\.\|\.find\|\.get\|\.findAll" -B2

# Find @OneToMany and @ManyToMany — default fetch is LAZY but could be EAGER
rg "@OneToMany\|@ManyToMany" --type java -A5
rg "FetchType" --type java

# Find explicit fetch joins (good sign)
rg "JOIN FETCH\|@EntityGraph\|@Query.*fetch" --type java
```

### Find transaction issues

```bash
# Check @Transactional coverage
rg "@Transactional" --type java -B2

# Find EntityManager operations outside transactions
rg "entityManager\|em\.persist\|em\.merge\|em\.find\|em\.remove" --type java -B5 | grep -B5 "@Transactional"
```

### Find query performance issues

```bash
# Find custom @Query definitions
rg "@Query" --type java -A3

# Find count queries
rg "count\|COUNT" --type java | rg "Query\|@Query\|criteria\|Specification"
```

## Required Output

Return:

1. **N+1 queries detected**: list each loop-repository pattern with file, line, and entity pair
2. **Fetching strategy issues**: eager fetching that should be lazy, or lazy that causes N+1
3. **Transaction scope problems**: missing `@Transactional`, too-wide transactions, `LazyInitializationException` risks
4. **Query optimization opportunities**: missing `JOIN FETCH`, cartesian products, unused fetched data
5. **Recommended fixes** for each issue, prioritized by expected impact
6. **Validation command** to verify the fix doesn't break existing tests

## Validation

```bash
# Enable SQL logging
./mvnw spring-boot:run -pl <module> -Pdev -Dspring.jpa.show-sql=true > /tmp/sql-log.log 2>&1 &

# Run a test that exercises the affected code
./mvnw test -pl <module> -Dtest=AffectedServiceTest

# Count SQL statements per operation
grep "Hibernate:" /tmp/sql-log.log | wc -l
```

## Final Rule

One N+1 bug in a loop over 1000 rows generates 1001 SQL queries. Fix the loop before optimizing the query.
