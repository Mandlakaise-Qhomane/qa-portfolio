# Guru99 Bank — Selenium BDD suite (STLC)

**SUT:** [Guru99 Bank Demo V4](https://www.demo.guru99.com/V4/)  
**Stack:** Java 17 · Maven · Selenium 4 · Cucumber 7 · TestNG  
**Tracking:** Jira story keys `GURU-101` … `GURU-207` (see [jira/backlog.md](jira/backlog.md))  
**Cases:** 10 Gherkin scenarios

This folder is Phase 2 of the Guru99 work: same bank demo as `guru99-bank-framework`, rewritten as BDD.

---

## Recruiter path

1. This README  
2. [docs/00-stlc-index.md](docs/00-stlc-index.md)  
3. Features in `src/test/resources/features/`  
4. [jira/backlog.md](jira/backlog.md)  
5. [docs/08-defect-reports.md](docs/08-defect-reports.md)

---

## The 10 scenarios

| ID | Jira | Scenario |
|---|---|---|
| TC-01 | GURU-101 | Valid manager login |
| TC-02 | GURU-102 | Invalid password |
| TC-03 | GURU-103 | Blank user id |
| TC-04 | GURU-201 | Name rejects digits |
| TC-05 | GURU-202 | Create customer |
| TC-06 | GURU-203 | Open savings account |
| TC-07 | GURU-204 | Deposit |
| TC-08 | GURU-205 | Withdraw within balance |
| TC-09 | GURU-206 | Withdraw over balance |
| TC-10 | GURU-207 | Logout |

---

## Run

1. Generate a manager on https://www.demo.guru99.com/  
2. Put `username` and `password` in `src/main/resources/config.properties`  
3. JDK 17 + Maven + Chrome  

```bash
cd selenium/guru99-bdd-stlc
mvn test
```

Report: `target/cucumber-report.html`

Tags:

```bash
mvn test -Dcucumber.filter.tags="@smoke"
mvn test -Dcucumber.filter.tags="@GURU-101"
```

Guru99 demo IDs expire. If login fails, generate a new manager. Do not commit a personal password you use elsewhere.
