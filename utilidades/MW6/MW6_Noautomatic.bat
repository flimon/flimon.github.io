@echo off
SET FicheroNoautomatic="MeteoWatcher6.Noautomatic"
SET FicheroAutomatic="MeteoWatcher6.Automatic"

IF NOT EXIST %USERPROFILE%\Documents\MeteoWatcher6\%FicheroNoautomatic% (
	echo %date% %time% > %USERPROFILE%\Documents\MeteoWatcher6\%FicheroNoautomatic%
	IF EXIST %USERPROFILE%\Documents\MeteoWatcher6\%Ficheroautomatic% erase %USERPROFILE%\Documents\MeteoWatcher6\%Ficheroautomatic%
)