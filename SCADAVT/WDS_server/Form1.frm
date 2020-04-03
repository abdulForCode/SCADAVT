VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form Form1 
   Caption         =   "WaterSim"
   ClientHeight    =   3735
   ClientLeft      =   11280
   ClientTop       =   6045
   ClientWidth     =   6915
   LinkTopic       =   "Form1"
   ScaleHeight     =   3735
   ScaleWidth      =   6915
   Begin VB.CommandButton Command2 
      Caption         =   "Command2"
      Height          =   375
      Left            =   5400
      TabIndex        =   7
      Top             =   3000
      Width           =   1095
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   500
      Left            =   2280
      Top             =   1680
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Open"
      Height          =   495
      Left            =   4680
      TabIndex        =   5
      Top             =   480
      Width           =   735
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   240
      Top             =   1680
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.TextBox Text3 
      Height          =   495
      Left            =   1200
      TabIndex        =   4
      Text            =   "9009"
      Top             =   1080
      Width           =   4215
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   840
      Top             =   1680
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.TextBox Text1 
      Height          =   495
      Left            =   1200
      TabIndex        =   1
      Text            =   "H:\Dropbox\WDS_server\test1.inp"
      Top             =   480
      Width           =   3375
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Start Sever"
      Height          =   615
      Left            =   840
      TabIndex        =   0
      Top             =   2280
      Width           =   4095
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      Caption         =   "Label2"
      Height          =   375
      Left            =   1320
      TabIndex        =   6
      Top             =   1800
      Width           =   3615
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
      Caption         =   "Epanet file"
      Height          =   495
      Left            =   240
      TabIndex        =   2
      Top             =   480
      Width           =   855
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
Private Sub Command1_Click()
    CommonDialog1.ShowOpen
    Text1.Text = CommonDialog1.FileName
End Sub

Private Sub Command2_Click()
Dim S As Long
S = 23
Label2.Caption = VBA.Hex$(S)
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
    End If
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
   'If msg.getCompId = "read" Or msg.getCompId = "write" Then
   If msg.getCompId = "write" Then
        If msg.getCompId = "write" Then
            ENrunH t
            ENnextH st
            cc = cc + 1
            Label2.Caption = t
        End If
        Winsock1.SendData ("end")
        'Winsock1.Close
        'Winsock1.Listen
  Else
        message = msgsend.packMessage(Reg.Read_Write(msg.getAction, msg.getCompId, msg.getCompType, msg.getDataType, msg.getDataValue), msg)
        Winsock1.SendData (message)
  End If
  
End Sub

