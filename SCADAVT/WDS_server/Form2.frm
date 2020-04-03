VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "MSFLXGRD.OCX"
Begin VB.Form Form2 
   Caption         =   "Form2"
   ClientHeight    =   9525
   ClientLeft      =   5430
   ClientTop       =   3405
   ClientWidth     =   14520
   LinkTopic       =   "Form2"
   ScaleHeight     =   9525
   ScaleWidth      =   14520
   Begin VB.CheckBox Check1 
      Caption         =   "PureNormal"
      Height          =   195
      Left            =   3150
      TabIndex        =   12
      Top             =   8865
      Width           =   1860
   End
   Begin VB.OptionButton Option2 
      Caption         =   "Weka"
      Height          =   195
      Left            =   4320
      TabIndex        =   11
      Top             =   9135
      Width           =   1140
   End
   Begin VB.OptionButton Option1 
      Caption         =   "Excel"
      Height          =   195
      Left            =   3105
      TabIndex        =   10
      Top             =   9135
      Value           =   -1  'True
      Width           =   1140
   End
   Begin VB.TextBox Text1 
      Height          =   375
      Left            =   6885
      TabIndex        =   4
      Text            =   "Test"
      Top             =   9090
      Width           =   4245
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Show"
      Height          =   8565
      Left            =   3015
      TabIndex        =   3
      Top             =   180
      Width           =   555
   End
   Begin MSFlexGridLib.MSFlexGrid MSFlexGrid1 
      Height          =   8655
      Left            =   3690
      TabIndex        =   2
      Top             =   135
      Width           =   10770
      _ExtentX        =   18997
      _ExtentY        =   15266
      _Version        =   393216
      Cols            =   1
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Export"
      Height          =   420
      Left            =   11205
      TabIndex        =   1
      Top             =   9090
      Width           =   3255
   End
   Begin VB.ListBox List1 
      Height          =   8610
      Left            =   90
      Style           =   1  'Checkbox
      TabIndex        =   0
      Top             =   135
      Width           =   2760
   End
   Begin VB.Label Label5 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Abnormal"
      Height          =   285
      Left            =   1485
      TabIndex        =   9
      Top             =   9180
      Width           =   1275
   End
   Begin VB.Label Label4 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Normal"
      Height          =   285
      Left            =   1485
      TabIndex        =   8
      Top             =   8820
      Width           =   1275
   End
   Begin VB.Label Label3 
      Caption         =   "Abnormal"
      Height          =   285
      Left            =   45
      TabIndex        =   7
      Top             =   9180
      Width           =   1275
   End
   Begin VB.Label Label2 
      Caption         =   "Normal"
      Height          =   285
      Left            =   90
      TabIndex        =   6
      Top             =   8820
      Width           =   1275
   End
   Begin VB.Label Label1 
      Caption         =   "File Name"
      Height          =   330
      Left            =   5805
      TabIndex        =   5
      Top             =   9090
      Width           =   1005
   End
End
Attribute VB_Name = "Form2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Command2_Click()
    Command2.Caption = "Exporting"
    Command2.Enabled = False
    If Option1.Value = True Then Call excel Else Call weka
    Command2.Caption = "Export"
    Command2.Enabled = True
End Sub

Private Sub Command3_Click()
Dim normal As Long
Dim abnormal As Long
Cols = 0
 For i = 0 To List1.ListCount - 1
    If List1.Selected(i) Then
        Cols = Cols + 1
        With MSFlexGrid1
            .Cols = Cols
            .TextMatrix(0, Cols - 1) = List1.List(i)
            .ColAlignment(Cols - 1) = 4
            .ColWidth(Cols - 1) = 1100
        End With
    End If
