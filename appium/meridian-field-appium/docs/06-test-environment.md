# Test environment

| Item | Local profile | Android profile |
|---|---|---|
| Driver | Chrome mobile emulation (Pixel 7) | Appium UiAutomator2 + Chrome |
| App | `LocalFieldApp` HTTP app on `127.0.0.1:18081` | same app; AVD may need `http://10.0.2.2:18081/` |
| JDK | 17+ | 17+ |
| Build | Maven 3.9+ | Maven 3.9+ |
| Appium server | not required | Appium 2 on :4723 + uiautomator2 driver |
| Device | none | Pixel_7 emulator (or set `udid`) |
| Config | `src/main/resources/config.properties` | set `platform=android` |

Credentials: `agentId=agent.jhb`, `password=Field@123`.
