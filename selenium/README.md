# Selenium

BDD suite for a Guru99 Bank V4-style manager flow. Cases cover login, customer create, savings account, deposit, withdrawal, and logout.

Open [`guru99-bdd-stlc`](./guru99-bdd-stlc) and run `mvn test`.

**Stack:** Java 17 · Maven · Selenium 4 · Cucumber 7 · TestNG · Jira keys · STLC docs

The suite starts a local bank on `http://127.0.0.1:18080/`Last local run: **10 passed / 54 steps**.

## Test cases

| ID | Jira | What we tested | Type |
|---|---|---|---|
| TC-01 | GURU-101 | Valid manager login opens home | Smoke |
| TC-02 | GURU-102 | Invalid password is rejected | Negative |
| TC-03 | GURU-103 | Blank user id is rejected | Negative |
| TC-04 | GURU-201 | Customer name rejects digits | Validation |
| TC-05 | GURU-202 | New customer is created and an ID is issued | Smoke |
| TC-06 | GURU-203 | Savings account is opened | Functional |
| TC-07 | GURU-204 | Deposit posts to the account | Functional |
| TC-08 | GURU-205 | Withdrawal within balance is accepted | Functional |
| TC-09 | GURU-206 | Withdrawal over balance is rejected | Negative |
| TC-10 | GURU-207 | Logout returns to the login page | Functional |
