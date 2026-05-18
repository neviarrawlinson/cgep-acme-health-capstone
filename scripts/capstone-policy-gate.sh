#!/usr/bin/env bash
set -euo pipefail

WORKSPACE="${1:-terraform}"
POLICY_DIR="${2:-policies}"
EVIDENCE_DIR="${3:-evidence/capstone}"

if command -v conftest >/dev/null 2>&1; then
  CONFTEST_BIN="conftest"
elif [[ -x "/c/Tools/conftest/conftest.exe" ]]; then
  CONFTEST_BIN="/c/Tools/conftest/conftest.exe"
else
  echo "conftest not found. Install it or place conftest.exe in C:/Tools/conftest." >&2
  exit 2
fi

mkdir -p "${EVIDENCE_DIR}"

terraform -chdir="${WORKSPACE}" init -input=false
terraform -chdir="${WORKSPACE}" validate
terraform -chdir="${WORKSPACE}" plan -out=tfplan -input=false
terraform -chdir="${WORKSPACE}" show -json tfplan > "${EVIDENCE_DIR}/capstone-plan.json"

"${CONFTEST_BIN}" test "${EVIDENCE_DIR}/capstone-plan.json" \
  --policy "${POLICY_DIR}" \
  --output json > "${EVIDENCE_DIR}/capstone-conftest-results.json"

rm -f "${WORKSPACE}/tfplan"

echo "capstone-policy-gate: PASS"
