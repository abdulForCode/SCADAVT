VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "message_recv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private action As Byte
Private compId As String
Private dataType As Byte
Private dataValue As Single
Private compType As Byte

Public Property Get getAction() As Byte
    getAction = action
End Property
Public Property Get getCompId() As String
    getCompId = Trim(compId)
End Property
Public Property Get getDataType() As Byte
    getDataType = dataType
End Property
Public Property Get getDataValue() As String
    getDataValue = dataValue
End Property
Public Property Get getCompType() As Byte
    getCompType = compType
End Property
Public Sub unpackMessage(data() As Byte)
    Dim IdLen As Integer
    Dim dataLen As Integer
    Dim compIdByte() As Byte
    Dim dataVlaueByte() As Byte
    For i = 1 To 10
        If data(i) <> 0 Then
          IdLen = IdLen + 1
        End If
        If data(12 + i) <> 0 Then
          dataLen = dataLen + 1
        End If
    Next i
    ReDim compIdByte(IdLen - 1)
    ReDim dataVlaueByte(dataLen - 1)
    For i = 1 To 10
        If data(i) <> 0 Then
          compIdByte(i - 1) = data(i)
        End If
        If data(12 + i) <> 0 Then
          dataVlaueByte(i - 1) = data(12 + i)
        End If
    Next i
    compId = StrConv(compIdByte, vbUnicode)
    dataValue = VBA.CDec((StrConv(dataVlaueByte, vbUnicode)))
    action = CInt(data(0))
    compType = CInt(data(11))
    dataType = CInt(data(12))
    dataValue = dataValue
    compId = compId
End Sub
