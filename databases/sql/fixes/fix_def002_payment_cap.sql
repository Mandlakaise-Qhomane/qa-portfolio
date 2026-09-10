-- Patch for DEF-002
-- Reject a payment that would take cleared receipts above order.total_amount.
USE meridian_oms;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_record_payment $$
CREATE PROCEDURE sp_record_payment(
  IN  p_order_id INT UNSIGNED,
  IN  p_amount   DECIMAL(12,2),
  IN  p_method   VARCHAR(20),
  OUT p_result   VARCHAR(80)
)
proc: BEGIN
  DECLARE v_status VARCHAR(20);
  DECLARE v_total  DECIMAL(12,2);
  DECLARE v_paid   DECIMAL(12,2);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_result = 'ERROR_SQL';
  END;

  START TRANSACTION;

  SELECT status, total_amount
    INTO v_status, v_total
  FROM orders
  WHERE order_id = p_order_id
  FOR UPDATE;

  IF v_status IS NULL THEN
    ROLLBACK;
    SET p_result = 'ERROR_NOT_FOUND';
    LEAVE proc;
  END IF;

  IF v_status IN ('DRAFT', 'CANCELLED') THEN
    ROLLBACK;
    SET p_result = 'ERROR_INVALID_STATUS';
    LEAVE proc;
  END IF;

  IF p_amount IS NULL OR p_amount <= 0 THEN
    ROLLBACK;
    SET p_result = 'ERROR_INVALID_AMOUNT';
    LEAVE proc;
  END IF;

  SELECT IFNULL(SUM(amount), 0) INTO v_paid
  FROM payments
  WHERE order_id = p_order_id
    AND status = 'CLEARED';

  IF v_paid + p_amount > v_total THEN
    ROLLBACK;
    SET p_result = 'ERROR_OVERPAYMENT';
    LEAVE proc;
  END IF;

  INSERT INTO payments (order_id, amount, method, status)
  VALUES (p_order_id, p_amount, p_method, 'CLEARED');

  INSERT INTO audit_log (entity_name, entity_id, action, new_values)
  VALUES (
    'payments', LAST_INSERT_ID(), 'RECORD',
    JSON_OBJECT('order_id', p_order_id, 'amount', p_amount, 'method', p_method)
  );

  COMMIT;
  SET p_result = 'OK';
END $$
DELIMITER ;
