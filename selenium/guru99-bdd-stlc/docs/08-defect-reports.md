# Defects and Jira

This project does not call the Jira REST API. Stories and bugs are modelled the way a squad would file them.

See [jira/backlog.md](../jira/backlog.md) for the story list.

## Defect template

| Field | Example |
|---|---|
| Key | GURU-301 |
| Linked story | GURU-202 |
| Title | New Customer submit shows unexpected alert |
| Severity | Major |
| Steps | Scenario TC-05 |
| Expected | Customer ID table |
| Actual | Alert text / timeout |
| Build | Chrome headless, demo V4 |

Known product risk: demo manager IDs expire. Treat expired login as environment, not a product bug.
