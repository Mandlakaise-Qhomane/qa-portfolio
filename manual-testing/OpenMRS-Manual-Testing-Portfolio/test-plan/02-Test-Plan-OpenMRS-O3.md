# Test Plan
## OpenMRS 3 (O3) – Health Management System Manual Testing

**Document Version:** 1.0  
**Date:** September 2026  
**Prepared by:** Mandlakaise Qhomane – QA Lead – Manual Test Portfolio  
**Project:** Manual Testing Portfolio – Healthcare Domain  
**Application Under Test:** OpenMRS 3 (O3) Demo  
**Demo URL:** https://o3.openmrs.org/openmrs/spa/login  
**Credentials:** Location – Any | Username – admin | Password – Admin123  

---

## 1. Introduction

### 1.1 Purpose
This Test Plan defines the scope, approach, resources, and schedule for manual testing of the OpenMRS 3 Health Management System demo. It ensures comprehensive coverage of core clinical workflows and produces professional artifacts suitable for a QA portfolio.

### 1.2 Objectives
- Validate that core functional requirements work as expected.
- Identify defects in critical patient and clinical workflows.
- Demonstrate enterprise-grade test documentation and STLC adherence.
- Produce clear evidence (test cases, execution logs, screenshots, defect reports).

### 1.3 Scope

**In Scope:**
- Authentication & Authorization
- Patient Registration and Search
- Appointment Scheduling (Create / Edit / Cancel)
- Clinical Documentation (Vitals, Encounters, Notes)
- Service Queues and Patient Flow
- Basic Orders (Lab / Medication)
- UI/UX, Cross-browser, Accessibility, Negative & Boundary testing

**Out of Scope:**
- API / FHIR testing
- Performance / Load / Stress testing
- Security penetration testing
- Mobile application testing
- Custom module development or configuration changes

---

## 2. Test Strategy

### 2.1 Testing Levels
- **Functional Testing** (primary focus)
- **UI / Usability Testing**
- **Compatibility Testing** (browsers)
- **Negative Testing**
- **Boundary Value Analysis**
- **Exploratory Testing**
- **Accessibility (basic)**

### 2.2 Test Design Techniques
- Equivalence Partitioning
- Boundary Value Analysis
- Decision Table Testing (where applicable)
- Error Guessing
- Exploratory Testing (charter-based)

### 2.3 Entry Criteria
- Requirements document finalized and approved
- Test cases designed and reviewed
- Test environment (demo site) accessible
- Test data prepared
- Browsers installed and ready

### 2.4 Exit Criteria
- All planned test cases executed
- Critical and High priority defects resolved or documented with workarounds
- Test Summary Report completed
- Traceability Matrix updated
- Evidence (screenshots, logs) archived

---

## 3. Test Environment

| Item | Details |
|------|---------|
| Application | OpenMRS 3 (O3) Public Demo |
| URL | https://o3.openmrs.org/openmrs/spa/login |
| Credentials | admin / Admin123 (Location: Any) |
| Browsers | Chrome (latest), Firefox (latest), Microsoft Edge (latest) |
| OS | Windows 10/11 or macOS |
| Tools | Browser DevTools, ShareX/Greenshot (screenshots), Excel/Google Sheets, Markdown |

**Note:** Demo data may reset. Always verify current state before execution.

---

## 4. Test Deliverables

1. Requirements Specification (SRS)
2. Test Plan (this document)
3. Test Cases (Master + modular)
4. Requirements Traceability Matrix (RTM)
5. Test Execution Logs / Reports
6. Screenshots (organized by module)
7. Defect Log + individual defect reports
8. Test Summary Report
9. Metrics Dashboard
10. Lessons Learned

---

## 5. Roles and Responsibilities

| Role | Responsibility |
|------|----------------|
| QA Lead / Tester | Requirement analysis, test design, execution, defect reporting, summary reporting |
| (Portfolio context) | Single person performing all roles to demonstrate full ownership |

---

## 6. Schedule (Suggested for Portfolio)

| Phase | Activity | Estimated Effort |
|-------|----------|------------------|
| 1 | Requirement Analysis & SRS | 0.5 day |
| 2 | Test Planning | 0.5 day |
| 3 | Test Case Design | 1–1.5 days |
| 4 | Test Environment Setup & Dry Run | 0.5 day |
| 5 | Test Execution (Cycle 1) | 1–2 days |
| 6 | Defect Reporting & Retesting | 0.5–1 day |
| 7 | Test Summary & Portfolio Packaging | 0.5 day |

**Total Estimated Effort:** 5–7 days of focused work

---

## 7. Risks and Mitigations

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Demo site downtime or data reset | High | Medium | Document current state; re-execute critical cases if needed |
| Limited role options in public demo | Medium | High | Focus on available admin features; note limitations |
| Unstable internet | Medium | Low | Use stable connection; save evidence frequently |
| Incomplete feature visibility | Medium | Medium | Combine functional + exploratory testing |

---

## 8. Test Metrics to Track

- Total Test Cases Designed
- Test Cases Executed
- Pass Percentage
- Fail Percentage
- Number of Defects by Severity
- Requirements Coverage %
- Defect Detection Efficiency

---

## 9. Approvals

| Role | Name | Signature / Date |
|------|------|------------------|
| Prepared by | Mandlakaise Qhomane | |
| Reviewed by | (Self-review for portfolio) | |

---

**Document Control**  
This Test Plan is part of a complete STLC-based Manual Testing Portfolio focused on the Healthcare domain.  
All related artifacts will be maintained in the GitHub repository structure defined in the portfolio README.
