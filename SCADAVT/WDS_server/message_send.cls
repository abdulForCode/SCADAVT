VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "message_send"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Public Function packMessage(ByVal value As Single, ByVal recv As message_recv) As String
 Dim msg As String
  msg = CStr(recv.getAction) + ":" + CStr(recv.getCompId) + ":" + CStr(recv.getCompType) + ":" + CStr(recv.getDataType) + ":" + CStr(value)
  packMessage = msg
End Function

