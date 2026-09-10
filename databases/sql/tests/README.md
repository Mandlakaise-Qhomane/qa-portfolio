# Executable test scripts

Each file is one case from `docs/05-test-cases.md`.

| Script | Case | Cycle 1 |
|---|---|---|
| TC-01_schema_constraints.sql | Constraints | PASS |
| TC-02_referential_integrity.sql | Foreign keys | PASS |
| TC-03_stock_reservation.sql | Confirm / oversell | PASS |
| TC-04_order_total_consistency.sql | Header = lines | PASS |
| TC-05_status_state_machine.sql | Status path | PASS |
| TC-06_payment_cap.sql | Payment cap | FAIL → DEF-002 |
| TC-07_transaction_atomicity.sql | Rollback | PASS |
| TC-08_cancel_releases_stock.sql | Cancel stock | FAIL → DEF-001 |
| TC-09_audit_trail.sql | Audit | PASS |
| TC-10_query_performance.sql | Indexes | PASS |
