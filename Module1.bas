Attribute VB_Name = "Module1"
'/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////This part is for control use

Public gbafilepath As String         'save gba file path and name

Public Hexstream1 As String         'load current layer1 decompressed room all Hex stream
Public Hexstream2 As String         'load current layer2 decompressed room all Hex stream

Public widtha1 As String        'save layer's width
Public heighta2 As String       'save layer's height
Public transmita3 As String      'transmit a3

Public leftzerozero1 As Long         'save the "00" data number

Public BeforeLine As Integer           'for Form1 drawing line, rectangle and print font

Public layer1compressdatalength As Long    'store layer compress data length, ��λ��4��bit������ֽ�
Public layer2compressdatalength As Long

Public startoffset As String     'Just store in Hex, if use, we can change it to Dec.
Public PointerOffset1 As String  'make index in case of expand other pointer Offset varients

Public IfisNewRoom As Boolean    'decide if form2 show to create a new room
Public IfisNewRoomConnectionDataBuffer As Boolean
Public RoomConnectionDataBuffer As String

Public LevelStartStream As String
Public LevelStartStreamOffset As String
Public LevelNumber As String     'store level number which can be got from 030000023 h
Public LevelRoomIndex As String                          'count from 1
Public LevelAllRoomPointerandDataBaseOffset As String
Public LevelAllRoomPointerandDataallHex As String
Public RoomElementOffset As String
Public LevelChangeRoomStreamOffset As String
Public LevelChangeRoomStreamPointerOffset As String

Public SaveDatabuffer() As String
Public SaveDataOffset() As String

Public TempPointerValue() As String

Public RoomElementFirstOffset As String

'******************************************************************************from Form 6 for global use
Public CameraCotrolString As String
Public CameraCotrolPointerOffset As String      '��ţ�ָ��ָ����ͷλ�õ�ָ�룩�ĵ�ַ
Public RoomCameraStringPointerOffset As String     '��ţ�ָ��Room��Camera�������ַ�����ָ�룩�ĵ�ַ
Public LengthOfAllPointer As Long               'ָ����ܳ�����λ��Byte
'******************************************************************************
Public WasCameraControlStringChange As Boolean
'/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Public Function CompressDataOnly(ByVal Hexstream As String) As String   'compress data only, and value "FF" has not been try.
Dim OutputStream As String
Dim str1 As String, str2 As String    'store now text in byte

Dim Num1 As Integer    'count for non repeat byte
Dim num2 As Integer    'count for  repeat byte

Dim shiftoffset As Long   '��λ��8��bit������ֽ�
Dim tempstream As String  '������ظ��ֽ�����

Num1 = 0
num2 = Val("&H" & "80")
shiftoffset = -1

Do
DoEvents
shiftoffset = shiftoffset + 2
str1 = Mid(Hexstream, shiftoffset, 2)
str2 = Mid(Hexstream, shiftoffset + 2, 2)

If str2 <> str1 Then
Num1 = Num1 + 1

    If num2 = Val("&H" & "80") And Num1 < Val("&H" & "7E") And (shiftoffset < Len(Hexstream) - 3) Then    'less then 7Eh
    tempstream = tempstream & str1
    ElseIf num2 = Val("&H" & "80") And Num1 = Val("&H" & "7E") Then               'now equal to 7Eh
    OutputStream = OutputStream & "7F" & tempstream & str1 & str2
    Num1 = 0
    shiftoffset = shiftoffset + 2
    tempstream = ""
    ElseIf num2 = Val("&H" & "80") And Num1 < Val("&H" & "7E") And (shiftoffset = Len(Hexstream) - 3) Then               'now equal to 7Eh and to the end
    OutputStream = OutputStream & Right("00" & Hex(Num1 + 1), 2) & tempstream & str1 & str2
    ElseIf num2 > Val("&H" & "80") And num2 < Val("&H" & "FF") And (shiftoffset < Len(Hexstream) - 3) And Num1 = 1 Then
    OutputStream = OutputStream & Right("00" & Hex(num2 + 1), 2) & str1
    num2 = Val("&H" & "80")
    Num1 = 0
    ElseIf num2 > Val("&H" & "80") And (shiftoffset = Len(Hexstream) - 3) Then
    OutputStream = OutputStream & Right("00" & Hex(num2 + 2), 2) & str1 & "01" & str2
    End If
