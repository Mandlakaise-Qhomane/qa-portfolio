# 07 — Test Execution Report

| Field | Value |
|---|---|
| Document ID | MER-QA-EX-001 |
| Cycle | 1 — baseline routines (with planted defects) |
| Executed by | Rethabile C. M. Qhomane |
| Date | 2026-09-09 |
| Build | `sql/01_schema.sql` + `sql/02_routines.sql` + `sql/03_seed.sql` |
| STLC phase | Test execution |

---

## 1. Scope of this run

All 10 cases in [05-test-cases.md](05-test-cases.md), executed against the unfixed baseline. Environment built using [06-test-environment.md](06-test-environment.md).

## 2. Results

| Case | Title | Expected this cycle | Actual | Status | Defect |
|---|---|---|---|---|---|
| TC-01 | Schema and constraint enforcement | PASS | Constraints rejected negative price, duplicate SKU, zero qty, negative credit | **PASS** | — |
| TC-02 | Referential integrity | PASS | Customer / product / warehouse deletes blocked; temp order lines cascaded | **PASS** | — |
| TC-03 | Stock reservation on confirm | PASS | ORD-10001 reserved cement 20 → 30; 10 000 bricks rejected | **PASS** | — |
| TC-04 | Header vs line totals | PASS | Header = 1224.00; bad line_total rejected | **PASS** | — |
| TC-05 | Status state machine | PASS | Illegal transitions rejected; legal path ended SHIPPED | **PASS** | — |
| TC-06 | Payment cap | FAIL | Second payment of 1.00 was accepted; cleared paid = 180.80 > 179.80 | **FAIL** | DEF-002 |
| TC-07 | Confirm atomicity | PASS | Status stayed DRAFT; reserved paint unchanged; no CONFIRM audit | **PASS** | — |
| TC-08 | Cancel releases stock | FAIL | Status became CANCELLED but qty_reserved did not drop | **FAIL** | DEF-001 |
| TC-09 | Audit trail | PASS | CONFIRM row from procedure and STATUS_UPDATE_ROW from trigger | **PASS** | — |
| TC-10 | Reporting indexes | PASS | `idx_orders_status_date` and `uq_orders_number` present | **PASS** | — |

## 3. Totals

| Metric | Count |
|---|---|
| Planned | 10 |
| Executed | 10 |
| Passed | 8 |
| Failed | 2 |
| Blocked | 0 |
| Not run | 0 |
| Pass rate | 80% |

## 4. Evidence notes

- Each script prints a `test_case` / `result` row. Capture that output (CLI `--table` or client grid) into `evidence/` if you rerun.
- TC-10 also prints `EXPLAIN FORMAT=JSON`. Store that output beside the result row.
- Failed cases have full reproduction SQL in the defect report.

## 5. Deviations from plan

None. Entry criteria were met. Two failures were expected: they are the planted baseline defects used to exercise the defect process.

## 6. Retest plan

1. Apply `sql/fixes/fix_def001_cancel_release.sql`.
2. Apply `sql/fixes/fix_def002_payment_cap.sql`.
3. Reseed.
4. Re-run TC-06 and TC-08 only.
5. Record cycle 2 in an addendum (below).

## 7. Cycle 2 addendum (after fixes)

| Case | Actual after fix | Status |
|---|---|---|
| TC-06 | Second payment returns `ERROR_OVERPAYMENT`; paid remains 179.80 | **PASS** |
| TC-08 | Reserved paint decreases by 2 on cancel | **PASS** |

Cycle 2 pass rate on the two defect cases: 2 / 2. Full suite after fixes: **10 / 10**.
