# Manual + Automated Test Cases

| ID | Module | Precondition | Steps | Data | Expected |
|----|--------|--------------|-------|------|----------|
| TC_LOGIN_001 | Login | On login page | Enter valid user/pass, click Login | config.properties | Manager Home |
| TC_LOGIN_002 | Login | On login page | Enter invalid user/pass | badUser / badPass | Alert: not valid |
| TC_LOGIN_003 | Login | On login page | Leave fields blank, click Login | empty | Validation alert |
| TC_CUST_001 | Customer | Logged in | Fill New Customer, submit | unique email | Customer ID shown |
| TC_CUST_002 | Customer | Logged in | Type numbers in Name | 12345 | Field validation message |
| TC_ACCT_001 | Account | Customer ID exists | Open Savings, initial deposit 5000 | customerId | Account ID shown |
| TC_TRAN_001 | Deposit | Account exists | Deposit 1000 | accountId | Success + balance up |
| TC_TRAN_002 | Withdrawal | Account exists | Withdraw 100 | accountId | Success + balance down |
| TC_TRAN_003 | Withdrawal | Account exists | Withdraw 99999999 | accountId | Insufficient funds error |
| TC_TRAN_004 | Statement | After transactions | Mini Statement for account | accountId | Table of txns |
| TC_TRAN_005 | Transfer | Two accounts | Transfer 10 | from/to IDs | Both balances update |
