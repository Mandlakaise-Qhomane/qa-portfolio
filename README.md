# QA Portfolio — Mandlakaise Qhomane

Junior / entry QA work: manual, API, performance, database, and UI automation. Click a folder to open the project.

**Email:** mandlaqhomane07@gmail.com

---

## [manual-testing](./manual-testing)

Full STLC on the [OpenMRS 3](https://o3.openmrs.org/openmrs/spa/login) EMR demo: SRS, plan, RTM, 10 cases (login, patient, appointments, clinical, security), screenshots, and closure. Cycle 1 pass rate was 100%. Open [`OpenMRS-Manual-Testing-Portfolio`](./manual-testing/OpenMRS-Manual-Testing-Portfolio) for the pack.

---

## [postman](./postman)

REST tests on [Restful Booker](https://restful-booker.herokuapp.com) with Postman, Newman, and GitHub Actions. Seven cases cover auth, create, read, update, and list; two negative cases found live defects (bad dates accepted, price truncated). Collection, environments, bug reports, and CI live in this folder.

---

## [databases](./databases)

MySQL 8 order-management suite: schema, procedures, 10 SQL cases, STLC docs, and CI. Cycle 1 on GitHub Actions is 8 PASS / 2 FAIL by design (stock not released on cancel; overpayment allowed). Start at this folder’s README, then `docs/` and `sql/tests/`.

---

## [jmeter](./jmeter)

JMeter performance work on [BlazeDemo](https://blazedemo.com): critical path, load, soak, data-driven, and negative tests. Booking stays under 3s; the site strains near 160 concurrent users; two bugs are logged. Open [`blazedemo-performance-portfolio`](./jmeter/blazedemo-performance-portfolio).

---

## [selenium](./selenium)

Java 17 + Selenium 4 + TestNG + Maven Page Object framework for [Guru99 Bank V4](https://www.demo.guru99.com/V4/). Source and suite live in [`guru99-bank-framework`](./selenium/guru99-bank-framework). Run with `mvn test`.

---

## [playwright](./playwright)

Placeholder for Playwright UI automation. No executed suite yet.

---

## [rest-assured](./rest-assured)

Placeholder for Rest Assured (Java) API automation. No executed suite yet.

---

Mandlakaise Qhomane · QA / Manual & API Test Engineer
