-- =============================================================================
-- Meridian OMS — Stored procedures and triggers
-- NOTE: Two known defects are left in this baseline (see docs/08-defect-reports.md)
--   DEF-001  sp_cancel_order does not release qty_reserved
--   DEF-002  sp_record_payment allows payments to exceed order total
-- =============================================================================

USE meridian_oms;

DELIMITER $$

-- Recalculate header total from lines
DROP PROCEDURE IF EXISTS sp_recalc_order_total $$
CREATE PROCEDURE sp_recalc_order_total(IN p_order_id INT UNSIGNED)
BEGIN
  UPDATE orders o
  SET o.total_amount = (
        SELECT IFNULL(SUM(oi.line_total), 0)
        FROM order_items oi
        WHERE oi.order_id = p_order_id
      ),
      o.row_version = o.row_version + 1
  WHERE o.order_id = p_order_id;
END $$

-- Confirm a DRAFT order: reserve stock atomically
DROP PROCEDURE IF EXISTS sp_confirm_order $$
CREATE PROCEDURE sp_confirm_order(
  IN  p_order_id INT UNSIGNED,
  OUT p_result   VARCHAR(80)
)
proc: BEGIN
  DECLARE v_status     VARCHAR(20);
  DECLARE v_warehouse  TINYINT UNSIGNED;
  DECLARE v_short      INT DEFAULT 0;

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

  IF v_status <> 'DRAFT' THEN
    ROLLBACK;
    SET p_result = 'ERROR_INVALID_STATUS';
    LEAVE proc;
  END IF;

  -- Lock inventory rows for every line and test availability
  SELECT COUNT(*) INTO v_short
  FROM order_items oi
  JOIN inventory inv
    ON inv.product_id = oi.product_id
   AND inv.warehouse_id = v_warehouse
  WHERE oi.order_id = p_order_id
    AND (inv.qty_on_hand - inv.qty_reserved) < oi.qty
  FOR UPDATE;

  IF v_short > 0 THEN
    ROLLBACK;
    SET p_result = 'ERROR_INSUFFICIENT_STOCK';
    LEAVE proc;
  END IF;

  UPDATE inventory inv
  JOIN order_items oi
    ON oi.product_id = inv.product_id
  SET inv.qty_reserved = inv.qty_reserved + oi.qty,
      inv.row_version  = inv.row_version + 1
  WHERE oi.order_id = p_order_id
    AND inv.warehouse_id = v_warehouse;

  UPDATE orders
  SET status = 'CONFIRMED',
      row_version = row_version + 1
  WHERE order_id = p_order_id;

  INSERT INTO audit_log (entity_name, entity_id, action, new_values)
  VALUES ('orders', p_order_id, 'CONFIRM', JSON_OBJECT('status', 'CONFIRMED'));

  COMMIT;
  SET p_result = 'OK';
END $$

-- Advance status along the allowed path (no stock change except SHIPPED)
DROP PROCEDURE IF EXISTS sp_advance_status $$
CREATE PROCEDURE sp_advance_status(
  IN  p_order_id  INT UNSIGNED,
  IN  p_new_status VARCHAR(20),
  OUT p_result    VARCHAR(80)
)
proc: BEGIN
  DECLARE v_status    VARCHAR(20);
  DECLARE v_warehouse TINYINT UNSIGNED;
  DECLARE v_allowed   TINYINT DEFAULT 0;

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

  SET v_allowed = CASE
    WHEN v_status = 'CONFIRMED' AND p_new_status = 'PICKING'   THEN 1
    WHEN v_status = 'PICKING'   AND p_new_status = 'SHIPPED'   THEN 1
    WHEN v_status = 'SHIPPED'   AND p_new_status = 'DELIVERED' THEN 1
    ELSE 0
  END;

  IF v_allowed = 0 THEN
    ROLLBACK;
    SET p_result = 'ERROR_INVALID_TRANSITION';
    LEAVE proc;
  END IF;

  -- On ship: convert reservation into a physical deduction
  IF p_new_status = 'SHIPPED' THEN
    UPDATE inventory inv
    JOIN order_items oi ON oi.product_id = inv.product_id
    SET inv.qty_on_hand  = inv.qty_on_hand  - oi.qty,
        inv.qty_reserved = inv.qty_reserved - oi.qty,
        inv.row_version  = inv.row_version + 1
    WHERE oi.order_id = p_order_id
      AND inv.warehouse_id = v_warehouse;
  END IF;

  UPDATE orders
  SET status = p_new_status,
      row_version = row_version + 1
  WHERE order_id = p_order_id;

  INSERT INTO audit_log (entity_name, entity_id, action, old_values, new_values)
  VALUES (
    'orders', p_order_id, 'STATUS_CHANGE',
    JSON_OBJECT('status', v_status),
    JSON_OBJECT('status', p_new_status)
  );

  COMMIT;
  SET p_result = 'OK';
END $$

-- DEF-001: reservation is NOT released. This is intentional for the first test cycle.
DROP PROCEDURE IF EXISTS sp_cancel_order $$
CREATE PROCEDURE sp_cancel_order(
  IN  p_order_id INT UNSIGNED,
  OUT p_result   VARCHAR(80)
)
proc: BEGIN
  DECLARE v_status VARCHAR(20);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_result = 'ERROR_SQL';
  END;

  START TRANSACTION;

  SELECT status INTO v_status
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

  -- Missing: release qty_reserved when status IN ('CONFIRMED','PICKING')
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

-- DEF-002: no cap against order total / already-paid amount
DROP PROCEDURE IF EXISTS sp_record_payment $$
CREATE PROCEDURE sp_record_payment(
  IN  p_order_id INT UNSIGNED,
  IN  p_amount   DECIMAL(12,2),
  IN  p_method   VARCHAR(20),
  OUT p_result   VARCHAR(80)
)
proc: BEGIN
  DECLARE v_status VARCHAR(20);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_result = 'ERROR_SQL';
  END;

  START TRANSACTION;

  SELECT status INTO v_status
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

  -- Missing: reject when paid_to_date + p_amount > total_amount

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

-- Trigger: any direct UPDATE of orders.status is audited
DROP TRIGGER IF EXISTS trg_orders_status_audit $$
CREATE TRIGGER trg_orders_status_audit
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
  IF OLD.status <> NEW.status THEN
    INSERT INTO audit_log (entity_name, entity_id, action, old_values, new_values)
    VALUES (
      'orders', NEW.order_id, 'STATUS_UPDATE_ROW',
      JSON_OBJECT('status', OLD.status),
      JSON_OBJECT('status', NEW.status)
    );
  END IF;
END $$

DELIMITER ;
