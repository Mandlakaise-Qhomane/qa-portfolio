# Functional Requirements — Guru99 Bank Demo

| Req ID | Description | Priority |
|--------|-------------|----------|
| REQ-LOGIN-01 | System shall authenticate managers with valid credentials and land on Manager Home. | High |
| REQ-LOGIN-02 | System shall reject invalid credentials and show an error. | High |
| REQ-LOGIN-03 | System shall validate blank user ID / password fields. | Medium |
| REQ-CUST-01 | System shall create a new customer and return a Customer ID. | High |
| REQ-CUST-02 | Customer name field shall reject numeric-only input. | Medium |
| REQ-ACCT-01 | System shall open a Savings account for an existing customer and return Account ID. | High |
| REQ-TRAN-01 | System shall accept a deposit and update the account balance. | High |
| REQ-TRAN-02 | System shall accept a valid withdrawal and update the account balance. | High |
| REQ-TRAN-03 | System shall reject withdrawal amounts greater than available balance. | High |
| REQ-TRAN-04 | System shall transfer funds between two accounts. | Medium |
| REQ-STMT-01 | Mini Statement shall list recent transactions for an account. | Medium |
| REQ-SEC-01 | Logout shall return to login; browser back shall not restore the session. | High |
| REQ-PWD-01 | Manager shall be able to change password with confirmation. | Low |
