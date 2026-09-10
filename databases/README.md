# Database testing — Meridian OMS (MySQL 8)

**GitHub path:** [`database/`](https://github.com/Mandlakaise-Qhomane/qa-portfolio/tree/main/database) in `qa-portfolio`

**System under test:** Meridian Wholesale Order Management System (MySQL 8)  
**Discipline:** Database testing aligned to the Software Testing Life Cycle (STLC)  
**Candidate:** Rethabile Cecil Mandlakaise Qhomane  
**Role target:** Junior / Entry QA Tester · API + Database validation  
**Test cases:** 10  
**Documents:** All STLC artefacts are Markdown (`.md`)

This repository is a complete, runnable database-testing project. It starts with requirements, plans the work, designs cases, prepares an environment, executes tests against MySQL, logs defects, and closes the cycle with a summary report.

It is intended to show hiring managers that the tester can:

- derive test conditions from business rules, not only from a UI
- design cases using STLC and a requirements traceability matrix
- validate schema, constraints, referential integrity, transactions, state machines, audit trails, and query performance
- write reproduction SQL, expected vs actual results, and defect reports a developer can act on

---

## What this project proves

| Capability | Where it is shown |
|---|---|
| Requirement analysis | [docs/01-requirement-analysis.md](docs/01-requirement-analysis.md) |
| Test planning (scope, risk, entry/exit) | [docs/02-test-plan.md](docs/02-test-plan.md) |
| Design techniques + coverage | [docs/03-test-design-strategy.md](docs/03-test-design-strategy.md) |
| Requirements ↔ cases | [docs/04-traceability-matrix.md](docs/04-traceability-matrix.md) |
| 10 executable test cases | [docs/05-test-cases.md](docs/05-test-cases.md) |
| Environment & data | [docs/06-test-environment.md](docs/06-test-environment.md) |
| Execution evidence | [docs/07-test-execution-report.md](docs/07-test-execution-report.md) |
| Defect lifecycle | [docs/08-defect-reports.md](docs/08-defect-reports.md) |
| Cycle closure | [docs/09-test-closure-report.md](docs/09-test-closure-report.md) |
| Runnable MySQL assets | [`sql/`](sql/) |

---

## Domain in one paragraph

Meridian Wholesale (Pty) Ltd distributes stock from warehouses to credit-account customers. An order moves through a controlled status path. Confirming an order **reserves** stock. Cancelling must **release** that reservation. Payments must never exceed the order total. Sensitive changes must be written to an audit log. These rules live in the database (constraints, procedures, triggers), so they can be tested without a UI.

---

## Repository layout

```
meridian-oms-db-qa/
├── README.md
├── .gitignore
├── docs/                          # STLC documents (all .md)
│   ├── 01-requirement-analysis.md
│   ├── 02-test-plan.md
│   ├── 03-test-design-strategy.md
│   ├── 04-traceability-matrix.md
│   ├── 05-test-cases.md
│   ├── 06-test-environment.md
│   ├── 07-test-execution-report.md
│   ├── 08-defect-reports.md
│   └── 09-test-closure-report.md
├── sql/
│   ├── 01_schema.sql              # tables, keys, checks, indexes
│   ├── 02_routines.sql            # procedures + audit trigger
│   ├── 03_seed.sql                # controlled baseline data
│   ├── 04_reset.sql               # return DB to known state
│   ├── tests/                     # one script per test case
│   └── fixes/                     # optional patches after defects
└── evidence/                      # notes on how to capture EXPLAIN / results
```

---

## Quick start (MySQL 8)

```bash
mysql -u root -p < sql/01_schema.sql
mysql -u root -p < sql/02_routines.sql
mysql -u root -p < sql/03_seed.sql
```

Run a single case:

```bash
mysql -u root -p --table < sql/tests/TC-01_schema_constraints.sql
```

Reset between cases:

```bash
mysql -u root -p < sql/04_reset.sql
```

Run all cases in order (each script prints PASS/FAIL markers):

```bash
for f in sql/tests/TC-*.sql; do echo "===== $f ====="; mysql -u root -p --table < "$f"; done
```

Expected first-cycle result: **8 PASSED, 2 FAILED** (two planted production-style defects). See the execution and defect reports.

---

## STLC map

```
Requirements  →  Test Plan  →  Test Design  →  Environment
                                              ↓
                                   Test Execution
                                              ↓
                              Defects  →  Retest  →  Closure
```

No phase was skipped. Requirements were baselined before cases were written. Cases were written before execution. Defects were logged against failed cases. Closure compares actual coverage and residual risk to the plan.

---

## Tools used

- MySQL 8.0+ (InnoDB)
- SQL clients: MySQL CLI / DBeaver / MySQL Workbench
- Markdown for every STLC artefact
- Git / GitHub for version control and portfolio evidence

This project deliberately does **not** use Selenium or Jenkins. Scope is database quality: schema, data, procedures, integrity, and performance of SQL.

---

## Licence

Portfolio sample. Use and adapt with attribution.
