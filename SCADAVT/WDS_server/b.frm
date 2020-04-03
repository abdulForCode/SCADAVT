VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "MSFLXGRD.OCX"
Begin VB.Form Form1 
   Caption         =   "WaterSim"
   ClientHeight    =   5880
   ClientLeft      =   1980
   ClientTop       =   2520
   ClientWidth     =   13935
   LinkTopic       =   "Form1"
   ScaleHeight     =   5880
   ScaleWidth      =   13935
   Begin MSFlexGridLib.MSFlexGrid MSFlexGrid1 
      Height          =   2055
      Left            =   120
      TabIndex        =   12
      Top             =   3720
      Width           =   13635
      _ExtentX        =   24051
      _ExtentY        =   3625
      _Version        =   393216
      Cols            =   28
   End
   Begin VB.TextBox Text2 
      Alignment       =   2  'Center
      Height          =   495
      Left            =   1200
      TabIndex        =   9
      Text            =   "1"
      Top             =   1680
      Width           =   615
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   1920
      Top             =   2400
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   1320
      Top             =   2400
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      Filter          =   "*.inp"
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   360
      Top             =   2760
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Open"
      Height          =   495
      Left            =   4680
      TabIndex        =   5
      Top             =   480
      Width           =   735
   End
   Begin VB.TextBox Text3 
      Height          =   495
      Left            =   1200
      TabIndex        =   4
      Text            =   "9009"
      Top             =   1080
      Width           =   975
   End
   Begin VB.TextBox Text1 
      Height          =   495
      Left            =   1200
      TabIndex        =   1
      Top             =   480
      Width           =   3375
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Start Sever"
      Height          =   615
      Left            =   1080
      TabIndex        =   0
      Top             =   2880
      Width           =   4095
   End
   Begin VB.Image Image1 
      Height          =   3330
      Left            =   5715
      Picture         =   "b.frx":0000
      Stretch         =   -1  'True
      Top             =   135
      Width           =   8070
   End
   Begin VB.Label Label8 
      Caption         =   "Label8"
      Height          =   495
      Left            =   8280
      TabIndex        =   13
      Top             =   840
      Width           =   2175
   End
   Begin VB.Label Label7 
      Caption         =   "Label7"
      Height          =   495
      Left            =   3120
      TabIndex        =   11
      Top             =   1320
      Width           =   1935
   End
   Begin VB.Label Label6 
      Alignment       =   2  'Center
      Caption         =   "Seconds"
      Height          =   255
      Left            =   1920
      TabIndex        =   10
      Top             =   1800
      Width           =   735
   End
   Begin VB.Label Label5 
      BorderStyle     =   1  'Fixed Single
      Caption         =   "SimTime"
      Height          =   495
      Left            =   240
      TabIndex        =   8
      Top             =   1680
      Width           =   855
   End
   Begin VB.Label Label4 
      Height          =   375
      Left            =   4800
      TabIndex        =   7
      Top             =   2280
      Width           =   855
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      Height          =   375
      Left            =   1530
      TabIndex        =   6
      Top             =   2160
      Width           =   2415
   End
   Begin VB.Label Label3 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Port"
      Height          =   495
      Left            =   240
      TabIndex        =   3
      Top             =   1080
      Width           =   855
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Description  File"
      Height          =   495
      Left            =   240
      TabIndex        =   2
      Top             =   480
      Width           =   855
   End
   Begin VB.Menu sim 
      Caption         =   "sim"
      Begin VB.Menu Export 
         Caption         =   "Export"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private t As Long
Private st As Long
Private Reg As New Registers
Private cc As Long
Dim counter As Long
Private Sub Command1_Click()
    CommonDialog1.ShowOpen
    Text1.Text = CommonDialog1.FileName
End Sub
Private Sub Command3_Click()
    If Command3.Caption = "Start Sever" Then
        Call ENopen(Trim(Text1.Text), "example2.rpt", "")
        Call ENopenH
        Call ENinitH(0)
        Winsock1.LocalPort = CLng(Text3.Text)
        Winsock1.Listen
        Command3.Caption = "Stop Server"
    Else
        Winsock1.Close
        Command3.Caption = "Start Sever"
        Timer1.Enabled = False
    End If
End Sub

Private Sub Export_Click()
  Form2.Show (1)
End Sub

Private Sub Form_Load()
Text1.Text = App.Path + "\test111.inp"
 With MSFlexGrid1
    .TextMatrix(0, 0) = "Time"
    .TextMatrix(0, 1) = "Pump_1"
    .TextMatrix(0, 2) = "Pump_2"
    .TextMatrix(0, 3) = "Pump_3"
    .TextMatrix(0, 4) = "Pump_4"
    .TextMatrix(0, 5) = "Pump_5"
    .TextMatrix(0, 6) = "Tank1_Lev"
    .TextMatrix(0, 7) = "Tank2_Lev"
    .TextMatrix(0, 8) = "Tank3_Lev"
    .TextMatrix(0, 9) = "Pi6_Flow"
    .TextMatrix(0, 10) = "Pi4_Flow"
    .TextMatrix(0, 11) = "Pi7_Flow"
    .TextMatrix(0, 12) = "Pi9_Flow"
    .TextMatrix(0, 13) = "Pi8_Flow"
    .TextMatrix(0, 14) = "Pi16_Flow"
    .TextMatrix(0, 15) = "Valve_1"
    .TextMatrix(0, 16) = "J3_PRESSURE"
    .TextMatrix(0, 17) = "J4_PRESSURE"
    .TextMatrix(0, 18) = "J5_PRESSURE"
    .TextMatrix(0, 19) = "J15_PRESSURE"
    .TextMatrix(0, 20) = "J16_PRESSURE"
    .TextMatrix(0, 21) = "J17_PRESSURE"
    .TextMatrix(0, 22) = "J18_PRESSURE"
    .TextMatrix(0, 23) = "J8_PRESSURE"
    .TextMatrix(0, 24) = "J9_PRESSURE"
    .TextMatrix(0, 25) = "J10_PRESSURE"
    .TextMatrix(0, 26) = "J29_PRESSURE"
    .TextMatrix(0, 27) = "Label"
    For i = 0 To .Cols - 1
        .ColAlignment(i) = 4
        .ColWidth(i) = 1100
    Next i
