# Test execution report

**Cycle:** 1  
**Profile:** `localchrome` (Chrome mobile emulation + bundled app on :18081)  
**Command:** `mvn test`  
**Build:** meridian-field-appium 1.0.0

| ID | Jira | Scenario | Result |
|---|---|---|---|
| TC-01 | APP-101 | App launch shows sign-in | PASS |
| TC-02 | APP-102 | Valid agent login opens home | PASS |
| TC-03 | APP-103 | Invalid password rejected | PASS |
| TC-04 | APP-104 | Blank agent id rejected | PASS |
| TC-05 | APP-105 | Logout returns to sign-in | PASS |
| TC-06 | APP-201 | Job list shows three open jobs | PASS |
| TC-07 | APP-202 | Job 1001 opens as ASSIGNED | PASS |
| TC-08 | APP-203 | Start job → IN_PROGRESS | PASS |
| TC-09 | APP-204 | Complete job → COMPLETED | PASS |
| TC-10 | APP-205 | Site note saved | PASS |
| TC-11 | APP-206 | Search "meter" finds 1001 | PASS |
| TC-12 | APP-301 | Priority queue = HIGH only | PASS |
| TC-13 | APP-302 | Offline banner shown | PASS |
| TC-14 | APP-303 | Depot change to CPT-West | PASS |
| TC-15 | APP-304 | Idle timeout ends session | PASS |

**Summary:** 15 PASS / 0 FAIL / 0 BLOCKED

Failed scenarios attach a PNG under `evidence/screenshots/` and into the Cucumber HTML report.
