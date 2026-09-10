-- TC-09  Sensitive status changes write an audit row
-- Expected: PASS
USE meridian_oms;

DELIMITER $$
DROP PROCEDURE IF EXISTS tc09_run $$
CREATE PROCEDURE tc09_run()
BEGIN
  DECLARE v_result   VARCHAR(80);
  DECLARE v_proc_row INT DEFAULT 0;
  DECLARE v_trg_row  INT DEFAULT 0;
  DECLARE v_pass     INT DEFAULT 0;
  DECLARE v_before   INT;

  SELECT COUNT(*) INTO v_before FROM audit_log;

  -- Procedure path writes action = CONFIRM
  -- ORD-10001 is DRAFT in a fresh seed
  CALL sp_confirm_order(1, v_result);

  SELECT COUNT(*) INTO v_proc_row
  FROM audit_log
  WHERE entity_name = 'orders'
    AND entity_id = '1'
    AND action = 'CONFIRM';

  -- Trigger path: direct UPDATE still audited as STATUS_UPDATE_ROW
  UPDATE orders SET status = 'PICKING' WHERE order_id = 1 AND status = 'CONFIRMED';

  SELECT COUNT(*) INTO v_trg_row
  FROM audit_log
  WHERE entity_name = 'orders'
    AND entity_id = '1'
    AND action = 'STATUS_UPDATE_ROW'
    AND JSON_UNQUOTE(JSON_EXTRACT(new_values, '$.status')) = 'PICKING';

  IF v_result = 'OK' AND v_proc_row >= 1 AND v_trg_row >= 1 THEN
    SET v_pass = 1;
  END IF;

  SELECT
    'TC-09' AS test_case,
    CASE WHEN v_pass = 1 THEN 'PASS' ELSE 'FAIL' END AS result,
    v_result   AS confirm_result,
    v_proc_row AS procedure_audit_rows,
    v_trg_row  AS trigger_audit_rows,
    v_before   AS audit_rows_before;
END $$
DELIMITER ;

CALL tc09_run();
DROP PROCEDURE IF EXISTS tc09_run;
