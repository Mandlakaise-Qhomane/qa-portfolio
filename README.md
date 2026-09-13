# QA Portfolio — Mandlakaise Qhomane

Junior / entry QA work: manual, API, performance, database, UI, mobile, and VBScript automation. Click a folder to open the project.

**Email:** mandlaqhomane07@gmail.com

## ⚠️ Testing Environment Note

Some automation suites in this portfolio (e.g. Selenium-based tests) were executed 
via RDP into an AWS EC2 instance, accessed from a mobile device, rather than a 
local desktop/laptop environment. This setup was a deliberate way to demonstrate 
cloud-based test execution and remote environment familiarity, but it does 
introduce memory/resource constraints on the EC2 instance that occasionally 
prevent higher-memory test runs (e.g. large parallel Selenium suites) from 
completing successfully.

**Why this is here:** I want to be transparent about the environment behind 
these results — this is a constraint of the infrastructure I used to build 
this portfolio, not a gap in my understanding of the tools or test design. 
Test logic, structure, and coverage reflect my actual working knowledge of 
Selenium and automation frameworks.

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
