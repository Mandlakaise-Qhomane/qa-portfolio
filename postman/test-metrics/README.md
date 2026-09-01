# Test Metrics — Restful Booker API

Quantitative summary of test coverage, execution, and defect discovery for this test cycle.

## Test Execution Metrics

| Metric | Value |
|---|---|
| Total test cases designed | 7 |
| Total test cases executed | 7 |
| Test execution completion rate | 100% |
| Test cases passed | 5 |
| Test cases failed (revealing defects) | 2 |
| Pass rate (excluding intentional negative tests) | 100% (5/5) |
| Total assertions written | 19 |
| Assertions passed | 15 |
| Assertions failed | 4 |
| Assertion pass rate | 79% |

## Defect Metrics

| Metric | Value |
|---|---|
| Total defects found | 2 |
| Critical severity | 1 (DEF-001) |
| Major severity | 1 (DEF-002) |
| Defect detection rate | 2 defects / 7 test cases = 28.6% |
| Defects found via negative testing | 2 / 2 (100%) |
| Defects found via positive testing | 0 |

## Coverage Metrics

| Metric | Value |
|---|---|
| API endpoints identified | 5 (auth, create, get single, get all, patch) |
| API endpoints tested | 5 (100% of in-scope endpoints) |
| Requirements traced (see RTM) | 9 identified, 7 covered (78%) |
| Positive scenario coverage | 5 test cases |
| Negative scenario coverage | 2 test cases |
| Positive-to-negative test ratio | 5:2 (71% / 29%) |

## Test Type Breakdown

| Test Type | Count | % of Total |
|---|---|---|
| Positive | 5 | 71% |
| Negative | 2 | 29% |

## Priority Breakdown

| Priority | Count |
|---|---|
| P0 (Critical) | 3 (TC01, TC02, TC06) |
| P1 (High) | 4 (TC03, TC04, TC05, TC07) |
| P2 (Medium) | 0 |
| P3 (Low) | 0 |

## Execution Efficiency

| Metric | Value |
|---|---|
| Total automated run duration | 2.3s |
| Average response time per request | 221ms |
| Fastest response | 116ms |
| Slowest response | 630ms |
| Total data transferred per run | ~58 KB |
| Runs performed for stability confirmation | 3 (1 Postman Runner, 2 Newman CLI) |

## Interpretation
A 100% pass rate on positive test cases combined with a 100% defect-confirmation rate on negative test cases indicates a well-targeted test design: every test case did exactly what it was built to do. The two defects found (DEF-001, DEF-002) represent genuine, reproducible issues rather than test flakiness, confirmed by consistent results across three independent execution runs on two different dates.
