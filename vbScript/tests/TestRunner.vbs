' TestRunner.vbs
' STLC automated execution for NalediPay InvoiceEngine.
' Run: cscript //nologo tests\TestRunner.vbs
' Exit 0 = all passed, 1 = failures.

Option Explicit

Dim fso, scriptDir, srcPath, sourceText, passed, failed, total
Set fso = CreateObject("Scripting.FileSystemObject")
scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)
srcPath = fso.BuildPath(fso.GetParentFolderName(scriptDir), "src\InvoiceEngine.vbs")

If Not fso.FileExists(srcPath) Then
    WScript.Echo "FAIL  engine not found: " & srcPath
    WScript.Quit 1
End If

sourceText = fso.OpenTextFile(srcPath, 1).ReadAll
ExecuteGlobal sourceText

passed = 0
failed = 0
total = 0

Sub AssertTrue(condition, caseId, detail)
    total = total + 1
    If condition Then
        passed = passed + 1
        WScript.Echo "PASS  " & caseId & "  " & detail
    Else
        failed = failed + 1
        WScript.Echo "FAIL  " & caseId & "  " & detail
    End If
End Sub

Sub AssertEqual(expected, actual, caseId)
    total = total + 1
    If expected = actual Then
        passed = passed + 1
        WScript.Echo "PASS  " & caseId & "  expected=" & expected
    Else
        failed = failed + 1
        WScript.Echo "FAIL  " & caseId & "  expected=" & expected & " actual=" & actual
    End If
End Sub

Function RaisedCode(ByRef actionName, ByRef arg1, ByRef arg2, ByRef arg3)
    On Error Resume Next
    Err.Clear
    Select Case actionName
        Case "LineNet"
            Call LineNet(arg1, arg2)
        Case "ApplyDiscount"
            Call ApplyDiscount(arg1, arg2)
        Case "VatOn"
            Call VatOn(arg1)
        Case "BuildInvoice"
            Call BuildInvoice(arg1, arg2, arg3, 10, 0)
        Case "BuildInvoiceFull"
            ' arg1 = invoice, arg2 = email, arg3 unused; uses extra globals
            Err.Raise 1, "RaisedCode", "use BuildInvoice directly"
    End Select
    RaisedCode = Err.Number
    On Error GoTo 0
End Function

' ---------- TC-01 health / engine load ----------
AssertTrue Len(sourceText) > 0, "TC-01", "InvoiceEngine.vbs loaded"

' ---------- invoice number (REQ-02) ----------
AssertTrue IsValidInvoiceNumber("INV0001234"), "TC-02", "valid INV0001234"
AssertTrue IsValidInvoiceNumber("inv0001234"), "TC-03", "lowercase prefix accepted"
AssertTrue Not IsValidInvoiceNumber("INV123"), "TC-04", "too short rejected"
AssertTrue Not IsValidInvoiceNumber("ABC0001234"), "TC-05", "wrong prefix rejected"
AssertTrue Not IsValidInvoiceNumber("INV00AB234"), "TC-06", "non-numeric tail rejected"

' ---------- email (REQ-03) ----------
AssertTrue IsValidEmail("buyer@example.com"), "TC-07", "valid email"
AssertTrue Not IsValidEmail("buyer.example.com"), "TC-08", "missing @ rejected"
AssertTrue Not IsValidEmail("buyer@example"), "TC-09", "missing dot after @ rejected"
AssertTrue Not IsValidEmail("buyer@ example.com"), "TC-10", "space rejected"

' ---------- line net (REQ-04, REQ-05) ----------
AssertEqual 250, LineNet(5, 50), "TC-11"
AssertEqual 0.02, LineNet(2, 0.01), "TC-12"

Dim code
On Error Resume Next
Err.Clear
Call LineNet(0, 10)
code = Err.Number
On Error GoTo 0
AssertEqual 1002, code, "TC-13"

On Error Resume Next
Err.Clear
Call LineNet(1, 0)
code = Err.Number
On Error GoTo 0
AssertEqual 1003, code, "TC-14"

On Error Resume Next
Err.Clear
Call LineNet(2, 60000)
code = Err.Number
On Error GoTo 0
AssertEqual 1004, code, "TC-15"

' ---------- discount (REQ-06) ----------
AssertEqual 90, ApplyDiscount(100, 10), "TC-16"
AssertEqual 100, ApplyDiscount(100, 0), "TC-17"
AssertEqual 50, ApplyDiscount(100, 50), "TC-18"

On Error Resume Next
Err.Clear
Call ApplyDiscount(100, 51)
code = Err.Number
On Error GoTo 0
AssertEqual 1011, code, "TC-19"

On Error Resume Next
Err.Clear
Call ApplyDiscount(100, -1)
code = Err.Number
On Error GoTo 0
AssertEqual 1011, code, "TC-20"

' ---------- VAT 15% (REQ-07) ----------
AssertEqual 15, VatOn(100), "TC-21"
AssertEqual 0, VatOn(0), "TC-22"
AssertEqual 1.5, VatOn(10), "TC-23"

On Error Resume Next
Err.Clear
Call VatOn(-5)
code = Err.Number
On Error GoTo 0
AssertEqual 1021, code, "TC-24"

' ---------- gross (REQ-08) ----------
AssertEqual 115, InvoiceGross(100), "TC-25"
AssertEqual 57.5, InvoiceGross(50), "TC-26"

' ---------- build invoice (REQ-09) ----------
Dim built
built = BuildInvoice("INV0001234", "Buyer@Example.com", 2, 50, 10)
AssertTrue InStr(built, "INVNO=INV0001234") > 0, "TC-27", "invoice number echoed"
AssertTrue InStr(built, "EMAIL=buyer@example.com") > 0, "TC-28", "email normalised"
AssertTrue InStr(built, "NET=100.00") > 0, "TC-29", "net 2 x 50"
AssertTrue InStr(built, "DISC=90.00") > 0, "TC-30", "10 percent off"
AssertTrue InStr(built, "VAT=13.50") > 0, "TC-31", "VAT on discounted net"
AssertTrue InStr(built, "GROSS=103.50") > 0, "TC-32", "gross = disc + vat"

On Error Resume Next
Err.Clear
Call BuildInvoice("BAD", "buyer@example.com", 1, 10, 0)
code = Err.Number
On Error GoTo 0
AssertEqual 1030, code, "TC-33"

On Error Resume Next
Err.Clear
Call BuildInvoice("INV0001234", "not-an-email", 1, 10, 0)
code = Err.Number
On Error GoTo 0
AssertEqual 1031, code, "TC-34"

WScript.Echo ""
WScript.Echo "=============================="
WScript.Echo "Total: " & total & "  Passed: " & passed & "  Failed: " & failed
If failed = 0 Then
    WScript.Echo "SUITE RESULT: PASS"
    WScript.Quit 0
Else
    WScript.Echo "SUITE RESULT: FAIL"
    WScript.Quit 1
End If
