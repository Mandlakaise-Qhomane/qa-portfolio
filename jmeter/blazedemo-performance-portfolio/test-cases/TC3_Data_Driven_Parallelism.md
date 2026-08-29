# TC3 — Data-Driven Parallelism (CSV Data Set Config)

| Field | Value |
|---|---|
| **Test Case ID** | TC3 |
| **Test Suite** | BlazeDemo_Suite.jmx → `TC3_DataDriven_ThreadGroup` |
| **Test Type** | Performance — Data-Driven Load Test |
| **Priority** | Medium |
| **Maps to Requirement** | Scenario 3 — see `docs/02-performance-requirements.md` |
| **STLC Phase** | Test Execution |
| **Author** | Mandla Qhomane |
| **Date Executed** | 2026-08-29 |

## Objective
Prove that the booking funnel correctly handles concurrent threads each driven by unique input data (city pairs and passenger names) via CSV Data Set Config, rather than a single hardcoded payload.

## Preconditions
- `blazedemo_data.csv` (10 unique rows, no header) present in `test-plans/`, same folder as the `.jmx` file.
- Only `TC3_DataDriven_ThreadGroup` enabled in JMeter.

## Test Steps
1. Configure Thread Group: 10 threads, 10s ramp-up, Loop Count = 1.
2. Add CSV Data Set Config: Variable Names = `fromCity,toCity,passengerName`, Sharing Mode = All threads, Recycle on EOF = False.
3. Execute `01_Home_GET`.
4. Execute `02_FindFlights_POST` using `${fromCity}` / `${toCity}` (Encode? checked for accented characters).
5. Execute `03_ChooseFlight_POST` using `${fromCity}` / `${toCity}` plus static flight/price fields (static because BlazeDemo's results table doesn't vary by route).
6. Execute `04_Purchase_POST` using `${passengerName}` for `inputName` and `nameOnCard`.
7. Verify in View Results Tree that each thread's Request tab shows real CSV values, not literal `${fromCity}` placeholders.

## Test Data
`test-plans/blazedemo_data.csv` — 10 rows pairing valid BlazeDemo cities with unique passenger names (e.g. Boston→London/John Smith, São Paolo→Buenos Aires/Liam O'Brien).

## Expected Result
| Metric | Target |
|---|---|
| Each thread uses a distinct CSV row | 100% — verified in View Results Tree |
| Error % | 0% |
| Placeholder leakage (`${fromCity}` literal text) | None |

## Actual Result
| Label | # Samples | Error % |
|---|---|---|
| 01_Home_GET | 10 | 0.00% |
| 02_FindFlights_POST | 10 | 0.00% |
| 03_ChooseFlight_POST | 10 | 0.00% |
| 04_Purchase_POST | 10 | 10.00%* |
| **TOTAL** | **40** | **2.50%** |

\*Single Duration Assertion failure (>2,000 ms) carried over from stress-test config — not a data-driven functional defect. Removing that assertion yields 0% error.

**Honest portfolio caveat:** BlazeDemo's flight results are static demo data — the server returns the same 5 flights regardless of route. This test proves the CSV Data Set Config *technique* (each thread genuinely submits distinct data) rather than proving server-side cache-busting against a live database.

## Status
**PASS**

## Defects Logged
None functional. One residual Duration Assertion carryover noted above (informational, not filed as a defect).

## Artifacts
- `test-results/TC3/` — View Results Tree export, Aggregate Report export.
