# Requirements

**SUT:** Guru99 Bank Manager module V4  
**Source:** public demo behaviour + manager workflows

| ID | Requirement |
|---|---|
| BR-01 | Only a valid manager user and password reach the home page |
| BR-02 | Invalid or blank credentials are rejected with an alert |
| BR-03 | Customer name must not contain digits |
| BR-04 | A manager can register a customer and receive a Customer ID |
| BR-05 | A savings account can be opened against that customer |
| BR-06 | Deposit posts to the account |
| BR-07 | Withdrawal within balance posts |
| BR-08 | Withdrawal above balance is rejected |
| BR-09 | Logout returns the manager to the login page |

Jira epic keys: GURU-100 (auth), GURU-200 (servicing).
