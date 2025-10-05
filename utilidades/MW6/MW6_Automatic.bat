@echo off
SET FicheroNoautomatic="MeteoWatcher6.Noautomatic"
SET FicheroAutomatic="MeteoWatcher6.Automatic"

IF NOT EXIST %USERPROFILE%\Documents\MeteoWatcher6\%FicheroAutomatic% (
	echo %date% %time% > %USERPROFILE%\Documents\MeteoWatcher6\%FicheroAutomatic%
	IF EXIST %USERPROFILE%\Documents\MeteoWatcher6\%FicheroNoautomatic% erase %USERPROFILE%\Documents\MeteoWatcher6\%FicheroNoautomatic%
)
