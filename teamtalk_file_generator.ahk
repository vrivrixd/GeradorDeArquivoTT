; Shared code for TeamTalk File Generator.
; Do not run or compile this file directly: run or compile english.ahk or portugues.ahk,
; which set the interface texts (T_*) and then include this file.
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

Gui +LastFound
Gui, Add, Text, x10 y10, %T_ServerName%
Gui, Add, Edit, x150 y10 w200 vttname

Gui, Add, Text, x10 y40, %T_ServerAddress%
Gui, Add, Edit, x150 y40 w200 vttaddress

Gui, Add, Text, x10 y70, %T_TcpPort%
Gui, Add, Edit, x150 y70 w200 vtcpport, 10333

Gui, Add, Text, x10 y100, %T_UdpPort%
Gui, Add, Edit, x150 y100 w200 vudpport, 10333

Gui, Add, Text, x10 y130, %T_Encrypted%
Gui, Add, CheckBox, x150 y130 vencrypted

Gui, Add, Text, x10 y160, %T_Username%
Gui, Add, Edit, x150 y160 w200 vusername

Gui, Add, Text, x10 y190, %T_Password%
Gui, Add, Edit, x150 y190 w170 vpassword Password
Gui, Add, Button, x330 y187 w50 h20 gTogglePass1 vPassBtn1, %T_Show%

Gui, Add, Text, x10 y220, %T_Nickname%
Gui, Add, Edit, x150 y220 w200 vnickname

Gui, Add, Text, x10 y250, %T_Channel%
Gui, Add, Edit, x150 y250 w200 vchannel

Gui, Add, Text, x10 y280, %T_ChannelPassword%
Gui, Add, Edit, x150 y280 w170 vchannelpass Password
Gui, Add, Button, x330 y277 w50 h20 gTogglePass2 vPassBtn2, %T_Show%

Gui, Add, Button, x150 y320 w100 gGenerate, %T_Generate%
Gui, Add, Button, x260 y320 w100 gCancel, %T_Cancel%

Gui, Show, w400 h360, %T_Title%
return

TogglePass1:
GuiControlGet, currentText,, PassBtn1
Gui, Submit, NoHide
if (currentText = T_Show) {
    GuiControl, -Password, password
    GuiControl,, PassBtn1, %T_Hide%
} else {
    GuiControl, +Password, password
    GuiControl,, PassBtn1, %T_Show%
}
GuiControl,, password, %password%
return

TogglePass2:
GuiControlGet, currentText,, PassBtn2
Gui, Submit, NoHide
if (currentText = T_Show) {
    GuiControl, -Password, channelpass
    GuiControl,, PassBtn2, %T_Hide%
} else {
    GuiControl, +Password, channelpass
    GuiControl,, PassBtn2, %T_Show%
}
GuiControl,, channelpass, %channelpass%
return

Generate:
Gui, Submit
if (!ttname || !ttaddress || !tcpport || !udpport || !username) {
    MsgBox, 48, %T_Error%, %T_FillRequired%
    Gui, Show
    return
}

FileSelectFile, filename, S16, , %T_Save%, TeamTalk Host Settings (*.tt)
if (filename = "")
    return

if (!InStr(filename, ".tt"))
    filename .= ".tt"

content := "<?xml version=""1.0"" encoding=""UTF-8"" ?>`r`n"
content .= "<!DOCTYPE teamtalk>`r`n"
content .= "<teamtalk version=""5.0"">`r`n"
content .= " <host>`r`n"
content .= "  <name>" . ttname . "</name>`r`n"
content .= "  <address>" . ttaddress . "</address>`r`n"
content .= "  <tcpport>" . tcpport . "</tcpport>`r`n"
content .= "  <udpport>" . udpport . "</udpport>`r`n"

if (encrypted = 1)
    content .= "  <encrypted>true</encrypted>`r`n"
else
    content .= "  <encrypted>false</encrypted>`r`n"

content .= "  <auth>`r`n"
content .= "   <username>" . username . "</username>`r`n"
content .= "   <password>" . password . "</password>`r`n"
content .= "   <nickname>" . nickname . "</nickname>`r`n"
content .= "  </auth>`r`n"

if (channel != "") {
    content .= "  <join>`r`n"
    content .= "   <channel>" . channel . "</channel>`r`n"
    content .= "   <password>" . channelpass . "</password>`r`n"
    content .= "  </join>`r`n"
}

content .= " </host>`r`n"
content .= "</teamtalk>`r`n"

FileDelete, %filename%
FileAppend, %content%, %filename%, UTF-8

MsgBox, 64, %T_Success%, %T_Generated%
ExitApp
return

Cancel:
GuiClose:
ExitApp
