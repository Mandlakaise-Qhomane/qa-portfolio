# Test Case Template
## OpenMRS 3 (O3) – Manual Testing Portfolio

**Use this template for every test case.**

---

### Test Case Header

| Field | Value |
|-------|-------|
| **TC ID** | TC-XXX-000 |
| **Module** | Authentication / Patient / Appointments / Clinical / Queues / Orders / Security / UI / Accessibility |
| **Title** | Short descriptive title |
| **Priority** | Critical / High / Medium / Low |
| **Type** | Positive / Negative / Boundary / Exploratory |
| **Requirements** | FR-XX, NFR-XX |
| **Preconditions** | List any setup required before starting the test |
| **Test Data** | Specific data to be used |
| **Browser / OS** | e.g. Chrome 128 / Windows 11 |

---

### Test Steps

| Step # | Action | Expected Result |
|--------|--------|-----------------|
| 1 | | |
| 2 | | |
| 3 | | |
| 4 | | |
| 5 | | |

---

### Execution Details (fill during execution)

| Field | Value |
|-------|-------|
| **Actual Result** | |
| **Status** | Pass / Fail / Blocked / Not Executed |
| **Defect ID** | (if Fail) |
| **Evidence** | Screenshot filename(s) |
| **Executed By** | |
| **Execution Date** | |
| **Comments** | |

---

### Guidelines for Writing Good Test Cases

1. One test case = one clear objective.
2. Steps must be numbered and atomic (one action per step).
3. Expected Result must be specific and measurable.
4. Include both positive and negative scenarios.
5. Use realistic test data.
6. Always link back to a requirement (FR/NFR).

---

**Example of a well-written step:**

| Step # | Action | Expected Result |
|--------|--------|-----------------|
| 1 | Navigate to https://o3.openmrs.org/openmrs/spa/login | Login page is displayed with location, username and password fields |
| 2 | Select any location from the dropdown | Location is selected |
| 3 | Enter username `admin` and password `Admin123` | Credentials are accepted in the fields |
| 4 | Click the Login button | User is successfully logged in and redirected to the home/dashboard page |
