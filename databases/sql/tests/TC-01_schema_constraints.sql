-- TC-01  Schema and constraint enforcement
-- Expected: PASS
USE meridian_oms;

DELIMITER $$
DROP PROCEDURE IF EXISTS tc01_run $$
CREATE PROCEDURE tc01_run()
BEGIN
  DECLARE v_neg_price   INT DEFAULT 0;
  DECLARE v_dup_sku     INT DEFAULT 0;
  DECLARE v_zero_qty    INT DEFAULT 0;
  DECLARE v_neg_credit  INT DEFAULT 0;
  DECLARE v_pass        INT DEFAULT 0;

  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_neg_price = 1;
  INSERT INTO products (sku, product_name, unit_price) VALUES ('SKU-NEG', 'Illegal negative price', -0.01);

  BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_dup_sku = 1;
    INSERT INTO products (sku, product_name, unit_price) VALUES ('SKU-CEM-50', 'Duplicate SKU', 10.00);
  END;

  BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_zero_qty = 1;
    INSERT INTO order_items (order_id, product_id, qty, unit_price, line_total)
    VALUES (1, 3, 0, 449.00, 0.00);
  END;

  BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_neg_credit = 1;
    INSERT INTO customers (customer_code, legal_name, email, credit_limit)
    VALUES ('CUS-BAD', 'Bad Credit', 'bad@demo.co.za', -100.00);
  END;

  IF v_neg_price = 1 AND v_dup_sku = 1 AND v_zero_qty = 1 AND v_neg_credit = 1 THEN
    SET v_pass = 1;
  END IF;

  SELECT
    'TC-01' AS test_case,
    CASE WHEN v_pass = 1 THEN 'PASS' ELSE 'FAIL' END AS result,
    v_neg_price  AS rejected_negative_price,
    v_dup_sku    AS rejected_duplicate_sku,
    v_zero_qty   AS rejected_zero_qty,
    v_neg_credit AS rejected_negative_credit;
END $$
DELIMITER ;

CALL tc01_run();
DROP PROCEDURE IF EXISTS tc01_run;
