# TC5 — Endurance / Soak Test

| Field | Value |
|---|---|
| **Test Case ID** | TC5 |
| **Test Suite** | BlazeDemo_Suite.jmx → `TC5_Soak_ThreadGroup` |
| **Test Type** | Performance — Endurance / Soak Test |
| **Priority** | Medium |
| **Maps to Requirement** | Scenario 5 — see `docs/02-performance-requirements.md` |
| **STLC Phase** | Test Execution |
| **Author** | Mandla Qhomane |
| **Date Executed** | 2026-08-29 |

## Objective
Confirm the application sustains a steady, moderate load (20 users, ~60 req/min) over a full 60-minute window without progressive response-time degradation, error accumulation, or signs of memory leaks / resource exhaustion.

## Preconditions
- Only `TC5_Soak_ThreadGroup` enabled in JMeter.
- View Results Tree disabled before the real run (memory-heavy at sustained volume) — Aggregate Report and Response Time Graph kept active.

## Test Steps
1. Configure Thread Group: 20 threads, 60s ramp-up, Loop Count = Infinite, Scheduler duration = 3600s (60 min).
2. Add Constant Throughput Timer: 60 samples/minute, calculated across all active threads.
3. Execute the standard 4-step funnel (`01_Home_GET` → `02_FindFlights_POST` → `03_ChooseFlight_POST` → `04_Purchase_POST`) on a continuous loop for the full duration.
4. Monitor Aggregate Report for response-time drift between early and late samples.
5. Screenshot Response Time Graph at completion for portfolio evidence of trend stability.

## Test Data
Boston → London, Virgin America flight 43, $472.56 — identical static payload replayed continuously for the full 60-minute duration.

## Expected Result
| Metric | Target |
|---|---|
| Response time drift (minute 5 vs minute 55) | < 20% increase |
| Error % over full 60 min | < 1% |
| Throughput stability | Within ~10% of the 60/min target throughout |

## Actual Result (60 Minutes + 5 Seconds)
| Label | # Samples | Average | Median | 90% Line | 95% Line | 99% Line | Error % | Throughput |
|---|---|---|---|---|---|---|---|---|
| 01_Home_GET | 912 | 529 ms | 374 ms | 832 ms | 1,279 ms | 2,643 ms | 0.00% | 15.2/min |
| 02_FindFlights_POST | 909 | 527 ms | 375 ms | 859 ms | 1,295 ms | 3,321 ms | 0.00% | 15.2/min |
| 03_ChooseFlight_POST | 902 | 504 ms | 379 ms | 841 ms | 1,165 ms | 2,227 ms | 0.00% | 15.0/min |
| 04_Purchase_POST | 896 | 528 ms | 380 ms | 909 ms | 1,315 ms | 2,751 ms | 0.00% | 14.9/min |
| **TOTAL** | **3,619** | **522 ms** | **376 ms** | **862 ms** | **1,256 ms** | **2,735 ms** | **0.00%** | **~60/min** |

**Response Time Graph analysis:** Consistent baseline performance with occasional outlier spikes, but no progressive upward drift — indicating no memory leak or resource exhaustion under sustained load. The 99th percentile occasionally spiked to ~3.3s, representing brief latency bursts rather than systemic degradation.

## Status
**PASS**

## Defects Logged
None.

## Artifacts
- `test-results/TC5/Response Time Graph.png`
- `test-results/results.jtl` (raw sample log)
- `test-reports/report_output/` (JMeter HTML dashboard: `index.html`, `statistics.json`, `content/`, `sbadmin2-1.0.7/`)
