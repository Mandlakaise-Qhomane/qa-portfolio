# Low-storage plan (2.16 GB free on C:)

Your C: drive is 29.4 GB with **2.16 GB free**. IntelliJ + JDK + Maven cache + Jenkins will not fit safely.

## Do this first on Windows (free 4–8 GB if possible)

1. Settings → System → Storage → Temporary files → remove Recycle Bin, Delivery Optimization, Thumbnails.
2. Run Disk Cleanup on C: (including "Clean up system files").
3. Uninstall unused apps (old games, extra browsers, unused Office).
4. Empty Downloads. Move videos/photos to Google Drive / phone / external USB.
5. Disable Hibernate if you do not use it: `powercfg -h off` in Admin CMD (can free several GB).
6. Move the Windows pagefile only if you know what you are doing — skip if unsure.

**Target:** at least 8 GB free before installing any Java tooling.

## What NOT to install locally

| Skip | Typical size | Replacement |
|------|--------------|-------------|
| IntelliJ IDEA | 1–2 GB + caches | VS Code Java pack (~300 MB) or Codespaces |
| Jenkins LTS | 200 MB + builds | GitHub Actions (already in this repo) |
| Android Studio / unused IDEs | multi-GB | uninstall |
| Local ChromeDriver zip | extra copies | WebDriverManager downloads once |

## Recommended path A — GitHub only (almost zero disk)

1. Download this starter zip.
2. Create empty repo on GitHub: `selenium-java-bank-framework`.
3. Upload the unzipped folder (or use GitHub web “uploading files”).
4. Enable Actions. CI runs in the cloud. Your PC stays empty.

## Recommended path B — GitHub Codespaces (browser IDE, 60–120 hrs/month free on many accounts)

1. Push the repo.
2. Code → Codespaces → Create codespace on main.
3. Terminal: `mvn test`.
4. No JDK/IntelliJ on C:.

## Recommended path C — Light local (if you free ≥8 GB)

Install **only**:
- Eclipse Temurin JDK 17 (~300 MB) from adoptium.net
- VS Code + Extension Pack for Java (not IntelliJ)
- Use the Maven wrapper later if needed; Chrome you already have

Then:

```
cd selenium-java-bank-framework
mvn -q test
```

Set `headless=true` in `config.properties` if you want less UI overhead.

## Build order that matches the blueprint but saves disk

| Day | Do | Avoid |
|-----|----|--------|
| 1 | Polish docs already in `/docs` | Installing IDEs |
| 2 | Push repo + enable Actions | Jenkins WAR |
| 3 | Finish Login tests on Codespaces/VS Code | Saving screenshots into git |
| 4–7 | Customer → Account → Transactions | Copying `target/` around |
| 8 | Paste Extent summary into `docs/05_execution_report.md` | |
| 9–10 | README screenshots (one PNG only) | Local Jenkins job |

## After every Maven run

```
rmdir /s /q target
rmdir /s /q test-output
rmdir /s /q screenshots
```

Keep one Extent HTML if you need it for the portfolio README.
