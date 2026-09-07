# Software Requirements Specification (SRS)
## OpenMRS 3 (O3) – Health Management System (Demo Instance)

**Document Version:** 1.0  
**Date:** September 2026  
**Prepared by:** Mandlakaise Qhomane – QA Lead – Manual Test Portfolio  
**Status:** Baseline for STLC  
**Application Under Test:** OpenMRS 3 (O3)  
**Demo URL:** https://o3.openmrs.org/openmrs/spa/login  
**Credentials:** Location – Any | Username – admin | Password – Admin123  

---

## 1. Introduction

### 1.1 Purpose
This Software Requirements Specification (SRS) defines the functional and non-functional requirements of the OpenMRS 3 Electronic Medical Records (EMR) system demo instance. It serves as the baseline for designing, executing, and reporting manual test cases in an enterprise-grade QA portfolio.

### 1.2 Scope
**In Scope:**
- Authentication & Authorization
- Patient Registration & Search
- Appointment Scheduling
- Clinical Chart / Encounters (Vitals, Notes, Diagnoses)
- Service Queues & Patient Flow
- Basic Lab and Medication Orders
- User Role Permissions (as available in demo)
- UI/UX, Accessibility, Cross-browser compatibility
- Data Integrity, Negative testing, and Boundary testing

**Out of Scope:**
- Full FHIR API testing
- Offline mode / mobile app
- Custom module development
- Performance / Load testing (high-level observation only)
- Backend database verification

### 1.3 Definitions & Acronyms
| Term | Definition |
|------|------------|
| EMR  | Electronic Medical Records |
| O3   | OpenMRS 3 (next-generation frontend) |
| SPA  | Single Page Application |
| TC   | Test Case |
| RTM  | Requirements Traceability Matrix |
| PHI  | Protected Health Information (demo data is anonymized) |

---

## 2. Overall Description

### 2.1 Product Perspective
OpenMRS 3 is an open-source, modern EMR used in over 70 countries. The public demo instance provides a realistic environment for testing core clinical workflows without real patient data.

### 2.2 User Classes
| Role | Description |
|------|-------------|
| Administrator | Full access to system configuration and all clinical functions |
| Clinician / Doctor | Patient chart, encounters, orders, appointments |
| Receptionist / Clerk | Patient registration, check-in, appointments |
| Nurse | Vitals, queues, basic documentation |

---

## 3. Functional Requirements

| ID | Requirement | Priority | Description |
|----|-------------|----------|-------------|
| FR-01 | Secure Login | Critical | System shall allow authorized users to log in with valid credentials and location selection. |
| FR-02 | Invalid Login Handling | High | System shall display clear error messages and prevent access on invalid credentials. |
| FR-03 | Patient Registration | Critical | System shall allow registration of a new patient with mandatory demographic fields. |
| FR-04 | Patient Search | High | System shall allow searching patients by name, ID, or identifier with accurate results. |
| FR-05 | Appointment Scheduling | High | System shall allow creating, viewing, editing, and cancelling appointments. |
| FR-06 | Record Vitals & Biometrics | Critical | System shall allow recording of vital signs (BP, pulse, temperature, height, weight, etc.). |
| FR-07 | Clinical Encounter / Notes | High | System shall allow creation of clinical encounters, notes, and diagnoses. |
| FR-08 | Service Queues | High | System shall support patient check-in and status management in service queues. |
| FR-09 | Lab / Medication Orders | Medium | System shall allow placing basic laboratory and medication orders. |
| FR-10 | Patient Dashboard & History | High | System shall display patient overview, history, and timeline correctly. |
| FR-11 | Logout & Session Management | High | System shall allow secure logout and handle session timeout appropriately. |
| FR-12 | Role-Based Access Control | Critical | System shall restrict features based on user role/permissions. |

---

## 4. Non-Functional Requirements

| ID | Category | Requirement |
|----|----------|-------------|
| NFR-01 | Usability | Clear error messages, intuitive navigation, and consistent UI patterns. |
| NFR-02 | Security | No unauthorized access to patient data; proper session handling. |
| NFR-03 | Compatibility | Support latest versions of Chrome, Firefox, and Edge. |
| NFR-04 | Accessibility | Form fields properly labeled; basic keyboard navigation support. |
| NFR-05 | Data Integrity | No data loss on save; proper validation of mandatory fields and formats. |
| NFR-06 | Reliability | Consistent behavior across repeated actions on the demo instance. |
| NFR-07 | Performance | Acceptable response time for core actions under normal demo load. |

---

## 5. Assumptions and Constraints

**Assumptions:**
- Demo data is anonymized and may be reset periodically.
- Tester has stable internet connection.
- No real PHI is present or accessible.

**Constraints:**
- Testing limited to publicly available demo features.
- Some advanced configuration options may be restricted in the public demo.
- No ability to create new user roles beyond what the demo provides.

---

## 6. Requirements Traceability

All functional requirements listed above will be traced to one or more test cases in the Requirements Traceability Matrix (RTM).

---

**Document Control**  
Prepared for Manual Testing Portfolio – Healthcare Domain  
Next Review: After Test Execution Cycle 1
