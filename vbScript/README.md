# NalediPay — VBScript STLC QA Portfolio

End-to-end **Software Testing Life Cycle** project for a **VBScript** invoice engine.

Reviewers can clone this repo, run one command on Windows, and see a **green suite**. Defect tickets show New → Open → Fixed → Retest → Closed.

## Application under test

`src/InvoiceEngine.vbs` — **NalediPay** invoice rules:

- Invoice numbers `INV` + 7 digits
- Customer email format check
- Line net = qty × unit price (cap 100000.00)
- Discount 0–50%
- VAT **15%** (South Africa)
- Gross = discounted net + VAT

## Run the passing tests (Windows)

```bat
cscript //nologo tests\TestRunner.vbs
```

Or double-click `run-tests.cmd`.

Expected last lines:

```
Total: 34  Passed: 34  Failed: 0
SUITE RESULT: PASS
```

Exit code `0` = pass, `1` = fail. GitHub Actions uses `windows-latest` and the same command.

## STLC map

| Phase | Folder |
| --- | --- |
| Requirement analysis | [stlc/01-requirement-analysis](stlc/01-requirement-analysis/requirements.md) |
| Test planning | [stlc/02-test-planning](stlc/02-test-planning/test-plan.md) |
| Test design + RTM | [stlc/03-test-design](stlc/03-test-design/test-cases.md) |
| Environment | [stlc/04-test-environment](stlc/04-test-environment/environment.md) |
| Execution | [stlc/05-test-execution](stlc/05-test-execution/execution-log.md) |
| Closure | [stlc/06-test-closure](stlc/06-test-closure/test-summary.md) |
| Defect management | [defects](defects/defect-log.md) |

## Defects shown in this cycle

| ID | Summary | Outcome |
| --- | --- | --- |
| [DEF-001](defects/DEF-001.md) | VAT taken on amount before discount | Fixed + retested |
| [DEF-002](defects/DEF-002.md) | Invoice prefix check was case-sensitive | Fixed + retested |
| [DEF-003](defects/DEF-003.md) | Discount above 50% accepted | Fixed + retested |
| [DEF-004](defects/DEF-004.md) | WSH host required (not a product bug) | Closed — environment note |

## Skills demonstrated

VBScript / WSH · STLC · test harness design · EP / BVA · error-code assertions · defect lifecycle · RTM · GitHub Actions (`windows-latest`) · residual-risk notes

## Licence

MIT. See `LICENSE`.
