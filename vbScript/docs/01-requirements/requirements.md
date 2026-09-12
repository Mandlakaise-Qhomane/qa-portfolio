# Requirement Analysis — NalediPay Invoice Engine v1.0

**AUT:** `src/InvoiceEngine.vbs`  
**Cycle:** QA-01  
**Date:** 2026-09-12  
**Language:** VBScript (Windows Script Host)

## Business context

NalediPay builds a single invoice line in ZAR. Quantity and unit price produce a net amount. An optional discount is applied, then 15% VAT, then a gross total. Invoice numbers and customer emails must be valid before an invoice is issued.

## In-scope requirements

| ID | Requirement | Priority | Testability | Risk |
| --- | --- | --- | --- | --- |
| REQ-01 | Engine script loads under `cscript` | Must | High | Low |
| REQ-02 | Invoice number is `INV` + 7 digits; comparison is case-insensitive | Must | High | Medium |
| REQ-03 | Customer email must contain `@` and a dot in the domain | Must | High | Medium |
| REQ-04 | Line net = qty × unit price, rounded to 2 decimals | Must | High | High |
| REQ-05 | Qty > 0, unit price ≥ 0.01, line net ≤ 100000.00 | Must | High | High |
| REQ-06 | Discount percent is 0–50 inclusive | Must | High | Medium |
| REQ-07 | VAT is 15% of the **discounted** net | Must | High | High |
| REQ-08 | Gross = discounted net + VAT | Must | High | High |
| REQ-09 | `BuildInvoice` rejects bad invoice numbers and emails with distinct error codes | Must | High | Medium |

## Out of scope

- Persistence / database
- Multi-line invoices and credit notes
- Foreign currency
- UI (HTA) and Outlook macros
- Password hashing or tokens

## Ambiguities closed

| Topic | Decision |
| --- | --- |
| VAT base | After discount (DEF-001) |
| Invoice prefix case | Accept `inv` / `INV` (DEF-002) |
| Discount ceiling | 50% (DEF-003) |

## Phase exit

Requirements are testable, numbered, and mapped into the RTM.
