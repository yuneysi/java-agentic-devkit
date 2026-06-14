# Code Reviewer Skill

Use this skill when the user asks to review code changes, review a pull request, or audit a diff for quality and risk.

## Goal

Review the diff for bugs, behavioral regressions, security issues, and Jakarta EE / Spring Boot 3 correctness. Report findings by severity. Do not approve changes that break tests or introduce risk.

## Rules

- Read the diff first (`git diff` or `git diff <branch>...HEAD`). Understand scope before diving into files.
- Check Jakarta EE namespace: new code must use `jakarta.*`, not `javax.*`.
- Check Spring Boot 3 error response handling — tests must handle RFC 7807 Problem Details JSON.
- Check JPA for N+1, lazy loading outside transaction, missing `@Transactional`.
- Check SOAP/XML for namespace drift, element order changes, SOAPAction changes.
- Check JMS for concurrency settings, redelivery config, transaction boundaries.
- Order findings: bugs > regressions > security > risk > style > naming.
- If a finding is uncertain, flag it as `needs investigation` — do not guess.

## Context Needed

- `git diff --stat` — what files changed
- For PR review: the PR description, base branch, and related issue
- Knowledge of the project's risk areas (SOAP, JPA, JMS, REST)

## Inspect / Search

### For code reviews

```bash
git diff <base-branch>...HEAD --stat
git diff <base-branch>...HEAD
git log <base-branch>..HEAD --oneline
```

### For security

```bash
rg "password|secret|token|apiKey|certificate|keystore|truststore" --type java
rg "@Value|@ConfigurationProperties|Environment.getProperty" --type java
rg "ProcessBuilder|Runtime\.exec|Runtime\.getRuntime" --type java
```

### For JPA risks

```bash
rg "@OneToMany|@ManyToMany|FetchType" --type java
rg "for.*\.get\|while.*\.get\|stream.*\.get" --type java
rg "EntityManager|em\.find|em\.merge|em\.persist" --type java
```

### For SOAP/XML risks

```bash
rg "SOAPAction|@XmlElement|@XmlRootElement|namespace" --type java
rg "JAXBElement|ObjectFactory|Marshaller|Unmarshaller" --type java
```

## Required Output

Return a review with sections:

1. **Summary**: what changed, how many files, risk level
2. **Bugs** (if any): what breaks, why, how to fix
3. **Behavioral risks**: Jakarta EE issues, SB3 error handling, SOAP contract changes
4. **Security risks**: credentials, injection, deserialization, file handling
5. **Performance risks**: N+1 queries, missing indexes, unnecessary object creation
6. **Style / maintainability** (minor): naming, logging, dead code, duplication
7. **Open questions**: things that need human confirmation

Each finding should reference the file and line number.

## Final Rule

A review is not complete until bugs are reported before style suggestions. Style without correctness is noise.
