#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

PB_BIN="${PB_BIN:-${ROOT_DIR}/backend/pocketbase/pocketbase}"
PB_DIR="${PB_DIR:-${ROOT_DIR}/backend/pocketbase/pb_data}"
API_BASE_URL="${API_BASE_URL:-http://127.0.0.1:8090}"
SUPERUSER_EMAIL="${SUPERUSER_EMAIL:-psc-admin@example.com}"
SUPERUSER_PASSWORD="${SUPERUSER_PASSWORD:-change-me-please}"
SMOKE_USER_EMAIL="${SMOKE_USER_EMAIL:-}"
SMOKE_USER_EMAIL_PREFIX="${SMOKE_USER_EMAIL_PREFIX:-psc-smoke-user}"
SMOKE_USER_PASSWORD="${SMOKE_USER_PASSWORD:-Passw0rd!123}"
LOCKOUT_TEST_EMAIL_PREFIX="${LOCKOUT_TEST_EMAIL_PREFIX:-psc-lockout-user}"
LOCKOUT_TEST_PASSWORD="${LOCKOUT_TEST_PASSWORD:-Passw0rd!123}"
ALLOW_GUEST_MODE="${ALLOW_GUEST_MODE:-true}"
PSC_AUTH_LOGIN_MAX_ATTEMPTS="${PSC_AUTH_LOGIN_MAX_ATTEMPTS:-8}"
PSC_AUTH_VERIFY_RESEND_MAX_ATTEMPTS="${PSC_AUTH_VERIFY_RESEND_MAX_ATTEMPTS:-3}"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "[smoke] required command not found: $1" >&2
    exit 1
  fi
}

require_cmd curl
require_cmd jq

now_utc="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
stamp="$(date -u +"%Y%m%d%H%M%S")"

if [[ -z "${SMOKE_USER_EMAIL}" ]]; then
  SMOKE_USER_EMAIL="${SMOKE_USER_EMAIL_PREFIX}-${stamp}@example.com"
fi

if [[ ! -x "${PB_BIN}" ]]; then
  echo "[smoke] PocketBase binary not found or not executable: ${PB_BIN}" >&2
  exit 1
fi

echo "[smoke] upserting superuser ${SUPERUSER_EMAIL}"
"${PB_BIN}" superuser upsert "${SUPERUSER_EMAIL}" "${SUPERUSER_PASSWORD}" --dir "${PB_DIR}" >/dev/null

superuser_auth_resp="$(
  curl -fsS -X POST "${API_BASE_URL}/api/collections/_superusers/auth-with-password" \
    -H 'Content-Type: application/json' \
    -d "{\"identity\":\"${SUPERUSER_EMAIL}\",\"password\":\"${SUPERUSER_PASSWORD}\"}"
)"

superuser_token="$(echo "${superuser_auth_resp}" | jq -r '.token // empty')"
if [[ -z "${superuser_token}" ]]; then
  echo "[smoke] failed to authenticate superuser" >&2
  echo "${superuser_auth_resp}" >&2
  exit 1
fi

admin_headers=(
  -H "Authorization: Bearer ${superuser_token}"
  -H 'Content-Type: application/json'
)

ensure_user_account() {
  local email="$1"
  local password="$2"
  local name="$3"
  local create_user_resp
  local user_lookup_resp
  local user_id

  create_user_resp="$(
    curl -sS -X POST "${API_BASE_URL}/api/collections/users/records" \
      -H 'Content-Type: application/json' \
      -d "{\"email\":\"${email}\",\"password\":\"${password}\",\"passwordConfirm\":\"${password}\",\"name\":\"${name}\"}"
  )"

  if ! echo "${create_user_resp}" | jq -e '.id != null' >/dev/null 2>&1; then
    if ! echo "${create_user_resp}" | jq -e '.data.email.code == "validation_not_unique"' >/dev/null 2>&1; then
      echo "[smoke] failed to create user account: ${email}" >&2
      echo "${create_user_resp}" >&2
      exit 1
    fi
  fi

  user_lookup_resp="$(
    curl -fsS "${API_BASE_URL}/api/collections/users/records?filter=email=%22${email}%22&perPage=1" \
      "${admin_headers[@]}"
  )"
  user_id="$(echo "${user_lookup_resp}" | jq -r '.items[0].id // empty')"
  if [[ -z "${user_id}" ]]; then
    echo "[smoke] failed to resolve user id after upsert: ${email}" >&2
    echo "${user_lookup_resp}" >&2
    exit 1
  fi

  curl -fsS -X PATCH "${API_BASE_URL}/api/collections/users/records/${user_id}" \
    "${admin_headers[@]}" \
    -d '{"verified":true}' >/dev/null
}

echo "[smoke] ensuring app user account ${SMOKE_USER_EMAIL}"
ensure_user_account "${SMOKE_USER_EMAIL}" "${SMOKE_USER_PASSWORD}" "Smoke User"

