# TC6 — Negative Path / Business Rule Validation

| Field | Value |
|---|---|
| **Test Case ID** | TC6 |
| **Test Suite** | BlazeDemo_Suite.jmx → `TC6_Negative_Path_ThreadGroup` |
| **Test Type** | Functional — Negative / Business Logic Test |
| **Priority** | High |
| **Maps to Requirement** | Business logic boundary testing — see `docs/02-performance-requirements.md` |
| **STLC Phase** | Test Execution |
| **Author** | Mandla Qhomane |
| **Date Executed** | 2026-08-29 |

## Objective
Evaluate how the application handles an out-of-sequence request with no prior session state — posting directly to `/purchase.php` with an empty body, bypassing the expected search-then-select flow — to test for missing server-side validation.

## Preconditions
- Only `TC6_Negative_Path_ThreadGroup` enabled in JMeter.
- No prior `/reserve.php` call is made before the purchase POST (deliberate).

## Test Steps
1. Configure Thread Group: 1 thread, 1s ramp-up, Loop Count = 1.
2. Execute `01_Home_GET`.
3. Execute `02_Purchase_Direct_POST` (`POST /purchase.php`) with **zero parameters** — no `fromPort`, `toPort`, `airline`, `flight`, or `price`.
4. Attach Response Assertion `ASSERT_Correct_Origin_City`: Contains `"Boston"` (expected to fail).
5. Attach Response Assertion `ASSERT_Correct_Price`: Contains `"472.56"` (expected to fail).
6. In View Results Tree, inspect Response Data for `02_Purchase_Direct_POST` to capture the actual returned content as defect evidence.

## Test Data
Intentionally empty — no flight search or selection data is submitted.

## Expected Result
| Metric | Expected |
|---|---|
| Application behavior | Reject the malformed request or return a validation error |
| `ASSERT_Correct_Origin_City` | Should not be relevant if request is properly rejected |
| `ASSERT_Correct_Price` | Should not be relevant if request is properly rejected |

## Actual Result
The application returned **HTTP 200** and silently fabricated an unrelated reservation:

```
Your flight from TLV to SFO has been reserved.
Airline: United
Flight Number: UA954
Price: 400
Arbitrary Fees and Taxes: 514.76
Total Cost: 914.76
```

Both assertions correctly failed as designed:
- `ASSERT_Correct_Origin_City` — expected `Boston`, got `TLV` → **FAIL**
- `ASSERT_Correct_Price` — expected `472.56`, got `400` / `914.76` → **FAIL**

## Status
**FAIL** (application defect confirmed — the failing assertions are the intended, correct outcome of this negative test).

## Defects Logged
- **BUG-001**: No server-side validation that a purchase request corresponds to a real, prior flight search. The app fabricates plausible-looking but entirely unrelated flight/price data instead of rejecting the malformed request with an error. **Severity:** High (data-integrity gap) · **Priority:** High · Full report: `bug-reports/BUG-001.md`.

## Portfolio Takeaway
The app has no server-side check that a purchase request corresponds to a real prior flight search — it silently fabricates plausible-looking data instead of rejecting the malformed request. This is the strongest artifact in the suite for demonstrating negative-testing and business-logic-validation skills.

## Artifacts
- `test-results/TC6/` — View Results Tree export (Response Data tab showing fabricated TLV/SFO content), Aggregate Report export (100% assertion-failure rate on this sampler despite HTTP 200).
