# Test Summary Report — Sprint 1

**API Under Test:** Restful Booker (`https://restful-booker.herokuapp.com`)
**Test Run Date:** 2026-09-01
**Execution Tools:** Postman (manual) + Newman CLI (automated, repeatable)
**Full HTML report:** [`reports/sprint-1-test-summary.html`](../reports/sprint-1-test-summary.html)

## Summary

| Metric | Value |
|---|---|
| Total test cases | 7 |
| Total requests executed | 7 |
| Request-level errors | 0 |
| Total assertions | 19 |
| Assertions passed | 15 |
| Assertions failed | 4 |
| Test cases fully passing | 5 |
| Test cases revealing defects | 2 |
| Total run duration | 2.3s |
| Average response time | 221ms |

## Results by Test Case

| TC ID | Name | Status | Notes |
|---|---|---|---|
| TC01 | Authentication Token Generation | ✅ PASS | Token generated and reused successfully across the suite |
| TC02 | Create Valid Booking | ✅ PASS | Booking ID captured and reused correctly |
| TC03 | Get Single Booking | ✅ PASS | Corrected after an initial URL misconfiguration (hardcoded ID) |
| TC04 | Update Booking Partially | ✅ PASS | 4/4 assertions passed |
| TC05 | Get All Bookings | ✅ PASS | 4/4 assertions passed |
| TC06 | Invalid Date Format | ❌ FAIL (expected) | Confirms **DEF-001** |
| TC07 | Floating-Point Price | ❌ FAIL (expected) | Confirms **DEF-002** |

## Interpretation

The 4 failing assertions are not testing defects — they are the **intended outcome** of negative testing. TC06 and TC07 were specifically designed to probe known weak points in input validation, and both successfully surfaced real, reproducible defects (see [Bug Reports](../bug-reports/README.md)).

Results were confirmed stable across multiple independent runs:
- Manual execution via Postman Runner (15 passed / 4 failed)
- Automated execution via Newman CLI, run twice on separate dates, both producing identical pass/fail patterns

This consistency confirms the defects are genuine and reproducible, not flaky test artifacts.

## Known Issues During Test Development
- An early Newman run failed all 7 requests with "Invalid URI" errors, traced to a Postman export quirk where `base_url`'s Initial Value exported as blank despite showing a value in the live UI. Resolved by manually verifying and correcting the exported environment JSON.
- TC07's request body initially included stray HTTP header lines pasted directly into the Body field, causing spurious `400 Bad Request` responses unrelated to the actual defect. Resolved by isolating the JSON payload correctly in the Body tab.

## Conclusion
The Restful Booker API's core CRUD functionality (authentication, create, read, update) behaves correctly under valid input. Two real, reproducible defects were identified through deliberate negative testing: acceptance of malformed date formats (DEF-001) and silent truncation of decimal pricing (DEF-002). Both are documented with full reproduction steps, root cause analysis, and suggested fixes in the Bug Reports.
