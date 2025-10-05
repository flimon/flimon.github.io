@echo off
SET FicheroLock="MeteoWatcher6.lock"
SET FicheroUnlock="MeteoWatcher6.unlock"

IF NOT EXIST %USERPROFILE%\Documents\MeteoWatcher6\%FicheroUnlock% (
	echo %date% %time% > %USERPROFILE%\Documents\MeteoWatcher6\%FicheroUnlock%
	IF EXIST %USERPROFILE%\Documents\MeteoWatcher6\%FicheroLock% erase %USERPROFILE%\Documents\MeteoWatcher6\%FicheroLock%
)
