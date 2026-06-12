# Java 8 Human Checklist

Use this checklist during human review of Java 8 maintenance work.

## Project Setup

- [ ] The work was done in the standard devkit container or an equivalent documented environment.
- [ ] The active runtime is Java 8.
- [ ] Maven Wrapper was used when available.
- [ ] The current branch is the intended working branch.

## Java 8 Compatibility

- [ ] No Java language feature newer than Java 8 was introduced.
- [ ] No Java API newer than Java 8 was introduced.
- [ ] Collection factory usage remains Java 8 compatible.
- [ ] Stream, Optional, file, and HTTP APIs remain Java 8 compatible.
- [ ] The code follows existing project patterns.

## Change Review

- [ ] The change is small and focused.
- [ ] Unrelated refactors were avoided.
- [ ] Formatting-only churn was avoided.
- [ ] Existing behavior is preserved unless a behavior change was approved.
- [ ] Risky behavior is covered by a test or documented validation.

## Testing

- [ ] The narrowest relevant test was run first.
- [ ] Broader validation was run when shared behavior, dependencies, runtime wiring, public APIs, persistence, or security were affected.
- [ ] Test failures are documented.
- [ ] Tests that could not be run are listed with the command to run later.

## Enterprise Java Review

- [ ] SOAP/XML contracts were checked when touched.
- [ ] JAXB marshalling or unmarshalling behavior was checked when touched.
- [ ] JMS acknowledgement, retry, redelivery, listener concurrency, and transaction behavior were checked when touched.
- [ ] JDBC SQL, transaction boundaries, isolation, connection handling, and generated keys were checked when touched.
- [ ] JPA lazy loading, flush behavior, and transaction scope were checked when touched.
- [ ] JSP, servlet, tag library, and container behavior were checked when touched.
- [ ] Spring profiles, bean lifecycle, and property resolution were checked when touched.
- [ ] Date, time, timezone, locale, charset, and `BigDecimal` behavior were checked when touched.
- [ ] Logging used by monitoring or operations was preserved or intentionally updated.

## Dependency Review

- [ ] Dependency changes have a clear reason.
- [ ] Dependency changes are compatible with Java 8.
- [ ] Dependency changes are isolated from application code changes when possible.
- [ ] Runtime behavior risk was reviewed.
- [ ] Validation evidence is recorded.

## Security And Errors

- [ ] No secrets, tokens, passwords, personal data, or large payloads were added to logs.
- [ ] Exception causes are preserved.
- [ ] Authentication, authorization, TLS, CORS, CSRF, deserialization, file handling, and external command execution were reviewed when touched.

## Final Human Review

- [ ] `git diff` was reviewed.
- [ ] `git status` is understood.
- [ ] The commit is focused on one logical change.
- [ ] Validation results are ready to include in the commit or pull request notes.
