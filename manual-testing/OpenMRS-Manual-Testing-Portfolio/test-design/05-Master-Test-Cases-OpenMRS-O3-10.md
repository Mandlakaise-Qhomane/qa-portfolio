# Master Test Cases (Selected 10)
## OpenMRS 3 (O3) – Health Management System

**Document Version:** 1.1  
**Total Test Cases:** 10 (Focused set for strong portfolio coverage)  
**Linked Documents:** SRS, Test Plan, RTM  

**Demo URL:** https://o3.openmrs.org/openmrs/spa/login  
**Credentials:** Location – Any | Username – admin | Password – Admin123  

---

### TC-AUTH-001 – Valid Login (Admin)
| Field | Details |
|-------|---------|
| **Priority** | Critical |
| **Type** | Positive |
| **Requirements** | FR-01 |
| **Preconditions** | Demo site is accessible |
| **Test Data** | Username: `admin`, Password: `Admin123`, Location: Any |

**Test Steps:**
1. Navigate to https://o3.openmrs.org/openmrs/spa/login
2. Select any location from the dropdown
3. Enter username `admin`
4. Enter password `Admin123`
5. Click the Login button

**Expected Result:** User is successfully logged in and redirected to the home/dashboard page. Patient search and clinical features are visible.

---

### TC-AUTH-002 – Invalid Login (Wrong Password)
| Field | Details |
|-------|---------|
| **Priority** | High |
| **Type** | Negative |
| **Requirements** | FR-02, NFR-01 |

**Test Steps:**
1. Navigate to the login page
2. Select any location
3. Enter username `admin`
4. Enter incorrect password (e.g. `WrongPass123`)
5. Click Login

**Expected Result:** Clear error message is displayed. User remains on the login page. No access is granted.

---

### TC-PAT-001 – Register New Patient (Happy Path)
| Field | Details |
|-------|---------|
| **Priority** | Critical |
| **Type** | Positive |
| **Requirements** | FR-03 |
| **Test Data** | Given Name: Thabo, Family Name: Molefe, Gender: Male, DOB: 15-Mar-1985 |

**Test Steps:**
1. Login as admin
2. Click “Add Patient” or equivalent
3. Fill all mandatory fields (Given Name, Family Name, Gender, Date of Birth)
4. Click Save / Confirm

**Expected Result:** Patient is successfully created. A unique Patient ID is generated. Patient appears in search results.

---

### TC-PAT-002 – Search Existing Patient by Name
| Field | Details |
|-------|---------|
| **Priority** | High |
| **Type** | Positive |
| **Requirements** | FR-04 |

**Test Steps:**
1. From the home page, enter a known patient name in the search field
2. Press Enter or click Search
3. Click on the matching patient result

**Expected Result:** Matching patient(s) are displayed accurately. Clicking a result opens the patient chart.

---

### TC-PAT-003 – Register Patient with Missing Mandatory Fields
| Field | Details |
|-------|---------|
| **Priority** | High |
| **Type** | Negative |
| **Requirements** | FR-03, NFR-05 |

**Test Steps:**
1. Open Add Patient form
2. Leave one or more mandatory fields (e.g. Name or Gender) empty
3. Attempt to save

**Expected Result:** Clear validation errors are shown. Patient is not created.

---

### TC-APT-001 – Schedule New Appointment
| Field | Details |
|-------|---------|
| **Priority** | High |
| **Type** | Positive |
| **Requirements** | FR-05 |

**Test Steps:**
1. Open a patient chart
2. Navigate to Appointments section
3. Click Create / Schedule Appointment
4. Select service, date and time
5. Confirm / Save

**Expected Result:** Appointment is created successfully and appears in the patient’s appointment list.

---

### TC-CLI-001 – Record Vitals & Biometrics
| Field | Details |
|-------|---------|
| **Priority** | Critical |
| **Type** | Positive |
| **Requirements** | FR-06 |
| **Test Data** | BP: 120/80, Pulse: 72, Temp: 36.6°C, Height: 175 cm, Weight: 78 kg |

**Test Steps:**
1. Open patient chart
2. Navigate to Vitals / Biometrics form
3. Enter Blood Pressure, Pulse, Temperature, Height, Weight
4. Save

**Expected Result:** Vitals are saved successfully. Values appear in the patient timeline / history.

---

### TC-CLI-002 – Create Clinical Encounter / Note
| Field | Details |
|-------|---------|
| **Priority** | High |
| **Type** | Positive |
| **Requirements** | FR-07 |

**Test Steps:**
1. Open patient chart
2. Start a new Visit / Encounter if required
3. Add a clinical note
4. Save the encounter

**Expected Result:** Encounter and note are saved and visible in the patient history.

---

### TC-QUE-001 – Check-in Patient to Service Queue
| Field | Details |
|-------|---------|
| **Priority** | High |
| **Type** | Positive |
| **Requirements** | FR-08 |

**Test Steps:**
1. Locate a patient
2. Perform Check-in or add to a service queue
3. Observe the queue status

**Expected Result:** Patient appears in the selected queue with the correct status.

---

### TC-SEC-001 – Unauthorized Access After Logout
| Field | Details |
|-------|---------|
| **Priority** | Critical |
| **Type** | Negative / Security |
| **Requirements** | FR-11, FR-12, NFR-02 |

**Test Steps:**
1. Login successfully
2. Open any patient chart
3. Logout
4. Attempt to go back using the browser back button or re-open the previous patient URL

**Expected Result:** Access is denied. User is redirected to the login page. Session is properly terminated.

---

**Coverage Summary (10 Test Cases)**

| Area | Test Cases | Priority Focus |
|------|------------|----------------|
| Authentication | TC-AUTH-001, TC-AUTH-002 | Critical + Negative |
| Patient Management | TC-PAT-001, TC-PAT-002, TC-PAT-003 | Critical + Search + Validation |
| Appointments | TC-APT-001 | High |
| Clinical | TC-CLI-001, TC-CLI-002 | Critical + High |
| Queues | TC-QUE-001 | High |
| Security | TC-SEC-001 | Critical |

These 10 test cases provide strong, balanced coverage of the most important workflows while remaining manageable for a high-quality portfolio.
