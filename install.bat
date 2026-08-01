@echo off
title YouTube Downloader - Installer
color 0F

set "SCRIPT_DIR=%~dp0"
set "BIN_DIR=%SCRIPT_DIR%bin"
set "TEMP_DIR=%SCRIPT_DIR%install_temp"

:: Pass /silent (e.g. called automatically from ytmp3.bat) to skip pauses
:: on success. Errors still pause so the problem is visible either way.
set "SILENT=0"
if /i "%~1"=="/silent" set "SILENT=1"

echo ============================================
echo   YouTube Downloader - Dependency Installer
echo ============================================
echo.

if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

:: --- yt-dlp ---
echo [1/4] yt-dlp
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%download_progress.ps1" ^
    -Url "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" ^
    -OutFile "%BIN_DIR%\yt-dlp.exe" -Label "  Downloading yt-dlp.exe"
if not exist "%BIN_DIR%\yt-dlp.exe" (
    echo.
    echo ERROR: Failed to download yt-dlp.exe
    echo Check your internet connection and try again.
    pause
    exit /b 1
)
echo.

:: --- ffmpeg ---
echo [2/4] ffmpeg
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%download_progress.ps1" ^
    -Url "https://github.com/BtbN/FFmpeg-Builds/releases/latest/download/ffmpeg-master-latest-win64-gpl.zip" ^
    -OutFile "%TEMP_DIR%\ffmpeg.zip" -Label "  Downloading ffmpeg.zip"
if not exist "%TEMP_DIR%\ffmpeg.zip" (
    echo.
    echo ERROR: Failed to download ffmpeg.
    echo Check your internet connection and try again.
    pause
    exit /b 1
)
echo.

echo [3/4] Extracting ffmpeg
powershell -NoProfile -Command "Expand-Archive -Force '%TEMP_DIR%\ffmpeg.zip' '%TEMP_DIR%\ffmpeg_extracted'"

:: The zip contains a versioned subfolder like ffmpeg-master-latest-win64-gpl\bin
for /d %%D in ("%TEMP_DIR%\ffmpeg_extracted\*") do (
    if exist "%%D\bin\ffmpeg.exe" (
        copy /y "%%D\bin\ffmpeg.exe" "%BIN_DIR%\ffmpeg.exe" >nul
        copy /y "%%D\bin\ffprobe.exe" "%BIN_DIR%\ffprobe.exe" >nul
    )
)

if not exist "%BIN_DIR%\ffmpeg.exe" (
    echo.
    echo ERROR: Could not locate ffmpeg.exe after extraction.
    echo You may need to place it in "%BIN_DIR%" manually.
    pause
) else (
    echo Done.
)

echo.
echo Cleaning up temporary files...
rmdir /s /q "%TEMP_DIR%"

echo.
set "BRIDGE_DIR=%SCRIPT_DIR%browser-bridge"
if exist "%BRIDGE_DIR%\register_protocol.bat" (
    echo [4/4] Browser integration
    call "%BRIDGE_DIR%\register_protocol.bat" /silent
    if exist "%BRIDGE_DIR%\register_protocol.bat" echo Done.
    set "DID_REGISTER=1"
) else (
    set "DID_REGISTER=0"
)

echo.
echo ============================================
echo   Installation complete!
echo   yt-dlp and ffmpeg are ready in: %BIN_DIR%
echo   You can now run ytmp3.bat
echo ============================================
if "%DID_REGISTER%"=="1" (
    echo.
    echo One manual step remains for the browser download button:
    echo   1. Open Chrome and go to chrome://extensions
    echo   2. Turn on "Developer mode" ^(top right^)
    echo   3. Click "Load unpacked" and select the "browser-extension" folder
    echo   Chrome does not allow this step to be automated for security reasons.
)
echo.
if "%SILENT%"=="0" pause