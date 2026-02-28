#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROMPT_FILE="${ROOT_DIR}/docs/ralph/psc_bug_loop_prompt.md"
RUN_DIR="${ROOT_DIR}/docs/ralph/runs/bug-loop"
MAX_ITERS="${MAX_ITERS:-5}"

mkdir -p "${RUN_DIR}"

if [[ ! -f "${PROMPT_FILE}" ]]; then
  echo "[ralph-loop] missing prompt: ${PROMPT_FILE}" >&2
  exit 1
fi

echo "[ralph-loop] start (max iterations: ${MAX_ITERS})"

for i in $(seq 1 "${MAX_ITERS}"); do
  ITER_LOG="${RUN_DIR}/iter-${i}.log"
  LAST_MSG="${RUN_DIR}/iter-${i}.last.txt"

  echo "[ralph-loop] iteration ${i}"
  codex exec \
    --dangerously-bypass-approvals-and-sandbox \
    -C "${ROOT_DIR}" \
    --output-last-message "${LAST_MSG}" \
    - < "${PROMPT_FILE}" | tee "${ITER_LOG}"

  TOKEN="$(tr -d '\r' < "${LAST_MSG}" | tail -n 1 | tr -d '[:space:]')"
  echo "[ralph-loop] iteration ${i} result: ${TOKEN}"

  if [[ "${TOKEN}" == "NO_BUGS" ]]; then
    echo "[ralph-loop] converged at iteration ${i}"
    exit 0
  fi
done

echo "[ralph-loop] reached max iterations without NO_BUGS" >&2
exit 2
