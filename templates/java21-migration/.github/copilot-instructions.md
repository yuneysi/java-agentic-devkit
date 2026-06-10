# GitHub Copilot Instructions

This repository is being migrated from Java 8 to Java 21.

Preserve Java 8 behavior unless the user explicitly requests a behavior change.

Do not modernize production code for style reasons.

Do not perform broad refactors.

Prefer small, reviewable changes.

Before changing production code, prefer characterization or regression tests.

Pay special attention to:

- Spring Framework compatibility
- Tomcat 9 `javax.*` runtime
- Tomcat 11 `jakarta.*` runtime
- JSP behavior
- SOAP/XML contracts
- JAXB/Jakarta differences
- JMS behavior with ActiveMQ and IBM MQ
- JDBC behavior
- transaction boundaries
- date/time formatting
- timezone behavior
- locale behavior
- charset behavior
- BigDecimal formatting and rounding

Do not silently change:

- SOAP namespaces
- XML element order
- XML prefixes
- SOAPAction
- null vs empty XML elements
- JMS acknowledgement mode
- JMS retry behavior
- JMS transaction behavior
- SQL queries
- transaction boundaries
- date/time formatting
- BigDecimal formatting

Use Maven Wrapper when available:

```bash
./mvnw clean verify
```

Keep changes small and isolated.

For every suggested change, explain:

- why it is needed for Java 21
- migration risk
- files affected
- tests to run

---

# Recommended OpenCode prompts

## 1. Initial audit

```text
You are working on branch branch/java21.

Read AGENTS.md first and follow it strictly.

Inspect the project for Java 8 to Java 21 migration risks.

Do not modify files.

Focus on Maven, Java version configuration, Spring, Tomcat, JSP, SOAP/XML, JMS, JDBC, JAXB, and test setup.

Return a prioritized migration plan with small commits.
```

## 2. Build-only migration step

```text
Read AGENTS.md first and follow it strictly.

Update only the Maven build configuration required to compile with Java 21.

Do not upgrade application dependencies unless compilation requires it.

Do not modify production Java code.

Run the smallest relevant Maven validation command.

Report changed files, risk level, validation result, and proposed commit message.
```

## 3. Dependency audit

```text
Read AGENTS.md first and follow it strictly.

Audit dependencies for Java 21, Tomcat 11, Jakarta, SOAP/XML, JMS, JDBC, and test compatibility.

Do not modify files.

Group findings by risk.

For each dependency, report current version, recommended target version if known, reason, migration risk, and validation command.
```

## 4. SOAP characterization tests

```text
Read AGENTS.md first and follow it strictly.

Find SOAP/XML request and response generation code.

Do not modify production code.

Add characterization tests for existing Java 8 XML behavior using representative payloads.

Preserve namespaces, XML prefixes, element order, null vs empty elements, date/time formatting, and BigDecimal formatting.

Run only the relevant tests.

Report changed files, risk level, validation result, and proposed commit message.
```

## 5. Java 21 compilation fix

```text
Read AGENTS.md first and follow it strictly.

Fix only the current Java 21 compilation error.

Do not refactor unrelated code.

Do not modernize style.

Preserve Java 8 behavior.

Add or update tests only if the fix changes behavior or covers a migration risk.

Run the smallest relevant validation command.

Report changed files, risk level, validation result, and proposed commit message.
```

## 6. Review agent prompt

```text
Read AGENTS.md first and follow it strictly.

Review the current Git diff as a Java 8 to Java 21 migration auditor.

Do not modify files.

Check whether the diff preserves Java 8 behavior.

Classify migration risks.

Look specifically for SOAP/XML, JSP, JMS, JDBC, date/time, timezone, locale, charset, BigDecimal, dependency, and configuration risks.

Report blocking issues, non-blocking issues, missing tests, and whether the change is safe to commit.
```

---

# Suggested migration workflow

Use OpenCode / oh-my-opencode for the migration workflow:

```text
plan -> implement one small change -> test -> review -> commit
```

Use Copilot only inside the editor for narrow edits:

```text
generate this one test
explain this one compiler error
suggest this one Maven plugin config
convert this one class from javax to jakarta
```

Avoid asking Copilot:

```text
migrate this project to Java 21
```

That is too broad and likely to produce unsafe changes.

---

# First commit to make

```bash
git checkout feature/migrate_to_java21
git pull
git checkout -b branch/java21
```

Then:

```bash
mkdir -p .github docs scripts
cp /path/to/java-agentic-devkit/templates/java21-migration/AGENTS.md AGENTS.md
cp /path/to/java-agentic-devkit/templates/java21-migration/.github/copilot-instructions.md .github/copilot-instructions.md
cp /path/to/java-agentic-devkit/templates/java21-migration/docs/java21-migration.md docs/java21-migration.md
cp /path/to/java-agentic-devkit/templates/java21-migration/scripts/*.sh scripts/
chmod +x scripts/run-java8-baseline.sh scripts/run-java21-candidate.sh scripts/compare-behavior.sh
```

Commit:

```bash
git add AGENTS.md .github/copilot-instructions.md docs/java21-migration.md scripts/run-java8-baseline.sh scripts/run-java21-candidate.sh scripts/compare-behavior.sh
git commit -m "chore: add agent instructions for Java 21 migration"
```

This gives OpenCode, oh-my-opencode, and Copilot a shared migration contract before any code changes.