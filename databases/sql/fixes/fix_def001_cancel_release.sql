-- Patch for DEF-001
-- Cancel of CONFIRMED / PICKING orders must release qty_reserved.
USE meridian_oms;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_cancel_order $$
CREATE PROCEDURE sp_cancel_order(
  IN  p_order_id INT UNSIGNED,
  OUT p_result   VARCHAR(80)
)
proc: BEGIN
  DECLARE v_status    VARCHAR(20);
  DECLARE v_warehouse TINYINT UNSIGNED;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_result = 'ERROR_SQL';
  END;

  START TRANSACTION;

  SELECT status, warehouse_id
    INTO v_status, v_warehouse
  FROM orders
  WHERE order_id = p_order_id
  FOR UPDATE;

  IF v_status IS NULL THEN
    ROLLBACK;
    SET p_result = 'ERROR_NOT_FOUND';
    LEAVE proc;
  END IF;

  IF v_status IN ('SHIPPED', 'DELIVERED', 'CANCELLED') THEN
    ROLLBACK;
    SET p_result = 'ERROR_INVALID_STATUS';
    LEAVE proc;
  END IF;

  IF v_status IN ('CONFIRMED', 'PICKING') THEN
    UPDATE inventory inv
    JOIN order_items oi ON oi.product_id = inv.product_id
    SET inv.qty_reserved = inv.qty_reserved - oi.qty,
        inv.row_version  = inv.row_version + 1
    WHERE oi.order_id = p_order_id
      AND inv.warehouse_id = v_warehouse;
  END IF;

  UPDATE orders
  SET status = 'CANCELLED',
      row_version = row_version + 1
  WHERE order_id = p_order_id;

  INSERT INTO audit_log (entity_name, entity_id, action, old_values, new_values)
  VALUES (
    'orders', p_order_id, 'CANCEL',
    JSON_OBJECT('status', v_status),
    JSON_OBJECT('status', 'CANCELLED')
  );

  COMMIT;
  SET p_result = 'OK';
END $$
DELIMITER ;