ElseIf str1 = str2 Then

    If Num1 > 0 And (shiftoffset < Len(Hexstream) - 3) Then   '������һ�����ظ��ַ�����������ظ��ַ�
    OutputStream = OutputStream & Right("00" & Hex(Num1), 2) & tempstream
    Num1 = 0
    num2 = Val("&H" & "81")
    tempstream = ""
    ElseIf Num1 > 0 And (shiftoffset = Len(Hexstream) - 3) And Num1 < Val("&H" & "7E") Then   'to the end   �Ҿ����⼸����д�������Ϊ���һ��һ�㶼����һɫ��40��00�������⼸��һ���ò���
    OutputStream = OutputStream & Right("00" & Hex(Num1 + 2), 2) & tempstream & str1 & str2
    tempstream = ""
    ElseIf Num1 > 0 And (shiftoffset = Len(Hexstream) - 3) And Num1 = Val("&H" & "7E") Then   'to the end   �Ҿ����⼸����д�������Ϊ���һ��һ�㶼����һɫ��40��00�������⼸��һ���ò���
    OutputStream = OutputStream & Right("00" & Hex(Num1 + 1), 2) & tempstream & str1 & "01" & str2
    tempstream = ""
    ElseIf Num1 > 0 And (shiftoffset = Len(Hexstream) - 3) And Num1 = Val("&H" & "7F") Then   'to the end   �Ҿ����⼸����д�������Ϊ���һ��һ�㶼����һɫ��40��00�������⼸��һ���ò���
    OutputStream = OutputStream & Right("00" & Hex(Num1), 2) & tempstream & "82" & str2
    tempstream = ""
    ElseIf Num1 = 0 And num2 < Val("&H" & "FE") And (shiftoffset < Len(Hexstream) - 3) Then
    num2 = num2 + 1
    ElseIf Num1 = 0 And num2 < Val("&H" & "FE") And (shiftoffset = Len(Hexstream) - 3) Then
    num2 = num2 + 1
    OutputStream = OutputStream & Right("00" & Hex(num2 + 1), 2) & str1
    ElseIf Num1 = 0 And num2 = Val("&H" & "FE") Then
    OutputStream = OutputStream & "FF" & str1
    num2 = Val("&H" & "80")
    End If
End If

DoEvents

If shiftoffset = Len(Hexstream) - 3 Then
Exit Do
End If

Form2.Label1.Caption = "Output:" & str(shiftoffset) & "/" & str(Len(Hexstream) - 2)
Loop

CompressDataOnly = OutputStream
End Function

