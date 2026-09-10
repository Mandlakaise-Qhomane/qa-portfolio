#!/usr/bin/env bash
# Run the 10 Meridian OMS database cases.
# Cycle 1 expected: TC-06 and TC-08 FAIL (DEF-002, DEF-001). All others PASS.
set -u

HOST="${MYSQL_HOST:-127.0.0.1}"
USER="${MYSQL_USER:-root}"
export MYSQL_PWD="${MYSQL_PWD:-${MYSQL_PASSWORD:-root}}"
ROOT="$(cd "$(dirname "$0")" && pwd)"

mysql_cmd() {
  mysql -h "$HOST" -u "$USER" --protocol=TCP "$@"
}

echo "Loading schema + routines + seed on $HOST ..."
mysql_cmd < "$ROOT/sql/01_schema.sql"
mysql_cmd < "$ROOT/sql/02_routines.sql"
mysql_cmd < "$ROOT/sql/03_seed.sql"

pass=0
fail=0
unexpected=0

declare -A EXPECTED
EXPECTED[TC-01]=PASS
EXPECTED[TC-02]=PASS
EXPECTED[TC-03]=PASS
EXPECTED[TC-04]=PASS
EXPECTED[TC-05]=PASS
EXPECTED[TC-06]=FAIL
EXPECTED[TC-07]=PASS
EXPECTED[TC-08]=FAIL
EXPECTED[TC-09]=PASS
EXPECTED[TC-10]=PASS

echo
echo "========== CYCLE 1 (baseline routines) =========="

for script in "$ROOT"/sql/tests/TC-*.sql; do
  name="$(basename "$script" | cut -d_ -f1)"
  # Reseed cases that depend on ORD-10001
  if [[ "$name" == "TC-03" || "$name" == "TC-09" || "$name" == "TC-04" ]]; then
    mysql_cmd < "$ROOT/sql/03_seed.sql" >/dev/null
  fi
  out="$(mysql_cmd --table < "$script" 2>&1)" || true
  result="$(printf '%s\n' "$out" | awk '/PASS|FAIL/ { for(i=1;i<=NF;i++) if($i=="PASS"||$i=="FAIL") { print $i; exit } }')"
  if [[ -z "$result" ]]; then
    result="FAIL"
  fi
  exp="${EXPECTED[$name]}"
  mark="OK"
  if [[ "$result" != "$exp" ]]; then
    mark="UNEXPECTED"
    unexpected=$((unexpected + 1))
  fi
  if [[ "$result" == "PASS" ]]; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
  fi
  printf '%-6s  actual=%-4s  expected=%-4s  %s\n' "$name" "$result" "$exp" "$mark"
done

echo
echo "Passed: $pass   Failed: $fail   Unexpected vs plan: $unexpected"
echo "Cycle 1 plan: 8 PASS / 2 FAIL (DEF-001 cancel stock, DEF-002 payment cap)"

if [[ "$unexpected" -eq 0 ]]; then
  echo "SUITE RESULT: MATCHES PLAN"
  exit 0
fi
echo "SUITE RESULT: DRIFT FROM PLAN"
exit 1
