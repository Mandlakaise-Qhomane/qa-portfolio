-- TC-08  Cancel must release reserved stock
-- Expected: FAIL on baseline  (DEF-001)
USE meridian_oms;

DELIMITER $$
DROP PROCEDURE IF EXISTS tc08_run $$
CREATE PROCEDURE tc08_run()
BEGIN
  DECLARE v_result     VARCHAR(80);
  DECLARE v_confirm    VARCHAR(80);
  DECLARE v_status     VARCHAR(20);
  DECLARE v_reserved_b INT;
  DECLARE v_reserved_a INT;
  DECLARE v_order      INT;
  DECLARE v_released   INT DEFAULT 0;

  INSERT INTO orders (order_number, customer_id, warehouse_id, status, order_date, total_amount)
  VALUES (CONCAT('ORD-TC08-', UNIX_TIMESTAMP()), 1, 1, 'DRAFT', CURRENT_DATE, 449.00);
  SET v_order = LAST_INSERT_ID();

  INSERT INTO order_items (order_id, product_id, qty, unit_price, line_total)
  VALUES (v_order, 3, 2, 449.00, 898.00);

  CALL sp_confirm_order(v_order, v_confirm);

  SELECT qty_reserved INTO v_reserved_b
  FROM inventory WHERE warehouse_id = 1 AND product_id = 3;

  CALL sp_cancel_order(v_order, v_result);

  SELECT status INTO v_status FROM orders WHERE order_id = v_order;
  SELECT qty_reserved INTO v_reserved_a
  FROM inventory WHERE warehouse_id = 1 AND product_id = 3;

  IF v_confirm = 'OK'
     AND v_result = 'OK'
     AND v_status = 'CANCELLED'
     AND v_reserved_a = v_reserved_b - 2 THEN
    SET v_released = 1;
  END IF;

  SELECT
    'TC-08' AS test_case,
    CASE WHEN v_released = 1 THEN 'PASS' ELSE 'FAIL' END AS result,
    v_order      AS isolated_order_id,
    v_confirm    AS confirm_result,
    v_result     AS cancel_result,
    v_status     AS order_status,
    v_reserved_b AS reserved_before_cancel,
    v_reserved_a AS reserved_after_cancel,
    'DEF-001'    AS linked_defect;
END $$
DELIMITER ;

CALL tc08_run();
DROP PROCEDURE IF EXISTS tc08_run;
