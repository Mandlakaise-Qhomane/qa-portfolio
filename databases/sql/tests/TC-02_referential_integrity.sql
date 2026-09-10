-- TC-02  Referential integrity (RESTRICT vs CASCADE)
-- Expected: PASS
USE meridian_oms;

DELIMITER $$
DROP PROCEDURE IF EXISTS tc02_run $$
CREATE PROCEDURE tc02_run()
BEGIN
  DECLARE v_block_customer INT DEFAULT 0;
  DECLARE v_block_product  INT DEFAULT 0;
  DECLARE v_block_wh       INT DEFAULT 0;
  DECLARE v_cascade_items  INT DEFAULT 0;
  DECLARE v_item_count     INT DEFAULT 0;
  DECLARE v_new_order      INT DEFAULT 0;

  -- Cannot delete a customer that owns orders
  BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_block_customer = 1;
    DELETE FROM customers WHERE customer_id = 1;
  END;

  -- Cannot delete a product that is on an order line
  BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_block_product = 1;
    DELETE FROM products WHERE product_id = 1;
  END;

  -- Cannot delete a warehouse that holds inventory
  BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_block_wh = 1;
    DELETE FROM warehouses WHERE warehouse_id = 1;
  END;

  -- CASCADE: deleting a DRAFT order removes its lines
  INSERT INTO orders (order_number, customer_id, warehouse_id, status, order_date, total_amount)
  VALUES ('ORD-TEMP-CASCADE', 1, 1, 'DRAFT', CURRENT_DATE, 0.00);
  SET v_new_order = LAST_INSERT_ID();

  INSERT INTO order_items (order_id, product_id, qty, unit_price, line_total)
  VALUES (v_new_order, 3, 1, 449.00, 449.00);

  DELETE FROM orders WHERE order_id = v_new_order;

  SELECT COUNT(*) INTO v_item_count FROM order_items WHERE order_id = v_new_order;
  IF v_item_count = 0 THEN SET v_cascade_items = 1; END IF;

  SELECT
    'TC-02' AS test_case,
    CASE
      WHEN v_block_customer = 1 AND v_block_product = 1 AND v_block_wh = 1 AND v_cascade_items = 1
      THEN 'PASS' ELSE 'FAIL'
    END AS result,
    v_block_customer AS delete_customer_blocked,
    v_block_product  AS delete_product_blocked,
    v_block_wh       AS delete_warehouse_blocked,
    v_cascade_items  AS order_items_cascaded;
END $$
DELIMITER ;

CALL tc02_run();
DROP PROCEDURE IF EXISTS tc02_run;
