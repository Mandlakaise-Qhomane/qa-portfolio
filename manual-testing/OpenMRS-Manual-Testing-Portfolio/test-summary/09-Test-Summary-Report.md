# Test Summary Report
## OpenMRS 3 (O3) – Health Management System  
### Manual Testing Portfolio – Cycle 1

**Document Version:** 1.0  
**Date:** September 2026  
**Prepared by:** Mandlakaise Qhomane  

---

## 1. Project Overview

| Item                        | Details                                      |
|-----------------------------|----------------------------------------------|
| Application Under Test      | OpenMRS 3 (O3) – Electronic Medical Records  |
| Demo URL                    | https://o3.openmrs.org/openmrs/spa/login     |
| Testing Type                | Manual Functional + Negative + Security      |
| Test Cycle                  | Cycle 1                                      |
| Total Test Cases            | 10                                           |
| Execution Status            | Completed                                    |

---

## 2. Test Objectives

- Validate critical clinical and administrative workflows
- Verify authentication and session security
- Confirm data validation and error handling
- Demonstrate end-to-end patient journey coverage
- Produce professional, evidence-based test artifacts for portfolio

---

## 3. Scope Covered

**In Scope (Executed):**
- Authentication (Valid & Invalid login)
- Patient Registration & Search
- Appointment Scheduling
- Vitals & Biometrics recording
- Clinical Notes / Encounters
- Service Queue / Check-in
- Session Security after Logout

**Out of Scope:**
- API / FHIR testing
- Performance testing
- Mobile responsiveness deep testing
- Advanced reporting modules

---

## 4. Execution Results

| Status         | Count | Percentage |
|----------------|-------|------------|
| Passed         | 10    | 100%       |
| Failed         | 0     | 0%         |
| Blocked        | 0     | 0%         |
| Not Executed   | 0     | 0%         |
| **Total**      | **10**| **100%**   |

**Pass Rate: 100%**

---

## 5. Defect Summary

| Severity   | Count |
|------------|-------|
| Critical   | 0     |
| High       | 0     |
| Medium     | 0     |
| Low        | 0     |
| **Total**  | **0** |

No defects were identified during this test cycle.

---

## 6. Requirements Coverage

All selected high-priority and critical requirements from the SRS were covered by the 10 executed test cases (see RTM for full mapping).

- Critical Requirements: Fully covered and Passed
- High Priority Requirements: Fully covered and Passed

---

## 7. Key Observations

- The OpenMRS 3 demo environment was stable throughout execution.
- Core clinical workflows (Registration → Search → Appointment → Vitals → Note → Check-in) worked as expected.
- Validation messages for mandatory fields were clear and effective.
- Session management after logout behaved securely.
- Overall user experience was consistent and professional.

---

## 8. Risks & Limitations

- Public demo data may reset at any time.
- Some advanced features or role-based variations are limited in the public demo.
- Testing was performed primarily on Google Chrome.

---

## 9. Conclusion & Recommendation

The OpenMRS 3 application successfully passed all 10 planned test cases in Cycle 1 with a **100% pass rate** and **zero defects**.

The system demonstrated reliable behavior across authentication, patient management, clinical documentation, appointments, queues, and session security.

**Recommendation:** The application is stable for the tested scope. Future cycles can expand coverage to additional modules, cross-browser testing, and exploratory edge cases.

---

## 10. Deliverables Produced

- Software Requirements Specification (SRS)
- Test Plan
- Requirements Traceability Matrix (RTM)
- Master Test Cases (10)
- Test Data Document
- Test Execution Report – Cycle 1
- Defect Log
- Test Summary Report (this document)
- Screenshots (organized by test case)

---

## 11. Sign-off

| Role              | Name               | Date           |
|-------------------|--------------------|----------------|
| Prepared by       | Mandlakaise Qhomane | September 2026 |
| Reviewed by       | Self-review        | September 2026 |

---

**End of Test Summary Report**
