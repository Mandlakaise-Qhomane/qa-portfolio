# Test Plan — Selenium Java Bank Framework

## 1. Objective
Build a recruiter-ready automation portfolio covering login, customer, account, and transaction flows on Guru99 Bank Demo.

## 2. Scope
**In:** Login, New Customer, New Account, Deposit, Withdrawal, Fund Transfer, Mini Statement, Logout.  
**Out (Phase 1):** Payment gateway, Telecom module, Cucumber BDD (Phase 2).

## 3. Environment (storage-aware)
| Item | Choice | Why |
|------|--------|-----|
| Language | Java 17 | LTS |
| Browser | Chrome (WebDriverManager) | No manual driver binaries |
| Runner | TestNG + Maven | Standard |
| Reporting | Extent Reports 5 | Portfolio screenshot |
| CI | GitHub Actions | **No local Jenkins disk cost** |
| IDE | VS Code + Extension Pack for Java **or** GitHub Codespaces | IntelliJ is 1–2 GB |

## 4. Entry criteria
- Valid manager credentials in `config.properties`
- Demo site reachable
- JDK 17 available (local or Codespaces)

## 5. Exit criteria
- 10+ automated cases mapped in RTM
- Extent HTML report generated
- Repo on GitHub with Actions workflow green or documented

## 6. Risks
| Risk | Mitigation |
|------|------------|
| Demo site downtime / credential expiry | Config-driven URL + creds; regenerate manager ID on Guru99 |
| PC disk full (2 GB free) | Do not install IntelliJ/Jenkins locally; use Codespaces or VS Code; never commit `target/` |
| Flaky locators | Page Object Model + explicit waits |

## 7. Deliverables
Source framework, `/docs` STLC pack, Extent report sample, GitHub Actions badge.
