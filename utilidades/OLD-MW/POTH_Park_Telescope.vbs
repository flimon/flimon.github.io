' 
' Autor: Fernando Limon - MPC I99
' 2015-05
' Rev. 1.0
'

' Declaracion de variables
Dim Telescopio

' Conectamos telescopio
Set Telescopio = CreateObject("Poth.Telescope")
Telescopio.Connected = True
if Not Telescopio.Connected Then 
	WScript.echo "Error en conexi�n al telescopio" 
	WScript.Quit
End If 

' Park el telescopio
Telescopio.Park

' End Main
