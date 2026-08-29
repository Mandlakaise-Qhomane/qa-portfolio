# TC4 — Dynamic Session / Correlation (Regular Expression Extractor)

| Field | Value |
|---|---|
| **Test Case ID** | TC4 |
| **Test Suite** | BlazeDemo_Suite.jmx → `TC4_Correlation_ThreadGroup` |
| **Test Type** | Functional/Performance — Correlation Test |
| **Priority** | High |
| **Maps to Requirement** | Scenario 4 — see `docs/02-performance-requirements.md` |
| **STLC Phase** | Test Execution |
| **Author** | Mandla Qhomane |
| **Date Executed** | 2026-08-29 |

## Objective
Verify that a dynamic, server-generated value (the hidden `flight` field returned by `/reserve.php`) can be extracted at runtime and correctly correlated into the subsequent request, rather than relying on a hardcoded value.

## Preconditions
- Only `TC4_Correlation_ThreadGroup` enabled in JMeter.
- Target `/reserve.php` response contains `<input type="hidden" name="flight" value="X">`.

## Test Steps
1. Configure Thread Group: 1 thread, 1s ramp-up, Loop Count = 1.
2. Execute `01_Home_GET`.
3. Execute `02_FindFlights_POST` (`fromPort=Boston`, `toPort=London`).
4. Attach Regular Expression Extractor `Extract_FlightNum`: Field = Body, Regex = `name="flight" value="(\d+)"`, Template = `$1$`, Reference Name = `flightNum`, Default = `NOTFOUND`.
5. Execute `03_ChooseFlight_POST`, passing `flight=${flightNum}` instead of a hardcoded value.
6. Execute `04_Purchase_POST` with a Response Assertion for `"Thank you for your purchase today"`.
7. In View Results Tree, confirm `02_FindFlights_POST` Response Data contains the hidden field, and `03_ChooseFlight_POST` Request tab shows a real number (not `NOTFOUND` or the literal `${flightNum}`).

## Test Data
Boston → London, Virgin America, $472.56 — flight number sourced dynamically rather than hardcoded.

## Expected Result
| Metric | Target |
|---|---|
| `${flightNum}` resolves to a real numeric value | 100% of requests |
| `04_Purchase_POST` Response Assertion | Pass |
| Default value `NOTFOUND` never appears | Confirms correlation, not coincidence |

## Actual Result
All 4 samplers executed successfully (green). `Extract_FlightNum` correctly captured the numeric flight ID from the `/reserve.php` response body, and the same value was observed in the `03_ChooseFlight_POST` request payload. The final `04_Purchase_POST` assertion passed, confirming the correlated value flowed through the entire funnel.

## Status
**PASS**

## Defects Logged
None.

## Artifacts
- `test-results/TC4/` — View Results Tree export (Response Data + Request tabs), Aggregate Report export.
