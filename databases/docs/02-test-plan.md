# 02 — Test Plan

| Field | Value |
|---|---|
| Document ID | MER-QA-TP-001 |
| System | Meridian OMS database |
| Version | 1.0 |
| Status | Approved for execution |
| Author | Rethabile C. M. Qhomane |
| Date | 2026-09-09 |
| STLC phase | Test planning |
| Basis | [01-requirement-analysis.md](01-requirement-analysis.md) |

---

## 1. Objective

Confirm that the Meridian OMS MySQL database enforces the baselined business rules for stock, money, status and audit, and that the work is documented to STLC standard.

## 2. Test items

| Item | Location |
|---|---|
| Schema | `sql/01_schema.sql` |
| Procedures and trigger | `sql/02_routines.sql` |
| Baseline data | `sql/03_seed.sql` |
| View `vw_open_order_exposure` | schema script |

## 3. Features to be tested

FR-01 to FR-10 as listed in the requirements document.

## 4. Features not to be tested

UI, API controllers, Jenkins, Selenium, replication, disaster recovery, VAT.

## 5. Approach

- **Type:** Manual database testing with scripted SQL (repeatable).
- **Style:** Black-box against procedures, grey-box against schema and `EXPLAIN`.
- **Design techniques:** equivalence partitioning, boundary values, state transition, decision tables, error guessing, requirements-based coverage.
- **Independence:** each test case creates or uses isolated rows where mutation is required. Baseline is reseeded when a case needs a clean warehouse picture.
- **Defects:** two production-style faults are present in the baseline routines so the cycle can demonstrate fail → log → fix → retest.

## 6. Item pass / fail criteria

A test case **passes** when every expected result in [05-test-cases.md](05-test-cases.md) is observed, including expected SQL exceptions.

A test case **fails** when any expected result is missing, an unexpected exception is raised, or leftover data violates a business rule.

## 7. Entry criteria

- Requirements baselined.
- Test plan and cases reviewed.
- MySQL 8 available locally.
- `01_schema.sql`, `02_routines.sql`, `03_seed.sql` applied with no error.
- Tester can run `SELECT` / `CALL` as a user with full rights on `meridian_oms` (test environment only).

## 8. Exit criteria

- All 10 cases executed at least once.
- Every failure has a defect record.
- Traceability matrix is complete (100% of FR IDs mapped).
- Residual risk is stated in the closure report.
- Test summary signed off.

## 9. Suspension / resumption

Suspend if the schema cannot be created or seed fails. Resume after the environment document steps succeed.

## 10. Deliverables

All Markdown documents in `docs/`, SQL assets in `sql/`, execution notes in `evidence/`.

## 11. Environment needs

See [06-test-environment.md](06-test-environment.md). Minimum: MySQL 8.0+, InnoDB, `utf8mb4`, 200 MB disk.

## 12. Staffing and schedule

| Activity | Owner | Effort |
|---|---|---|
| Requirement analysis | QA | 0.5 day |
| Plan + design + cases | QA | 1 day |
| Environment + seed | QA | 0.25 day |
| Execution + defects | QA | 0.5 day |
| Closure | QA | 0.25 day |

This is a portfolio cycle, not a multi-sprint programme.

## 13. Risks and mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Cases share rows and contaminate each other | Medium | High | Isolated order numbers; reseed when needed |
| CHECK constraints disabled by old sql_mode | Low | High | Document required MySQL 8 settings |
| Tester runs only happy paths | Medium | High | Explicit negative steps in every high-priority case |
| Procedures bypassed by raw UPDATEs in production | Medium | High | Constraints + trigger still tested |

## 14. Roles

| Role | Responsibility |
|---|---|
| QA tester | Design, execute, log defects, close cycle |
| Developer (implied) | Apply fixes in `sql/fixes/` |
| Reviewer | Read plan and cases before execution |

## 15. Approval

Plan approved for a single test cycle against baseline `sql/02_routines.sql`.
