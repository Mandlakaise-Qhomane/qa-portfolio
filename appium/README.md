# Appium — Meridian Field

Mobile field-service suite. Cases cover launch, login, job list, start/complete, notes, search, priority, offline, depot change, and session timeout.

Unzip, then:

```bash
cd meridian-field-appium
mvn test
```

**Stack:** Java 17 · Maven · Appium Java Client 9 · Selenium 4 · Cucumber 7

**Default profile:** Chrome mobile emulation + bundled app on port 18081. No Appium server required.

Optional Android: start an emulator, start Appium on 4723, set `platform=android` in `meridian-field-appium/src/main/resources/config.properties`.

Full install notes: [`meridian-field-appium/INSTALL.md`](meridian-field-appium/INSTALL.md).
