# Meridian Field — Appium STLC suite

15 BDD cases for a field-service mobile app. Same STLC shape as the database and Guru99 folders.

**Stack:** Java 17 · Maven · Appium Java Client 9 · Selenium 4 · Cucumber 7 · TestNG

**Default run does not need an emulator.** Chrome opens in Pixel 7 emulation against a bundled app on `http://127.0.0.1:18081/`.

```bash
cd appium/meridian-field-appium
mvn test
```

Expected: **15 passed**.

## Android (optional)

1. Start an emulator  
2. `appium` (port 4723)  
3. In `src/main/resources/config.properties` set `platform=android`  
4. `mvn test`

## Cases

| ID | Jira | Scenario |
|---|---|---|
| TC-01 | APP-101 | App launch |
| TC-02 | APP-102 | Valid login |
| TC-03 | APP-103 | Bad password |
| TC-04 | APP-104 | Blank agent |
| TC-05 | APP-105 | Logout |
| TC-06 | APP-201 | Job list |
| TC-07 | APP-202 | Job detail |
| TC-08 | APP-203 | Start job |
| TC-09 | APP-204 | Complete job |
| TC-10 | APP-205 | Site note |
| TC-11 | APP-206 | Search |
| TC-12 | APP-301 | Priority queue |
| TC-13 | APP-302 | Offline banner |
| TC-14 | APP-303 | Change depot |
| TC-15 | APP-304 | Idle timeout |
