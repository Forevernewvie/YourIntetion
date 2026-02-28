# Auth + Onboarding Upgrade (MVP)

## Scope Implemented

- Email verification gating for authenticated users.
- Password recovery screens and API wiring.
- Onboarding completion persistence and route guards.
- First digest preview step before entering home.

## Route Guard Rules

Deterministic redirect order:

1. If unauthenticated: allow only auth routes (`/login`, `/signup`, `/forgot-password`, `/reset-password`) and public verification link (`/verify`).
2. If authenticated but unverified: force `/verify-pending`.
3. If verified but onboarding incomplete: force `/welcome`.
4. If verified and onboarding complete: block auth/onboarding routes and force `/home`.

## PocketBase Endpoints Used

- `POST /api/collections/users/auth-with-password`
- `POST /api/collections/users/auth-refresh`
- `POST /api/collections/users/records`
- `POST /api/collections/users/request-verification`
- `POST /api/collections/users/confirm-verification`
- `POST /api/collections/users/request-password-reset`
- `POST /api/collections/users/confirm-password-reset`

## New Flutter Screens

- `EmailVerificationPendingScreen`
- `VerificationResultScreen`
- `ForgotPasswordScreen`
- `ResetPasswordScreen`
- `FirstDigestPreviewScreen`

## Persistence

- Auth session now persists:
  - token
  - userId
  - email
  - `isVerified`
- Onboarding completion persists as:
  - `onboarding.completed` (SharedPreferences)

## Tests Added

- `test/auth_local_data_source_test.dart`
- `test/onboarding_status_controller_test.dart`

## Notes

- Digest contract and rule precedence are unchanged.
- Verification/reset flows use PocketBase built-in auth endpoints to keep MVP scope realistic.
