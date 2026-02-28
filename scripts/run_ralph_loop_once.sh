#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROMPT_FILE="${ROOT_DIR}/docs/ralph/psc_ralph_loop_prompt.md"
RUN_DIR="${ROOT_DIR}/docs/ralph/runs"
LAST_MESSAGE_FILE="${RUN_DIR}/last_message.md"
SESSION_LOG_FILE="${RUN_DIR}/last_exec.log"

mkdir -p "${RUN_DIR}"

if [[ ! -f "${PROMPT_FILE}" ]]; then
  echo "[ralph] prompt file not found: ${PROMPT_FILE}" >&2
  exit 1
fi

echo "[ralph] running one-loop execution from ${PROMPT_FILE}"

codex exec \
  --dangerously-bypass-approvals-and-sandbox \
  -C "${ROOT_DIR}" \
  --output-last-message "${LAST_MESSAGE_FILE}" \
  - < "${PROMPT_FILE}" | tee "${SESSION_LOG_FILE}"

echo "[ralph] done"
echo "[ralph] last message: ${LAST_MESSAGE_FILE}"
echo "[ralph] exec log: ${SESSION_LOG_FILE}"
