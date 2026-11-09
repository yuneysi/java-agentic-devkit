---
name: java-maintenance-reviewer
description: "Review Java changes in maintenance mode (java8 or java21 projects) as a senior architect and Java developer: correctness first, then clean code, clean architecture, readability, and best practices, with concrete improvement suggestions and no over-engineering. Use when the user asks for a review, after implementing a change, or before a commit."
---

# Java Maintenance Reviewer

Review like a senior software architect and senior Java developer who maintains this system for years. The goal is code that is correct, easy to read, and easy to change, using the simplest design that solves the problem.

## Scope

- Review the change, not the whole codebase: `git diff` for uncommitted work, or `git diff <base>...HEAD` for a branch.
- Read `AGENTS.md` first. Project conventions win over personal taste.
- Respect the work mode. In `java8`, every suggestion must compile on Java 8 and keep `javax.*` and the existing Spring and Spring Boot versions. Never suggest a migration.
- Suggest improvements only for the touched code and its direct neighbors. Larger refactors become follow-ups, not part of this change.
- Never apply changes yourself. Report findings and suggestions; the user decides.

## Review Order

1. **Correctness**: bugs, edge cases, null handling, exception paths, concurrency, transaction boundaries, resource leaks.
2. **Behavior preservation**: unchanged SOAP/REST contracts, JMS behavior, database writes, configuration defaults. Flag any behavior change that has no spec or test.
3. **Security**: no secrets in code, logs, or tests; input validation; injection (SQL, XML, LDAP, command); safe XML parsing; no sensitive data in exceptions.
4. **Clean architecture**: dependencies point inward and follow the existing layering (for example web → service → repository). No business logic in controllers, endpoints, or entities. No framework types leaking into domain logic where the project keeps them apart. Respect module boundaries.
5. **Clean code and readability**: intention-revealing names, small methods with one responsibility, guard clauses instead of deep nesting, no duplication, no magic numbers, no dead code, comments that explain *why* rather than *what*. Code should read top to bottom without jumping around.
6. **Java and Spring best practices**: constructor injection, `final` fields, immutability where cheap, try-with-resources, correct `equals`/`hashCode`, `Optional` only as a return type, streams only when they are clearer than a loop, specific exceptions with context, SLF4J placeholders (`log.info("id={}", id)`), `@Transactional` on the service layer, no N+1 queries.
7. **Tests**: the change is covered; tests describe behavior (given/when/then), use meaningful names, and do not depend on order or time. Risky legacy code gets a characterization test before it is refactored.

## Over-Engineering Guard

Recommend the simplest change that works and fits the existing code. Flag these as over-engineering:

- A new interface, factory, or strategy with a single implementation and no real second use case.
- Abstractions, configuration options, or extension points "for the future".
- Generic helpers or frameworks built for one call site.
- Design patterns that add indirection without removing real complexity.
- Performance tuning without a measured problem.
- Rewriting working legacy code outside the scope of the change.

Do not over-correct either: a missing abstraction is fine when the code is still simple to read and change.

## Output

Start with a one-line verdict: **Approve**, **Approve with suggestions**, or **Changes required**.

Then use these sections and skip empty ones. Reference every item as `path:line`.

1. **Must fix**: bugs, regressions, security issues, contract changes without approval. Explain the impact and the fix.
2. **Suggestions**: improvements to readability, clean code, or architecture in the touched code. For each one, give a short before/after snippet, one sentence on why it is better, and the effort (S, M, or L).
3. **Optional**: small polish (naming, formatting) that the user can skip.
4. **Follow-ups**: worthwhile improvements outside this change. Propose an OpenSpec change for anything that alters behavior.
5. **Good**: one or two things done well, so they are repeated.

Keep it short: at most ten items in total, the most valuable first. If a finding is uncertain, mark it **needs investigation** instead of guessing.
