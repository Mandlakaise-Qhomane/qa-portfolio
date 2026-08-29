# TC1 — Critical Business Path (End-to-End Booking Funnel)

## Metadata
| Attribute | Value |
|---|---|
| **STLC Phase** | Test Design & Execution |
| **Test Type** | Functional + Performance |
| **Objective** | Validate the complete booking funnel works correctly and responds in < 3 seconds |

## Test Design
| Parameter | Value |
|---|---|
| Thread Group | TC1_CriticalPath_ThreadGroup |
| Users | 1 |
| Ramp-up | 1 second |
| Loop Count | 1 |
| Transaction Controller | TXN_FullBookingFunnel (Generate parent sample = true) |

## JMeter Elements Used
- Transaction Controller (end-to-end timing)
- HTTP Request Samplers (4-step funnel)
- Response Assertions (3 assertions: "Flight #", "purchase the flight", "Thank you for your purchase today")

## Execution
Run in **GUI mode** (single user validation):
- Enable only TC1_CriticalPath_ThreadGroup
- Disable all other Thread Groups
- Click Start

## Actual Results
| Sampler | Status | Response Time |
|---|---|---|
| 01_Home_GET | ✅ Pass | ~200-400 ms |
| 02_FindFlights_POST | ✅ Pass | ~200-400 ms |
| 03_ChooseFlight_POST | ✅ Pass | ~200-400 ms |
| 04_Purchase_POST | ✅ Pass | ~200-400 ms |
| **TXN_FullBookingFunnel** | ✅ **Pass** | **< 3,000 ms** |

- All 3 Response Assertions passed
- Aggregate Report showed **0% Error**

## Analysis
The complete booking funnel executes successfully end-to-end. Response times are well within the < 3 second SLA, confirming the critical business path is functional and performant under single-user conditions.

## Pass/Fail Criteria
| Criteria | Result |
|---|---|
| End-to-end transaction < 3s | ✅ PASS |
| Error rate = 0% | ✅ PASS |
| All response assertions pass | ✅ PASS |

## Evidence
- Screenshot: Aggregate Report showing 0% error and response times
- Screenshot: View Results Tree showing all green samplers
