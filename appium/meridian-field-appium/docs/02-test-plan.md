# Test plan

**Objective:** Prove the Meridian Field mobile job app covers launch, auth, job lifecycle, search, priority, offline, depot change and session timeout.

**Scope in:** 15 BDD cases mapped to APP-101 … APP-304.  
**Scope out:** native gestures, push notifications, GPS, real device farm (optional Android profile only).

| Item | Default (`localchrome`) | Android |
|---|---|---|
| Driver | Chrome + Pixel 7 emulation | Appium UiAutomator2 + Chrome |
| App under test | Bundled `LocalFieldApp` on `127.0.0.1:18081` | Same URL from the emulator |
| Appium server | Not required | `appium` on :4723 |
| JDK / build | 17 / Maven | 17 / Maven |

**Entry:** JDK 17, Maven, Chrome installed.  
**Exit:** 15 PASS on the local profile. Android-only failures are environment defects, not product defects.

**Risks:** ChromeDriver mismatch (Selenium Manager), port 18081 clash, emulator Chrome version vs Appium chromedriver.
