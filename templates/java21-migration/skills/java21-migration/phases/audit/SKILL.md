# java21-migration-audit phase skill

## Responsibility

Produce migration sign-off quality evidence and a clear go/no-go recommendation.

## Inputs

- baseline evidence
- planning decisions and slice history
- implementation logs
- validation outputs and remaining risks

## Outputs

- migration audit summary
- unresolved risk register with owners and next actions
- go/no-go recommendation with conditions

## Mandatory steps

1. Verify baseline, plan, implementation, and validation artifacts are consistent.
2. Confirm every high-risk area has explicit validation coverage.
3. Identify unresolved risks and required follow-up.
4. State go/no-go recommendation and conditions transparently.
5. Record final status in `opencode/memory/status.md`.
6. Update `docs/migration-progress-checklist.md` with audit phase status.

## Exit criteria

- audit summary is reproducible from stored evidence,
- residual risks are explicit,
- recommendation is unambiguous and actionable.
