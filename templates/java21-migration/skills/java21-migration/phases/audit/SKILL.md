# Migration Audit Phase

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
2. Trace every implemented slice to its decision, diff, gates, and evidence.
3. Confirm every applicable high-risk area has explicit validation coverage or accepted residual risk.
4. Identify unresolved risks with severity, owner, next action, and due condition.
5. State exactly one recommendation: `Go`, `Go with conditions`, or `No-go`.
6. Record final status in `opencode/memory/status.md`.

## Exit criteria

- audit summary is reproducible from stored evidence,
- residual risks and release conditions are explicit,
- recommendation is unambiguous and actionable.
