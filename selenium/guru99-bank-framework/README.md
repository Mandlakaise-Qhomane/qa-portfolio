# Selenium-Java Banking Framework

Portfolio automation framework for [Guru99 Bank Demo V4](https://www.demo.guru99.com/V4/).

**Stack:** Java 17 · Selenium 4 · TestNG · Maven · Extent Reports · GitHub Actions

> Storage note: this repo is source-only (~small KB). `target/`, reports and screenshots are gitignored.

## How to run (light local setup)

```bash
# 1. Put a valid manager user/password in src/main/resources/config.properties
# 2. JDK 17 + Maven on PATH
mvn test
```

Open `reports/extent-report.html` after the run.

## Project layout

```
docs/                         STLC artifacts
src/main/java/.../base        Driver + BaseTest
src/main/java/.../pages       Page Objects
src/test/java/.../tests       TestNG tests
testng.xml                    Suite
.github/workflows             CI instead of local Jenkins
```

## Credentials

Guru99 issues temporary manager IDs. Generate yours on their demo signup page and keep them in `config.properties`.

## Phase 2

Cucumber BDD in a separate repo, reusing these Page Objects.
