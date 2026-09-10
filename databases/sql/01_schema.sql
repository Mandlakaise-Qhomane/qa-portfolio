-- =============================================================================
-- Meridian OMS — Schema (System Under Test)
-- MySQL 8 / InnoDB
-- Character set: utf8mb4
-- =============================================================================

DROP DATABASE IF EXISTS meridian_oms;
CREATE DATABASE meridian_oms
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE meridian_oms;

-- -----------------------------------------------------------------------------
-- Reference / master data
-- -----------------------------------------------------------------------------

CREATE TABLE customers (
  customer_id     INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  customer_code   VARCHAR(20)      NOT NULL,
  legal_name      VARCHAR(150)     NOT NULL,
  email           VARCHAR(120)     NOT NULL,
  phone           VARCHAR(20)      NULL,
  credit_limit    DECIMAL(12,2)    NOT NULL DEFAULT 0.00,
  account_status  ENUM('ACTIVE','ON_HOLD','CLOSED') NOT NULL DEFAULT 'ACTIVE',
  created_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (customer_id),
  UNIQUE KEY uq_customers_code  (customer_code),
  UNIQUE KEY uq_customers_email (email),
  CONSTRAINT chk_customers_credit CHECK (credit_limit >= 0)
) ENGINE=InnoDB;

CREATE TABLE warehouses (
  warehouse_id  TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  warehouse_code VARCHAR(10)     NOT NULL,
  warehouse_name VARCHAR(80)     NOT NULL,
  is_active     TINYINT(1)       NOT NULL DEFAULT 1,
  PRIMARY KEY (warehouse_id),
  UNIQUE KEY uq_warehouses_code (warehouse_code)
) ENGINE=InnoDB;

CREATE TABLE products (
  product_id    INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  sku           VARCHAR(30)      NOT NULL,
  product_name  VARCHAR(150)     NOT NULL,
  unit_price    DECIMAL(10,2)    NOT NULL,
  is_active     TINYINT(1)       NOT NULL DEFAULT 1,
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (product_id),
  UNIQUE KEY uq_products_sku (sku),
  CONSTRAINT chk_products_price CHECK (unit_price >= 0)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- Inventory — qty_on_hand is physical stock; qty_reserved is confirmed, not shipped
-- Available to sell = qty_on_hand - qty_reserved
-- -----------------------------------------------------------------------------

CREATE TABLE inventory (
  inventory_id   INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  warehouse_id   TINYINT UNSIGNED NOT NULL,
  product_id     INT UNSIGNED     NOT NULL,
  qty_on_hand    INT              NOT NULL DEFAULT 0,
  qty_reserved   INT              NOT NULL DEFAULT 0,
  row_version    INT UNSIGNED     NOT NULL DEFAULT 1,
  updated_at     DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (inventory_id),
  UNIQUE KEY uq_inventory_wh_prod (warehouse_id, product_id),
  KEY idx_inventory_product (product_id),
  CONSTRAINT fk_inv_warehouse FOREIGN KEY (warehouse_id)
    REFERENCES warehouses (warehouse_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_inv_product FOREIGN KEY (product_id)
    REFERENCES products (product_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_inv_on_hand  CHECK (qty_on_hand  >= 0),
  CONSTRAINT chk_inv_reserved CHECK (qty_reserved >= 0)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- Orders
-- Status path (happy): DRAFT -> CONFIRMED -> PICKING -> SHIPPED -> DELIVERED
-- Alternate:           any pre-SHIPPED -> CANCELLED
-- -----------------------------------------------------------------------------

CREATE TABLE orders (
  order_id       INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  order_number   VARCHAR(20)      NOT NULL,
  customer_id    INT UNSIGNED     NOT NULL,
  warehouse_id   TINYINT UNSIGNED NOT NULL,
  status         ENUM('DRAFT','CONFIRMED','PICKING','SHIPPED','DELIVERED','CANCELLED')
                                  NOT NULL DEFAULT 'DRAFT',
  order_date     DATE             NOT NULL,
  total_amount   DECIMAL(12,2)    NOT NULL DEFAULT 0.00,
  row_version    INT UNSIGNED     NOT NULL DEFAULT 1,
  created_at     DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (order_id),
  UNIQUE KEY uq_orders_number (order_number),
  KEY idx_orders_customer (customer_id),
  KEY idx_orders_status_date (status, order_date),
  CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
    REFERENCES customers (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_orders_warehouse FOREIGN KEY (warehouse_id)
    REFERENCES warehouses (warehouse_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_orders_total CHECK (total_amount >= 0)
) ENGINE=InnoDB;

CREATE TABLE order_items (
  order_item_id  INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  order_id       INT UNSIGNED     NOT NULL,
  product_id     INT UNSIGNED     NOT NULL,
  qty            INT              NOT NULL,
  unit_price     DECIMAL(10,2)    NOT NULL,
  line_total     DECIMAL(12,2)    NOT NULL,
  PRIMARY KEY (order_item_id),
  UNIQUE KEY uq_order_items_order_product (order_id, product_id),
  KEY idx_order_items_product (product_id),
  CONSTRAINT fk_items_order FOREIGN KEY (order_id)
    REFERENCES orders (order_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_items_product FOREIGN KEY (product_id)
    REFERENCES products (product_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_items_qty   CHECK (qty > 0),
  CONSTRAINT chk_items_price CHECK (unit_price >= 0),
  CONSTRAINT chk_items_line  CHECK (line_total = qty * unit_price)
) ENGINE=InnoDB;

CREATE TABLE payments (
  payment_id     INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  order_id       INT UNSIGNED     NOT NULL,
  amount         DECIMAL(12,2)    NOT NULL,
  method         ENUM('EFT','CARD','CASH','CREDIT_NOTE') NOT NULL,
  status         ENUM('PENDING','CLEARED','FAILED','REVERSED') NOT NULL DEFAULT 'CLEARED',
  paid_at        DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  reference_no   VARCHAR(40)      NULL,
  PRIMARY KEY (payment_id),
  KEY idx_payments_order (order_id),
  CONSTRAINT fk_pay_order FOREIGN KEY (order_id)
    REFERENCES orders (order_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_pay_amount CHECK (amount > 0)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- Audit — written by trigger / procedures
-- -----------------------------------------------------------------------------

CREATE TABLE audit_log (
  audit_id       BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
  entity_name    VARCHAR(40)      NOT NULL,
  entity_id      VARCHAR(40)      NOT NULL,
  action         VARCHAR(30)      NOT NULL,
  old_values     JSON             NULL,
  new_values     JSON             NULL,
  changed_by     VARCHAR(60)      NOT NULL DEFAULT (CURRENT_USER()),
  changed_at     DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (audit_id),
  KEY idx_audit_entity (entity_name, entity_id),
  KEY idx_audit_changed_at (changed_at)
) ENGINE=InnoDB;

-- Reporting view used in TC-10 (index / EXPLAIN checks)
CREATE OR REPLACE VIEW vw_open_order_exposure AS
SELECT
  o.order_id,
  o.order_number,
  o.customer_id,
  c.legal_name,
  o.status,
  o.total_amount,
  IFNULL(SUM(CASE WHEN p.status = 'CLEARED' THEN p.amount ELSE 0 END), 0) AS paid_amount,
  o.total_amount - IFNULL(SUM(CASE WHEN p.status = 'CLEARED' THEN p.amount ELSE 0 END), 0) AS outstanding
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
LEFT JOIN payments p ON p.order_id = o.order_id
WHERE o.status NOT IN ('CANCELLED')
GROUP BY o.order_id, o.order_number, o.customer_id, c.legal_name, o.status, o.total_amount;
