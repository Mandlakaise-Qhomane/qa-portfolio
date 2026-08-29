# Performance Requirements (NFRs) — BlazeDemo

## Business Critical Path
The end-to-end booking funnel must remain functional and performant under expected load.

**Funnel Steps:**
1. Home Page (`GET /`)
2. Find Flights (`POST /reserve.php`)
3. Choose Flight (`POST /purchase.php`)
4. Purchase Confirmation (`POST /confirmation.php`)

## Non-Functional Requirements

| Requirement ID | Description | Target | Test Case |
|---|---|---|---|
| NFR-001 | End-to-end transaction response time | < 3,000 ms | TC1 |
| NFR-002 | Error rate under normal load | < 1% | TC1, TC3, TC5 |
| NFR-003 | System breaking point identification | > 160 concurrent users | TC2 |
| NFR-004 | Response time at 95th percentile under stress | < 2,000 ms | TC2 |
| NFR-005 | Data-driven execution | 10 unique user data sets | TC3 |
| NFR-006 | Dynamic session correlation | 100% extraction success | TC4 |
| NFR-007 | Endurance stability | < 20% drift over 60 min | TC5 |
| NFR-008 | Invalid request rejection | HTTP 400 or redirect | TC6 |

## Environment Constraints
- **Target**: https://blazedemo.com (demo/training site)
- **Data**: Static demo data — flight table does not vary by city pair
- **Execution**: Single-machine JMeter (local)
- **Caveat**: Results demonstrate technique and relative performance, not production-grade absolute benchmarks
