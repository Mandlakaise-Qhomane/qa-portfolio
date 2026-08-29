# Test Closure Report — BlazeDemo Performance & Functional Test Suite

## 1. Summary
This report closes out the BlazeDemo test cycle covering 6 test cases spanning functional booking-flow validation, load/stress testing, data-driven testing, correlation testing, endurance testing, and negative-path business-rule validation — executed per the STLC (Test Planning → Test Case Design → Test Execution → Defect Reporting → Test Closure).

## 2. Test Execution Summary

| # | Test Case | Type | Status | Defects |
|---|---|---|---|---|
| TC1 | Critical Business Path | Functional (E2E) | PASS | None |
| TC2 | Peak Load / Stress | Performance | PASS (breaking point identified) | BUG-002 |
| TC3 | Data-Driven Parallelism | Performance | PASS | None |
| TC4 | Dynamic Correlation | Functional/Performance | PASS | None |
| TC5 | Endurance / Soak (60 min) | Performance | PASS | None |
| TC6 | Negative Path Validation | Functional (Negative) | FAIL (as designed) | BUG-001 |

**Total test cases:** 6 · **Passed:** 5 · **Failed (intended negative outcome):** 1 · **Defects logged:** 2

## 3. Exit Criteria Assessment
| Criterion | Status |
|---|---|
| All planned test cases executed | ✅ Met |
| Critical business path validated end-to-end | ✅ Met (TC1) |
| System breaking point identified | ✅ Met — ~160–165 concurrent users (TC2) |
| Data-driven technique proven | ✅ Met (TC3) |
| Dynamic correlation proven | ✅ Met (TC4) |
| No response-time drift over sustained load | ✅ Met — 0% error, no drift over 60 min (TC5) |
| Negative-path / business-rule gaps documented | ✅ Met — 1 high-severity defect found (TC6) |

## 4. Defect Summary
See `bug-reports/` for full bug-lifecycle detail on each.
- **BUG-001** (High): No server-side validation on `/purchase.php` — fabricates unrelated reservation data. Full report: `bug-reports/BUG-001.md`.
- **BUG-002** (Medium): Payment endpoint response time degrades past ~160 concurrent users. Full report: `bug-reports/BUG-002.md`.

## 5. Key Metrics
| Metric | Result |
|---|---|
| Booking funnel end-to-end time | < 3 s (TC1) |
| Breaking point | ~160–165 concurrent users (TC2) |
| Throughput at 200 users | 133.8 req/sec (TC2) |
| Soak test error rate (60 min) | 0.00% (TC5) |
| Soak test average response time | 522 ms (TC5) |

## 6. Lessons Learned
- BlazeDemo's static demo data limits how far data-driven and correlation tests can prove real backend behavior — documented as an explicit caveat rather than overstated (TC3).
- The payment endpoint is the consistent bottleneck under load across both stress and soak conditions.
- Negative-path testing surfaced the most portfolio-relevant finding: absence of server-side state validation.

## 7. Sign-Off
Test cycle considered **closed**. Artifacts retained in `test-results/`, `test-reports/report_output/` (JMeter HTML dashboard), and `test-cases/` for portfolio and future regression reference.

**Prepared by:** Mandla Qhomane · **Date:** 2026-08-29
