# Test Closure Report — NalediPay QA-01

## Outcome

Cycle closed for portfolio demonstration. All must-have requirements are traced to VBScript assertions. Money-rule P1 defects found in construction were fixed and retested.

## Metrics

| Metric | Result |
| --- | --- |
| Requirements covered | 9/9 |
| Planned cases | 34 |
| Passed | 34 |
| Failed | 0 |
| Open P1 product defects | 0 |

## Defects

| ID | Final state |
| --- | --- |
| DEF-001 VAT before discount | Closed — fixed |
| DEF-002 Case-sensitive INV prefix | Closed — fixed |
| DEF-003 Discount > 50% | Closed — fixed |
| DEF-004 Non-Windows host | Closed — environment constraint |

## Residual risk

VBScript is deprecated on future Windows releases. This lab AUT is appropriate for showing WSH / classic automation skill, not as a production billing system. A follow-up would port the same rules to PowerShell and keep the RTM IDs stable.

## Lessons

- Asserting `Err.Number` makes negative VBS tests reviewable.
- VAT base must be written as a requirement or testers will assume the wrong figure.
- CI must use `windows-latest`; Ubuntu cannot execute `.vbs`.
