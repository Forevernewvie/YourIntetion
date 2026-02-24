# PocketBase Backend (Preference Summary Curator)

This backend implements an MVP API for deterministic digest curation using PocketBase `v0.36.x`.

## What is included

- PocketBase collections + migrations (`pb_migrations`)
- Custom `/v1/*` API routes in hooks (`pb_hooks/main.pb.js`)
- Deterministic digest pipeline with precedence:
  - `hard filters > source allow/block > topic priority > tone > length > ranking tweaks`
- Idempotent digest generation key:
  - `sha256(userScope + profileId + utcHourBucket + sourceSnapshotHash)`
- Structured error shape:
  - `{ code, message, details, traceId }`
- Curl smoke test (`scripts/smoke_test.sh`)

## Directory layout

- `backend/pocketbase/pocketbase`
- `backend/pocketbase/pb_migrations`
- `backend/pocketbase/pb_hooks`
- `backend/pocketbase/scripts`
- `backend/pocketbase/config`

## Environment

See `backend/pocketbase/.env.example`:

- `ALLOW_GUEST_MODE=false` (recommended for login-required mode)
- `API_BASE_URL=http://127.0.0.1:8090`
- `SUPERUSER_EMAIL=psc-admin@example.com`
- `SUPERUSER_PASSWORD=change-me-please`

## Run locally

1. Ensure executable bit is set:

```bash
chmod +x backend/pocketbase/pocketbase
```

2. Start PocketBase:

```bash
backend/pocketbase/pocketbase serve \
  --dir backend/pocketbase/pb_data \
  --hooksDir backend/pocketbase/pb_hooks \
  --migrationsDir backend/pocketbase/pb_migrations \
  --http 127.0.0.1:8090
```

3. Run smoke tests (in another shell while server is running):

```bash
bash backend/pocketbase/scripts/smoke_test.sh
```

## API routes

- `GET /v1/digests/latest?ruleProfileId={id}`
- `GET /v1/digests/{digestId}`
- `POST /v1/rules/profiles`
- `PATCH /v1/rules/profiles/{id}`
- `POST /v1/feedback`
- `GET /v1/saved-digests?limit=&cursor=`

## Authentication flow

Use PocketBase built-in `users` auth endpoints:

- Sign up: `POST /api/collections/users/records`
- Login: `POST /api/collections/users/auth-with-password`

Pass access token on all `/v1/*` requests:

```http
Authorization: Bearer <users_jwt_token>
```

## Notes

- Collection APIs are locked to superuser-level rules; consumer access is provided through custom `/v1/*` routes.
- In guest mode, rule profile operations are scoped to a single guest profile (upsert semantics for `POST /v1/rules/profiles`).
- When `ALLOW_GUEST_MODE=false`, unauthenticated `/v1/*` requests return `401` and non-`users` tokens are rejected.
- If there are no candidate `source_entries`, digest endpoints return a valid payload with empty `items` and low quality score.
- Flutter contract for digest DTO is preserved for the two digest endpoints.
