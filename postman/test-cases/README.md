# Test Cases — Restful Booker API

**Total Test Cases:** 7 (5 Positive, 2 Negative)
**Tool:** Postman + Newman
**Related:** [Test Plan](../test-plan/README.md) · [Bug Reports](../bug-reports/README.md) · [RTM](../rtm/README.md)

---

## TC01 — Authentication Token Generation

| Field | Value |
|---|---|
| Type | Positive / Smoke |
| Priority | P0 |
| Method | `POST` |
| Endpoint | `{{base_url}}/auth` |

**Objective:** Confirm the `/auth` endpoint issues a valid token for correct credentials.

**Body:**
```json
{
  "username": "admin",
  "password": "password123"
}
```

**Assertions:** Status 200 · response has `token` property · token not empty · token saved to `auth_token`.

**Result:** ✅ PASS

---

## TC02 — Create a Valid Booking

| Field | Value |
|---|---|
| Type | Positive / Happy Path |
| Priority | P0 |
| Method | `POST` |
| Endpoint | `{{base_url}}/booking` |

**Body:**
```json
{
  "firstname": "John",
  "lastname": "Smith",
  "totalprice": 150,
  "depositpaid": true,
  "bookingdates": { "checkin": "2026-09-01", "checkout": "2026-09-10" },
  "additionalneeds": "Breakfast"
}
```

**Assertions:** Status 200 · `bookingid` returned as number · `firstname` matches · `totalprice` matches · `bookingid` saved to `booking_id`.

**Result:** ✅ PASS

---

## TC03 — Get Single Booking by ID

| Field | Value |
|---|---|
| Type | Positive |
| Priority | P1 |
| Method | `GET` |
| Endpoint | `{{base_url}}/booking/{{booking_id}}` |

**Assertions:** Status 200 · `firstname` matches the booking created in TC02.

**Result:** ✅ PASS
*(Note: initial run failed with a hardcoded ID instead of `{{booking_id}}` — corrected during execution.)*

---

## TC04 — Update Booking Partially

| Field | Value |
|---|---|
| Type | Positive |
| Priority | P1 |
| Method | `PATCH` |
| Endpoint | `{{base_url}}/booking/{{booking_id}}` |
| Headers | `Cookie: token={{auth_token}}` |

**Body:**
```json
{ "firstname": "Jane" }
```

**Assertions:** Status 200 · `firstname` updated to "Jane" · `lastname` and `totalprice` unchanged.

**Result:** ✅ PASS (4/4 assertions)

---

## TC05 — Get All Bookings

| Field | Value |
|---|---|
| Type | Positive |
| Priority | P1 |
| Method | `GET` |
| Endpoint | `{{base_url}}/booking` |

**Assertions:** Status 200 · response is an array · array has at least one item · each item has `bookingid`.

**Result:** ✅ PASS (4/4 assertions)

---

## TC06 — Create Booking with Invalid Date Format (Negative → DEF-001)

| Field | Value |
|---|---|
| Type | Negative |
| Priority | P0 |
| Method | `POST` |
| Endpoint | `{{base_url}}/booking` |

**Body:**
```json
{
  "firstname": "Jane",
  "lastname": "Doe",
  "totalprice": 100,
  "depositpaid": true,
  "bookingdates": { "checkin": "2026/08/29", "checkout": "29-08-2026" },
  "additionalneeds": "None"
}
```

**Assertions:** Status should be 400 · `checkin` should not contain corrupted value.

**Expected:** `400 Bad Request`, no booking created.
**Actual:** `200 OK` — booking created with malformed dates accepted.
**Result:** ❌ FAIL — see **DEF-001**

---

## TC07 — Create Booking with Floating-Point Price (Negative → DEF-002)

| Field | Value |
|---|---|
| Type | Negative |
| Priority | P1 |
| Method | `POST` |
| Endpoint | `{{base_url}}/booking` |

**Body:**
```json
{
  "firstname": "Bob",
  "lastname": "Builder",
  "totalprice": 123.45,
  "depositpaid": true,
  "bookingdates": { "checkin": "2026-10-01", "checkout": "2026-10-05" },
  "additionalneeds": "Wi-Fi"
}
```

**Assertions:** `totalprice` should exactly equal `123.45` · `totalprice` should not equal `123`.

**Expected:** `200 OK`, price preserved as `123.45`.
**Actual:** `200 OK`, but `totalprice` returned as `123` — decimal silently dropped.
**Result:** ❌ FAIL — see **DEF-002**

---

## Summary

| TC ID | Name | Type | Priority | Status | Defect |
|---|---|---|---|---|---|
| TC01 | Authentication Token Generation | Positive | P0 | ✅ PASS | N/A |
| TC02 | Create Valid Booking | Positive | P0 | ✅ PASS | N/A |
| TC03 | Get Single Booking | Positive | P1 | ✅ PASS | N/A |
| TC04 | Update Booking Partially | Positive | P1 | ✅ PASS | N/A |
| TC05 | Get All Bookings | Positive | P1 | ✅ PASS | N/A |
| TC06 | Invalid Date Format | Negative | P0 | ❌ FAIL | DEF-001 |
| TC07 | Floating-Point Price | Negative | P1 | ❌ FAIL | DEF-002 |

**Confirmed via Newman CLI (repeatable):** 7/7 requests executed, 0 request errors, 19 assertions run, 4 failed — all 4 isolated to TC06 and TC07 exactly as expected.
