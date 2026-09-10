# 06 — Test Environment

| Field | Value |
|---|---|
| Document ID | MER-QA-ENV-001 |
| STLC phase | Environment setup |

---

## 1. Purpose

Describe a repeatable MySQL environment so any reviewer can recreate the exact SUT used for execution.

## 2. Target platform

| Item | Value |
|---|---|
| RDBMS | MySQL 8.0 or later |
| Engine | InnoDB |
| Character set | utf8mb4 |
| Collation | utf8mb4_0900_ai_ci |
| Time zone | Africa/Johannesburg (optional, dates are DATE/DATETIME) |
| Client | mysql CLI, DBeaver, or MySQL Workbench |

## 3. Required settings

```sql
SELECT @@version, @@sql_mode;
-- CHECK constraints require MySQL 8.0.16+
```

Recommended `sql_mode` includes `STRICT_TRANS_TABLES`. Do not disable CHECK constraints.

## 4. Build steps

From the repository root:

```bash
mysql -u root -p < sql/01_schema.sql
mysql -u root -p < sql/02_routines.sql
mysql -u root -p < sql/03_seed.sql
```

Smoke check:

```sql
USE meridian_oms;
SHOW TABLES;
SELECT COUNT(*) AS customers FROM customers;   -- 3
SELECT COUNT(*) AS products  FROM products;    -- 4
SELECT sku, qty_on_hand, qty_reserved
FROM inventory i JOIN products p ON p.product_id = i.product_id
WHERE warehouse_id = 1;
```

Expected BFN opening picture:

| SKU | On hand | Reserved |
|---|---|---|
| SKU-CEM-50 | 200 | 20 |
| SKU-BRK-STD | 5000 | 0 |
| SKU-PNT-20 | 40 | 0 |

## 5. Reset

```bash
mysql -u root -p < sql/03_seed.sql
```

Reseed between cases if you have been experimenting by hand. Scripted cases that mutate data create their own order numbers and do not require a reset between TC-01…TC-10, except TC-03 and TC-09 which use seeded ORD-10001. Run those two against a freshly seeded database, or reseed before each of them.

**Safe full-cycle recipe**

```bash
mysql -u root -p < sql/01_schema.sql
mysql -u root -p < sql/02_routines.sql
mysql -u root -p < sql/03_seed.sql
mysql -u root -p --table < sql/tests/TC-01_schema_constraints.sql
mysql -u root -p --table < sql/tests/TC-02_referential_integrity.sql
mysql -u root -p < sql/03_seed.sql
mysql -u root -p --table < sql/tests/TC-03_stock_reservation.sql
mysql -u root -p < sql/03_seed.sql
mysql -u root -p --table < sql/tests/TC-04_order_total_consistency.sql
mysql -u root -p --table < sql/tests/TC-05_status_state_machine.sql
mysql -u root -p --table < sql/tests/TC-06_payment_cap.sql
mysql -u root -p --table < sql/tests/TC-07_transaction_atomicity.sql
mysql -u root -p --table < sql/tests/TC-08_cancel_releases_stock.sql
mysql -u root -p < sql/03_seed.sql
mysql -u root -p --table < sql/tests/TC-09_audit_trail.sql
mysql -u root -p --table < sql/tests/TC-10_query_performance.sql
```

## 6. Privileges

The test user needs `CREATE`, `DROP`, `INSERT`, `UPDATE`, `DELETE`, `SELECT`, `EXECUTE`, `TRIGGER` on `meridian_oms`. Production-like least privilege is out of scope for this portfolio cycle.

## 7. Environment readiness checklist

- [ ] MySQL 8 running
- [ ] Scripts applied with no error
- [ ] Seed row counts match section 4
- [ ] `SHOW PROCEDURE STATUS WHERE Db = 'meridian_oms'` lists `sp_confirm_order`, `sp_cancel_order`, `sp_record_payment`, `sp_advance_status`, `sp_recalc_order_total`
- [ ] `SHOW TRIGGERS FROM meridian_oms` lists `trg_orders_status_audit`

## 8. Known environment risks

| Risk | Mitigation |
|---|---|
| SOURCE path in `04_reset.sql` depends on client cwd | Prefer running `03_seed.sql` directly |
| `UNIX_TIMESTAMP()` in isolated order numbers | Unique enough for a local cycle |
| Running TC-03 then TC-09 without reseed | Reseed as in the recipe above |
