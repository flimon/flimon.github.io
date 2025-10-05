@echo off
SET FicheroLock="MeteoWatcher6.lock"
SET FicheroUnlock="MeteoWatcher6.unlock"

IF NOT EXIST %USERPROFILE%\Documents\MeteoWatcher6\%FicheroLock% (
	echo %date% %time% > %USERPROFILE%\Documents\MeteoWatcher6\%FicheroLock%
	IF EXIST %USERPROFILE%\Documents\MeteoWatcher6\%FicheroUnlock% erase %USERPROFILE%\Documents\MeteoWatcher6\%FicheroUnlock%
)
