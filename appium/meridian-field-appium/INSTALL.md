# Install and run — Meridian Field Appium

Default profile does **not** need an emulator or Appium server.

## Prerequisites

- JDK 17+ (`java -version`)
- Maven 3.9+ (`mvn -version`)
- Google Chrome (Selenium Manager downloads the matching ChromeDriver)

## Local run (recruiter / demo)

```bash
cd meridian-field-appium
mvn test
```

Expected: **15 passed**. HTML report: `target/cucumber-report.html`.

Run one case:

```bash
mvn test -Dcucumber.filter.tags="@APP-102"
```

## Android run (optional)

1. Start an Android emulator (Pixel 7 recommended)
2. `npm i -g appium` then `appium driver install uiautomator2`
3. `appium` (port 4723)
4. In `src/main/resources/config.properties` set `platform=android`
5. `mvn test`

The suite still drives the bundled field app over Chrome. Point the emulator at `http://10.0.2.2:18081/` if `127.0.0.1` does not resolve from the AVD (`baseUrl` in config).

## Common fixes

| Symptom | Fix |
|---|---|
| `ChromeDriver` / session not created | Install Chrome. Delete `~/.cache/selenium` and rerun. |
| Port 18081 in use | Stop the other process or change `LocalFieldApp.PORT` and `baseUrl`. |
| Android session fails, local passes | Environment issue — log it in `docs/08-defect-reports.md`. |
| Blank login case flakes | Already handled: empty agent id is sent as a blank field. |

Credentials used by the suite: `agent.jhb` / `Field@123`.
