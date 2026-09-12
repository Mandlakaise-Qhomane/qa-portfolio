# Test Cases — NalediPay v1.0

Executed by `tests/TestRunner.vbs`. Result after QA-01: **all Pass**.

| ID | Title | REQ | Pri | Type | Expected |
| --- | --- | --- | --- | --- | --- |
| TC-01 | Engine file loads | REQ-01 | P1 | Smoke | source length > 0 |
| TC-02 | Valid invoice INV0001234 | REQ-02 | P1 | Functional | True |
| TC-03b | Lowercase inv0001234 accepted | REQ-02 | P1 | Functional | True |
| TC-04 | Short invoice INV123 | REQ-02 | P2 | BVA | False |
| TC-05 | Wrong prefix ABC0001234 | REQ-02 | P2 | Negative | False |
| TC-06 | Letters in numeric tail | REQ-02 | P2 | Negative | False |
| TC-07 | Valid email | REQ-03 | P1 | Functional | True |
| TC-08 | Email without @ | REQ-03 | P1 | Negative | False |
| TC-09 | Email without domain dot | REQ-03 | P2 | Negative | False |
| TC-10 | Email with space | REQ-03 | P2 | Negative | False |
| TC-11 | LineNet 5 × 50 | REQ-04 | P1 | Functional | 250 |
| TC-12 | LineNet 2 × 0.01 | REQ-04/05 | P1 | BVA | 0.02 |
| TC-13 | Qty 0 raises 1002 | REQ-05 | P1 | Negative | Err 1002 |
| TC-14 | Price 0 raises 1003 | REQ-05 | P1 | BVA | Err 1003 |
| TC-15 | Line over cap raises 1004 | REQ-05 | P1 | BVA | Err 1004 |
| TC-16 | 10% off 100 | REQ-06 | P1 | Functional | 90 |
| TC-17 | 0% discount | REQ-06 | P1 | BVA | 100 |
| TC-18 | 50% discount | REQ-06 | P1 | BVA | 50 |
| TC-19 | 51% discount raises 1011 | REQ-06 | P1 | BVA | Err 1011 |
| TC-20 | −1% discount raises 1011 | REQ-06 | P2 | Negative | Err 1011 |
| TC-21 | VAT on 100 | REQ-07 | P1 | Functional | 15 |
| TC-22 | VAT on 0 | REQ-07 | P2 | BVA | 0 |
| TC-23 | VAT on 10 | REQ-07 | P1 | Functional | 1.5 |
| TC-24 | VAT on −5 raises 1021 | REQ-07 | P2 | Negative | Err 1021 |
| TC-25 | Gross of 100 | REQ-08 | P1 | Functional | 115 |
| TC-26 | Gross of 50 | REQ-08 | P2 | Functional | 57.5 |
| TC-27–32 | BuildInvoice payload fields | REQ-09 | P1 | Functional | NET 100, DISC 90, VAT 13.50, GROSS 103.50 |
| TC-33 | Bad invoice number raises 1030 | REQ-09 | P1 | Negative | Err 1030 |
| TC-34 | Bad email raises 1031 | REQ-09 | P1 | Negative | Err 1031 |
