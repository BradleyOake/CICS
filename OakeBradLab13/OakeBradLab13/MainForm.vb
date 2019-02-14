Imports CclEPILib

Public Class frmMainForm
    Dim EPI As CclOEPI
    Dim Terminal As CclOTerminal
    Dim Session As CclOSession
    Dim Screen As CclOScreen
    Dim map As CclOMap
    Dim Field As CclOField
  
    Private Sub btnExit_Click(sender As Object, e As EventArgs) Handles btnExit.Click
        Screen.SetAID(CclAIDKeys.cclPF4)
        Terminal.Send(Session)
        Terminal.Disconnect()
        Field = Nothing
        Screen = Nothing
        Session = Nothing
        Terminal = Nothing
        EPI = Nothing
        Close()
    End Sub

    Private Sub btnConnect_Click(sender As Object, e As EventArgs) Handles btnConnect.Click
        btnConnect.Enabled = False
        EPI = New CclOEPI
        Terminal = New CclOTerminal
        Terminal.Connect("INFINITY", "", "")
        Session = New CclOSession
        map = CreateObject("ccl.MAP")

        Terminal.Start(Session, "BO02", "")
        Screen = Terminal.Screen

        map = New CclOMap
        If (map.Validate(Screen, MAP2)) Then
            Field = map.FieldByName(MAP2_MSG)
            lblMessage.Text = Field.Text
        Else
            lblMessage.Text = "Unexpected screen data"
            Exit Sub
        End If
    End Sub

    Private Sub btnInquire_Click(sender As Object, e As EventArgs) Handles btnInquire.Click
        Field = map.FieldByName(MAP2_INVNUM)
        Field.SetText(txtInvoiceNumber.Text)
        Terminal.Start(Session, "BO02", "")
        Screen = Terminal.Screen

        map = New CclOMap
        If (map.Validate(Screen, MAP2)) Then
            Field = map.FieldByName(MAP2_MSG)
            lblMessage.Text = Field.Text
            Field = map.FieldByName(MAP2_PROD11)
            lblProduct1.Text = Field.Text
            Field = map.FieldByName(MAP2_PROD12)
            lblProduct1.Text = lblProduct1.Text & " " & Field.Text
            Field = map.FieldByName(MAP2_PROD21)
            lblProduct2.Text = Field.Text
            Field = map.FieldByName(MAP2_PROD22)
            lblProduct2.Text = lblProduct2.Text & " " & Field.Text
            Field = map.FieldByName(MAP2_PROD31)
            lblProduct3.Text = Field.Text
            Field = map.FieldByName(MAP2_PROD32)
            lblProduct3.Text = lblProduct3.Text & " " & Field.Text
            Field = map.FieldByName(MAP2_PROD41)
            lblProduct4.Text = Field.Text
            Field = map.FieldByName(MAP2_PROD42)
            lblProduct4.Text = lblProduct4.Text & " " & Field.Text
            Field = map.FieldByName(MAP2_PROD51)
            lblProduct5.Text = Field.Text
            Field = map.FieldByName(MAP2_PROD52)
            lblProduct5.Text = lblProduct5.Text & " " & Field.Text
            Field = map.FieldByName(MAP2_NAME)
            lblName.Text = Field.Text
            Field = map.FieldByName(MAP2_ADDLN1)
            lblAddress.Text = Field.Text
            Field = map.FieldByName(MAP2_ADDLN2)
            lblAddress.Text = lblAddress.Text & vbCrLf & Field.Text
            Field = map.FieldByName(MAP2_ADDLN3)
            lblAddress.Text = lblAddress.Text & vbCrLf & Field.Text
            Field = map.FieldByName(MAP2_POSTAL1)
            lblPostalCode.Text = Field.Text
            Field = map.FieldByName(MAP2_POSTAL2)
            lblPostalCode.Text = lblPostalCode.Text & " " & Field.Text

            Field = map.FieldByName(MAP2_ARCODE)
            lblPhoneNumber.Text = "(" & Field.Text & ") "
            Field = map.FieldByName(MAP2_EXCHNO)
            lblPhoneNumber.Text = lblPhoneNumber.Text & Field.Text & "-"
            Field = map.FieldByName(MAP2_PHONNUM)
            lblPhoneNumber.Text = lblPhoneNumber.Text & Field.Text
        Else
            lblMessage.Text = "Unexpected screen data"
            Exit Sub
        End If
    End Sub
End Class
