# Maintainer-Only Main Branch Ruleset (GitHub UI Runbook)

Use this runbook to ensure only the repository owner can update `main`.

## Objective

- block direct pushes to `main` from everyone except the maintainer
- require pull requests and checks
- prevent force-push and branch deletion

## Steps (GitHub)

1. Open repository **Settings** -> **Rules** -> **Rulesets**.
2. Create a new **Branch ruleset** for target branch `main`.
3. Enable:
   - Require a pull request before merging
   - Require status checks to pass before merging
   - Block force pushes
   - Block branch deletion
4. Enable **Restrict updates** / **Restrict who can push** and allow only your GitHub user.
5. Save and verify by testing with a non-maintainer account or token.

## Recommended Add-ons

- Require signed commits (optional)
- Require linear history (optional)
- Require conversation resolution before merge (recommended)

## Notes

Repository files cannot enforce push restrictions alone; this must be configured in GitHub settings.
