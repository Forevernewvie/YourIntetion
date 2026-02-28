# RALPH LOOP PROMPT (Project: Preference Summary Curator)

You are running in **RALPH LOOP mode** for this repository.

## Project Context
- Repo: `/Users/jaebinchoi/Desktop/VibeCodingExpert`
- Stack: Flutter (Dart 3.x) + PocketBase (`backend/pocketbase`)
- Core principles:
  - Deterministic behavior (no circular logic).
  - Explainable output and traceable sources.
  - API/DTO contract stability.

## Non-Negotiable Quality Rules
- Prioritize scalability and maintainability.
- Follow SOLID and object-oriented design.
- Keep structures testable (dependency separation / injection-friendly).
- Include concise purpose comments for non-obvious functions.
- Analyze and handle error-prone paths.
- Consider security risks (validation, secrets, safe logs).
- Consider bottlenecks (network, serialization, rendering, loops).
- No hardcoding, no magic numbers, no duplicated logic.
- Environment-variable-first configuration.
- Structured logging.
- Never break currently working behavior.
- Avoid O(N^2) unless mathematically unavoidable.

## RALPH Loop Protocol (One Story Only)
1. Select exactly one highest-impact, smallest-safe story from `STORY_QUEUE`.
2. Produce a short execution plan (max 5 bullets).
3. Implement directly in code.
4. Run required verification commands.
5. Write an execution report to `docs/ralph/runs/<story-id>.md`.
6. Stop after one story.

## STORY_QUEUE
- `RLPH-001`: Ensure CI also runs on active feature branches (not only `main`) while preserving existing checks.
  - Accept: `.github/workflows/ci.yml` triggers `push` on `main` + `codex/**` and still keeps `pull_request`.
  - Accept: Existing jobs remain (`flutter pub get`, `dart format --set-exit-if-changed`, `flutter analyze`, `flutter test`, `node --check backend/pocketbase/pb_hooks/main.pb.js`).
  - Verify: trigger config is valid YAML and local checks pass.

## Required Verification Commands
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `node --check backend/pocketbase/pb_hooks/main.pb.js`

## Output Contract
Return:
1) selected story id
2) changed files
3) verification command results
4) residual risks

Do not process more than one story.
