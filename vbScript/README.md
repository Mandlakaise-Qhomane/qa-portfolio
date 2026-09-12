# NalediPay — VBScript STLC QA Portfolio

End-to-end **Software Testing Life Cycle** project for a **VBScript** invoice engine.

Reviewers on Windows can clone this repo, run one command, and see a **green suite**. Defect tickets show New → Open → Fixed → Retest → Closed.

## Application under test

`src/InvoiceEngine.vbs` — **NalediPay** invoice rules:

- Invoice numbers `INV` + 7 digits (case-insensitive prefix)
- Customer email format check
- Line net = qty × unit price (cap 100000.00)
- Discount 0–50%
- VAT **15%** of the **discounted** net (South Africa)
- Gross = discounted net + VAT

## How to run (Windows only)

VBScript needs Windows Script Host (`cscript.exe`). It will not run on Ubuntu, macOS, or GitHub `ubuntu-latest`.

From the `vbScript` folder:

```bat
cscript //nologo tests\TestRunner.vbs
