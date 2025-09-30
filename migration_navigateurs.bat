@echo off
setlocal enabledelayedexpansion

echo.
echo === Debut de la sauvegarde des profils Firefox et Chrome ===
echo.

REM === Dossier de destination sur le partage reseau ===
set "BACKUP_DIR=P:\Profiles\%USERNAME%"
echo Dossier de sauvegarde : !BACKUP_DIR!
mkdir "!BACKUP_DIR!\Firefox\Profiles" 2>nul
mkdir "!BACKUP_DIR!\Chrome" 2>nul

REM === [1/2] Sauvegarde de Firefox ===
echo.
echo === [1/2] Sauvegarde de Firefox en cours... ===
set "FIREFOX_PROFILE_DIR=%APPDATA%\Mozilla\Firefox\Profiles"
if exist "!FIREFOX_PROFILE_DIR!" (
    for /d %%D in ("!FIREFOX_PROFILE_DIR!\*") do (
        echo Copie du profil Firefox : %%~nxD ...
        xcopy "%%D" "!BACKUP_DIR!\Firefox\Profiles\%%~nxD\" /E /I /Y /C >nul
        echo   Profil %%~nxD copie.
    )
    echo Copie de profiles.ini ...
    xcopy "%APPDATA%\Mozilla\Firefox\profiles.ini" "!BACKUP_DIR!\Firefox\" /Y >nul
    echo   profiles.ini copie.
) else (
    echo  Firefox non detecte sur ce poste.
)

REM === [2/2] Sauvegarde de Chrome ===
echo.
echo === [2/2] Sauvegarde de Chrome en cours... ===
set "CHROME_USERDATA_DIR=%LOCALAPPDATA%\Google\Chrome\User Data"
if exist "!CHROME_USERDATA_DIR!" (
    echo Copie du dossier Chrome ...
    xcopy "!CHROME_USERDATA_DIR!" "!BACKUP_DIR!\Chrome\" /E /I /Y /C >nul
    echo  Profils Chrome copies.
) else (
    echo Chrome non détecté sur ce poste.
)

echo.
echo Sauvegarde terminee avec succes !
echo Les donnees ont ete copiees dans :
echo !BACKUP_DIR!
echo.
pause
