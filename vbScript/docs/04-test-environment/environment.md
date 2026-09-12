# Test Environment

## Local Windows

```bat
cscript
cd path\to\vbscript-stlc-qa
cscript //nologo tests\TestRunner.vbs
```

`cscript.exe` ships with Windows. No Python, Node, or extra runtime.

## CI

`.github/workflows/qa.yml` runs the same command on `windows-latest`.

## Isolation

Each run `ExecuteGlobal`s a fresh copy of `InvoiceEngine.vbs`. The engine is stateless; no files are written.

## Readiness

- [x] `InvoiceEngine.vbs` present under `src\`
- [x] Runner path uses `WScript.ScriptFullName` so it works from any cwd
- [x] Failures return exit code 1 for CI
