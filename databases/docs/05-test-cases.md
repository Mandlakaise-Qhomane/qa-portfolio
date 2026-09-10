# 05 — Test Cases

| Field | Value |
|---|---|
| Document ID | MER-QA-TC-001 |
| Count | 10 |
| STLC phase | Test design |
| Execution | [07-test-execution-report.md](07-test-execution-report.md) |

Each case below is implemented as a SQL script under `sql/tests/`. Scripts print a single `test_case` / `result` row (`PASS` or `FAIL`).

---

## TC-01  Schema and constraint enforcement

| | |
|---|---|
| **ID** | TC-01 |
| **Requirement** | FR-01 |
| **Priority** | High |
| **Type** | Negative — constraints |
| **Script** | `sql/tests/TC-01_schema_constraints.sql` |

**Preconditions:** Schema and seed applied.

**Steps**

1. Insert a product with `unit_price = -0.01`.
2. Insert a product with an existing SKU `SKU-CEM-50`.
3. Insert an order line with `qty = 0`.
4. Insert a customer with `credit_limit = -100`.

**Expected**

- All four statements raise a SQL exception (CHECK or UNIQUE).
- Script result = `PASS`.

**Actual / status:** See execution report.

---

## TC-02  Referential integrity

| | |
|---|---|
| **ID** | TC-02 |
| **Requirement** | FR-02 |
| **Priority** | High |
| **Type** | Negative + cascade |
| **Script** | `sql/tests/TC-02_referential_integrity.sql` |

**Preconditions:** Seed present (`customer_id = 1` owns orders).

**Steps**

1. `DELETE FROM customers WHERE customer_id = 1`.
2. `DELETE FROM products WHERE product_id = 1`.
3. `DELETE FROM warehouses WHERE warehouse_id = 1`.
4. Insert a temporary DRAFT order with one line; delete the order; count leftover lines.

**Expected**

- Steps 1–3 fail with FK RESTRICT.
- Step 4 leaves zero `order_items` for the deleted order (CASCADE).
- Script result = `PASS`.

---

## TC-03  Stock reservation on confirm

| | |
|---|---|
| **ID** | TC-03 |
| **Requirement** | FR-03 |
| **Priority** | High |
| **Type** | Positive + boundary |
| **Script** | `sql/tests/TC-03_stock_reservation.sql` |

**Preconditions:** Fresh seed. ORD-10001 is DRAFT. BFN cement reserved = 20 (ORD-10002).

**Steps**

1. `CALL sp_confirm_order(1, @r)` for ORD-10001 (10 bags).
2. Read `inventory.qty_reserved` for BFN cement.
3. Create a DRAFT order requesting 10 000 bricks.
4. Confirm that order.

**Expected**

- Step 1 returns `OK`. BFN cement reserved becomes **30**.
- Step 4 returns `ERROR_INSUFFICIENT_STOCK`. Order stays `DRAFT`.
- Script result = `PASS`.

---

## TC-04  Header vs line totals

| | |
|---|---|
| **ID** | TC-04 |
| **Requirement** | FR-04 |
| **Priority** | High |
| **Type** | Positive + negative |
| **Script** | `sql/tests/TC-04_order_total_consistency.sql` |

**Steps**

1. `CALL sp_recalc_order_total(1)`.
2. Compare `orders.total_amount` to `SUM(order_items.line_total)` for order 1.
3. Insert a line where `line_total <> qty * unit_price`.

**Expected**

- Header = lines = `1224.00`.
- Mismatched `line_total` is rejected by CHECK.
- Script result = `PASS`.

---

## TC-05  Status state machine

| | |
|---|---|
| **ID** | TC-05 |
| **Requirement** | FR-05 |
| **Priority** | High |
| **Type** | State transition |
| **Script** | `sql/tests/TC-05_status_state_machine.sql` |

**Steps**

1. Insert an isolated DRAFT order with one in-stock line.
2. Advance DRAFT → SHIPPED (illegal).
3. Confirm, then CONFIRMED → PICKING → SHIPPED (legal).
4. Advance SHIPPED → DRAFT (illegal).

