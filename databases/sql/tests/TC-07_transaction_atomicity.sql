-- TC-07  Confirm is atomic — insufficient stock rolls back every change
-- Expected: PASS
USE meridian_oms;

DELIMITER $$
DROP PROCEDURE IF EXISTS tc07_run $$
CREATE PROCEDURE tc07_run()
BEGIN
  DECLARE v_result     VARCHAR(80);
  DECLARE v_status     VARCHAR(20);
  DECLARE v_reserved   INT;
  DECLARE v_reserved_b INT;
  DECLARE v_audits     INT;
  DECLARE v_new_order  INT;
  DECLARE v_pass       INT DEFAULT 0;

  SELECT qty_reserved INTO v_reserved_b
  FROM inventory WHERE warehouse_id = 1 AND product_id = 3;

  INSERT INTO orders (order_number, customer_id, warehouse_id, status, order_date)
  VALUES ('ORD-ATOMIC', 1, 1, 'DRAFT', CURRENT_DATE);
  SET v_new_order = LAST_INSERT_ID();

  -- 40 on hand at BFN for paint; request 41
  INSERT INTO order_items (order_id, product_id, qty, unit_price, line_total)
  VALUES (v_new_order, 3, 41, 449.00, 18409.00);

  CALL sp_confirm_order(v_new_order, v_result);

  SELECT status INTO v_status FROM orders WHERE order_id = v_new_order;
  SELECT qty_reserved INTO v_reserved FROM inventory WHERE warehouse_id = 1 AND product_id = 3;
  SELECT COUNT(*) INTO v_audits
  FROM audit_log
  WHERE entity_name = 'orders' AND entity_id = v_new_order AND action = 'CONFIRM';

  IF v_result = 'ERROR_INSUFFICIENT_STOCK'
     AND v_status = 'DRAFT'
     AND v_reserved = v_reserved_b
     AND v_audits = 0 THEN
    SET v_pass = 1;
  END IF;

  SELECT
    'TC-07' AS test_case,
    CASE WHEN v_pass = 1 THEN 'PASS' ELSE 'FAIL' END AS result,
    v_result   AS proc_result,
    v_status   AS order_status,
    v_reserved_b AS reserved_before,
    v_reserved   AS reserved_after,
    v_audits     AS confirm_audit_rows;
END $$
DELIMITER ;

CALL tc07_run();
DROP PROCEDURE IF EXISTS tc07_run;
