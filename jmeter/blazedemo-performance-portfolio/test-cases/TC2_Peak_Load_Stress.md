# TC2 — Peak Load / Stress Test (Find Breaking Point)

| Field | Value |
|---|---|
| **Test Case ID** | TC2 |
| **Test Suite** | BlazeDemo_Suite.jmx → `TC2_StressTest_ThreadGroup` |
| **Test Type** | Performance — Stress Test |
| **Priority** | High |
| **Maps to Requirement** | Scenario 2 — see `docs/02-performance-requirements.md` |
| **STLC Phase** | Test Execution |
| **Author** | Mandla Qhomane |
| **Date Executed** | 2026-08-29 |

## Objective
Determine the concurrent-user breaking point of the BlazeDemo booking funnel by ramping load from 0 to 200 users over 10 minutes and monitoring error rate and response-time degradation.

## Preconditions
- Target application `https://blazedemo.com` is reachable.
- `BlazeDemo_Suite.jmx` opened in JMeter 5.6.3 with only `TC2_StressTest_ThreadGroup` enabled.
- HTTP Request Defaults, Cookie Manager, and Header Manager config elements are active at the Test Plan level.

## Test Steps
1. Configure Thread Group: 200 threads, 600s ramp-up, Loop Count = Infinite, Scheduler duration = 600s.
2. Execute `01_Home_GET` (`GET /`).
3. Execute `02_FindFlights_POST` (`POST /reserve.php`) with `fromPort=Boston`, `toPort=London`.
4. Execute `03_ChooseFlight_POST` (`POST /purchase.php`) with flight/airline/price payload.
5. Execute `04_Purchase_POST` (`POST /confirmation.php`) with full billing payload; attach a Duration Assertion of 2000 ms.
6. Monitor via Aggregate Report, Summary Report, and Active Threads Over Time listeners throughout the run.

## Test Data
Same static booking payload as TC1 (Boston → London, Virgin America flight 43, $472.56), replayed continuously by up to 200 virtual users.

## Expected Result
| Metric | Target |
|---|---|
| Error % | < 1% up to the point load exceeds sustainable capacity |
| 95th percentile response time | < 2,000 ms |
| Breaking point | Clearly identifiable via Aggregate Report trend |

## Actual Result
| Metric | At ~163 Users | At 200 Users |
|---|---|---|
| Active Threads | 163/200 | 200/200 |
| Total Error % | 1.00% | 1.33% |
| Purchase_POST Error % | 4.00% | 5.22% |
| Purchase 95th %ile | 1,543 ms | 2,207 ms |
| Throughput | — | 133.8 req/sec |

**Breaking point:** ~160–165 concurrent users — the point where total Error % crosses 1% and the 95th percentile exceeds 2,000 ms. Errors are Duration Assertion failures (HTTP 200 returned, but response time exceeded threshold), indicating the payment step (`04_Purchase_POST`) is the system bottleneck under load.

## Status
**PASS** (test executed as designed) — with a **Performance Defect** logged against the application. See `bug-reports/BUG-002.md`.

## Defects Logged
- **BUG-002**: Payment endpoint (`/confirmation.php`) response time exceeds 2,000 ms threshold beyond ~163 concurrent users. Severity: Medium. Full report: `bug-reports/BUG-002.md`.

## Artifacts
- `test-results/TC2/` — Aggregate Report export, Summary Report export, Active Threads Over Time graph.
