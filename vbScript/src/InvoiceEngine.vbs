' InvoiceEngine.vbs
' Application under test: NalediPay invoice rules (ZAR, VAT 15%).
' Loaded by the test runner via ExecuteGlobal.

Option Explicit

Public Const VAT_RATE = 0.15
Public Const MAX_LINE_AMOUNT = 100000
Public Const MIN_LINE_AMOUNT = 0.01

Function RoundMoney(ByVal value)
    RoundMoney = Round(CDbl(value) + 0.0000001, 2)
End Function

Function IsValidInvoiceNumber(ByVal invoiceNo)
    Dim patternOk
    If IsNull(invoiceNo) Then
        IsValidInvoiceNumber = False
        Exit Function
    End If
    invoiceNo = UCase(Trim(CStr(invoiceNo)))
    If Len(invoiceNo) <> 10 Then
        IsValidInvoiceNumber = False
        Exit Function
    End If
    ' Format: INV + 7 digits, e.g. INV0001234
    If Left(invoiceNo, 3) <> "INV" Then
        IsValidInvoiceNumber = False
        Exit Function
    End If
    If Not IsNumeric(Mid(invoiceNo, 4)) Then
        IsValidInvoiceNumber = False
        Exit Function
    End If
    IsValidInvoiceNumber = True
End Function

Function IsValidEmail(ByVal email)
    Dim atPos, dotPos
    email = LCase(Trim(CStr(email)))
    atPos = InStr(email, "@")
    dotPos = InStrRev(email, ".")
    If atPos <= 1 Then
        IsValidEmail = False
        Exit Function
    End If
    If dotPos <= atPos + 1 Then
        IsValidEmail = False
        Exit Function
    End If
    If dotPos = Len(email) Then
        IsValidEmail = False
        Exit Function
    End If
    If InStr(email, " ") > 0 Then
        IsValidEmail = False
        Exit Function
    End If
    IsValidEmail = True
End Function

Function LineNet(ByVal qty, ByVal unitPrice)
    If Not IsNumeric(qty) Or Not IsNumeric(unitPrice) Then
        Err.Raise 1001, "LineNet", "Quantity and unit price must be numeric"
    End If
    If CDbl(qty) <= 0 Then
        Err.Raise 1002, "LineNet", "Quantity must be greater than zero"
    End If
    If CDbl(unitPrice) < MIN_LINE_AMOUNT Then
        Err.Raise 1003, "LineNet", "Unit price must be at least 0.01"
    End If
    LineNet = RoundMoney(CDbl(qty) * CDbl(unitPrice))
    If LineNet > MAX_LINE_AMOUNT Then
        Err.Raise 1004, "LineNet", "Line amount exceeds 100000.00 cap"
    End If
End Function

Function ApplyDiscount(ByVal netAmount, ByVal percent)
    If Not IsNumeric(netAmount) Or Not IsNumeric(percent) Then
        Err.Raise 1010, "ApplyDiscount", "Amount and percent must be numeric"
    End If
    If CDbl(percent) < 0 Or CDbl(percent) > 50 Then
        Err.Raise 1011, "ApplyDiscount", "Discount percent must be between 0 and 50"
    End If
    If CDbl(netAmount) < 0 Then
        Err.Raise 1012, "ApplyDiscount", "Net amount cannot be negative"
    End If
    ApplyDiscount = RoundMoney(CDbl(netAmount) * (1 - CDbl(percent) / 100))
End Function

Function VatOn(ByVal netAmount)
    If Not IsNumeric(netAmount) Then
        Err.Raise 1020, "VatOn", "Net amount must be numeric"
    End If
    If CDbl(netAmount) < 0 Then
        Err.Raise 1021, "VatOn", "Net amount cannot be negative"
    End If
    VatOn = RoundMoney(CDbl(netAmount) * VAT_RATE)
End Function

Function InvoiceGross(ByVal netAfterDiscount)
    InvoiceGross = RoundMoney(CDbl(netAfterDiscount) + VatOn(netAfterDiscount))
End Function

Function BuildInvoice(ByVal invoiceNo, ByVal customerEmail, ByVal qty, ByVal unitPrice, ByVal discountPercent)
    Dim netValue, discounted, vatValue, grossValue
    If Not IsValidInvoiceNumber(invoiceNo) Then
        Err.Raise 1030, "BuildInvoice", "Invalid invoice number"
    End If
    If Not IsValidEmail(customerEmail) Then
        Err.Raise 1031, "BuildInvoice", "Invalid customer email"
    End If
    netValue = LineNet(qty, unitPrice)
    discounted = ApplyDiscount(netValue, discountPercent)
    vatValue = VatOn(discounted)
    grossValue = InvoiceGross(discounted)
    BuildInvoice = "INVNO=" & UCase(invoiceNo) & _
                   "|EMAIL=" & LCase(customerEmail) & _
                   "|NET=" & FormatNumber(netValue, 2, -1, 0, 0) & _
                   "|DISC=" & FormatNumber(discounted, 2, -1, 0, 0) & _
                   "|VAT=" & FormatNumber(vatValue, 2, -1, 0, 0) & _
                   "|GROSS=" & FormatNumber(grossValue, 2, -1, 0, 0)
End Function
