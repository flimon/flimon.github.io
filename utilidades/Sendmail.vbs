' Sendmail.vbs
' Autor: Fernando Limon - MPC I99
' 2014-05-04
' Rev. 1.0
'
Dim Msg, Conf

Set Msg = CreateObject("CDO.Message")
Set Conf = CreateObject("CDO.Configuration")

schema = "http://schemas.microsoft.com/cdo/configuration/"
Conf.Fields.Item(schema & "sendusing") = 2
Conf.Fields.Item(schema & "smtpserver") = "smtp.gmail.com" 
Conf.Fields.Item(schema & "smtpserverport") = 465
Conf.Fields.Item(schema & "smtpauthenticate") = 1
Conf.Fields.Item(schema & "sendusername") = "mi_cuenta_de_usuario_en_gmail"
Conf.Fields.Item(schema & "sendpassword") =  "password"
Conf.Fields.Item(schema & "smtpusessl") = 1
Conf.Fields.Update

With Msg
.To = "mi_cuenta@dominio"
.From = "mi_cuenta@dominio"
.Subject = WScript.Arguments(0)
.TextBody = WScript.Arguments(1)
Set .Configuration = Conf
.Send
End With

set Msg = nothing
set Conf = nothing