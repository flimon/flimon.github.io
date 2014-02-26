
' 
' Autor: Fernando Limón
' Año: 2012
'
Const ForAppending = 2
'Const url = "http://api.wunderground.com/api/nnnnnnnnnnnnnnnn/conditions/q/pws:AAAAAAAAA.xml"
Const url1 = "http://api.wunderground.com/api/"
Const url2 = "/conditions/q/pws:"
'
' Personalización:
Const LimiteViento = 15 ' 15 Kmh
Const HumedadAlta = 80  ' 80% humedad relativa
strDirectory = "C:\VWS"
strFile = "\VWS.dat"
'
Const Despejado = 1
Const Nublado = 2
Const Calma = 1
Const Ventoso = 2
Const Seco = 1
Const Humedo = 2
Const Espera = 300      ' 300 segundos
Const Cancel = 2        ' Finalizar programa
Const Continuar = 11    ' Continuar sin visualizar ventana

Dim url
Dim objFSO, objFolder, objShell, objTextFile, objFile
Dim strDirectory, strFile
Dim xmltag(5)
Dim RC

xmltag(0) = "temp_c"
xmltag(1) = "wind_kph"
xmltag(2) = "relative_humidity"
xmltag(3) = "dewpoint_c"
xmltag(4) = "weather"



Function Pd(n, totalDigits) 
 if totalDigits > len(n) then 
    pd = String(totalDigits-len(n),"0") & n 
 else 
    pd = n 
 end if 
End Function 

Function Sd(n, totalDigits) 
 if totalDigits > len(n) then 
    sd = String(totalDigits-len(n)," ") & n 
 else 
    sd = n 
 end if 
End Function 

Sub WriteMeteo ()
  ' OpenTextFile Method needs a Const value
  set objFile = nothing
  set objFolder = nothing
  Set objTextFile = objFSO.OpenTextFile (strDirectory & strFile, ForAppending, True)
  set xmlDoc = createobject("Microsoft.XMLDOM")
  xmlDoc.async = "false"
  xmlDoc.load (url)

  objTextFile.Write(Year(Now()) & "-" & Pd(Month(Now()),2) & "-" & Pd(Day(Now()),2) & " ")
  strMsg = "Fecha/Hora: " & Year(Now()) & "-" & Pd(Month(Now()),2) & "-" & Pd(Day(Now()),2) & " / "
  objTextFile.Write(Pd(Hour(Now()),2) & ":" & Pd(Minute(Now()),2) & ":" & Pd(Second(Now()),2) & ".00 C K ")
  strMsg = strMsg & Pd(Hour(Now()),2) & ":" & Pd(Minute(Now()),2) & ":" & Pd(Second(Now()),2) & vbCrLf
  
  For Each tag in xmltag
	set xmlCol = xmldoc.getElementsByTagName(tag)
	For Each Elem In xmlCol
		Select Case tag
		Case xmltag(0)
		   objTextFile.Write(Sd(0,6) & " " & Sd(Elem.firstChild.nodeValue,6) & " " & Sd(0,6) & " ")
		   strMsg = strMsg & "Temperatura:" & Sd(Elem.firstChild.nodeValue,6) & "ºC" & vbCrLf
		Case xmltag(1)
		   objTextFile.Write(Sd(Elem.firstChild.nodeValue,6) & " ")
		   strMsg = strMsg & "Velocidad viento:" & Sd(Elem.firstChild.nodeValue,6) & "Km/h" & vbCrLf
		   Velocidad = Int(Replace(Elem.firstChild.nodeValue,".",","))
		   Wind = Calma
		   if (Velocidad >= LimiteViento) then 
			  Wind = Ventoso
		   end if
		Case xmltag(2)
		   Humedad = Int(Left(Elem.firstChild.nodeValue,(Len(Elem.firstChild.nodeValue)-1)))
		   objTextFile.Write(Sd(Humedad,3) & " ")
		   strMsg = strMsg & "Humedad:" & Sd(Humedad,3) & "%" & vbCrLf
		   Rain = Seco
		   if ( Humedad >= HumedadAlta) then 
			  Rain = Humedo
		   end if
		Case xmltag(3)
		   objTextFile.Write(Sd(Elem.firstChild.nodeValue,6) & " " & Sd(0,3) & " 0 0 00600 ")
		   strMsg = strMsg & "Rocio:" & Sd(Elem.firstChild.nodeValue,6) & "ºC" & vbCrLf
		Case xmltag(4) ' Options: Overcast / Mostly Cloudy / Scattered Clouds / Partly Cloudy / Clear
		   strMsg = strMsg & "Cielo: " & Elem.firstChild.nodeValue & vbCrLf
		   HayNubes = (Elem.firstChild.nodeValue <> "Partly Cloudy") and (Elem.firstChild.nodeValue <> "Clear")
		   Cloud = Despejado
		   if (HayNubes) then 
			   Cloud = Nublado
		   end if
		End Select
	Next
  Next

  Tiempo = CStr(FormatNumber((DateDiff("h", 0, Now())/24),5,,,0))
  Tiempo = Replace(Tiempo,",",".")
  objTextFile.Write (Pd(Tiempo,12) & " ")
  objTextFile.Write (Cloud & " " & Wind & " " & Rain & " " & "0")
  Set xmlCol = Nothing
  Set xmlDoc = Nothing
  objTextFile.Close
  
  if (RC <> Continuar) then 
     RC = WshShell.Popup(strMsg, Espera, "Virtual Weather Station Info", 6+64+256)
     if (RC = Cancel) then
        WScript.Quit
     end if
  else
     WScript.Sleep Espera*1000 ' Espera en milisegundos
  end if

End Sub



' Main
' ------------------------------------------------------------------
set WshShell = CreateObject("WScript.Shell")

if Wscript.Arguments.Count < 2 Then
    WScript.echo "Missing parameters. Usage: VWS api-key pws"
else
  url = url1 & Wscript.Arguments(0) & url2 & Wscript.Arguments(1) & ".xml"
  ' Create the File System Object
  Set objFSO = CreateObject("Scripting.FileSystemObject")
  ' Check that the strDirectory folder and strFile exists
  if objFSO.FolderExists(strDirectory) then
     Set objFolder = objFSO.GetFolder(strDirectory)
  else
     Set objFolder = objFSO.CreateFolder(strDirectory)
  end if
  if objFSO.FileExists(strDirectory & strFile) then
     Set objFolder = objFSO.GetFolder(strDirectory)
  else
     Set objFile = objFSO.CreateTextFile(strDirectory & strFile)
  end If

  ' Begin
  RC = 0
  while true
    Call WriteMeteo()
  wend
  ' End
  
end if