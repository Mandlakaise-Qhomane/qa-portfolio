# Installation — Meridian OMS Database QA

Use this before you run any test case. Goal: MySQL 8 running, database `meridian_oms` loaded, seed data present.

Pick **one** path. On a phone, use **GitHub Codespaces** (Option 0).

---

## Option 0 — GitHub Codespaces (phone or any browser)

No Workbench. No Windows installer. MySQL runs in the cloud.

1. Put this folder on GitHub as a repository (example: `meridian-oms-db-qa`).
2. On github.com open that repo.
3. Tap **Code** → **Codespaces** → **Create codespace on main**.
4. Wait until the container finishes. `.devcontainer/setup.sh` installs the client and loads:
   - `sql/01_schema.sql`
   - `sql/02_routines.sql`
   - `sql/03_seed.sql`
5. Open the Codespaces **Terminal** and run:

```bash
mysql -h db -uroot -proot -e "USE meridian_oms; SHOW TABLES; SELECT COUNT(*) AS customers FROM customers;"
```

Connection inside Codespaces:

- Host: `db` (not `localhost`)
- User: `root`
- Password: `root`
- Port: `3306`

Run a test case:

```bash
mysql -h db -uroot -proot --table < sql/tests/TC-01_schema_constraints.sql
```

---

## Option A — Windows 10 / 11 (MySQL Installer)

### 1. Download

1. Open [https://dev.mysql.com/downloads/installer/](https://dev.mysql.com/downloads/installer/)
2. Choose **Windows** → **MySQL Installer for Windows**.
3. The smaller web installer (`mysql-installer-web-community`) is enough if you have internet.

### 2. Install

1. Run the installer.
2. Setup type: **Custom** or **Developer Default**.
3. Select at least:
   - MySQL Server 8.0 (or 8.4 LTS)
   - MySQL Workbench (GUI — useful for evidence screenshots)
4. Continue until **Type and Networking**:
   - Config type: **Development Computer**
   - Port: **3306**
   - Open Windows Firewall port if asked
5. Authentication: **Use Strong Password Encryption** (default).
6. Set the **root password**. Write it down. You need it for every script.
7. Windows Service: leave **Start the MySQL Server at System Startup** ticked.
8. Finish. Confirm the service is running:

```text
Win + R → services.msc → MySQL80 (or MySQL84) → Status = Running
```

### 3. Check the client works

Open **Command Prompt** or **PowerShell**:

```bat
mysql --version
mysql -u root -p
```

Type the root password. You should see `mysql>`.

If `mysql` is not recognised, add it to PATH:

```text
C:\Program Files\MySQL\MySQL Server 8.0\bin
```

Then close and reopen the terminal.

---

## Option B — Docker (any OS)

```bash
docker run --name meridian-mysql -e MYSQL_ROOT_PASSWORD=ChangeMe123 -p 3306:3306 -d mysql:8.0
docker exec -it meridian-mysql mysql -u root -p
```

---

## Load this project

From the folder that contains `sql/` (the unzipped repo):

**Windows Command Prompt**

```bat
cd path\to\meridian-oms-db-qa
mysql -u root -p < sql\01_schema.sql
mysql -u root -p < sql\02_routines.sql
mysql -u root -p < sql\03_seed.sql
```

**PowerShell** (redirection works differently — use this):

```powershell
cd path\to\meridian-oms-db-qa
Get-Content sql\01_schema.sql | mysql -u root -p
Get-Content sql\02_routines.sql | mysql -u root -p
Get-Content sql\03_seed.sql | mysql -u root -p
```

Workbench alternative: File → Run SQL Script → pick each file in order `01` then `02` then `03`.

### Smoke check

```sql
USE meridian_oms;
SHOW TABLES;
SELECT COUNT(*) AS customers FROM customers;
SELECT p.sku, i.qty_on_hand, i.qty_reserved
FROM inventory i
JOIN products p ON p.product_id = i.product_id
WHERE i.warehouse_id = 1
ORDER BY p.sku;
```

Expected:

- `customers` = 3
- BFN cement `SKU-CEM-50` on hand 200, reserved 20
- BFN bricks 5000 / 0
- BFN paint 40 / 0

If that matches, installation is done. Next step is running TC-01.

---

## Common install problems

| Symptom | Fix |
|---|---|
| `mysql` is not recognized | Add MySQL `bin` folder to PATH, new terminal |
| Access denied for root | Wrong password, or you set a different user during installer |
| Port 3306 already in use | XAMPP/WAMP/MariaDB already running — stop that service or use its mysql client |
| CHECK constraint errors ignored | You are on MySQL 5.7. Install 8.0+ |
| `SOURCE 04_reset.sql` fails | Ignore that file. Reset with `03_seed.sql` only |
