# Java 21 Candidate Validation Phase Skill

Use this skill when all migration steps are applied and the user asks to validate the Java 21 candidate against the Java 8 baseline.

## Goal

Prove the Java 21 candidate is behaviorally equivalent to the Java 8 baseline, classify all meaningful differences, document risk, and produce a go/no-go recommendation. If any behavioral regression is found, reject the candidate and report what must be fixed.

## Rules

- Read `docs/migration-results/java8-baseline/baseline-summary.md` first. Compare against raw baseline output files, not memory.
- Do not modify production code or tests during evaluation.
- Classify every difference between Java 8 and Java 21 as: `safe migration`, `behavioral risk`, or `regression`.
- If a difference is not understood, flag it as `needs investigation` — do not silently accept it.
- Track the `AgisControllerTest`/`MfcControllerTest` pattern: SB3 changes error response format to Problem Details JSON. Tests must match.

## Context Needed

Before this skill runs, it needs:

- `docs/migration-results/java8-baseline/baseline-summary.md` — baseline metrics and behavioral notes
- `docs/migration-results/java21-candidate/compile-and-test-output.log` — candidate build output
- `docs/migration-results/java21-candidate/migration-step-summary.md` (if exists) — migration record
- Git diff against baseline — `git diff --stat <baseline-branch>...HEAD`
- Knowledge of which behavior changes are expected (e.g., SB3 Problem Details JSON, `@ApiParam` -> `@Parameter`)

## Inspect / Search

Review these areas for behavioral differences:

- Test count: match exactly with baseline. If count differs, find missing or extra tests.
- Coverage: within 1% of baseline. If lower, find why (tests not running, JaCoCo config changed).
- Build output: any new warnings or errors (PMD, Checkstyle, dependency analysis).
- Java source diff: `git diff <baseline-branch>...HEAD -- '**/*.java'` — check for unexpected logic changes.
- POM diff: `git diff <baseline-branch>...HEAD -- pom.xml` — check for unintended dependency changes.
- Error response format: run each endpoint and capture the error body. SB3 returns Problem Details JSON.
- SOAP/XML: compare SOAP request/response XML samples. Check namespaces, element order, SOAPAction.

### Recommended search commands

```bash
# Compare test counts
grep "Tests run:" docs/migration-results/java8-baseline/compile-and-test-output.log
grep "Tests run:" docs/migration-results/java21-candidate/compile-and-test-output.log

# Find behavioral changes in java files
git diff <baseline-branch>...HEAD -- '**/*.java' | rg "^[+-]" | rg -v "^[+-]{3}" | rg -v "import " | head -100

# Check for remaining javax imports
rg "javax\." --type java | grep -v "generated" | grep -v "javax\.xml\.bind"

# Compare dependency trees
diff <(grep "BUILD\|Tests run:\|Coverage" docs/migration-results/java8-baseline/compile-and-test-output.log) <(grep "BUILD\|Tests run:\|Coverage" docs/migration-results/java21-candidate/compile-and-test-output.log)
```

## Required Output

Return:

1. Build status and test comparison against baseline (same count? same pass rate?)
2. All behavioral differences classified as safe, risk, or regression — with evidence for each
3. Go/No-Go recommendation with justification
4. If GO: the final commit message for documentation
5. If NO-GO: specific items that must be fixed before next evaluation

## Validation

```bash
# Run full candidate build
JAVA_HOME=/opt/java/jdk21 ./mvnw clean verify 2>&1 | tee docs/migration-results/java21-candidate/compile-and-test-output.log

# Compare with baseline
echo "=== Baseline ===" && grep "Tests run:" docs/migration-results/java8-baseline/compile-and-test-output.log
echo "=== Candidate ===" && grep "Tests run:" docs/migration-results/java21-candidate/compile-and-test-output.log
```

## Final Rule

A migration is not safe because it compiles. It is safer only when the Java 21 branch passes the same behavioral tests that describe Java 8 production behavior and every classified difference is documented and accepted.
