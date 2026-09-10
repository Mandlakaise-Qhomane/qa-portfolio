# Evidence folder

Store raw client output here when you rerun the suite on your machine. Suggested files:

```
evidence/
  cycle1_TC-01.txt
  cycle1_TC-06.txt
  cycle1_TC-08.txt
  cycle1_TC-10_explain.json
  cycle2_TC-06.txt
  cycle2_TC-08.txt
```

How to capture from the CLI:

```bash
mysql -u root -p --table meridian_oms < sql/tests/TC-06_payment_cap.sql > evidence/cycle1_TC-06.txt
```

Do not commit passwords. Screenshots from DBeaver are optional; the printed `PASS`/`FAIL` row is enough for a reviewer.
