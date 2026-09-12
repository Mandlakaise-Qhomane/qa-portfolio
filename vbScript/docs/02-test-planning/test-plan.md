# Test Plan — NalediPay QA-01

## 1. Objective

Prove the VBScript invoice engine meets REQ-01–REQ-09, that the suite is runnable with `cscript`, and that defects follow a visible lifecycle.

## 2. Scope

**In:** functional rules, validation, rounding, error numbers, build-invoice payload.  
**Out:** performance, security of WSH itself, UI.

## 3. Strategy

| Layer | Approach | Tool |
| --- | --- | --- |
| Smoke | Engine file loads | TestRunner.vbs |
| Functional | Happy path totals | AssertEqual |
| Negative | Invalid inputs raise documented Err.Number | On Error Resume Next |
| BVA | qty 0, price 0.01, discount 0 / 50 / 51 | TestRunner.vbs |
| Regression | Full suite on each push | GitHub Actions windows-latest |

## 4. Environment

Windows 10/11 or GitHub `windows-latest`. Host: `cscript.exe`. No extra install.

## 5. Entry / exit

**Start execution when:** requirements frozen, runner reviewed, `cscript` present.  
**Close cycle when:** all planned cases executed, P1 defects closed, summary signed.

## 6. Suspension

Stop if the engine file cannot be loaded or more than two P1 money-calculation defects are open.

## 7. Deliverables

This plan, requirements, cases, RTM, execution log, defect reports, closure report, passing `cscript` run, CI workflow.

## 8. Risks

| Risk | Mitigation |
| --- | --- |
| Linux/macOS cannot run VBS natively | CI uses windows-latest; README states the host |
| Floating-point drift | `RoundMoney` helper |
| VBScript deprecation in future Windows | Lab AUT; documented in closure |
