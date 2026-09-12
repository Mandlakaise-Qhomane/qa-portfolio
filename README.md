# QA Portfolio — Mandlakaise Qhomane

Junior / entry QA work: manual, API, performance, database, UI, mobile, and VBScript automation. Click a folder to open the project.

**Email:** mandlaqhomane07@gmail.com

---

## [manual-testing](./manual-testing)

Full STLC on the [OpenMRS 3](https://o3.openmrs.org/openmrs/spa/login) EMR demo: SRS, plan, RTM, 10 cases, screenshots, and closure. Cycle 1 pass rate was 100%. Open [`OpenMRS-Manual-Testing-Portfolio`](./manual-testing/OpenMRS-Manual-Testing-Portfolio).

---

## [postman](./postman)

REST tests on [Restful Booker](https://restful-booker.herokuapp.com) with Postman, Newman, and GitHub Actions. Seven cases cover auth, create, read, update, and list; two negative cases found live defects.

---

## [databases](./databases)

MySQL 8 order-management suite: schema, procedures, 10 SQL cases, STLC docs, and CI. Cycle 1 on GitHub Actions is 8 PASS / 2 FAIL by design (stock not released on cancel; overpayment allowed).

---

## [jmeter](./jmeter)

JMeter performance work on [BlazeDemo](https://blazedemo.com): load, soak, data-driven, and negative tests. Open [`blazedemo-performance-portfolio`](./jmeter/blazedemo-performance-portfolio).

---

## [selenium](./selenium)

Java 17, Maven, Selenium 4, Cucumber, and TestNG. Ten BDD scenarios for a Guru99-style bank, run against a local fixture so `mvn test`. Open [`guru99-bdd-stlc`](./selenium/guru99-bdd-stlc).

---

## [appium](./appium)

Mobile field-service suite for a Meridian Field agent app. Java 17, Appium, Cucumber, TestNG. Fifteen BDD cases. Open [`meridian-field-appium`](./appium/meridian-field-appium) and run `mvn test`.

---

## [vbScript](./vbScript)

STLC on **NalediPay**, a VBScript invoice engine (ZAR, 15% VAT). Custom WSH runner: 34 assertions, 9 requirements, 4 defect tickets (3 product bugs fixed, 1 environment constraint). Run on Windows:

```bat
cscript //nologo tests\TestRunner.vbs
