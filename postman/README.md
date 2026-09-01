# API Testing Portfolio — Restful Booker

**QA Engineer:** Mandla Qhomane
**Tools:** Postman · Newman · JavaScript (Postman assertions) · GitHub Actions
**API Under Test:** [Restful Booker](https://restful-booker.herokuapp.com) — `https://restful-booker.herokuapp.com`

![CI/CD](https://github.com/Mandlakaise-Qhomane/qa-api-portfolio/actions/workflows/postman-newman-ci.yml/badge.svg)

## Quick Stats

| Metric | Value |
|---|---|
| Test cases | 7 (5 positive, 2 negative) |
| Real defects discovered | 2 |
| API endpoints covered | 5 |
| Automated CI/CD | ✅ Newman runs on every push |

---

## What This Portfolio Proves

- **5 positive tests** confirming core booking functionality (auth, create, read, update, list) all work correctly under valid input.
- **2 real defects discovered through negative testing** — not hypothetical bugs written for show, but reproducible issues confirmed across multiple independent test runs (Postman Runner + Newman CLI, on separate dates).
- **Enterprise-style organization** following the Software Testing Life Cycle (STLC): requirement analysis → test planning → test case development → environment setup → execution → closure — with each phase documented separately.
- **CI/CD automation** — the full test suite runs automatically via GitHub Actions and Newman on every push, with HTML reports generated as build artifacts.

---

## Test Summary

| TC ID | Test Case Name | Type | Priority | Status | Defect ID |
|---|---|---|---|---|---|
| TC01 | Authentication Token Generation | Positive | P0 | ✅ PASS | N/A |
| TC02 | Create Valid Booking | Positive | P0 | ✅ PASS | N/A |
| TC03 | Get Single Booking | Positive | P1 | ✅ PASS | N/A |
| TC04 | Update Booking Partially | Positive | P1 | ✅ PASS | N/A |
| TC05 | Get All Bookings | Positive | P1 | ✅ PASS | N/A |
| TC06 | Invalid Date Format | Negative | P0 | ❌ FAIL | DEF-001 |
| TC07 | Floating-Point Price | Negative | P1 | ❌ FAIL | DEF-002 |

Full detail: [`test-cases/`](test-cases/README.md)

---

## Defects Documented

- **DEF-001 — Date Format Corruption** (Critical, P0): `POST /booking` accepts malformed date formats (e.g. `"2026/08/29"`) with `200 OK` instead of rejecting them with `400 Bad Request`.
- **DEF-002 — Price Precision Loss** (Major, P1): `POST /booking` silently truncates floating-point prices (e.g. `123.45` → `123`) instead of preserving decimal precision or rejecting the input.

Full reports with reproduction steps, root cause analysis, business impact, and suggested fixes: [`bug-reports/`](bug-reports/README.md)

---

## How to Run This Project

1. **Clone the repository**
   ```
   git clone https://github.com/Mandlakaise-Qhomane/qa-api-portfolio.git
   cd qa-api-portfolio
   ```

2. **Install Newman**
   ```
   npm install -g newman newman-reporter-htmlextra
   ```

3. **Import into Postman** (optional, for manual exploration)
   - Open Postman → Import → select `collections/Restful_Booker.postman_collection.json`
   - Import the environment: `environments/Restful-Booker-Dev.postman_environment.json`

4. **Run the full suite via Newman**
   ```
   newman run collections/Restful_Booker.postman_collection.json -e environments/Restful-Booker-Dev.postman_environment.json --reporters cli,htmlextra --reporter-htmlextra-export reports/sprint-1-test-summary.html
   ```

5. **View the report**
   Open `reports/sprint-1-test-summary.html` in any browser.

---

## CI/CD

Every push to `main` and every pull request automatically triggers the full Newman test suite via GitHub Actions. Reports are generated as workflow artifacts and retained for 30 days. See [`.github/workflows/postman-newman-ci.yml`](.github/workflows/postman-newman-ci.yml).

---

## Folder Structure

```
qa-api-portfolio/
├── README.md
├── .github/
│   └── workflows/
│       └── postman-newman-ci.yml
├── test-plan/
│   └── README.md
├── test-cases/
│   └── README.md
├── bug-reports/
│   └── README.md
├── rtm/
│   └── README.md
├── test-reports/
│   └── README.md
├── test-metrics/
│   └── README.md
├── collections/
│   └── Restful_Booker.postman_collection.json
├── environments/
│   └── Restful-Booker-Dev.postman_environment.json
├── reports/
│   └── sprint-1-test-summary.html
└── assets/
    ├── defect-evidence/
    └── test-execution/
```

---

## Tools & Technologies

- 🧪 **Postman** — request building, assertion scripting, environment management
- ⚙️ **Newman** — CLI test automation and repeatable execution
- 🤖 **GitHub Actions** — CI/CD pipeline
- 📜 **JavaScript** — Postman test assertions (`pm.test`, `pm.expect`)
- 🔗 **REST API Testing** — HTTP methods, status codes, JSON validation
- 📄 **JSON** — request/response payloads and Postman collection format

---

## Contact

**Mandla Qhomane**
📧 mandlaqhomane07@gmail.com
🔗 [github.com/Mandlakaise-Qhomane](https://github.com/Mandlakaise-Qhomane)
