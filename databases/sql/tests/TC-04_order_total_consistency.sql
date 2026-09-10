-- TC-04  Header total equals SUM of line totals
-- Expected: PASS
USE meridian_oms;

DELIMITER $$
DROP PROCEDURE IF EXISTS tc04_run $$
CREATE PROCEDURE tc04_run()
BEGIN
  DECLARE v_header DECIMAL(12,2);
  DECLARE v_lines  DECIMAL(12,2);
  DECLARE v_match  INT DEFAULT 0;
  DECLARE v_chk    INT DEFAULT 0;

  CALL sp_recalc_order_total(1);

  SELECT total_amount INTO v_header FROM orders WHERE order_id = 1;
  SELECT SUM(line_total) INTO v_lines FROM order_items WHERE order_id = 1;

  IF v_header = v_lines AND v_header = 1224.00 THEN
    SET v_match = 1;
  END IF;

  -- line_total must equal qty * unit_price (CHECK constraint)
  BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_chk = 1;
    INSERT INTO order_items (order_id, product_id, qty, unit_price, line_total)
    VALUES (1, 3, 2, 449.00, 1.00); -- deliberately wrong line_total
  END;

  SELECT
    'TC-04' AS test_case,
    CASE WHEN v_match = 1 AND v_chk = 1 THEN 'PASS' ELSE 'FAIL' END AS result,
    v_header AS header_total,
    v_lines  AS summed_lines,
    v_chk    AS mismatched_line_rejected;
END $$
DELIMITER ;

CALL tc04_run();
DROP PROCEDURE IF EXISTS tc04_run;