End With
End Sub

Private Sub Text2_Change()
Timer1.Interval = Trim(Text2.Text)
End Sub

Private Sub Timer1_Timer()
    ENrunH t
    ENnextH st
    Label2.Caption = VBA.Round((t / (60 * 60))) + 1
    Label4.Caption = Reg.showLinkData("V1", 12)
    Call ShowDataIntoGrid
End Sub
Private Sub Winsock1_ConnectionRequest(ByVal requestID As Long)
    If Winsock1.State <> closed Then Winsock1.Close
    Winsock1.Accept requestID
   
End Sub
Private Sub Winsock1_DataArrival(ByVal bytesTotal As Long)
    Dim msg As New message_recv
    Dim msgsend As New message_send
    Dim data() As Byte
    Call Winsock1.GetData(data)
   msg.unpackMessage data
   Label7.Caption = msg.getCompId
   'Label4.Caption = "connected"
  If msg.getCompId = "read" Or msg.getCompId = "write" Then
        Timer1.Enabled = True
        Winsock1.SendData ("end")
  Else
        Winsock1.SendData (msgsend.packMessage(Reg.Read_Write(msg.getAction, msg.getCompId, msg.getCompType, msg.getDataType, msg.getDataValue), msg))
  End If
   If msg.getCompId = "write" Then
         'ENrunH t
         'ENnextH st
         'Label2.Caption = Int(t / (60 * 60))
         'Label4.Caption = Reg.showLinkData("V1", 12)
         'Call ShowDataIntoGrid
   End If
End Sub
Private Sub ShowDataIntoGrid()
counter = counter + 1
     With MSFlexGrid1
        .ScrollTrack = True
        .Rows = counter + 1
        .TextMatrix(counter, 0) = VBA.Round((t / (60 * 60))) + 1
        .TextMatrix(counter, 1) = Reg.showLinkData("P1", EN_STATUS)
        .TextMatrix(counter, 2) = Reg.showLinkData("P2", EN_STATUS)
        .TextMatrix(counter, 3) = Reg.showLinkData("P3", EN_STATUS)
        .TextMatrix(counter, 4) = Reg.showLinkData("P4", EN_STATUS)
        .TextMatrix(counter, 5) = Reg.showLinkData("P5", EN_STATUS)
        .TextMatrix(counter, 6) = Reg.showNodeData("T1", EN_PRESSURE)
        .TextMatrix(counter, 7) = Reg.showNodeData("T2", EN_PRESSURE)
        .TextMatrix(counter, 8) = Reg.showNodeData("T3", EN_PRESSURE)
        
        .TextMatrix(counter, 9) = Reg.Read_Write(1, "Pi6", 2, EN_FLOW, 0)
        .TextMatrix(counter, 10) = Reg.Read_Write(1, "Pi4", 2, EN_FLOW, 0)
        .TextMatrix(counter, 11) = Reg.Read_Write(1, "Pi7", 2, EN_FLOW, 0)
        .TextMatrix(counter, 12) = Reg.Read_Write(1, "Pi9", 2, EN_FLOW, 0)
        .TextMatrix(counter, 13) = Reg.Read_Write(1, "Pi8", 2, EN_FLOW, 0)
        .TextMatrix(counter, 14) = Reg.Read_Write(1, "Pi16", 2, EN_FLOW, 0)
        .TextMatrix(counter, 15) = Reg.Read_Write(1, "V1", 2, EN_SETTING, 0)

        
        .TextMatrix(counter, 16) = Reg.Read_Write(1, "J3", 1, EN_PRESSURE, 0)
        .TextMatrix(counter, 17) = Reg.Read_Write(1, "J4", 1, EN_PRESSURE, 0)
        .TextMatrix(counter, 18) = Reg.Read_Write(1, "J5", 1, EN_PRESSURE, 0)
        .TextMatrix(counter, 19) = Reg.Read_Write(1, "J15", 1, EN_PRESSURE, 0)
        .TextMatrix(counter, 20) = Reg.Read_Write(1, "J16", 1, EN_PRESSURE, 0)
        .TextMatrix(counter, 21) = Reg.Read_Write(1, "J17", 1, EN_PRESSURE, 0)
        .TextMatrix(counter, 22) = Reg.Read_Write(1, "J18", 1, EN_PRESSURE, 0)
        .TextMatrix(counter, 23) = Reg.Read_Write(1, "J8", 1, EN_PRESSURE, 0)
        .TextMatrix(counter, 24) = Reg.Read_Write(1, "J9", 1, EN_PRESSURE, 0)
        .TextMatrix(counter, 25) = Reg.Read_Write(1, "J10", 1, EN_PRESSURE, 0)
        .TextMatrix(counter, 26) = Reg.Read_Write(1, "J29", 1, EN_PRESSURE, 0)
        
        
        .TextMatrix(counter, 27) = 0
        .TopRow = counter
        .Row = counter
        .ColSel = .Cols - 1
        Timer1.Enabled = False
        .SetFocus
    End With
    Label8.Caption = Str(Reg.showLinkData("P4", EN_SETTING)) + "   --  " + Str(Reg.showLinkData("P5", EN_SETTING))
End Sub
