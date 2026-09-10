-- TC-03  Confirm order reserves available stock and rejects oversell
-- Expected: PASS
USE meridian_oms;

DELIMITER $$
DROP PROCEDURE IF EXISTS tc03_run $$
CREATE PROCEDURE tc03_run()
BEGIN
  DECLARE v_ok            VARCHAR(80);
  DECLARE v_fail          VARCHAR(80);
  DECLARE v_reserved_ok   INT DEFAULT 0;
  DECLARE v_oversell_ok   INT DEFAULT 0;
  DECLARE v_reserved_after INT DEFAULT 0;
  DECLARE v_new_order     INT DEFAULT 0;

  -- Happy path: confirm ORD-10001 (10 cement + 100 bricks) from BFN
  CALL sp_confirm_order(1, v_ok);

  SELECT qty_reserved INTO v_reserved_after
  FROM inventory
  WHERE warehouse_id = 1 AND product_id = 1;

  -- Seed already reserved 20 on ORD-10002; confirm adds 10 → 30
  IF v_ok = 'OK' AND v_reserved_after = 30 THEN
    SET v_reserved_ok = 1;
  END IF;

  -- Oversell: draft for 10 000 bricks when only 5 000 on hand
  INSERT INTO orders (order_number, customer_id, warehouse_id, status, order_date)
  VALUES ('ORD-OVERSELL', 1, 1, 'DRAFT', CURRENT_DATE);
  SET v_new_order = LAST_INSERT_ID();

  INSERT INTO order_items (order_id, product_id, qty, unit_price, line_total)
  VALUES (v_new_order, 2, 10000, 3.25, 32500.00);

  CALL sp_confirm_order(v_new_order, v_fail);

  IF v_fail = 'ERROR_INSUFFICIENT_STOCK'
     AND (SELECT status FROM orders WHERE order_id = v_new_order) = 'DRAFT' THEN
    SET v_oversell_ok = 1;
  END IF;

  SELECT
    'TC-03' AS test_case,
    CASE WHEN v_reserved_ok = 1 AND v_oversell_ok = 1 THEN 'PASS' ELSE 'FAIL' END AS result,
    v_ok              AS confirm_result,
    v_reserved_after  AS cement_reserved_bfn,
    v_fail            AS oversell_result;
END $$
DELIMITER ;

CALL tc03_run();
DROP PROCEDURE IF EXISTS tc03_run;
