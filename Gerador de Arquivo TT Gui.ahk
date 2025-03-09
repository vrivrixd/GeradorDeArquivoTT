#SingleInstance Force
SetWorkingDir %A_ScriptDir%

Gui +LastFound
Gui, Add, Text, x10 y10, Nome do servidor:
Gui, Add, Edit, x150 y10 w200 vttname

Gui, Add, Text, x10 y40, Endereço do servidor:
Gui, Add, Edit, x150 y40 w200 vttaddress

Gui, Add, Text, x10 y70, Porta TCP:
Gui, Add, Edit, x150 y70 w200 vtcpport, 10333

Gui, Add, Text, x10 y100, Porta UDP:
Gui, Add, Edit, x150 y100 w200 vudpport, 10333

Gui, Add, Text, x10 y130, Servidor Criptografado
Gui, Add, CheckBox, x150 y130 vencrypted

Gui, Add, Text, x10 y160, Nome de usuário:
Gui, Add, Edit, x150 y160 w200 vusername

Gui, Add, Text, x10 y190, Senha:
Gui, Add, Edit, x150 y190 w170 vpassword Password
Gui, Add, Button, x330 y187 w50 h20 gTogglePass1 vPassBtn1, Mostrar

Gui, Add, Text, x10 y220, Apelido (opcional):
Gui, Add, Edit, x150 y220 w200 vnickname

Gui, Add, Text, x10 y250, Canal (opcional):
Gui, Add, Edit, x150 y250 w200 vchannel

Gui, Add, Text, x10 y280, Senha do canal:
Gui, Add, Edit, x150 y280 w170 vchannelpass Password
Gui, Add, Button, x330 y277 w50 h20 gTogglePass2 vPassBtn2, Mostrar

Gui, Add, Button, x150 y320 w100 gGenerate, Gerar Arquivo
Gui, Add, Button, x260 y320 w100 gCancel, Cancelar

Gui, Show, w400 h360, Gerador de arquivo .TT
return

TogglePass1:
GuiControlGet, currentText,, PassBtn1
Gui, Submit, NoHide
if (currentText = "Mostrar") {
    GuiControl, -Password, password
    GuiControl,, PassBtn1, Ocultar
} else {
    GuiControl, +Password, password
    GuiControl,, PassBtn1, Mostrar
}
GuiControl,, password, %password%
return

TogglePass2:
GuiControlGet, currentText,, PassBtn2
Gui, Submit, NoHide
if (currentText = "Mostrar") {
    GuiControl, -Password, channelpass
    GuiControl,, PassBtn2, Ocultar
} else {
    GuiControl, +Password, channelpass
    GuiControl,, PassBtn2, Mostrar
}
GuiControl,, channelpass, %channelpass%
return

Generate:
Gui, Submit
if (!ttname || !ttaddress || !tcpport || !udpport || !username) {
    MsgBox, 48, Erro, Por favor, preencha todos os campos obrigatórios!
    Gui, Show
    return
}

FileSelectFile, filename, S16, , Salvar, TeamTalk Host Settings (*.tt)
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

MsgBox, 64, Êxito, Arquivo gerado com sucesso.
ExitApp
return

Cancel:
GuiClose:
ExitApp