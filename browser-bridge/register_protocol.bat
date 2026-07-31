@echo off
title Register ytdlp:// Protocol
color 0F

set "SCRIPT_DIR=%~dp0"
set "HANDLER=%SCRIPT_DIR%handle_download.ps1"

echo ============================================
echo   YT Downloader - Browser Link Registration
echo ============================================
echo.

if not exist "%HANDLER%" (
    echo ERROR: handle_download.ps1 not found in this folder.
    pause
    exit /b 1
)

reg add "HKCU\Software\Classes\ytdlp" /ve /d "URL:YTDLP Protocol" /f >nul
reg add "HKCU\Software\Classes\ytdlp" /v "URL Protocol" /d "" /f >nul
reg add "HKCU\Software\Classes\ytdlp\shell\open\command" /ve /d "powershell.exe -NoProfile -ExecutionPolicy Bypass -File \"%HANDLER%\" \"%%1\"" /f >nul

if errorlevel 1 (
    echo.
    echo ERROR: Could not register the protocol.
    pause
    exit /b 1
)

echo.
echo Done! The "ytdlp://" link type is now registered for your user account.
echo.
echo Next steps:
echo   1. Load the browser-extension folder into Chrome
echo      (chrome://extensions -^> Developer mode -^> Load unpacked)
echo   2. Open a YouTube video and click the Download button
echo   3. Chrome will ask permission to open "YT Downloader" the first
echo      time - allow it, and it will remember your choice after that.
echo.
pause
