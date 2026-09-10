# 01 — Requirement Analysis

| Field | Value |
|---|---|
| Document ID | MER-QA-REQ-001 |
| System | Meridian Wholesale OMS — Database layer |
| Version | 1.0 |
| Status | Baselined |
| Author | Rethabile C. M. Qhomane |
| Date | 2026-09-09 |
| STLC phase | Requirement analysis |

---

## 1. Purpose

Capture testable requirements for the Meridian OMS database **before** test planning and case design. Requirements come from business rules for a South African wholesale distributor. The database is the system under test (SUT). There is no UI in scope.

## 2. In scope

- Schema objects: tables, keys, CHECK constraints, indexes, view
- Stock reservation, confirmation, shipping deduction, cancellation
- Order header / line financial consistency
- Order status state machine
- Payment allocation against an order
- Transaction atomicity on confirm
- Audit trail for status changes
- Index presence for the open-order exposure query

## 3. Out of scope

- Application UI, API controllers, Selenium
- CI/CD (Jenkins)
- VAT calculation engine, credit-scoring, courier integration
- Backup / point-in-time recovery drills
- Cross-database replication

## 4. Stakeholders

| Role | Interest |
|---|---|
| Warehouse | Stock on hand and reserved must be trustworthy |
| Credit control | Payments cannot exceed the invoice total |
| Finance | Order totals match line items |
| Compliance | Status changes are auditable |
| QA | Requirements are unambiguous and testable |

## 5. Functional requirements

| ID | Requirement | Priority | Source |
|---|---|---|---|
| FR-01 | Product SKU and customer email / code are unique. Prices, quantities, credit limits and order totals cannot be negative. Order line quantity must be greater than zero. Line total must equal quantity × unit price. | High | Data model |
| FR-02 | A customer, product or warehouse that is referenced by orders or inventory cannot be deleted (RESTRICT). Deleting an order deletes its lines (CASCADE). | High | Data model |
| FR-03 | Confirming a DRAFT order reserves `qty` on each line against `inventory.qty_reserved` at the order warehouse. Confirm is rejected when available stock (`qty_on_hand - qty_reserved`) is insufficient. | High | Warehouse rule WR-01 |
| FR-04 | `orders.total_amount` always equals the sum of `order_items.line_total` after recalculation. | High | Finance rule FN-01 |
| FR-05 | Allowed status path: DRAFT → CONFIRMED → PICKING → SHIPPED → DELIVERED. Pre-ship statuses may move to CANCELLED. All other transitions are rejected. Shipping converts reserved quantity into a physical deduction from `qty_on_hand`. | High | Operations rule OP-01 |
| FR-06 | Cleared payments on an order must not exceed `orders.total_amount`. Payments are not accepted on DRAFT or CANCELLED orders. | High | Finance rule FN-02 |
| FR-07 | If confirm detects insufficient stock, the order remains DRAFT, reserved quantities are unchanged, and no confirm audit row is written. | High | Warehouse rule WR-02 |
| FR-08 | Cancelling CONFIRMED or PICKING releases the reserved quantity back to availability. SHIPPED / DELIVERED / already-CANCELLED cannot be cancelled. | High | Warehouse rule WR-03 |
| FR-09 | Every successful confirm, cancel and status change writes a row to `audit_log`. A direct UPDATE of `orders.status` is also audited by trigger. | Medium | Compliance rule CM-01 |
| FR-10 | Lookups of orders by status and date use index `idx_orders_status_date`. Order number lookups use `uq_orders_number`. | Medium | Performance rule PF-01 |

## 6. Non-functional requirements

| ID | Requirement | Priority |
|---|---|---|
| NFR-01 | Engine is InnoDB so transactions and row locks are available. | High |
| NFR-02 | Procedures that change stock run in a single transaction with `FOR UPDATE` on the order and affected inventory rows. | High |
| NFR-03 | Character set `utf8mb4` to support South African names and references. | Low |
| NFR-04 | Monetary values use `DECIMAL`, never `FLOAT`. | High |

## 7. Business rules (plain language)

1. Available to sell = on hand − reserved.
2. Confirming an order is a promise to the customer; stock is ring-fenced.
3. Cancelling that promise must put the stock back.
4. Shipping is the moment stock physically leaves.
5. Money received cannot exceed the invoice.
6. Nobody silently changes an order status without a trail.

## 8. Assumptions

- Single warehouse per order.
- One product may appear only once per order.
- Seeded catalogue and opening stock are the controlled test baseline.
- Application users call the stored procedures; they do not update inventory by hand in production. Tests still try illegal direct writes where a constraint should stop them.

## 9. Questions closed during analysis

| Question | Decision |
|---|---|
| Soft delete customers? | No. Status `CLOSED` plus RESTRICT on delete. |
| Allow overselling? | No. Confirm must fail closed. |
| Partial payments? | Yes, as long as the sum of cleared payments ≤ total. |
| Who may cancel SHIPPED? | Nobody via `sp_cancel_order`. Returns need a future process. |

## 10. Requirement sign-off

Requirements in this document are the baseline for the test plan and the traceability matrix. No test case is written for a rule that is not listed here.
