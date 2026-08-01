@echo off
title Register ytdlp:// Protocol
color 0F

set "SCRIPT_DIR=%~dp0"
set "HANDLER_EXE=%SCRIPT_DIR%handle_download.exe"
set "HANDLER_PS1=%SCRIPT_DIR%handle_download.ps1"

set "SILENT=0"
if /i "%~1"=="/silent" set "SILENT=1"

if "%SILENT%"=="0" (
    echo ============================================
    echo   YT Downloader - Browser Link Registration
    echo ============================================
    echo.
)

if not exist "%HANDLER_EXE%" if not exist "%HANDLER_PS1%" (
    echo ERROR: No handler found ^(expected handle_download.exe or
    echo handle_download.ps1^) in this folder.
    if "%SILENT%"=="0" pause
    exit /b 1
)

reg add "HKCU\Software\Classes\ytdlp" /ve /d "URL:YTDLP Protocol" /f >nul
reg add "HKCU\Software\Classes\ytdlp" /v "URL Protocol" /d "" /f >nul

if exist "%HANDLER_EXE%" (
    reg add "HKCU\Software\Classes\ytdlp\shell\open\command" /ve /d "\"%HANDLER_EXE%\" \"%%1\"" /f >nul
) else (
    reg add "HKCU\Software\Classes\ytdlp\shell\open\command" /ve /d "powershell.exe -NoProfile -ExecutionPolicy Bypass -File \"%HANDLER_PS1%\" \"%%1\"" /f >nul
)

if errorlevel 1 (
    echo.
    echo ERROR: Could not register the protocol.
    if "%SILENT%"=="0" pause
    exit /b 1
)

if "%SILENT%"=="0" (
    echo.
    echo Done! The "ytdlp://" link type is now registered for your user account.
    echo.
    echo Next steps:
    echo   1. Load the browser-extension folder into Chrome
    echo      ^(chrome://extensions -^> Developer mode -^> Load unpacked^)
    echo   2. Open a YouTube video and click the Download button
    echo   3. Chrome will ask permission to open "YT Downloader" the first
    echo      time - allow it, and it will remember your choice after that.
    echo.
    pause
)
