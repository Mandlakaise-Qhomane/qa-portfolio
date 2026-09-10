# Appium

Mobile field-service suite for a Meridian Field agent app.

## What we tested

Launch, login (valid / invalid / blank), logout, job list, job detail, start job, complete job, site notes, search, priority queue, offline banner, depot change, and session timeout. 15 BDD cases across auth, jobs and ops.

Open [`meridian-field-appium`](./meridian-field-appium) and run `mvn test`. Expected: **15 passed**.

## Stack

Java 17 · Maven · Appium Java Client 9 · Selenium 4 · Cucumber 7 · TestNG

Default profile: Chrome Pixel 7 emulation + bundled app on `http://127.0.0.1:18081/`. No emulator or Appium server required.

Optional Android: start an emulator, start Appium on port 4723, set `platform=android` in `meridian-field-appium/src/main/resources/config.properties`.

## Bugs

No planted product defects on the default profile. Environment-only failures (ChromeDriver, emulator, Appium server) are logged in [`meridian-field-appium/docs/08-defect-reports.md`](./meridian-field-appium/docs/08-defect-reports.md). Jira keys sit in [`meridian-field-appium/jira/backlog.md`](./meridian-field-appium/jira/backlog.md).

| ID | Jira | What we tested | Type |
|---|---|---|---|
| TC-01 | APP-101 | App launch shows the sign-in screen | Smoke |
| TC-02 | APP-102 | Valid agent login opens home | Smoke |
| TC-03 | APP-103 | Invalid password is rejected | Negative |
| TC-04 | APP-104 | Blank agent id is rejected | Negative |
| TC-05 | APP-105 | Logout returns to sign-in | Functional |
| TC-06 | APP-201 | Job list shows three open jobs | Smoke |
| TC-07 | APP-202 | Job 1001 opens as ASSIGNED | Functional |
| TC-08 | APP-203 | Start job moves status to IN_PROGRESS | Functional |
| TC-09 | APP-204 | Complete job moves status to COMPLETED | Functional |
| TC-10 | APP-205 | Site note is saved on the job | Functional |
| TC-11 | APP-206 | Search by text finds job 1001 | Functional |
| TC-12 | APP-301 | Priority queue lists only HIGH jobs | Functional |
| TC-13 | APP-302 | Offline banner is shown | Functional |
| TC-14 | APP-303 | Depot can be changed in settings | Functional |
| TC-15 | APP-304 | Idle timeout ends the session | Negative |
