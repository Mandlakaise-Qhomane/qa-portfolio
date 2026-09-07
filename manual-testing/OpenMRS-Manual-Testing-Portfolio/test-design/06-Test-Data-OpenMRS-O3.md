# Test Data
## OpenMRS 3 (O3) – Manual Testing Portfolio

**Document Version:** 1.0  
**Purpose:** Provide consistent, realistic test data for repeatable execution of test cases.

**Important Notes:**
- Demo data may be reset periodically. Always verify existing patients before using them.
- Prefer creating new patients during execution so results are clean.
- Do not use real personal data.

---

## 1. Login Credentials

| Role | Username | Password | Location | Notes |
|------|----------|----------|----------|-------|
| Administrator | admin | Admin123 | Any | Primary test account |

---

## 2. Patient Registration Data

### Patient Set 1 – Happy Path (Primary)
| Field | Value |
|-------|-------|
| Given Name | Thabo |
| Family Name | Molefe |
| Gender | Male |
| Date of Birth | 15-Mar-1985 |
| Age (calculated) | ~41 years |
| Identifier (if required) | Leave default or system generated |
| Address (if available) | 45 Mandela Street, Johannesburg |
| Phone (if available) | 0821234567 |

### Patient Set 2 – Alternative
| Field | Value |
|-------|-------|
| Given Name | Naledi |
| Family Name | Dlamini |
| Gender | Female |
| Date of Birth | 22-Jul-1992 |
| Notes | Use for second registration or search tests |

### Patient Set 3 – Boundary / Negative
| Field | Value | Purpose |
|-------|-------|---------|
| Given Name | | Empty – mandatory field test |
| Family Name | Test | |
| Date of Birth | 01-Jan-2030 | Future date – boundary test |
| Date of Birth | 01-Jan-1850 | Very old date – boundary test |

---

## 3. Vitals & Biometrics Data

### Vitals Set 1 – Normal Values
| Vital | Value | Unit |
|-------|-------|------|
| Systolic BP | 120 | mmHg |
| Diastolic BP | 80 | mmHg |
| Pulse | 72 | beats/min |
| Temperature | 36.6 | °C |
| Height | 175 | cm |
| Weight | 78 | kg |
| Respiratory Rate | 16 | breaths/min |
| Oxygen Saturation | 98 | % |

### Vitals Set 2 – Abnormal / Boundary
| Vital | Value | Purpose |
|-------|-------|---------|
| Systolic BP | 210 | High – boundary |
| Diastolic BP | 130 | High – boundary |
| Temperature | 39.8 | Fever |
| Temperature | 34.5 | Low |
| Pulse | 45 | Bradycardia |
| Pulse | 130 | Tachycardia |

---

## 4. Appointment Data

### Appointment Set 1
| Field | Value |
|-------|-------|
| Service / Type | General Consultation (or available option) |
| Date | Tomorrow’s date or next available |
| Time | 10:00 |
| Provider | Any available (if selectable) |
| Notes | Portfolio test appointment – TC-APT-001 |

### Appointment Set 2 – Edit / Cancel
| Field | Value |
|-------|-------|
| Use existing appointment created in TC-APT-001 | Change time to 11:30 or cancel |

---

## 5. Clinical Notes / Encounter Data

| Field | Sample Value |
|-------|--------------|
| Chief Complaint | Headache and mild fever for 2 days |
| History of Present Illness | Patient reports intermittent headache since yesterday. No vomiting. |
| Diagnosis (if selectable) | Tension headache or available coded diagnosis |
| Plan | Rest, hydration, paracetamol if needed |

---

## 6. Orders Data

### Lab Order
| Field | Value |
|-------|-------|
| Test | Full Blood Count / available lab test |
| Urgency | Routine |
| Notes | Portfolio test lab order |

### Medication Order
| Field | Value |
|-------|-------|
| Drug | Paracetamol (or available medication) |
| Dose | 500 mg |
| Frequency | Three times a day |
| Duration | 3 days |
| Route | Oral |

---

## 7. Search Data

| Search Type | Value | Expected |
|-------------|-------|----------|
| Full Name | Thabo Molefe | Exact match |
| Partial Name | Tha | Relevant results |
| Partial Name | Mole | Relevant results |
| Invalid | Xyzabc123 | No results / empty state |

---

## 8. Browser Matrix (for TC-UI-002)

| Browser | Version | OS | Status |
|---------|---------|----|--------|
| Google Chrome | Latest | Windows 11 / macOS | To be tested |
| Mozilla Firefox | Latest | Windows 11 / macOS | To be tested |
| Microsoft Edge | Latest | Windows 11 | To be tested |

---

## Guidelines for Using Test Data

1. Always prefer creating **new patients** rather than modifying existing demo patients when possible.
2. Record the exact Patient ID generated during registration — you will need it for later test cases.
3. If the demo resets, recreate the primary patient (Patient Set 1) before continuing.
4. Keep a small execution log of the actual Patient IDs and Appointment IDs created during your test cycle.

**Document Owner:** Mandlakaise Qhomane  
**Last Updated:** September 2026