Next i
MSFlexGrid1.Rows = Form1.MSFlexGrid1.Rows
For i = 1 To Form1.MSFlexGrid1.Rows - 1
    For b = 0 To Form1.MSFlexGrid1.Cols - 1
        For d = 0 To MSFlexGrid1.Cols - 1
            If Form1.MSFlexGrid1.TextMatrix(0, b) = MSFlexGrid1.TextMatrix(0, d) Then
               MSFlexGrid1.TextMatrix(i, d) = Form1.MSFlexGrid1.TextMatrix(i, b)
            End If
        Next d
        If Form1.MSFlexGrid1.TextMatrix(0, b) = "Label" Then
            If Int(Form1.MSFlexGrid1.TextMatrix(i, b)) = 0 Then
                normal = normal + 1
                Label4.Caption = normal
            Else
                    abnormal = abnormal + 1
                    Label5.Caption = abnormal
            End If
        End If
    Next b
Next i
End Sub

Private Sub Form_Load()
    Cols = Form1.MSFlexGrid1.Cols
    For i = 0 To Cols - 1
        List1.AddItem (Form1.MSFlexGrid1.TextMatrix(0, i))
     Next i
End Sub
Private Sub weka()
    Dim wekaLine As String
    wekaLine = "@relation " + Trim(Text1.Text) + VBA.vbNewLine + VBA.vbNewLine
    iFileNo = FreeFile
    Open "D:\TestData\" + Trim(Text1.Text) + ".arff" For Output As #iFileNo
    Print #iFileNo, wekaLine
    For i = 0 To MSFlexGrid1.Cols - 1
        If Trim(MSFlexGrid1.TextMatrix(0, i)) = "Pump_1" Or Trim(MSFlexGrid1.TextMatrix(0, i)) = "Pump_2" Or Trim(MSFlexGrid1.TextMatrix(0, i)) = "Pump 1" Or Trim(MSFlexGrid1.TextMatrix(0, i)) = "Pump_3" Or Trim(MSFlexGrid1.TextMatrix(0, i)) = "Pump_4" Or Trim(MSFlexGrid1.TextMatrix(0, i)) = "Pump_5" Or Trim(MSFlexGrid1.TextMatrix(0, i)) = "Valve_1" Then
            wekaLine = "@attribute " + MSFlexGrid1.TextMatrix(0, i) + " {1, 0}"
        ElseIf Trim(MSFlexGrid1.TextMatrix(0, i)) = "Label" Then
            wekaLine = "@attribute class {1, 0}"
        Else
            wekaLine = "@attribute " + MSFlexGrid1.TextMatrix(0, i) + " real"
        End If
        Print #iFileNo, wekaLine
        wekaLine = ""
    Next i
    wekaLine = VBA.vbNewLine + VBA.vbNewLine + "@data"
    Print #iFileNo, wekaLine
    wekaLine = ""
    For i = 1 To MSFlexGrid1.Rows - 1
        For b = 0 To MSFlexGrid1.Cols - 1
            If b = MSFlexGrid1.Cols - 1 Then
                wekaLine = wekaLine + MSFlexGrid1.TextMatrix(i, b)
            Else
                wekaLine = wekaLine + MSFlexGrid1.TextMatrix(i, b) + ","
            End If
        Next b
        If Check1.Value = 0 Then
             Print #iFileNo, wekaLine
        Else
            If MSFlexGrid1.TextMatrix(i, MSFlexGrid1.Cols - 1) = 0 Then
                 Print #iFileNo, wekaLine
            End If
        End If
        wekaLine = ""
    Next i
    Close #iFileNo
End Sub
Private Sub excel()
    iFileNo = FreeFile
    Open "D:\TestData\" + Trim(Text1.Text) + ".csv" For Output As #iFileNo
    Dim Line As String
    For i = 1 To MSFlexGrid1.Rows - 1
        For b = 0 To MSFlexGrid1.Cols - 1
            If b = MSFlexGrid1.Cols - 1 Then
                Line = Line + MSFlexGrid1.TextMatrix(i, b)
            Else
                Line = Line + MSFlexGrid1.TextMatrix(i, b) + ","
            End If
        Next b
        If Check1.Value = 0 Then
             Print #iFileNo, Line
        Else
            If MSFlexGrid1.TextMatrix(i, MSFlexGrid1.Cols - 1) = 0 Then
                 Print #iFileNo, Line
            End If
        End If
        Line = ""
    Next i
    Close #iFileNo
End Sub
