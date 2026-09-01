# Bug Reports — Restful Booker API

Two defects were discovered through negative testing (TC06 and TC07), confirmed as reproducible across multiple Postman runs and an automated Newman CLI run.

---

## DEF-001 — Date Format Corruption on Booking Creation

| Field | Value |
|---|---|
| Defect ID | DEF-001 |
| Status | Open |
| Severity | Critical |
| Priority | P0 |
| Environment | Dev (`https://restful-booker.herokuapp.com`) |
| Reporter | QA Engineer |
| Assigned To | Unassigned |
| Date Reported | 2026-08-30 |
| STLC Phase Found | Test Execution |
| SDLC Phase Impact | Development / Backend validation layer |
| Related Test Case | TC06 |

### Description
`POST /booking` is expected to validate the `checkin` and `checkout` fields inside `bookingdates` and reject any request where these values are not valid, parseable dates. Instead, the endpoint accepts clearly malformed date strings — such as `"2026/08/29"` (wrong delimiter) and `"29-08-2026"` (wrong field order) — and responds with `200 OK` as though the booking were created successfully.

This is a data integrity issue, not just a cosmetic one: malformed dates that pass through unvalidated risk being stored in a corrupted state internally, and any downstream system consuming this API (a front-end booking calendar, a reporting pipeline, a billing system) would receive dates it cannot reliably parse.

Anyone integrating with this API — a developer building a booking UI, or an automated system syncing reservation data — is affected, since they have no reliable signal from the API that their date input was invalid until they inspect the stored data directly.

### Steps to Reproduce
1. Send a `POST` request to `{{base_url}}/booking` with header `Content-Type: application/json`.
2. Use the following body:
   ```json
   {
     "firstname": "Jane",
     "lastname": "Doe",
     "totalprice": 100,
     "depositpaid": true,
     "bookingdates": {
       "checkin": "2026/08/29",
       "checkout": "29-08-2026"
     },
     "additionalneeds": "None"
   }
   ```
3. Observe the response status code and body.

**cURL equivalent:**
```bash
curl -X POST https://restful-booker.herokuapp.com/booking \
  -H "Content-Type: application/json" \
  -d '{"firstname":"Jane","lastname":"Doe","totalprice":100,"depositpaid":true,"bookingdates":{"checkin":"2026/08/29","checkout":"29-08-2026"},"additionalneeds":"None"}'
```

### Expected Result
`400 Bad Request` with a clear validation error message identifying which date field was invalid and why, and no booking record created.

### Actual Result
- **Status code:** `200 OK`
- **Behavior:** The booking is created and a `bookingid` is returned as if the request were fully valid. The malformed date strings are accepted at the API boundary with no validation error surfaced to the client.

### Evidence
- `assets/defect-evidence/DEF-001-postman-response.png` — Postman response pane showing `200 OK` for the malformed-date request.
- Newman CLI output confirming reproducibility: `expected response to have status code 400 but got 200`.

### Root Cause Analysis
The most likely cause is a missing or incomplete input validation layer on the `bookingdates` object before it reaches the persistence layer. The API appears to accept `checkin`/`checkout` as free-form strings rather than parsing and validating them against an expected date format (e.g., ISO 8601 `YYYY-MM-DD`) before storage. This is a backend/API-layer issue, not a database-layer one — the fix belongs in request validation, before any data reaches storage.

### Business Impact
- **Data integrity:** Corrupted or unparseable dates entering the system silently undermine trust in all downstream reporting and scheduling logic.
- **Compliance:** For businesses in regulated hospitality/travel sectors, inaccurate booking date records could complicate audit trails.
- **Customer trust:** A guest whose booking dates are stored incorrectly could show up on the wrong day, or their reservation could be dropped from availability calendars.
- **Revenue:** Overlapping or corrupted date ranges could result in double-bookings or lost reservations.

### Suggested Fix
- Add server-side validation requiring `checkin` and `checkout` to match a strict format (e.g., `YYYY-MM-DD`) using a library-level date parser rather than a permissive string check.
- Return `400 Bad Request` with a body such as:
  ```json
  { "error": "Invalid date format for 'checkin'. Expected YYYY-MM-DD." }
  ```
- Add unit tests at the API layer covering common malformed date patterns (wrong delimiter, wrong field order, non-existent dates like Feb 30).

### Defect Life Cycle Trail

| Date | Action | Actor | New Status |
|---|---|---|---|
| 2026-08-30 | Defect discovered via TC06, logged | QA Engineer | New |
| 2026-08-30 | Reproduced via Newman CLI automated run | QA Engineer | Open |

