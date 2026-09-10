# Test cases (BDD)

Executable source of truth:

- `src/test/resources/features/login.feature`
- `src/test/resources/features/customer_account.feature`

Each scenario is tagged `@TC-0n` and `@GURU-xxx`. Run one story with:

```bash
mvn test -Dcucumber.filter.tags="@GURU-101"
```
