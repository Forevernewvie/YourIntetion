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
- `PSC_TRACE_ID_LENGTH=24`
- `PSC_SOURCE_LOOKBACK_HOURS=48`
- `PSC_SOURCE_CANDIDATE_LIMIT=500`
- `PSC_DIGEST_ITEMS_READ_LIMIT=100`
- `PSC_DIGEST_CITATIONS_READ_LIMIT=20`
- `PSC_SAVED_DIGESTS_DEFAULT_LIMIT=20`
- `PSC_SAVED_DIGESTS_MAX_LIMIT=50`
- `PSC_FRESHNESS_MAX_MINUTES=1440`
- `PSC_AUTH_POLICY_ENABLED=true`
- `PSC_AUTH_LOGIN_WINDOW_SECONDS=300`
- `PSC_AUTH_LOGIN_MAX_ATTEMPTS=8`
- `PSC_AUTH_LOGIN_LOCKOUT_SECONDS=900`
- `PSC_AUTH_VERIFY_RESEND_WINDOW_SECONDS=600`
- `PSC_AUTH_VERIFY_RESEND_MAX_ATTEMPTS=3`
- `PSC_AUTH_PASSWORD_RESET_WINDOW_SECONDS=600`
- `PSC_AUTH_PASSWORD_RESET_MAX_ATTEMPTS=3`
- `PSC_AUTH_VERIFY_CONFIRM_WINDOW_SECONDS=600`
- `PSC_AUTH_VERIFY_CONFIRM_MAX_ATTEMPTS=10`
- `PSC_AUTH_RESET_CONFIRM_WINDOW_SECONDS=600`
- `PSC_AUTH_RESET_CONFIRM_MAX_ATTEMPTS=10`

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
- Refresh session: `POST /api/collections/users/auth-refresh`
- Request email verification: `POST /api/collections/users/request-verification`
- Confirm email verification: `POST /api/collections/users/confirm-verification`
- Request password reset: `POST /api/collections/users/request-password-reset`
- Confirm password reset: `POST /api/collections/users/confirm-password-reset`

Pass access token on all `/v1/*` requests:

```http
Authorization: Bearer <users_jwt_token>
```

## Server-enforced Auth Policy

The backend enforces auth abuse controls in `pb_hooks/main.pb.js` using PocketBase auth hooks (`users` collection only):

- Login (`auth-with-password`):
  - Sliding window rate-limit by identity hash and IP hash.
  - Identity lockout on threshold breach (`AUTH_LOCKED`, `429`).
- Verification resend (`request-verification`): IP rate-limit (`RATE_LIMITED`, `429`).
- Password reset request (`request-password-reset`): IP rate-limit (`RATE_LIMITED`, `429`).
- Verification confirm (`confirm-verification`): token/IP attempt throttling.
- Password reset confirm (`confirm-password-reset`): token/IP attempt throttling.

Security notes:

- Policy data is persisted in `auth_rate_limits`, `auth_lockouts`, `auth_audit_logs`.
- Logs and audit records store only hashed identity/IP/token derivatives.
- Error payloads are structured as `{ code, message, details, traceId }`.

## Notes

- Collection APIs are locked to superuser-level rules; consumer access is provided through custom `/v1/*` routes.
- In guest mode, rule profile operations are scoped to a single guest profile (upsert semantics for `POST /v1/rules/profiles`).
- When `ALLOW_GUEST_MODE=false`, unauthenticated `/v1/*` requests return `401` and non-`users` tokens are rejected.
- If there are no candidate `source_entries`, digest endpoints return a valid payload with empty `items` and low quality score.
- Flutter contract for digest DTO is preserved for the two digest endpoints.
