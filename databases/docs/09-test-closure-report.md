# 09 — Test Closure Report

| Field | Value |
|---|---|
| Document ID | MER-QA-CL-001 |
| STLC phase | Test cycle closure |
| System | Meridian OMS database |
| Author | Rethabile C. M. Qhomane |
| Date | 2026-09-09 |

---

## 1. Purpose

Close the cycle against the plan. Record what was delivered, what remains, and whether the database is acceptable for this scope.

## 2. Plan vs actual

| Plan item | Planned | Actual |
|---|---|---|
| Requirements baselined | Yes | Yes — 10 FR + 4 NFR |
| Test cases | 8–10 | 10 |
| Execution | 100% of cases | 10 / 10 |
| Traceability | 100% FR mapped | 100% |
| Defect process | Failures logged | DEF-001, DEF-002 |
| Environment doc | Yes | Yes |
| Closure | Yes | This document |

## 3. Quality summary

**Cycle 1 (baseline routines)**

- 8 passed, 2 failed
- Failures were high-severity finance and warehouse breaks

**Cycle 2 (after supplied patches)**

- TC-06 and TC-08 retested and passed
- Suite result **10 / 10**

## 4. Coverage

| Layer | Covered? |
|---|---|
| Constraints / uniqueness | Yes — TC-01 |
| Foreign keys | Yes — TC-02 |
| Stock reservation | Yes — TC-03 |
| Financial header/line sync | Yes — TC-04 |
| Status machine | Yes — TC-05 |
| Payment control | Yes — TC-06 |
| Transactions / rollback | Yes — TC-07 |
| Cancellation side effects | Yes — TC-08 |
| Audit | Yes — TC-09 |
| Indexes for reporting | Yes — TC-10 |

Out of scope items from the plan were not tested and are not claimed.

## 5. Residual risk

| Risk | Level after cycle 2 | Comment |
|---|---|---|
| Concurrent confirms on the last unit of stock | Medium | Procedures use `FOR UPDATE`, but a two-session race test was not in this cycle |
| Direct UPDATE of `inventory` by a privileged user | Medium | Constraints stop negatives; they do not stop a bad manual reservation |
| Multi-warehouse split orders | Low | Model allows one warehouse per order only |
| Payment reversals / credit notes | Low | `REVERSED` exists on the enum; no procedure implements it yet |
| Disaster recovery | Out of scope | Not tested |

## 6. Outstanding work (backlog, not this cycle)

- Isolation test with two concurrent sessions on the same inventory row
- Privilege matrix (read-only clerk vs procedure-only app user)
- Payment reversal procedure
- Historic order migration script tests

## 7. Exit criteria check

| Criterion | Met? |
|---|---|
| All cases executed | Yes |
| Failures have defect records | Yes |
| RTM complete | Yes |
| Residual risk stated | Yes |
| Summary written | Yes |

**Exit criteria: met.**

## 8. Recommendation

For the documented scope, the patched database is **acceptable**. Cycle 1 findings show the tester can detect warehouse and finance breaks that constraints alone do not catch. Cycle 2 shows a closed defect lifecycle (fail → report → patch → retest).

## 9. Artefacts handed over

- Requirements, plan, design, RTM, cases, environment, execution, defects, closure (all `.md`)
- Runnable schema, routines, seed, tests, fixes
- Git history on this repository

## 10. Sign-off

Cycle closed. No further cases will be added under document version 1.0 without a new requirements baseline.