Public Function FindSpace(ByVal filepath As String, ByVal StartOffset1 As String, ByVal EndOffset1 As String, ByVal SpaceStr As String, ByVal SpaceLen As Long) As String
If StartOffset1 = "" Then StartOffset1 = "00"
If filepath = "" Then
FindSpace = ""
MsgBox "û���ƶ�ROM File��", vbOKOnly + vbExclamation, "Warning!"
Exit Function
End If
If Val("&H" & EndOffset1) - Val("&H" & StartOffset1) + 1 < SpaceLen Then '
FindSpace = "FFFFFFFF"
Exit Function
End If
If SpaceStr = "" Then SpaceStr = "00"
Dim ROMallbyte() As Byte     'max ROM space is 32 MB, is in VB's changeable String Type, its maximun is 2^31
Dim ROMallHex As String
Open gbafilepath For Binary As #1
ReDim ROMallbyte(LOF(1) - 1)
Get #1, Val("&H" & StartOffset1) + 1, ROMallbyte   'ROMallstr now contains all of the text in the file
Close #1
Dim i As Long         'ת��Hex
Dim j As Long         '������
For i = LBound(ROMallbyte) To LBound(ROMallbyte) + Val("&H" & EndOffset1) - Val("&H" & StartOffset1)
ROMallHex = ROMallHex & Right("00" & Hex(ROMallbyte(i)), 2)    '��Right()��ֹ����"0X"�����
DoEvents
Next i
Erase ROMallbyte()
For i = 0 To Val("&H" & EndOffset1) - Val("&H" & StartOffset1)
'Form2.Label8.Caption = "�������ܵ�Դ��ַ�е�Free Space�����ȣ�" & CStr(i) & CStr(Val("&H" & EndOffset1) - Val("&H" & StartOffset1))
If Mid(ROMallHex, 2 * i + 1, 2) = SpaceStr Then j = j + 1
If Mid(ROMallHex, 2 * i + 1, 2) <> SpaceStr Then j = 0
If Val("&H" & StartOffset1) + i > Val("&H" & EndOffset1) - SpaceLen Then
FindSpace = "FFFFFFFF"                                                   '���ش������
Exit Function
End If
If j = SpaceLen Then
FindSpace = Hex(Val("&H" & StartOffset1) + i - j + 1)
Exit For
End If
DoEvents
Next i
End Function

Public Function ReadFileHex(ByVal filepath As String, ByVal StartOffset2 As String, ByVal EndOffset2 As String) As String
If StartOffset2 = "" Then StartOffset2 = "00"
Dim ROMallbyte() As Byte     'max ROM space is 32 MB, is in VB's changeable String Type, its maximun is 2^31
Dim ROMallHex As String
Open gbafilepath For Binary As #1
ReDim ROMallbyte(LOF(1) - 1)
If EndOffset2 = "" Or Val("&H" & EndOffset2) = 0 Then EndOffset2 = Hex(LOF(1) - 1)
Get #1, Val("&H" & StartOffset2) + 1, ROMallbyte   'ROMallstr now contains all of the text in the file
Close #1
Dim i As Long         'ת��Hex
Dim j As Long         '������
For i = LBound(ROMallbyte) To LBound(ROMallbyte) + (Val("&H" & EndOffset2) - Val("&H" & StartOffset2))
ROMallHex = ROMallHex & Right("00" & Hex(ROMallbyte(i)), 2)    '��Right()��ֹ����"0X"�����
DoEvents
Next i
Erase ROMallbyte()
ReadFileHex = ROMallHex
End Function

Public Function ReadFileHexWithByteInterchange(ByVal filepath As String, ByVal StartOffset2 As String, ByVal EndOffset2 As String) As String
If StartOffset2 = "" Then StartOffset2 = "00"
Dim ROMallbyte() As Byte     'max ROM space is 32 MB, is in VB's changeable String Type, its maximun is 2^31
Dim ROMallHex As String
Open gbafilepath For Binary As #1
ReDim ROMallbyte(LOF(1) - 1)
If EndOffset2 = "" Or Val("&H" & EndOffset2) = 0 Then EndOffset2 = Hex(LOF(1) - 1)
Get #1, Val("&H" & StartOffset2) + 1, ROMallbyte   'ROMallstr now contains all of the text in the file
Close #1
Dim i As Long         'ת��Hex
Dim j As Long         '������
Dim n1 As String, n2 As String
For i = LBound(ROMallbyte) To LBound(ROMallbyte) + (Val("&H" & EndOffset2) - Val("&H" & StartOffset2))
ROMallHex = ROMallHex & Hex(ROMallbyte(i) And 15) & Mid(Hex(ROMallbyte(i) And 240), 1, 1)
DoEvents
Next i
Erase ROMallbyte()
ReadFileHexWithByteInterchange = ROMallHex
End Function

Public Function strcmp(str1 As String, str2 As String) As Integer
If (Len(str1) < Len(str2)) Or (Len(str1) > Len(str2)) Then
strcmp = -1
Exit Function
End If
Dim i As Long
For i = 1 To Len(str1)
If Mid(str1, i, 1) <> Mid(str2, i, 1) Then
strcmp = i
Exit Function
End If
Next i
strcmp = 0
End Function

