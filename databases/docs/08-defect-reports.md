# 08 — Defect Reports

| Field | Value |
|---|---|
| Document ID | MER-QA-DEF-001 |
| STLC phase | Defect reporting |
| Cycle | 1 (open) → 2 (verified) |

Defects follow a single template so a developer can reproduce without a meeting.

---

## DEF-001  Cancel does not release reserved stock

| Field | Value |
|---|---|
| **ID** | DEF-001 |
| **Title** | `sp_cancel_order` leaves `qty_reserved` unchanged |
| **Status** | Open in cycle 1 · **Verified fixed in cycle 2** |
| **Severity** | High |
| **Priority** | P1 |
| **Environment** | MySQL 8 / `meridian_oms` baseline routines |
| **Found in** | TC-08 |
| **Requirement** | FR-08 |
| **Detected by** | Rethabile C. M. Qhomane |
| **Date found** | 2026-09-09 |

### Description

When a CONFIRMED or PICKING order is cancelled, warehouse stock that was reserved at confirm remains reserved. Available-to-sell stays reduced even though the customer will never take the goods.

### Steps to reproduce

```sql
USE meridian_oms;

INSERT INTO orders (order_number, customer_id, warehouse_id, status, order_date, total_amount)
VALUES ('ORD-DEF001', 1, 1, 'DRAFT', CURRENT_DATE, 898.00);
SET @oid = LAST_INSERT_ID();

INSERT INTO order_items (order_id, product_id, qty, unit_price, line_total)
VALUES (@oid, 3, 2, 449.00, 898.00);

CALL sp_confirm_order(@oid, @c);
SELECT qty_reserved AS reserved_after_confirm
FROM inventory WHERE warehouse_id = 1 AND product_id = 3;

CALL sp_cancel_order(@oid, @k);
SELECT status FROM orders WHERE order_id = @oid;
SELECT qty_reserved AS reserved_after_cancel
FROM inventory WHERE warehouse_id = 1 AND product_id = 3;
```

### Expected

- `@k = 'OK'`
- Order status = `CANCELLED`
- `qty_reserved` decreases by 2

### Actual (cycle 1)

- `@k = 'OK'`
- Order status = `CANCELLED`
- `qty_reserved` **unchanged**

### Impact

Permanent loss of sellable stock after every cancelled confirmed order. Warehouse figures drift. Later genuine customers can be rejected for “no stock” that is only ghost-reserved.

### Root cause

`sp_cancel_order` updates `orders.status` only. It never subtracts line quantities from `inventory.qty_reserved`.

### Suggested fix

When current status is `CONFIRMED` or `PICKING`, subtract each line `qty` from `inventory.qty_reserved` for the order warehouse, inside the same transaction, before setting `CANCELLED`.

Patch supplied: `sql/fixes/fix_def001_cancel_release.sql`

### Retest

Re-run TC-08 after the patch. Cycle 2: **PASS**.

---

## DEF-002  Payments can exceed the order total

| Field | Value |
|---|---|
| **ID** | DEF-002 |
| **Title** | `sp_record_payment` does not cap cleared receipts |
| **Status** | Open in cycle 1 · **Verified fixed in cycle 2** |
| **Severity** | High |
| **Priority** | P1 |
| **Environment** | MySQL 8 / `meridian_oms` baseline routines |
| **Found in** | TC-06 |
| **Requirement** | FR-06 |
| **Detected by** | Rethabile C. M. Qhomane |
| **Date found** | 2026-09-09 |

### Description

A second (or first oversized) payment is accepted even when it pushes the sum of `CLEARED` payments above `orders.total_amount`.

### Steps to reproduce

```sql
USE meridian_oms;

INSERT INTO orders (order_number, customer_id, warehouse_id, status, order_date, total_amount)
VALUES ('ORD-DEF002', 1, 1, 'CONFIRMED', CURRENT_DATE, 179.80);
SET @oid = LAST_INSERT_ID();

INSERT INTO order_items (order_id, product_id, qty, unit_price, line_total)
VALUES (@oid, 1, 2, 89.90, 179.80);

CALL sp_record_payment(@oid, 179.80, 'EFT', @r1);
CALL sp_record_payment(@oid, 1.00,    'EFT', @r2);

SELECT @r1 AS first_pay, @r2 AS second_pay;
SELECT SUM(amount) AS cleared
FROM payments WHERE order_id = @oid AND status = 'CLEARED';
```

### Expected

- `@r1 = 'OK'`
- `@r2 = 'ERROR_OVERPAYMENT'`
- Cleared total = `179.80`

### Actual (cycle 1)

- `@r1 = 'OK'`
- `@r2 = 'OK'`
- Cleared total = `180.80`

### Impact

Finance can show over-receipted invoices. Credit notes and bank recs will not match the order book. In a real ledger this is a control failure.

### Root cause

`sp_record_payment` checks status and amount > 0 only. It never compares `SUM(cleared) + new amount` to `orders.total_amount`.

### Suggested fix

Lock the order row, compute cleared receipts, reject with `ERROR_OVERPAYMENT` when the new payment would exceed the header total.

Patch supplied: `sql/fixes/fix_def002_payment_cap.sql`

### Retest

Re-run TC-06 after the patch. Cycle 2: **PASS**.

---

## Defect summary

| ID | Severity | Cycle 1 | Cycle 2 |
|---|---|---|---|
| DEF-001 | High | Open | Closed — verified |
| DEF-002 | High | Open | Closed — verified |

No cosmetic defects were logged. Both findings are business-rule breaks, which is what a database tester is hired to catch.