user_auth_resp="$(
  curl -fsS -X POST "${API_BASE_URL}/api/collections/users/auth-with-password" \
    -H 'Content-Type: application/json' \
    -d "{\"identity\":\"${SMOKE_USER_EMAIL}\",\"password\":\"${SMOKE_USER_PASSWORD}\"}"
)"

user_token="$(echo "${user_auth_resp}" | jq -r '.token // empty')"
if [[ -z "${user_token}" ]]; then
  echo "[smoke] failed to authenticate user" >&2
  echo "${user_auth_resp}" >&2
  exit 1
fi

user_headers=(
  -H "Authorization: Bearer ${user_token}"
  -H 'Content-Type: application/json'
)

echo "[smoke] validating server lockout policy"
lockout_test_email="${LOCKOUT_TEST_EMAIL_PREFIX}-${stamp}@example.com"
ensure_user_account "${lockout_test_email}" "${LOCKOUT_TEST_PASSWORD}" "Lockout Probe"

login_block_status=""
login_block_file=""
for attempt in $(seq 1 $((PSC_AUTH_LOGIN_MAX_ATTEMPTS + 1))); do
  login_block_file="/tmp/psc_login_probe_${attempt}.json"
  login_block_status="$(
    curl -sS -o "${login_block_file}" -w "%{http_code}" \
      -X POST "${API_BASE_URL}/api/collections/users/auth-with-password" \
      -H 'Content-Type: application/json' \
      -d "{\"identity\":\"${lockout_test_email}\",\"password\":\"wrong-password-${attempt}\"}"
  )"

  if [[ "${login_block_status}" == "429" ]]; then
    break
  fi
done

if [[ "${login_block_status}" != "429" ]]; then
  echo "[smoke] expected login lockout/rate-limit status 429, got ${login_block_status}" >&2
  cat "${login_block_file}" >&2 || true
  exit 1
fi

jq -e '.code == "AUTH_LOCKED" or .code == "RATE_LIMITED"' "${login_block_file}" >/dev/null

echo "[smoke] validating verification resend throttling"
verify_block_status=""
verify_block_file=""
for attempt in $(seq 1 $((PSC_AUTH_VERIFY_RESEND_MAX_ATTEMPTS + 1))); do
  verify_block_file="/tmp/psc_verify_probe_${attempt}.json"
  verify_block_status="$(
    curl -sS -o "${verify_block_file}" -w "%{http_code}" \
      -X POST "${API_BASE_URL}/api/collections/users/request-verification" \
      -H 'Content-Type: application/json' \
      -d "{\"email\":\"${lockout_test_email}\"}"
  )"

  if [[ "${verify_block_status}" == "429" ]]; then
    break
  fi
done

if [[ "${verify_block_status}" != "429" ]]; then
  echo "[smoke] expected verification resend throttle status 429, got ${verify_block_status}" >&2
  cat "${verify_block_file}" >&2 || true
  exit 1
fi

jq -e '.code == "RATE_LIMITED" or .code == "AUTH_LOCKED"' "${verify_block_file}" >/dev/null

seed_entry() {
  local source_name="$1"
  local source_type="$2"
  local source_domain="$3"
  local topic="$4"
  local title="$5"
  local snippet="$6"
  local canonical_url="$7"
  local trust_score="$8"
  local published_at="$9"

  curl -fsS -X POST "${API_BASE_URL}/api/collections/source_entries/records" \
    "${admin_headers[@]}" \
    -d "{\"source_name\":\"${source_name}\",\"source_type\":\"${source_type}\",\"source_domain\":\"${source_domain}\",\"topic\":\"${topic}\",\"title\":\"${title}\",\"content_snippet\":\"${snippet}\",\"canonical_url\":\"${canonical_url}\",\"published_at\":\"${published_at}\",\"trust_score\":${trust_score},\"tags\":[\"mvp\",\"smoke\"],\"blocked\":false}"
}

echo "[smoke] seeding source_entries"
seed_entry "Tech Ledger" "news" "tech-ledger.example" "AI" "Deterministic digest patterns" "Teams report improved trust when digests remain deterministic." "https://tech-ledger.example/${stamp}-1" 91 "${now_utc}" >/dev/null
seed_entry "Market Scope" "news" "market-scope.example" "markets" "Infrastructure spend remains steady" "Spending stayed resilient despite macro concerns." "https://market-scope.example/${stamp}-2" 87 "${now_utc}" >/dev/null
seed_entry "Builder Forum" "community" "builder-forum.example" "productivity" "Reduced notification fatigue" "Users shared anti-feed routines that reduced fatigue." "https://builder-forum.example/${stamp}-3" 83 "${now_utc}" >/dev/null

echo "[smoke] creating rule profile"
create_profile_resp="$(
  curl -fsS -X POST "${API_BASE_URL}/v1/rules/profiles" \
    "${user_headers[@]}" \
    -d '{"topic_priorities":{"AI":0.9,"markets":0.7,"productivity":0.6},"hard_filters":[],"source_allowlist":[],"source_blocklist":[],"tone":"neutral","frequency":"daily","length":"quick","ranking_tweaks":{"trustBoost":0.25,"freshnessBoost":0.2,"priorityBoost":0.55}}'
)"

