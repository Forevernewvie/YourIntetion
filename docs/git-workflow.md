# Git Workflow

## Branch Strategy
- `main`: protected, release-ready only.
- `feat/*`: new product capability.
- `fix/*`: bug fixes.
- `chore/*`: repository/tooling/maintenance.
- `perf/*`: algorithmic/performance work.
- `codex/*`: AI-assisted short-lived branches.

## Recommended Working Model
- Create feature branch from `main`.
- Keep PR scope small and reviewable.
- Rebase or merge `main` before opening/merging PR.
- Use squash merge only to keep `main` history clean.

## Commit Convention
- Use Conventional Commits:
  - `feat: ...`
  - `fix: ...`
  - `perf: ...`
  - `chore: ...`
  - `docs: ...`
  - `ci: ...`
- Keep subject line imperative and concise.

## PR Policy
- No direct push to `main`.
- Required checks:
  - formatting
  - static analysis
  - test suite
- PR must include:
  - change summary
  - risk/rollback notes
  - test evidence

## Merge Policy
- Squash merge only.
- Delete branch after merge.
- If CI fails, do not merge.
