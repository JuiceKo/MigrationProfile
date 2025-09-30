@echo off
setlocal enabledelayedexpansion

echo === Debut de la restauration des profils Firefox et Chrome ===
echo.

REM === Chemin initial basé sur %USERNAME% ===
set "BACKUP_DIR=P:\Profiles\%USERNAME%"
if not exist "!BACKUP_DIR!" (
    echo Le dossier "!BACKUP_DIR!" n'existe pas.
    set /p INPUT_NAME=Entrez manuellement le nom du dossier de l'utilisateur sur le NAS :
    set "BACKUP_DIR=\\ds415\partage\Profiles\!INPUT_NAME!"

    if not exist "!BACKUP_DIR!" (
        echo Le dossier "!BACKUP_DIR!" est introuvable. Abandon.
        pause
        exit /b
    )
)

REM === === === FIREFOX === === ===
echo [1/2] Restauration de Firefox...

set "FIREFOX_APPDATA=%APPDATA%\Mozilla\Firefox"
set "FIREFOX_BACKUP=!BACKUP_DIR!\Firefox"

REM Sauvegarder les anciens profils Firefox s’ils existent
if exist "!FIREFOX_APPDATA!\Profiles" (
    echo Renommage de l'ancien dossier Profiles en Profiles.old
    if exist "!FIREFOX_APPDATA!\Profiles.old" (
        echo Suppression de l'ancien backup Firefox existant
        rmdir /S /Q "!FIREFOX_APPDATA!\Profiles.old"
    )
    move "!FIREFOX_APPDATA!\Profiles" "!FIREFOX_APPDATA!\Profiles.old" >nul
)

if exist "!FIREFOX_APPDATA!\profiles.ini" (
    echo Renommage de profiles.ini en profiles.ini.old
    del /Q "!FIREFOX_APPDATA!\profiles.ini.old" >nul 2>&1
    move "!FIREFOX_APPDATA!\profiles.ini" "!FIREFOX_APPDATA!\profiles.ini.old" >nul
)

if exist "!FIREFOX_APPDATA!\installs.ini" (
    echo Renommage de installs.ini en installs.ini.old
    del /Q "!FIREFOX_APPDATA!\installs.ini.old" >nul 2>&1
    move "!FIREFOX_APPDATA!\installs.ini" "!FIREFOX_APPDATA!\installs.ini.old" >nul
)

mkdir "!FIREFOX_APPDATA!\Profiles"

xcopy "!FIREFOX_BACKUP!\Profiles" "!FIREFOX_APPDATA!\Profiles" /E /I /Y /C >nul
xcopy "!FIREFOX_BACKUP!\profiles.ini" "!FIREFOX_APPDATA!\" /Y /C >nul

echo Firefox restaure avec succes.
echo.

REM === === === CHROME === === ===
echo [2/2] Restauration de Chrome...

set "CHROME_LOCALAPPDATA=%LOCALAPPDATA%\Google\Chrome\User Data"
set "CHROME_BACKUP=!BACKUP_DIR!\Chrome"

if exist "!CHROME_LOCALAPPDATA!" (
    echo Renommage de l'ancien dossier Chrome en Chrome.old
    if exist "!CHROME_LOCALAPPDATA!.old" (
        echo Suppression de l'ancien backup Chrome  existant
        rmdir /S /Q "!CHROME_LOCALAPPDATA!.old"
    )
    move "!CHROME_LOCALAPPDATA!" "!CHROME_LOCALAPPDATA!.old" >nul
)

xcopy "!CHROME_BACKUP!" "!CHROME_LOCALAPPDATA!\" /E /I /Y /C >nul

echo Chrome restaure avec succes.
echo.
echo Restauration terminee avec succes.
pause