profile_id="$(echo "${create_profile_resp}" | jq -r '.id // empty')"
if [[ -z "${profile_id}" ]]; then
  echo "[smoke] failed to create profile" >&2
  echo "${create_profile_resp}" >&2
  exit 1
fi

echo "[smoke] patching rule profile ${profile_id}"
patch_profile_resp="$(
  curl -fsS -X PATCH "${API_BASE_URL}/v1/rules/profiles/${profile_id}" \
    "${user_headers[@]}" \
    -d '{"tone":"analytical","source_blocklist":["blocked.example"],"source_allowlist":["blocked.example","tech-ledger.example"]}'
)"

echo "${patch_profile_resp}" | jq -e '.tone == "analytical"' >/dev/null

echo "[smoke] fetching latest digest"
latest_1="$(curl -fsS "${API_BASE_URL}/v1/digests/latest?ruleProfileId=${profile_id}" -H "Authorization: Bearer ${user_token}")"

# Contract shape assertions for GET /v1/digests/latest
echo "${latest_1}" | jq -e '
  (.id | type == "string") and
  (.profileId | type == "string") and
  (.generatedAt | type == "string") and
  (.qualityScore | type == "number") and
  (.items | type == "array")
' >/dev/null

digest_id="$(echo "${latest_1}" | jq -r '.id // empty')"
if [[ -z "${digest_id}" ]]; then
  echo "[smoke] latest digest id missing" >&2
  echo "${latest_1}" >&2
  exit 1
fi

if [[ "$(echo "${latest_1}" | jq -r '.items | length')" -gt 0 ]]; then
  echo "${latest_1}" | jq -e '
    .items[0] |
    (.id | type == "string") and
    (.topic | type == "string") and
    (.whyReason | type == "string") and
    (.summary | type == "string") and
    (.freshnessMinutes | type == "number") and
    (.citations | type == "array")
  ' >/dev/null
fi

echo "[smoke] fetching digest detail ${digest_id}"
detail_resp="$(curl -fsS "${API_BASE_URL}/v1/digests/${digest_id}" -H "Authorization: Bearer ${user_token}")"
echo "${detail_resp}" | jq -e --arg did "${digest_id}" '.id == $did' >/dev/null

echo "[smoke] submitting feedback"
feedback_resp="$(
  curl -fsS -X POST "${API_BASE_URL}/v1/feedback" \
    "${user_headers[@]}" \
    -d '{"rating":5,"reason":"clear and concise"}'
)"
echo "${feedback_resp}" | jq -e '.rating == 5' >/dev/null

echo "[smoke] reading saved digests"
saved_resp="$(curl -fsS "${API_BASE_URL}/v1/saved-digests?limit=5" -H "Authorization: Bearer ${user_token}")"
echo "${saved_resp}" | jq -e '(.items | type == "array") and ((.nextCursor == null) or (.nextCursor | type == "string"))' >/dev/null

echo "[smoke] deterministic output check"
latest_2="$(curl -fsS "${API_BASE_URL}/v1/digests/latest?ruleProfileId=${profile_id}" -H "Authorization: Bearer ${user_token}")"

sig_1="$(echo "${latest_1}" | jq -c '.items | map({topic,whyReason,summary,freshnessMinutes,citations: (.citations | map({sourceName,canonicalUrl,publishedAt}))})')"
sig_2="$(echo "${latest_2}" | jq -c '.items | map({topic,whyReason,summary,freshnessMinutes,citations: (.citations | map({sourceName,canonicalUrl,publishedAt}))})')"

id_1="$(echo "${latest_1}" | jq -r '.id')"
id_2="$(echo "${latest_2}" | jq -r '.id')"

if [[ "${id_1}" != "${id_2}" ]]; then
  echo "[smoke] deterministic check failed: digest ids differ (${id_1} vs ${id_2})" >&2
  exit 1
fi

if [[ "${sig_1}" != "${sig_2}" ]]; then
  echo "[smoke] deterministic check failed: digest item signatures differ" >&2
  echo "sig1=${sig_1}" >&2
  echo "sig2=${sig_2}" >&2
  exit 1
fi

if [[ "${ALLOW_GUEST_MODE}" == "false" ]]; then
  echo "[smoke] verifying unauthenticated access is blocked"
  unauth_code="$(
    curl -sS -o /tmp/psc_smoke_unauth.json -w "%{http_code}" \
      "${API_BASE_URL}/v1/digests/latest?ruleProfileId=${profile_id}"
  )"
  if [[ "${unauth_code}" != "401" ]]; then
    echo "[smoke] expected 401 for unauthenticated request, got ${unauth_code}" >&2
    cat /tmp/psc_smoke_unauth.json >&2
    exit 1
  fi
fi

echo "[smoke] PASS"
