-- =============================================================================
-- Controlled baseline data for Meridian OMS
-- All test cases assume this dataset unless a case inserts its own rows.
-- =============================================================================

USE meridian_oms;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE audit_log;
TRUNCATE TABLE payments;
TRUNCATE TABLE order_items;
TRUNCATE TABLE orders;
TRUNCATE TABLE inventory;
TRUNCATE TABLE products;
TRUNCATE TABLE warehouses;
TRUNCATE TABLE customers;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO warehouses (warehouse_id, warehouse_code, warehouse_name, is_active) VALUES
  (1, 'BFN-01', 'Bloemfontein Central', 1),
  (2, 'JHB-01', 'Johannesburg City Deep', 1);

INSERT INTO customers (customer_id, customer_code, legal_name, email, phone, credit_limit, account_status) VALUES
  (1, 'CUS-1001', 'Free State Builders CC',     'ap@fsbuilders.co.za',  '0510001001',  50000.00, 'ACTIVE'),
  (2, 'CUS-1002', 'Karoo Trade House (Pty) Ltd','accounts@karoo.co.za', '0510001002',  15000.00, 'ACTIVE'),
  (3, 'CUS-1003', 'Closed Account Demo',        'closed@demo.co.za',    '0510001003',      0.00, 'CLOSED');

INSERT INTO products (product_id, sku, product_name, unit_price, is_active) VALUES
  (1, 'SKU-CEM-50',  'Cement 50kg bag',           89.90,  1),
  (2, 'SKU-BRK-STD', 'Standard clay brick',        3.25,  1),
  (3, 'SKU-PNT-20',  'Roof paint 20L',           449.00,  1),
  (4, 'SKU-DISCON',  'Discontinued flashing roll', 120.00, 0);

INSERT INTO inventory (warehouse_id, product_id, qty_on_hand, qty_reserved) VALUES
  (1, 1, 200, 0),
  (1, 2, 5000, 0),
  (1, 3, 40,  0),
  (2, 1, 80,  0),
  (2, 3, 10,  0);

-- ORD-10001  DRAFT, two lines, total 899.00 + 325.00 = 1224.00 after recalc
INSERT INTO orders (order_id, order_number, customer_id, warehouse_id, status, order_date, total_amount)
VALUES (1, 'ORD-10001', 1, 1, 'DRAFT', '2026-09-01', 0.00);

INSERT INTO order_items (order_id, product_id, qty, unit_price, line_total) VALUES
  (1, 1, 10, 89.90, 899.00),
  (1, 2, 100, 3.25, 325.00);

CALL sp_recalc_order_total(1);

-- ORD-10002  already CONFIRMED with reservation on BFN cement (20 units)
INSERT INTO orders (order_id, order_number, customer_id, warehouse_id, status, order_date, total_amount)
VALUES (2, 'ORD-10002', 2, 1, 'CONFIRMED', '2026-09-02', 1798.00);

INSERT INTO order_items (order_id, product_id, qty, unit_price, line_total) VALUES
  (2, 1, 20, 89.90, 1798.00);

UPDATE inventory SET qty_reserved = 20 WHERE warehouse_id = 1 AND product_id = 1;

-- ORD-10003  SHIPPED historic order (stock already left the building)
INSERT INTO orders (order_id, order_number, customer_id, warehouse_id, status, order_date, total_amount)
VALUES (3, 'ORD-10003', 1, 1, 'SHIPPED', '2026-08-15', 449.00);

INSERT INTO order_items (order_id, product_id, qty, unit_price, line_total) VALUES
  (3, 3, 1, 449.00, 449.00);

INSERT INTO payments (order_id, amount, method, status, reference_no)
VALUES (3, 449.00, 'EFT', 'CLEARED', 'EFT-AUG-003');

INSERT INTO audit_log (entity_name, entity_id, action, new_values, changed_by)
VALUES ('SEED', '0', 'BASELINE', JSON_OBJECT('note', 'seed complete'), 'seed');
