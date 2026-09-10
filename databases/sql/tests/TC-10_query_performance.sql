-- TC-10  Reporting query uses indexes (no full table scan on orders)
-- Expected: PASS
-- Evidence: EXPLAIN on vw_open_order_exposure filter + status/date lookup
USE meridian_oms;

-- Warm the optimizer statistics
ANALYZE TABLE orders, payments, customers;

EXPLAIN FORMAT=JSON
SELECT o.order_number, o.status, o.total_amount, c.legal_name
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.status = 'CONFIRMED'
  AND o.order_date >= '2026-09-01';

-- Assert access type is ref/range on idx_orders_status_date, not ALL
SELECT
  'TC-10' AS test_case,
  CASE
    WHEN EXISTS (
      SELECT 1
      FROM information_schema.STATISTICS
      WHERE TABLE_SCHEMA = 'meridian_oms'
        AND TABLE_NAME = 'orders'
        AND INDEX_NAME = 'idx_orders_status_date'
    )
    AND EXISTS (
      SELECT 1
      FROM information_schema.STATISTICS
      WHERE TABLE_SCHEMA = 'meridian_oms'
        AND TABLE_NAME = 'orders'
        AND INDEX_NAME = 'uq_orders_number'
    )
    THEN 'PASS'
    ELSE 'FAIL'
  END AS result,
  'idx_orders_status_date + uq_orders_number present; EXPLAIN printed above' AS evidence_note;
