@echo off
rem Installs MacDock for the current user (no admin needed) into %LOCALAPPDATA%\MacDock and starts it.
setlocal
set "SRC=%~dp0"
set "DEST=%LOCALAPPDATA%\MacDock"
if not exist "%SRC%bin\MacDock.exe" (
    echo bin\MacDock.exe not found - building it from source with the compiler built into Windows...
    call "%SRC%mac-dock\build.bat" nopause
    if not exist "%SRC%mac-dock\MacDock.exe" ( echo Build failed. & pause & exit /b 1 )
    mkdir "%SRC%bin" 2>nul
    copy /Y "%SRC%mac-dock\MacDock.exe" "%SRC%bin\MacDock.exe" >nul
    copy /Y "%SRC%mac-dock\MacDock.exe.config" "%SRC%bin\MacDock.exe.config" >nul 2>&1
    if exist "%SRC%mac-dock\fonts" xcopy "%SRC%mac-dock\fonts" "%SRC%bin\fonts\" /E /I /Y /Q >nul
    if exist "%SRC%mac-dock\icons" xcopy "%SRC%mac-dock\icons" "%SRC%bin\icons\" /E /I /Y /Q >nul
)
echo Installing MacDock (open source, per-user, no admin) to %DEST%
taskkill /f /im MacDock.exe >nul 2>&1
mkdir "%DEST%" 2>nul
xcopy "%SRC%bin" "%DEST%\bin\" /E /I /Y /Q >nul
if exist "%SRC%icons" xcopy "%SRC%icons" "%DEST%\icons\" /E /I /Y /Q >nul
if exist "%SRC%dark-icons" xcopy "%SRC%dark-icons" "%DEST%\dark-icons\" /E /I /Y /Q >nul
copy /Y "%SRC%Uninstall.bat" "%DEST%\Uninstall.bat" >nul 2>&1
echo Creating Start Menu shortcut...
rem Start Menu shortcut
powershell -NoProfile -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut([Environment]::GetFolderPath('Programs')+'\MacDock.lnk');$s.TargetPath='%DEST%\bin\MacDock.exe';$s.WorkingDirectory='%DEST%\bin';$s.Save()" >nul 2>&1
start "" "%DEST%\bin\MacDock.exe"
echo MacDock installed to %DEST% and started. It starts at login by default (toggle in Settings).
pause
