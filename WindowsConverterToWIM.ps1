@echo off
set "ISOPath=%userprofile%\Downloads\windows.iso"
set "ExtractPath=%userprofile%\Downloads\Windows"

echo "Extrahiere Dateien aus der ISO: %ISOPath%"

:: Erstelle Zielordner
if not exist "%ExtractPath%" mkdir "%ExtractPath%"

:: Extrahiere die ISO-Datei mit 7-Zip
"C:\Program Files\7-Zip\7z.exe" x "%ISOPath%" -o"%ExtractPath%" -r -y

echo "Extrahieren abgeschlossen. Die Dateien wurden in den Ordner %ExtractPath% extrahiert."

echo "Führe DISM-Befehle aus:"
set "WIMPath=%userprofile%\Downloads\Windows\Sources\install.wim"

dism /Get-WimInfo /WimFile:"%ExtractPath%\sources\install.esd"
dism /export-image /SourceImageFile:"%ExtractPath%\sources\install.esd" /SourceIndex:5 /DestinationImageFile:"%WIMPath%" /Compress:max /CheckIntegrity

echo "DISM-Befehle abgeschlossen."
