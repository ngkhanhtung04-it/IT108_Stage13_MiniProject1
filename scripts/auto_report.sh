#!/usr/bin/env bash
set -u
set -o pipefail

# Audit: resolve paths relative to this script; this script never deletes files.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
LOG_FILE="${ROOT}/data/log-he-thong.log"
REPORT_DIR="${ROOT}/backup"
REPORT_FILE="${REPORT_DIR}/bao-cao-su-co.txt"

echo "[AUDIT] Project root: ${ROOT}"
echo "[AUDIT] Log source: ${LOG_FILE}"
echo "[AUDIT] Append-only report: ${REPORT_FILE}"

if [[ ! -f "${LOG_FILE}" ]]; then
  echo "[ERROR] Khong tim thay file log: ${LOG_FILE}" >&2
  exit 2
fi
mkdir -p -- "${REPORT_DIR}" || exit 3
{
  printf '\n===== BAO CAO SU CO HE THONG =====\n'
  printf 'Thoi gian chay: %s\n' "$(date '+%Y-%m-%d %H:%M:%S %z')"
  printf 'Nguon: data/log-he-thong.log\n'
  printf 'Bo loc: CRITICAL, ERROR 404, TIMEOUT\n'
  printf '%s\n' '----------------------------------'
} >> "${REPORT_FILE}"

# Pipeline streams lines from the source to grep; append results instead of overwriting.
set +e
cat -- "${LOG_FILE}" | grep -Ei 'CRITICAL|ERROR 404|TIMEOUT' >> "${REPORT_FILE}"
rc=$?
set -e
if [[ ${rc} -eq 1 ]]; then
  printf 'Khong tim thay dong phu hop trong lan chay nay.\n' >> "${REPORT_FILE}"
elif [[ ${rc} -gt 1 ]]; then
  printf '[ERROR] grep gap loi khi doc/loc log.\n' >> "${REPORT_FILE}"
  exit 4
fi
printf '%s\n' '===== KET THUC =====' >> "${REPORT_FILE}"
echo "Hoan tat. Bao cao da duoc ghi noi vao: ${REPORT_FILE}"