---

## DEF-002 — Price Precision Loss on Booking Creation

| Field | Value |
|---|---|
| Defect ID | DEF-002 |
| Status | Open |
| Severity | Major |
| Priority | P1 |
| Environment | Dev (`https://restful-booker.herokuapp.com`) |
| Reporter | QA Engineer |
| Assigned To | Unassigned |
| Date Reported | 2026-08-30 |
| STLC Phase Found | Test Execution |
| SDLC Phase Impact | Development / Data type handling |
| Related Test Case | TC07 |

### Description
`POST /booking` is expected to accept and store the `totalprice` field exactly as submitted, including decimal precision — this matters because prices are financial data, and financial data cannot tolerate silent rounding. When a floating-point value such as `123.45` is submitted, the API responds with `200 OK`, but the value returned (and presumably stored) is `123` — the decimal portion is silently discarded rather than preserved or rejected.

This is a silent failure: no error is returned, no warning is surfaced, and the client has no way of knowing data was altered unless they explicitly compare the response against what they sent. For a booking system, price accuracy directly affects billing correctness.

Anyone relying on this API for actual financial transactions — payment reconciliation, invoicing, revenue reporting — would be affected, since accumulated rounding errors across many bookings can produce meaningful financial discrepancies.

### Steps to Reproduce
1. Send a `POST` request to `{{base_url}}/booking` with header `Content-Type: application/json`.
2. Use the following body:
   ```json
   {
     "firstname": "Bob",
     "lastname": "Builder",
     "totalprice": 123.45,
     "depositpaid": true,
     "bookingdates": {
       "checkin": "2026-10-01",
       "checkout": "2026-10-05"
     },
     "additionalneeds": "Wi-Fi"
   }
   ```
3. Inspect the `totalprice` field in the response.

**cURL equivalent:**
```bash
curl -X POST https://restful-booker.herokuapp.com/booking \
  -H "Content-Type: application/json" \
  -d '{"firstname":"Bob","lastname":"Builder","totalprice":123.45,"depositpaid":true,"bookingdates":{"checkin":"2026-10-01","checkout":"2026-10-05"},"additionalneeds":"Wi-Fi"}'
```

### Expected Result
`200 OK` with `totalprice` returned as exactly `123.45`, matching the submitted value bit-for-bit.

### Actual Result
- **Status code:** `200 OK`
- **Behavior:** `totalprice` is returned as `123` — the `.45` fractional component is silently truncated. No error or warning is present anywhere in the response.

### Evidence
- `assets/defect-evidence/DEF-002-postman-response.png` — Postman response pane showing `totalprice: 123` despite `123.45` being submitted.
- Newman CLI output confirming reproducibility: `expected 123 to deeply equal 123.45`.

### Root Cause Analysis
This points to the `totalprice` field being cast or parsed as an integer type on the backend (e.g., `parseInt()` in JavaScript, or an integer column type in the underlying data store) instead of a floating-point/decimal type. Since `parseInt(123.45)` in JavaScript evaluates to `123`, this is consistent with a type-coercion bug at the point where the request body is deserialized, likely in the backend application layer rather than the database schema itself (though the schema may also need review if it stores price as an integer).

### Business Impact
- **Data integrity:** Financial values are being altered without consent or notification — a serious defect class for any system handling money.
- **Compliance:** In real payment systems, silently altering monetary amounts could violate financial record-keeping regulations (e.g., PCI-DSS's requirements around accurate transaction data).
- **Customer trust:** A customer quoted $123.45 who is later charged or invoiced $123 (or vice versa, if reconciliation logic assumes accuracy) will lose confidence in the platform's billing accuracy.
- **Revenue:** At scale, systematically truncating fractional cents/units across thousands of transactions compounds into material revenue leakage.

### Suggested Fix
- Change the backend price handling to use a proper decimal/float type consistently (e.g., `parseFloat()` instead of `parseInt()` in JS, or `DECIMAL`/`NUMERIC` column types in SQL rather than `INTEGER`).
- Alternatively, if integer-only pricing is an intentional business rule, the API should **reject** non-integer prices with `400 Bad Request` rather than silently truncating them — silent data loss is worse than a rejected request.
- Add regression tests asserting exact decimal round-trip for `totalprice` across create, read, and update operations.

### Defect Life Cycle Trail

| Date | Action | Actor | New Status |
|---|---|---|---|
| 2026-08-30 | Defect discovered via TC07, logged | QA Engineer | New |
| 2026-08-30 | Reproduced via Newman CLI automated run | QA Engineer | Open |
