# Jira backlog (portfolio model)

Use these keys in Cucumber tags and in a real Jira project if you create one.

## Epic GURU-100 — Authentication

| Key | Type | Summary | Scenario |
|---|---|---|---|
| GURU-101 | Story | Valid manager login | TC-01 |
| GURU-102 | Story | Reject invalid password | TC-02 |
| GURU-103 | Story | Reject blank user id | TC-03 |

## Epic GURU-200 — Customer and account

| Key | Type | Summary | Scenario |
|---|---|---|---|
| GURU-201 | Story | Customer name cannot contain digits | TC-04 |
| GURU-202 | Story | Create customer | TC-05 |
| GURU-203 | Story | Open savings account | TC-06 |
| GURU-204 | Story | Deposit | TC-07 |
| GURU-205 | Story | Withdraw within balance | TC-08 |
| GURU-206 | Story | Reject over-balance withdrawal | TC-09 |
| GURU-207 | Story | Logout | TC-10 |

## Bugs (file when a run fails)

| Key | Linked | Title |
|---|---|---|
| GURU-301 | GURU-202 | Create customer alert / missing ID |
| GURU-302 | GURU-206 | Over-balance withdrawal does not alert |

Workflow in a real Jira: To Do → In Test → Done, or To Do → In Test → Bug.
