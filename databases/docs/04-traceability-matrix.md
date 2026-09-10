# 04 — Requirements Traceability Matrix

| Field | Value |
|---|---|
| Document ID | MER-QA-RTM-001 |
| STLC phase | Test design |
| Coverage rule | Every FR must map to ≥ 1 test case |

---

## Requirements → test cases

| Req ID | Requirement (short) | Priority | Test case(s) | Cycle 1 result | Defect |
|---|---|---|---|---|---|
| FR-01 | Uniqueness + CHECK constraints | High | TC-01 | PASS | — |
| FR-02 | FK RESTRICT / CASCADE | High | TC-02 | PASS | — |
| FR-03 | Confirm reserves stock; reject oversell | High | TC-03 | PASS | — |
| FR-04 | Header total = sum of lines | High | TC-04 | PASS | — |
| FR-05 | Legal status transitions only | High | TC-05 | PASS | — |
| FR-06 | Payments cannot exceed order total | High | TC-06 | FAIL | DEF-002 |
| FR-07 | Failed confirm is atomic | High | TC-07 | PASS | — |
| FR-08 | Cancel releases reservation | High | TC-08 | FAIL | DEF-001 |
| FR-09 | Status changes are audited | Medium | TC-09 | PASS | — |
| FR-10 | Reporting indexes exist | Medium | TC-10 | PASS | — |
| NFR-02 | Procedures use transactions | High | TC-03, TC-07 | PASS | — |
| NFR-04 | DECIMAL for money | High | TC-04, TC-06 | PASS | — |

## Test cases → requirements

| Test case | FR covered | Script |
|---|---|---|
| TC-01 | FR-01 | `sql/tests/TC-01_schema_constraints.sql` |
| TC-02 | FR-02 | `sql/tests/TC-02_referential_integrity.sql` |
| TC-03 | FR-03, NFR-02 | `sql/tests/TC-03_stock_reservation.sql` |
| TC-04 | FR-04, NFR-04 | `sql/tests/TC-04_order_total_consistency.sql` |
| TC-05 | FR-05 | `sql/tests/TC-05_status_state_machine.sql` |
| TC-06 | FR-06, NFR-04 | `sql/tests/TC-06_payment_cap.sql` |
| TC-07 | FR-07, NFR-02 | `sql/tests/TC-07_transaction_atomicity.sql` |
| TC-08 | FR-08 | `sql/tests/TC-08_cancel_releases_stock.sql` |
| TC-09 | FR-09 | `sql/tests/TC-09_audit_trail.sql` |
| TC-10 | FR-10 | `sql/tests/TC-10_query_performance.sql` |

## Coverage summary

| Metric | Value |
|---|---|
| Functional requirements | 10 |
| Requirements with ≥ 1 case | 10 (100%) |
| Cases executed cycle 1 | 10 (100%) |
| Requirements passing cycle 1 | 8 / 10 |
| Requirements with open defects | 2 (FR-06, FR-08) |

No orphan requirements. No orphan test cases.