**Expected**

- Illegal transitions return `ERROR_INVALID_TRANSITION`.
- Legal path ends in `SHIPPED` with result `OK`.
- Script result = `PASS`.

---

## TC-06  Payment cap

| | |
|---|---|
| **ID** | TC-06 |
| **Requirement** | FR-06 |
| **Priority** | High |
| **Type** | Negative — finance |
| **Script** | `sql/tests/TC-06_payment_cap.sql` |
| **Linked defect** | DEF-002 |

**Steps**

1. Insert an isolated CONFIRMED order with total `179.80`.
2. Record payment `179.80` EFT.
3. Record a second payment of `1.00`.

**Expected**

- First payment `OK`.
- Second payment `ERROR_OVERPAYMENT`.
- Sum of cleared payments ≤ `179.80`.

**First-cycle note:** baseline `sp_record_payment` accepts the second payment. Case is designed to **FAIL** until the fix is applied.

---

## TC-07  Confirm atomicity

| | |
|---|---|
| **ID** | TC-07 |
| **Requirement** | FR-07 |
| **Priority** | High |
| **Type** | Transaction |
| **Script** | `sql/tests/TC-07_transaction_atomicity.sql` |

**Steps**

1. Snapshot `qty_reserved` for BFN paint.
2. Insert DRAFT order requesting **41** tins (on hand = 40).
3. Confirm.
4. Re-read status, reserved qty, and confirm audit rows.

**Expected**

- Result `ERROR_INSUFFICIENT_STOCK`.
- Status still `DRAFT`.
- Reserved qty unchanged.
- Zero `CONFIRM` audit rows for that order.
- Script result = `PASS`.

---

## TC-08  Cancel releases reserved stock

| | |
|---|---|
| **ID** | TC-08 |
| **Requirement** | FR-08 |
| **Priority** | High |
| **Type** | Positive — warehouse |
| **Script** | `sql/tests/TC-08_cancel_releases_stock.sql` |
| **Linked defect** | DEF-001 |

**Steps**

1. Insert isolated DRAFT for 2 × paint at BFN. Confirm it.
2. Snapshot `qty_reserved`.
3. `CALL sp_cancel_order(...)`.
4. Re-read status and reserved qty.

**Expected**

- Status `CANCELLED`.
- Reserved qty decreases by 2.

**First-cycle note:** baseline cancel leaves the reservation in place. Case is designed to **FAIL** until the fix is applied.

---

## TC-09  Audit trail

| | |
|---|---|
| **ID** | TC-09 |
| **Requirement** | FR-09 |
| **Priority** | Medium |
| **Type** | Positive |
| **Script** | `sql/tests/TC-09_audit_trail.sql` |

**Steps**

1. Confirm ORD-10001 via procedure.
2. Count `audit_log` rows with `action = 'CONFIRM'` for that order.
3. Direct `UPDATE orders SET status = 'PICKING'` on that order.
4. Count trigger rows `STATUS_UPDATE_ROW`.

**Expected**

- At least one procedure audit row and one trigger audit row.
- Script result = `PASS`.

---

## TC-10  Reporting indexes

| | |
|---|---|
| **ID** | TC-10 |
| **Requirement** | FR-10 |
| **Priority** | Medium |
| **Type** | Structural / performance |
| **Script** | `sql/tests/TC-10_query_performance.sql` |

**Steps**

1. `ANALYZE TABLE orders, payments, customers`.
2. `EXPLAIN` a status + date filter on `orders`.
3. Assert `idx_orders_status_date` and `uq_orders_number` exist in `information_schema.STATISTICS`.

**Expected**

- Both indexes present. EXPLAIN is printed for evidence.
- Script result = `PASS`.

---

## Case writing standard used

Every case has: ID, requirement link, priority, preconditions, numbered steps, expected result, and a script name. Actual results are not written here; they belong in the execution report so design stays independent of a single run.
