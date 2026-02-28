# RALPH BUG LOOP (PSC)

You are running a single iteration of a Ralph bug loop for this repository.

## Mission
- Find and fix only real, reproducible bugs.
- Keep behavior/API contracts unchanged.
- Prefer minimal, production-safe patches.

## Hard Rules
- No speculative refactors.
- No new features.
- No circular dependencies.
- Do not break deterministic rule precedence:
  - `hard filters > source allow/block > topic priority > tone > length > ranking tweaks`
- Keep complexity at most linear unless unavoidable.

## Iteration Steps
1. Run checks:
   - `flutter pub get`
   - `flutter analyze`
   - `flutter test`
   - `node --check backend/pocketbase/pb_hooks/main.pb.js`
   - `bash backend/pocketbase/scripts/smoke_test.sh`
2. If **all pass**, make **no code changes** and return exactly:
   - `NO_BUGS`
3. If any check fails:
   - Identify root cause with file/line evidence.
   - Implement smallest fix.
   - Re-run failed checks (and any impacted checks).
   - If all then pass, return exactly:
     - `FIXED`

## Output Contract
- Output exactly one token at end: `NO_BUGS` or `FIXED`.
