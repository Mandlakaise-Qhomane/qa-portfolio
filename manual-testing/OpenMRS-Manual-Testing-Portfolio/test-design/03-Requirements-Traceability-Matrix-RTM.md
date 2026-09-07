# Requirements Traceability Matrix (RTM)
## OpenMRS 3 (O3) – Health Management System

**Document Version:** 1.0  
**Date:** September 2026  
**Linked Documents:**  
- 01-Requirements-SRS-OpenMRS-O3.md  
- 02-Test-Plan-OpenMRS-O3.md  

**Purpose:** Ensure every functional and non-functional requirement is covered by one or more test cases.

---

## Functional Requirements Traceability

| Req ID | Requirement Title | Priority | Test Case ID(s) | Coverage Status |
|--------|-------------------|----------|-----------------|-----------------|
| FR-01 | Secure Login | Critical | TC-AUTH-001, TC-AUTH-003 | Covered |
| FR-02 | Invalid Login Handling | High | TC-AUTH-002, TC-AUTH-004 | Covered |
| FR-03 | Patient Registration | Critical | TC-PAT-001, TC-PAT-003, TC-PAT-004 | Covered |
| FR-04 | Patient Search | High | TC-PAT-002, TC-PAT-005 | Covered |
| FR-05 | Appointment Scheduling | High | TC-APT-001, TC-APT-002, TC-APT-003 | Covered |
| FR-06 | Record Vitals & Biometrics | Critical | TC-CLI-001, TC-CLI-003 | Covered |
| FR-07 | Clinical Encounter / Notes | High | TC-CLI-002, TC-CLI-004 | Covered |
| FR-08 | Service Queues | High | TC-QUE-001, TC-QUE-002 | Covered |
| FR-09 | Lab / Medication Orders | Medium | TC-ORD-001, TC-ORD-002 | Covered |
| FR-10 | Patient Dashboard & History | High | TC-CLI-005, TC-PAT-006 | Covered |
| FR-11 | Logout & Session Management | High | TC-AUTH-005 | Covered |
| FR-12 | Role-Based Access Control | Critical | TC-SEC-001 | Covered |

---

## Non-Functional Requirements Traceability

| Req ID | Category | Requirement | Test Case ID(s) | Coverage Status |
|--------|----------|-------------|-----------------|-----------------|
| NFR-01 | Usability | Clear error messages & intuitive navigation | TC-AUTH-002, TC-PAT-003, TC-UI-001 | Covered |
| NFR-02 | Security | No unauthorized access | TC-SEC-001, TC-AUTH-005 | Covered |
| NFR-03 | Compatibility | Chrome, Firefox, Edge | TC-UI-002 | Covered |
| NFR-04 | Accessibility | Labeled fields & keyboard navigation | TC-ACC-001 | Covered |
| NFR-05 | Data Integrity | Validation & no data loss | TC-PAT-003, TC-CLI-001, TC-PAT-004 | Covered |
| NFR-06 | Reliability | Consistent behavior | All core TCs (re-execution) | Covered |
| NFR-07 | Performance | Acceptable response time | Observational during execution | Covered |

---

## Coverage Summary

| Category | Total Requirements | Covered | Coverage % |
|----------|--------------------|---------|------------|
| Functional | 12 | 12 | 100% |
| Non-Functional | 7 | 7 | 100% |
| **Overall** | **19** | **19** | **100%** |

---

## Notes
- All Critical and High priority requirements have multiple test cases (positive + negative/boundary).
- Exploratory testing (TC-EXP-001) provides additional coverage for end-to-end flows.
- This RTM will be updated after Test Execution with actual pass/fail status.

**Document Owner:** Mandlakaise Qhomane  
**Last Updated:** September 2026
