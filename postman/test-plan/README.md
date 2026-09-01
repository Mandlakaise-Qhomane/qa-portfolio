# Test Plan — Restful Booker API

## Objective
Validate the core booking functionality of the Restful Booker API (`https://restful-booker.herokuapp.com`) through both positive and negative API testing, using Postman and Newman, to confirm correct behavior under normal conditions and to identify defects through deliberate edge-case testing.

## Scope

### In Scope
- Authentication (`POST /auth`)
- Booking creation (`POST /booking`)
- Booking retrieval — single (`GET /booking/{id}`) and all (`GET /booking`)
- Partial booking updates (`PATCH /booking/{id}`)
- Negative testing of date format handling and price precision

### Out of Scope
- Full booking update (`PUT /booking/{id}`)
- Booking deletion (`DELETE /booking/{id}`)
- Load, performance, and security testing
- UI-level testing (this API has no front end)

## Test Environments

| Environment | Base URL | Purpose |
|---|---|---|
| Dev | `https://restful-booker.herokuapp.com` | Public sandbox API used for all test execution |

Configured in Postman as the `Restful-Booker-Dev` environment, with variables `base_url`, `auth_token`, and `booking_id`.

## Defect Reporting Procedure
Defects are logged in `bug-reports/README.md` with a unique ID (`DEF-XXX`), severity, priority, reproduction steps, and evidence (screenshots + Newman output). Each defect links back to the test case that discovered it.

## Test Strategy
- **Positive testing (5 cases):** Confirm that standard CRUD operations behave correctly with valid input.
- **Negative testing (2 cases):** Deliberately submit invalid data (malformed dates, floating-point prices) to confirm the API validates input correctly — or to document where it doesn't.
- Test execution performed manually in Postman first, then automated via Newman CLI for repeatable, scriptable runs.

## Test Schedule

| Activity | Status |
|---|---|
| Requirement analysis | Complete |
| Test case design (7 cases) | Complete |
| Environment setup | Complete |
| Test execution (Postman) | Complete |
| Test execution (Newman CLI) | Complete |
| Defect documentation | Complete |
| Test summary reporting | Complete |

## Test Deliverables
- Postman collection (`collections/Restful_Booker.postman_collection.json`)
- Postman environment (`environments/Restful-Booker-Dev.postman_environment.json`)
- Test case documentation (`test-cases/README.md`)
- Defect reports (`bug-reports/README.md`)
- Requirements Traceability Matrix (`rtm/README.md`)
- Test summary report (`test-reports/README.md`, `reports/sprint-1-test-summary.html`)
- Test metrics (`test-metrics/README.md`)

## Entry and Exit Criteria

### Entry Criteria
- Postman installed and environment configured
- API confirmed reachable (`base_url` responds)
- Test cases reviewed and approved

### Exit Criteria
- All 7 test cases executed
- All positive test cases pass
- All negative test cases produce evidence of the targeted defect (pass or documented fail)
- Defect reports written for any negative test case that fails
- Test summary report generated

## Test Execution

### Entry Criteria
Environment variables (`base_url`) verified as non-empty before each run.

### Exit Criteria
Newman run completes with 0 request errors (network/URI level); assertion failures are expected only for TC06 and TC07.

## Test Closure

### Entry Criteria
All 7 test cases have a final Pass/Fail status with evidence captured.

### Exit Criteria
Defect reports finalized; test summary and metrics documented; portfolio structure complete.

## Tools
- **Postman** — manual request building, assertion scripting, environment management
- **Newman** — CLI test runner for repeatable automated execution
- **newman-reporter-htmlextra** — visual HTML test reports
- **GitHub Actions** — CI/CD automation (planned)

## Risks and Mitigations

| Risk | Mitigation |
|---|---|
| Restful Booker is a free-tier Heroku app and may be slow to respond or occasionally drop connections | Retry failed requests; note transient errors separately from genuine defects |
| Postman's Initial Value vs Current Value behavior can cause environment variables to export empty | Manually verify `base_url` in the exported `.json` file before every Newman run |
| API is a public demo service and could change behavior over time | Re-verify defects periodically; note the date of each test run in reports |

## Approvals

| Role | Name | Date |
|---|---|---|
| QA Engineer | *(your name)* | *(date)* |
