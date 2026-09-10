# 03 — Test Design Strategy

| Field | Value |
|---|---|
| Document ID | MER-QA-TD-001 |
| STLC phase | Test design |
| Basis | Requirements + Test plan |

---

## 1. Coverage goal

Every functional requirement FR-01 … FR-10 has at least one test case. High-priority warehouse and finance rules have both a positive and a negative path.

## 2. Techniques applied

| Technique | Used on | Example |
|---|---|---|
| Equivalence partitioning | Prices, quantities, payment amounts | Valid amount > 0 vs amount ≤ 0 |
| Boundary value analysis | Stock availability | Request available qty vs available + 1 |
| Decision table | Confirm | Status = DRAFT AND stock OK → reserve; else reject |
| State transition | Order status | Legal path vs DRAFT→SHIPPED vs SHIPPED→DRAFT |
| Error guessing | Direct illegal DML | Negative price, duplicate SKU, delete in-use customer |
| Requirements-based | Whole suite | RTM in document 04 |

## 3. Decision table — confirm order (FR-03 / FR-07)

| Condition / action | C1 | C2 | C3 | C4 |
|---|---|---|---|---|
| Order exists | Y | Y | Y | N |
| Status = DRAFT | Y | Y | N | — |
| Stock available for every line | Y | N | — | — |
| **Reserve stock** | X | | | |
| **Set CONFIRMED + audit** | X | | | |
| **Remain DRAFT, no audit** | | X | | |
| **ERROR_INVALID_STATUS** | | | X | |
| **ERROR_NOT_FOUND** | | | | X |

C1 is covered by TC-03 (happy) and TC-09 (audit).  
C2 is covered by TC-03 (oversell) and TC-07 (atomicity).

## 4. State model — order status (FR-05)

```
                ┌──────────┐
                │  DRAFT   │
                └────┬─────┘
                     │ confirm
                     v
                ┌──────────┐     cancel      ┌────────────┐
                │CONFIRMED │ ───────────────►│ CANCELLED  │
                └────┬─────┘                 └────────────┘
                     │ advance                        ^
                     v                                │
                ┌──────────┐     cancel               │
                │ PICKING  │ ─────────────────────────┘
                └────┬─────┘
                     │ ship (deduct on-hand)
                     v
                ┌──────────┐
                │ SHIPPED  │
                └────┬─────┘
                     │
                     v
                ┌──────────┐
                │DELIVERED │
                └──────────┘
```

Illegal examples designed into TC-05: DRAFT→SHIPPED, SHIPPED→DRAFT.

## 5. Data design

| Set | Content |
|---|---|
| Master | 3 customers (ACTIVE ×2, CLOSED ×1), 2 warehouses, 4 products (1 discontinued) |
| Stock | BFN: 200 cement, 5000 bricks, 40 paint. JHB: 80 cement, 10 paint |
| Standing orders | DRAFT ORD-10001, CONFIRMED ORD-10002 (20 cement reserved), SHIPPED ORD-10003 |
| Transient | Each mutating case inserts `ORD-TCxx-<timestamp>` |

## 6. Case inventory

| ID | Title | Primary FR | Type | Expected first cycle |
|---|---|---|---|---|
| TC-01 | Schema and constraint enforcement | FR-01 | Negative | PASS |
| TC-02 | Referential integrity | FR-02 | Negative + cascade | PASS |
| TC-03 | Stock reservation on confirm | FR-03 | Positive + negative | PASS |
| TC-04 | Header vs line totals | FR-04 | Positive + negative | PASS |
| TC-05 | Status state machine | FR-05 | Transition | PASS |
| TC-06 | Payment cap | FR-06 | Negative | FAIL (DEF-002) |
| TC-07 | Confirm atomicity | FR-07 | Negative / transaction | PASS |
| TC-08 | Cancel releases stock | FR-08 | Positive | FAIL (DEF-001) |
| TC-09 | Audit trail | FR-09 | Positive | PASS |
| TC-10 | Index presence for reporting | FR-10 | Structural / performance | PASS |

## 7. Oracle (how expected results are known)

- Constraints: MySQL must raise SQL exception.
- Procedures: `OUT p_result` plus table contents after `COMMIT` / `ROLLBACK`.
- Audit: row count and JSON payload in `audit_log`.
- Performance: `information_schema.STATISTICS` plus `EXPLAIN`.

## 8. Design review checklist

- [x] Every FR has a case
- [x] Every case has preconditions, steps, expected result
- [x] Negative paths exist for money and stock
- [x] Two cases reserved to demonstrate defect handling
- [x] Scripts are executable without a GUI
