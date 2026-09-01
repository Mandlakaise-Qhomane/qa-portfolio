# Requirements Traceability Matrix (RTM) — Restful Booker API

Maps each testable feature/requirement of the API to the test case(s) that validate it, and confirms coverage status.

| Req ID | Requirement | Endpoint | Test Case(s) | Status |
|---|---|---|---|---|
| REQ-01 | User can authenticate and receive a token | `POST /auth` | TC01 | ✅ Covered |
| REQ-02 | User can create a booking with valid data | `POST /booking` | TC02 | ✅ Covered |
| REQ-03 | User can retrieve a single booking by ID | `GET /booking/{id}` | TC03 | ✅ Covered |
| REQ-04 | User can partially update an existing booking | `PATCH /booking/{id}` | TC04 | ✅ Covered |
| REQ-05 | User can retrieve all bookings | `GET /booking` | TC05 | ✅ Covered |
| REQ-06 | System must reject invalid date formats on booking creation | `POST /booking` | TC06 | ⚠️ Covered — defect found (DEF-001) |
| REQ-07 | System must preserve decimal precision in price fields | `POST /booking` | TC07 | ⚠️ Covered — defect found (DEF-002) |
| REQ-08 | User can fully replace a booking | `PUT /booking/{id}` | — | ❌ Not covered (out of scope for this cycle) |
| REQ-09 | User can delete a booking | `DELETE /booking/{id}` | — | ❌ Not covered (out of scope for this cycle) |

## Coverage Summary

- **Requirements identified:** 9
- **Requirements covered by test cases:** 7 (78%)
- **Requirements passing without defects:** 5 (56%)
- **Requirements with confirmed defects:** 2 (22%)
- **Requirements out of scope this cycle:** 2 (22%) — planned for a future sprint

## Notes
- REQ-06 and REQ-07 are marked "Covered" rather than "Failed" because the test cases *successfully did their job* — they were designed to catch exactly this kind of defect, and did. A negative test case that reveals a real bug is a successful test, not a broken one.
- `PUT` (full update) and `DELETE` were deliberately excluded from this test cycle's scope per the Test Plan, and are flagged here for future coverage rather than treated as gaps in current testing.
