# Test cases

Source of truth is Gherkin:

- `src/test/resources/features/auth.feature` (TC-01 … TC-05)
- `src/test/resources/features/jobs.feature` (TC-06 … TC-11)
- `src/test/resources/features/ops.feature` (TC-12 … TC-15)

Run one story: `mvn test -Dcucumber.filter.tags="@APP-102"`
