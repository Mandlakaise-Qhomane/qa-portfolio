# Test Execution Report – Cycle 1
## OpenMRS 3 (O3) – Health Management System

**Document Version:** 1.0  
**Execution Period:** September 2026  
**Executed By:** Mandlakaise Qhomane  
**Environment:** OpenMRS 3 Public Demo (https://o3.openmrs.org)  
**Browser:** Google Chrome (Primary)  

---

## 1. Execution Summary

| Metric                        | Value      |
|-------------------------------|------------|
| Total Test Cases              | 10         |
| Test Cases Executed           | 10         |
| Passed                        | 10         |
| Failed                        | 0          |
| Blocked                       | 0          |
| Not Executed                  | 0          |
| **Pass Percentage**           | **100%**   |
| Defects Found                 | 0          |

---

## 2. Detailed Execution Results

| TC ID          | Title                                      | Priority  | Status   | Evidence (Screenshots)                                      | Comments |
|----------------|--------------------------------------------|-----------|----------|-------------------------------------------------------------|----------|
| TC-AUTH-001    | Valid Login (Admin)                        | Critical  | Passed   | TC-AUTH-001_Before_Login_Form.png<br>TC-AUTH-001_After_Login_Success.png | Successful login to dashboard |
| TC-AUTH-002    | Invalid Login (Wrong Password)             | High      | Passed   | TC-AUTH-002_Before_Invalid_Login.png<br>TC-AUTH-002_After_Error_Message.png | Correct error message displayed |
| TC-PAT-001     | Register New Patient (Happy Path)          | Critical  | Passed   | TC-PAT-001_Before_Registration_Form.png<br>TC-PAT-001_After_Patient_Created.png | Patient "Thabo Molefe" created successfully |
| TC-PAT-002     | Search Existing Patient by Name            | High      | Passed   | TC-PAT-002_Before_Search.png<br>TC-PAT-002_After_Search_Result.png | Patient found and chart opened |
| TC-PAT-003     | Register Patient – Missing Mandatory Fields| High      | Passed   | TC-PAT-003_Before_Missing_Fields.png<br>TC-PAT-003_After_Validation_Error.png | Validation errors shown correctly |
| TC-APT-001     | Schedule New Appointment                   | High      | Passed   | TC-APT-001_Before_Appointment_Form.png<br>TC-APT-001_After_Appointment_Created.png | Appointment created successfully |
| TC-CLI-001     | Record Vitals & Biometrics                 | Critical  | Passed   | TC-CLI-001_Before_Vitals_Form.png<br>TC-CLI-001_After_Vitals_Saved.png | Vitals saved and visible in chart |
| TC-CLI-002     | Create Clinical Encounter / Note           | High      | Passed   | TC-CLI-002_Before_Clinical_Note.png<br>TC-CLI-002_After_Note_Saved.png | Clinical note saved successfully |
| TC-QUE-001     | Check-in Patient to Service Queue          | High      | Passed   | TC-QUE-001_Before_CheckIn.png<br>TC-QUE-001_After_CheckIn_Success.png | Patient checked in / added to queue |
| TC-SEC-001     | Unauthorized Access After Logout           | Critical  | Passed   | TC-SEC-001_Before_Logout.png<br>TC-SEC-001_After_Unauthorized_Access.png | Session terminated correctly; access denied |

---

## 3. Environment Details

- **Application:** OpenMRS 3 (O3) Public Demo
- **URL:** https://o3.openmrs.org/openmrs/spa/login
- **Credentials used:** admin / Admin123
- **Primary Browser:** Google Chrome
- **Operating System:** (to be filled by tester)
- **Screenshot Tool:** (ShareX / Greenshot / Snipping Tool)

---

## 4. Notes & Observations

- All critical and high priority workflows executed successfully.
- No defects were identified during this cycle.
- Demo environment was stable throughout execution.
- Patient “Thabo Molefe” was used as the primary test patient across multiple test cases.

---

## 5. Sign-off

| Role                | Name                  | Date          | Signature |
|---------------------|-----------------------|---------------|-----------|
| Executed By         | Mandlakaise Qhomane   | September 2026|           |
| Reviewed By         | Self-review           | September 2026|           |

---

**End of Test Execution Report – Cycle 1**
