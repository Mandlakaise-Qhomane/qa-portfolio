-- TC-05  Order status transitions
-- Expected: PASS
-- Uses a dedicated order so the case does not depend on other scripts.
USE meridian_oms;

DELIMITER $$
DROP PROCEDURE IF EXISTS tc05_run $$
CREATE PROCEDURE tc05_run()
BEGIN
  DECLARE r_bad1   VARCHAR(80);
  DECLARE r_bad2   VARCHAR(80);
  DECLARE r_ok1    VARCHAR(80);
  DECLARE r_ok2    VARCHAR(80);
  DECLARE v_order  INT;
  DECLARE v_pass   INT DEFAULT 0;

  INSERT INTO orders (order_number, customer_id, warehouse_id, status, order_date, total_amount)
  VALUES (CONCAT('ORD-TC05-', UNIX_TIMESTAMP()), 1, 1, 'DRAFT', CURRENT_DATE, 89.90);
  SET v_order = LAST_INSERT_ID();

  INSERT INTO order_items (order_id, product_id, qty, unit_price, line_total)
  VALUES (v_order, 1, 1, 89.90, 89.90);

  -- Illegal: DRAFT -> SHIPPED
  CALL sp_advance_status(v_order, 'SHIPPED', r_bad1);

  -- Legal confirm then CONFIRMED -> PICKING -> SHIPPED
  CALL sp_confirm_order(v_order, r_ok1);
  CALL sp_advance_status(v_order, 'PICKING', r_ok1);
  CALL sp_advance_status(v_order, 'SHIPPED', r_ok2);

  -- Illegal: SHIPPED -> DRAFT
  CALL sp_advance_status(v_order, 'DRAFT', r_bad2);

  IF r_bad1 = 'ERROR_INVALID_TRANSITION'
     AND r_bad2 = 'ERROR_INVALID_TRANSITION'
     AND r_ok2 = 'OK'
     AND (SELECT status FROM orders WHERE order_id = v_order) = 'SHIPPED' THEN
    SET v_pass = 1;
  END IF;

  SELECT
    'TC-05' AS test_case,
    CASE WHEN v_pass = 1 THEN 'PASS' ELSE 'FAIL' END AS result,
    v_order AS isolated_order_id,
    r_bad1  AS draft_to_shipped,
    r_ok2   AS picking_to_shipped,
    r_bad2  AS shipped_to_draft,
    (SELECT status FROM orders WHERE order_id = v_order) AS final_status;
END $$
DELIMITER ;

CALL tc05_run();
DROP PROCEDURE IF EXISTS tc05_run;
