VERSION 5.00
Begin VB.Form Form5 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "����ģ��"
   ClientHeight    =   3645
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   4560
   LinkTopic       =   "Form5"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   3645
   ScaleWidth      =   4560
   Visible         =   0   'False
   Begin VB.CommandButton Command1 
      Caption         =   "Save All"
      Height          =   375
      Left            =   120
      TabIndex        =   3
      Top             =   2640
      Width           =   4215
   End
   Begin VB.TextBox Text1 
      Height          =   2055
      Left            =   1440
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   2
      Top             =   480
      Width           =   3015
   End
   Begin VB.ListBox List1 
      Height          =   2040
      ItemData        =   "Form5.frx":0000
      Left            =   120
      List            =   "Form5.frx":0002
      TabIndex        =   1
      Top             =   480
      Width           =   1215
   End
   Begin VB.Label Label1 
      Caption         =   "save offset��    Hex��"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   3255
   End
End
Attribute VB_Name = "Form5"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
If SaveDataOffset(LBound(SaveDatabuffer())) = "" Then Exit Sub
Dim i As Integer, j As Long
Dim MassageByte() As Byte
Open gbafilepath For Binary As #1
For i = 0 To UBound(SaveDataOffset()) - LBound(SaveDataOffset())
If Len(SaveDatabuffer(i)) = 0 Then Exit For                 '����һ���� Redim ����(0) ʵ���Ͼ�ָ����һ������
    ReDim MassageByte(Len(SaveDatabuffer(i)) / 2 - 1)       '������ǣ�ARMָ�����С������λΪ�ֽڣ����Բ��õ���������ַ�������������Ҳ��Ҫ���ʱ�ı�֤
    For j = 1 To Len(SaveDatabuffer(i)) / 2
    MassageByte(j - 1) = Val("&H" & Mid(SaveDatabuffer(i), 2 * j - 1, 2))
    Next j
Put #1, Val("&H" & SaveDataOffset(i)) + 1, MassageByte()
Next i
Close #1

IfisNewRoom = False
IfisNewRoomConnectionDataBuffer = False
Erase MassageByte()
ReDim SaveDatabuffer(100)     '��¼�������ֵΪ101
ReDim SaveDataOffset(100)

Form5.List1.Clear
Form5.Text1.Text = ""

gbafilepath = ""
LevelNumber = ""
LevelAllRoomPointerandDataBaseOffset = ""
LevelAllRoomPointerandDataallHex = ""
LevelStartStreamOffset = ""
Form4TextBox2Temp = ""
RoomConnectionDataBuffer = ""
Form4.List1.Clear
Form4.List2.Clear
Form4.List3.Clear
Form4.List4.Clear
Form4.List5.Clear
Form4.List6.Clear
Form4.Text1.Text = ""
Form4.Text2.Text = ""
Form1.Text1.Text = ""
Form1.Picture1.Cls
BeforeLine = 0
MDIForm1.Caption = "�ؿ��޸Ŀ��ӻ�����"
MsgBox "������ɣ�Ҫ�����޸������´��ļ���", vbOKOnly

MDIForm1.mnuedit.Enabled = False
MDIForm1.mnusave.Enabled = False
MDIForm1.mnuFindBaseOffset.Enabled = False
MDIForm1.mnuRoomConnectionBeta.Enabled = False
MDIForm1.mnuLevelguidefrm.Enabled = False
MDIForm1.mnuopenfile.Enabled = True

Form1.Visible = False
Form2.Visible = False
Form3.Visible = False
Form4.Visible = False
Form6.Visible = False
Form8.Visible = False

WasCameraControlStringChange = False

Form5.Visible = False
End Sub

Private Sub Form_Activate()
Form5.Move 0, 0, 4650, 9705
Dim i As Integer

Form5.List1.Clear
For i = LBound(SaveDatabuffer()) To UBound(SaveDatabuffer())
If SaveDatabuffer(i) = "" Then Exit For
Form5.List1.AddItem SaveDataOffset(i)
Next i
End Sub

Private Sub Form_Load()
Form4.Visible = False
End Sub

Private Sub List1_Click()
Form5.Text1.Text = SaveDatabuffer(Form5.List1.ListIndex + LBound(SaveDatabuffer()))
End Sub
