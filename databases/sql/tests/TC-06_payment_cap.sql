-- TC-06  Payments must not exceed order total
-- Expected: FAIL on baseline  (DEF-002)
USE meridian_oms;

DELIMITER $$
DROP PROCEDURE IF EXISTS tc06_run $$
CREATE PROCEDURE tc06_run()
BEGIN
  DECLARE r1       VARCHAR(80);
  DECLARE r2       VARCHAR(80);
  DECLARE v_order  INT;
  DECLARE v_paid   DECIMAL(12,2);
  DECLARE v_total  DECIMAL(12,2) DEFAULT 179.80;
  DECLARE v_blocked INT DEFAULT 0;

  INSERT INTO orders (order_number, customer_id, warehouse_id, status, order_date, total_amount)
  VALUES (CONCAT('ORD-TC06-', UNIX_TIMESTAMP()), 1, 1, 'CONFIRMED', CURRENT_DATE, v_total);
  SET v_order = LAST_INSERT_ID();

  INSERT INTO order_items (order_id, product_id, qty, unit_price, line_total)
  VALUES (v_order, 1, 2, 89.90, 179.80);

  CALL sp_record_payment(v_order, 179.80, 'EFT', r1);
  CALL sp_record_payment(v_order, 1.00,    'EFT', r2);

  SELECT IFNULL(SUM(amount), 0) INTO v_paid
  FROM payments
  WHERE order_id = v_order AND status = 'CLEARED';

  IF r2 IN ('ERROR_OVERPAYMENT', 'ERROR_INVALID_AMOUNT') AND v_paid <= v_total THEN
    SET v_blocked = 1;
  END IF;

  SELECT
    'TC-06' AS test_case,
    CASE WHEN v_blocked = 1 THEN 'PASS' ELSE 'FAIL' END AS result,
    v_order AS isolated_order_id,
    r1      AS first_payment,
    r2      AS overpay_attempt,
    v_total AS order_total,
    v_paid  AS cleared_paid,
    'DEF-002' AS linked_defect;
END $$
DELIMITER ;

CALL tc06_run();
DROP PROCEDURE IF EXISTS tc06_run;