Public Function SaveCameraString(StrTemp As String) As Boolean         'not support resave
If SaveDataOffset(95) <> "" Then
    SaveCameraString = False
    Exit Function
End If
Dim i As Integer, TempAddress As Long
TempAddress = Val("&H" & LevelAllRoomPointerandDataBaseOffset) + 24 + (Val("&H" & LevelRoomIndex) - 1) * 44
For i = 1 To 100
If SaveDataOffset(i) = "" Then Exit For
Next i
SaveDataOffset(i) = Hex(TempAddress)
SaveDatabuffer(i) = "03"

i = i + 1
Dim TempPointer As String

StrTemp = Replace(StrTemp, Chr(32), "")
StrTemp = Replace(StrTemp, Chr(13), "")
StrTemp = Replace(StrTemp, Chr(10), "")

If RoomCameraStringPointerOffset = "" Then               '��ǰ������Camera����
        SaveDataOffset(i) = SaveDatabuffer(0)        '��д�µ�Camera����������
        TempPointer = Right("00" & Hex(Val("&H" & SaveDataOffset(i)) + Val("&H8000000")), 8)
        TempPointer = Mid(TempPointer, 7, 2) & Mid(TempPointer, 5, 2) & Mid(TempPointer, 3, 2) & Mid(TempPointer, 1, 2)
        SaveDatabuffer(i) = StrTemp
        SaveDatabuffer(0) = Hex(Val("&H" & SaveDatabuffer(0)) + Len(StrTemp))   '��ַ����
        SaveDatabuffer(0) = (SaveDatabuffer(0) \ 4) * 4 + 4
        SaveDataOffset(i + 1) = CameraCotrolPointerOffset      '�޸�ָ����ͷָ�룬����������ָ�����λ�úͳ���
        SaveDatabuffer(i + 1) = Right("0000" & Hex(Val("&H" & SaveDatabuffer(0)) + Val("&H8000000")), 8)
        SaveDatabuffer(i + 1) = Mid(SaveDatabuffer(i + 1), 7, 2) & Mid(SaveDatabuffer(i + 1), 5, 2) & Mid(SaveDatabuffer(i + 1), 3, 2) & Mid(SaveDatabuffer(i + 1), 1, 2)    '����ָ�룬��λ���µ�ָ����ַ
        SaveDataOffset(i + 2) = SaveDatabuffer(0)      'д�µ�ָ���
        
        SaveDatabuffer(i + 2) = TempPointer & ReadFileHex(gbafilepath, CameraCotrolPointerOffset, Hex(Val("&H" & CameraCotrolPointerOffset) + LengthOfAllPointer - 1))
        SaveDatabuffer(0) = Hex(Val("&H" & SaveDatabuffer(0)) + LengthOfAllPointer + 4) '��ַ����
Else
        If Len(StrTemp) > Len(CameraCotrolString) Then         '��ǰ����ֻ�����ڵıȽϳ�
        SaveDataOffset(i) = RoomCameraStringPointerOffset
        TempPointer = Right("0000" & Hex(Val("&H" & SaveDatabuffer(0)) + Val("&H8000000")), 8)
        TempPointer = Mid(TempPointer, 7, 2) & Mid(TempPointer, 5, 2) & Mid(TempPointer, 3, 2) & Mid(TempPointer, 1, 2)
        SaveDatabuffer(i) = TempPointer
        SaveDataOffset(i + 1) = SaveDatabuffer(0)
        SaveDatabuffer(i + 1) = StrTemp
        SaveDatabuffer(0) = Hex(Val("&H" & SaveDatabuffer(0)) + Len(StrTemp))   '��ַ����
        Else
        SaveDataOffset(i) = RoomCameraStringPointerOffset
        SaveDatabuffer(i) = StrTemp & Replace(Space(Len(CameraCotrolString) - Len(StrTemp)), Chr(32), "0")
        End If
End If
End Function

