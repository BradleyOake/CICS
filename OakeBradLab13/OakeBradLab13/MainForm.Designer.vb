<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmMainForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.btnConnect = New System.Windows.Forms.Button()
        Me.btnExit = New System.Windows.Forms.Button()
        Me.txtInvoiceNumber = New System.Windows.Forms.TextBox()
        Me.lblInvoiceNumber = New System.Windows.Forms.Label()
        Me.btnInquire = New System.Windows.Forms.Button()
        Me.lblNameHeader = New System.Windows.Forms.Label()
        Me.lblProduct1Header = New System.Windows.Forms.Label()
        Me.lblProduct5Header = New System.Windows.Forms.Label()
        Me.lblProduct2Header = New System.Windows.Forms.Label()
        Me.lblProduct3Header = New System.Windows.Forms.Label()
        Me.lblProduct4Header = New System.Windows.Forms.Label()
        Me.lblAddressHeader = New System.Windows.Forms.Label()
        Me.lblPostalCodeHeader = New System.Windows.Forms.Label()
        Me.lblPhoneNumberHeader = New System.Windows.Forms.Label()
        Me.lblProduct1 = New System.Windows.Forms.Label()
        Me.lblProduct2 = New System.Windows.Forms.Label()
        Me.lblProduct3 = New System.Windows.Forms.Label()
        Me.lblProduct4 = New System.Windows.Forms.Label()
        Me.lblProduct5 = New System.Windows.Forms.Label()
        Me.lblName = New System.Windows.Forms.Label()
        Me.lblAddress = New System.Windows.Forms.Label()
        Me.lblPostalCode = New System.Windows.Forms.Label()
        Me.lblPhoneNumber = New System.Windows.Forms.Label()
        Me.lblMessageHeader = New System.Windows.Forms.Label()
        Me.lblMessage = New System.Windows.Forms.Label()
        Me.SuspendLayout()
        '
        'btnConnect
        '
        Me.btnConnect.Location = New System.Drawing.Point(15, 73)
        Me.btnConnect.Name = "btnConnect"
        Me.btnConnect.Size = New System.Drawing.Size(75, 23)
        Me.btnConnect.TabIndex = 2
        Me.btnConnect.Text = "&Connect"
        Me.btnConnect.UseVisualStyleBackColor = True
        '
        'btnExit
        '
        Me.btnExit.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnExit.Location = New System.Drawing.Point(177, 73)
        Me.btnExit.Name = "btnExit"
        Me.btnExit.Size = New System.Drawing.Size(75, 23)
        Me.btnExit.TabIndex = 4
        Me.btnExit.Text = "E&xit"
        Me.btnExit.UseVisualStyleBackColor = True
        '
        'txtInvoiceNumber
        '
        Me.txtInvoiceNumber.Location = New System.Drawing.Point(128, 30)
        Me.txtInvoiceNumber.Name = "txtInvoiceNumber"
        Me.txtInvoiceNumber.Size = New System.Drawing.Size(100, 20)
        Me.txtInvoiceNumber.TabIndex = 1
        '
        'lblInvoiceNumber
        '
        Me.lblInvoiceNumber.AutoSize = True
        Me.lblInvoiceNumber.Location = New System.Drawing.Point(34, 33)
        Me.lblInvoiceNumber.Name = "lblInvoiceNumber"
        Me.lblInvoiceNumber.Size = New System.Drawing.Size(88, 13)
        Me.lblInvoiceNumber.TabIndex = 0
        Me.lblInvoiceNumber.Text = "Invoice Number: "
        '
        'btnInquire
        '
        Me.btnInquire.Location = New System.Drawing.Point(96, 73)
        Me.btnInquire.Name = "btnInquire"
        Me.btnInquire.Size = New System.Drawing.Size(75, 23)
        Me.btnInquire.TabIndex = 3
        Me.btnInquire.Text = "&Inquire"
        Me.btnInquire.UseVisualStyleBackColor = True
        '
        'lblNameHeader
        '
        Me.lblNameHeader.AutoSize = True
        Me.lblNameHeader.Location = New System.Drawing.Point(12, 260)
        Me.lblNameHeader.Name = "lblNameHeader"
        Me.lblNameHeader.Size = New System.Drawing.Size(41, 13)
        Me.lblNameHeader.TabIndex = 15
        Me.lblNameHeader.Text = "Name: "
        '
        'lblProduct1Header
        '
        Me.lblProduct1Header.AutoSize = True
        Me.lblProduct1Header.Location = New System.Drawing.Point(12, 117)
        Me.lblProduct1Header.Name = "lblProduct1Header"
        Me.lblProduct1Header.Size = New System.Drawing.Size(56, 13)
        Me.lblProduct1Header.TabIndex = 5
        Me.lblProduct1Header.Text = "Product 1:"
        '
        'lblProduct5Header
        '
        Me.lblProduct5Header.AutoSize = True
        Me.lblProduct5Header.Location = New System.Drawing.Point(12, 233)
        Me.lblProduct5Header.Name = "lblProduct5Header"
        Me.lblProduct5Header.Size = New System.Drawing.Size(56, 13)
        Me.lblProduct5Header.TabIndex = 13
        Me.lblProduct5Header.Text = "Product 5:"
        '
        'lblProduct2Header
        '
        Me.lblProduct2Header.AutoSize = True
        Me.lblProduct2Header.Location = New System.Drawing.Point(12, 146)
        Me.lblProduct2Header.Name = "lblProduct2Header"
        Me.lblProduct2Header.Size = New System.Drawing.Size(56, 13)
        Me.lblProduct2Header.TabIndex = 7
        Me.lblProduct2Header.Text = "Product 2:"
        '
        'lblProduct3Header
        '
        Me.lblProduct3Header.AutoSize = True
        Me.lblProduct3Header.Location = New System.Drawing.Point(12, 175)
        Me.lblProduct3Header.Name = "lblProduct3Header"
        Me.lblProduct3Header.Size = New System.Drawing.Size(56, 13)
        Me.lblProduct3Header.TabIndex = 9
        Me.lblProduct3Header.Text = "Product 3:"
        '
        'lblProduct4Header
        '
        Me.lblProduct4Header.AutoSize = True
        Me.lblProduct4Header.Location = New System.Drawing.Point(12, 204)
        Me.lblProduct4Header.Name = "lblProduct4Header"
        Me.lblProduct4Header.Size = New System.Drawing.Size(56, 13)
        Me.lblProduct4Header.TabIndex = 11
        Me.lblProduct4Header.Text = "Product 4:"
        '
        'lblAddressHeader
        '
        Me.lblAddressHeader.AutoSize = True
        Me.lblAddressHeader.Location = New System.Drawing.Point(12, 291)
        Me.lblAddressHeader.Name = "lblAddressHeader"
        Me.lblAddressHeader.Size = New System.Drawing.Size(48, 13)
        Me.lblAddressHeader.TabIndex = 17
        Me.lblAddressHeader.Text = "Address:"
        '
        'lblPostalCodeHeader
        '
        Me.lblPostalCodeHeader.AutoSize = True
        Me.lblPostalCodeHeader.Location = New System.Drawing.Point(9, 363)
        Me.lblPostalCodeHeader.Name = "lblPostalCodeHeader"
        Me.lblPostalCodeHeader.Size = New System.Drawing.Size(67, 13)
        Me.lblPostalCodeHeader.TabIndex = 19
        Me.lblPostalCodeHeader.Text = "Postal Code:"
        '
        'lblPhoneNumberHeader
        '
        Me.lblPhoneNumberHeader.AutoSize = True
        Me.lblPhoneNumberHeader.Location = New System.Drawing.Point(6, 415)
        Me.lblPhoneNumberHeader.Name = "lblPhoneNumberHeader"
        Me.lblPhoneNumberHeader.Size = New System.Drawing.Size(81, 13)
        Me.lblPhoneNumberHeader.TabIndex = 21
        Me.lblPhoneNumberHeader.Text = "Phone Number:"
        '
        'lblProduct1
        '
        Me.lblProduct1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblProduct1.Location = New System.Drawing.Point(96, 116)
        Me.lblProduct1.Name = "lblProduct1"
        Me.lblProduct1.Size = New System.Drawing.Size(100, 18)
        Me.lblProduct1.TabIndex = 6
        '
        'lblProduct2
        '
        Me.lblProduct2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblProduct2.Location = New System.Drawing.Point(96, 141)
        Me.lblProduct2.Name = "lblProduct2"
        Me.lblProduct2.Size = New System.Drawing.Size(100, 18)
        Me.lblProduct2.TabIndex = 8
        '
        'lblProduct3
        '
        Me.lblProduct3.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblProduct3.Location = New System.Drawing.Point(96, 170)
        Me.lblProduct3.Name = "lblProduct3"
        Me.lblProduct3.Size = New System.Drawing.Size(100, 18)
        Me.lblProduct3.TabIndex = 10
        '
        'lblProduct4
        '
        Me.lblProduct4.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblProduct4.Location = New System.Drawing.Point(96, 199)
        Me.lblProduct4.Name = "lblProduct4"
        Me.lblProduct4.Size = New System.Drawing.Size(100, 18)
        Me.lblProduct4.TabIndex = 12
        '
        'lblProduct5
        '
        Me.lblProduct5.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblProduct5.Location = New System.Drawing.Point(96, 228)
        Me.lblProduct5.Name = "lblProduct5"
        Me.lblProduct5.Size = New System.Drawing.Size(100, 18)
        Me.lblProduct5.TabIndex = 14
        '
        'lblName
        '
        Me.lblName.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblName.Location = New System.Drawing.Point(96, 260)
        Me.lblName.Name = "lblName"
        Me.lblName.Size = New System.Drawing.Size(100, 18)
        Me.lblName.TabIndex = 16
        '
        'lblAddress
        '
        Me.lblAddress.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblAddress.Location = New System.Drawing.Point(96, 290)
        Me.lblAddress.Name = "lblAddress"
        Me.lblAddress.Size = New System.Drawing.Size(100, 45)
        Me.lblAddress.TabIndex = 18
        '
        'lblPostalCode
        '
        Me.lblPostalCode.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblPostalCode.Location = New System.Drawing.Point(96, 358)
        Me.lblPostalCode.Name = "lblPostalCode"
        Me.lblPostalCode.Size = New System.Drawing.Size(100, 18)
        Me.lblPostalCode.TabIndex = 20
        '
        'lblPhoneNumber
        '
        Me.lblPhoneNumber.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblPhoneNumber.Location = New System.Drawing.Point(96, 410)
        Me.lblPhoneNumber.Name = "lblPhoneNumber"
        Me.lblPhoneNumber.Size = New System.Drawing.Size(100, 18)
        Me.lblPhoneNumber.TabIndex = 22
        '
        'lblMessageHeader
        '
        Me.lblMessageHeader.AutoSize = True
        Me.lblMessageHeader.Location = New System.Drawing.Point(9, 469)
        Me.lblMessageHeader.Name = "lblMessageHeader"
        Me.lblMessageHeader.Size = New System.Drawing.Size(53, 13)
        Me.lblMessageHeader.TabIndex = 23
        Me.lblMessageHeader.Text = "Message:"
        '
        'lblMessage
        '
        Me.lblMessage.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblMessage.Location = New System.Drawing.Point(68, 469)
        Me.lblMessage.Name = "lblMessage"
        Me.lblMessage.Size = New System.Drawing.Size(200, 18)
        Me.lblMessage.TabIndex = 24
        '
        'frmMainForm
        '
        Me.AcceptButton = Me.btnInquire
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.btnExit
        Me.ClientSize = New System.Drawing.Size(284, 494)
        Me.Controls.Add(Me.lblMessage)
        Me.Controls.Add(Me.lblMessageHeader)
        Me.Controls.Add(Me.lblPhoneNumber)
        Me.Controls.Add(Me.lblPostalCode)
        Me.Controls.Add(Me.lblAddress)
        Me.Controls.Add(Me.lblName)
        Me.Controls.Add(Me.lblProduct5)
        Me.Controls.Add(Me.lblProduct4)
        Me.Controls.Add(Me.lblProduct3)
        Me.Controls.Add(Me.lblProduct2)
        Me.Controls.Add(Me.lblProduct1)
        Me.Controls.Add(Me.lblPhoneNumberHeader)
        Me.Controls.Add(Me.lblPostalCodeHeader)
        Me.Controls.Add(Me.lblAddressHeader)
        Me.Controls.Add(Me.lblProduct4Header)
        Me.Controls.Add(Me.lblProduct3Header)
        Me.Controls.Add(Me.lblProduct2Header)
        Me.Controls.Add(Me.lblProduct5Header)
        Me.Controls.Add(Me.lblProduct1Header)
        Me.Controls.Add(Me.lblNameHeader)
        Me.Controls.Add(Me.btnInquire)
        Me.Controls.Add(Me.lblInvoiceNumber)
        Me.Controls.Add(Me.txtInvoiceNumber)
        Me.Controls.Add(Me.btnExit)
        Me.Controls.Add(Me.btnConnect)
        Me.MaximizeBox = False
        Me.Name = "frmMainForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Brad Oake's Lab 13"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents btnConnect As System.Windows.Forms.Button
    Friend WithEvents btnExit As System.Windows.Forms.Button
    Friend WithEvents txtInvoiceNumber As System.Windows.Forms.TextBox
    Friend WithEvents lblInvoiceNumber As System.Windows.Forms.Label
    Friend WithEvents btnInquire As System.Windows.Forms.Button
    Friend WithEvents lblNameHeader As System.Windows.Forms.Label
    Friend WithEvents lblProduct1Header As System.Windows.Forms.Label
    Friend WithEvents lblProduct5Header As System.Windows.Forms.Label
    Friend WithEvents lblProduct2Header As System.Windows.Forms.Label
    Friend WithEvents lblProduct3Header As System.Windows.Forms.Label
    Friend WithEvents lblProduct4Header As System.Windows.Forms.Label
    Friend WithEvents lblAddressHeader As System.Windows.Forms.Label
    Friend WithEvents lblPostalCodeHeader As System.Windows.Forms.Label
    Friend WithEvents lblPhoneNumberHeader As System.Windows.Forms.Label
    Friend WithEvents lblProduct1 As System.Windows.Forms.Label
    Friend WithEvents lblProduct2 As System.Windows.Forms.Label
    Friend WithEvents lblProduct3 As System.Windows.Forms.Label
    Friend WithEvents lblProduct4 As System.Windows.Forms.Label
    Friend WithEvents lblProduct5 As System.Windows.Forms.Label
    Friend WithEvents lblName As System.Windows.Forms.Label
    Friend WithEvents lblAddress As System.Windows.Forms.Label
    Friend WithEvents lblPostalCode As System.Windows.Forms.Label
    Friend WithEvents lblPhoneNumber As System.Windows.Forms.Label
    Friend WithEvents lblMessageHeader As System.Windows.Forms.Label
    Friend WithEvents lblMessage As System.Windows.Forms.Label

End Class
