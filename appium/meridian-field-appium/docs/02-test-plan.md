# Test plan

**Objective:** 15 mobile BDD cases covering auth, job lifecycle and field operations.

**Default run:** Chrome mobile emulation + bundled field app (no emulator).  
**Android run:** set `platform=android`, start Appium 2 + emulator, then `mvn test`.

**Exit:** 15 PASS on the local profile. Device/Appium failures are environment, not product defects.
