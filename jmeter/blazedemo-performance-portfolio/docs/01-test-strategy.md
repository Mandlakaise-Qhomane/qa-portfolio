# Performance Test Strategy — BlazeDemo Flight Booking

## 1. Project Overview
| Attribute | Details |
|---|---|
| **Application Under Test (AUT)** | BlazeDemo Flight Booking (https://blazedemo.com) |
| **Test Type** | Performance Testing (Load, Stress, Data-Driven, Correlation, Soak) |
| **Tool** | Apache JMeter 5.6.3 |
| **Test Environment** | Local execution |
| **Test Date** | [Insert your date] |

## 2. SDLC Alignment
| SDLC Phase | QA Activity |
|---|---|
| Requirements | NFRs defined (response time < 3s, error rate < 1%) |
| Design | Test architecture designed |
| Development | Test scripts built, data files prepared |
| **System Testing** | **Performance test execution, bottleneck identification, defect logging** |
| UAT | Performance sign-off before release |

## 3. STLC Phases Covered

### Phase 1: Requirement Analysis
- **Business Critical Path**: Home → Find Flights → Choose Flight → Purchase
- **NFRs**:
  - End-to-end transaction: < 3 seconds
  - Error rate under normal load: < 1%
  - Breaking point: ~160+ concurrent users
  - Soak test: No drift over 60 minutes

### Phase 2: Test Planning
- **Scope**: 6 test scenarios
- **Risks**:
  | Risk | Mitigation |
  |---|---|
  | Demo site (static data) | Documented as caveat; technique validity still proven |
  | Single-machine execution | Results treated as relative benchmarks |

### Phase 3: Test Design
- **Test Data**: `blazedemo_data.csv` with 10 unique combinations
- **Correlation**: Regular Expression Extractor for dynamic flight values
- **Assertions**: Response + Duration assertions for SLA enforcement

### Phase 4: Environment Setup
- JMeter 5.6.3
- HTTP Request Defaults, Cookie Manager, Header Manager at Test Plan level

### Phase 5: Test Execution
- Non-GUI mode for load tests
- Results logged to `.jtl` file
- HTML Dashboard Report generated

### Phase 6: Test Closure
- Metrics compiled per test case
- Defects documented with evidence

## 4. Test Case Matrix

| ID | Test Case | Type | Users | Duration |
|---|---|---|---|---|
| TC1 | Critical Business Path | Functional + Performance | 1 | 1 iteration |
| TC2 | Peak Load / Stress | Stress | 200 | 10 min |
| TC3 | Data-Driven Parallelism | Load + Data Variation | 10 | 1 iteration |
| TC4 | Dynamic Correlation | Functional + Correlation | 1 | 1 iteration |
| TC5 | Endurance / Soak | Soak | 20 | 60 min |
| TC6 | Negative Path / Defect | Negative / Security | 1 | 1 iteration |
