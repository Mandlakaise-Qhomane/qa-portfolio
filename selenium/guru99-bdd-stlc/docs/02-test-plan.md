# Test plan

**Objective:** Prove manager login and core servicing on Guru99 V4 using BDD.

**In scope:** login, new customer, new account, deposit, withdrawal, logout.  
**Out of scope:** customised statements, Selenium Grid, Jenkins.

**Approach:** Gherkin features → Cucumber steps → Page Objects → TestNG runner.

**Entry:** JDK 17, Maven, Chrome, fresh manager ID in `config.properties`.  
**Exit:** 10 scenarios executed; defects logged against Jira keys; residual risk accepted on demo instability.

**Risk:** Guru99 demo resets credentials and is rate-limited. Mitigation: unique emails, short suite, headless Chrome.
