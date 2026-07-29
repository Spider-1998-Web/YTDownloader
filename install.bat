@echo off
title YouTube Downloader - Installer
color 0A

set "SCRIPT_DIR=%~dp0"
set "BIN_DIR=%SCRIPT_DIR%bin"
set "TEMP_DIR=%SCRIPT_DIR%install_temp"

echo ============================================
echo   YouTube Downloader - Dependency Installer
echo ============================================
echo.

if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

:: --- yt-dlp ---
echo Downloading yt-dlp...
curl -L -o "%BIN_DIR%\yt-dlp.exe" "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
if not exist "%BIN_DIR%\yt-dlp.exe" (
    echo.
    echo ERROR: Failed to download yt-dlp.exe
    echo Check your internet connection and try again.
    pause
    exit /b 1
)
echo Done.
echo.

:: --- ffmpeg ---
echo Downloading ffmpeg (this is a larger file, may take a minute)...
curl -L -o "%TEMP_DIR%\ffmpeg.zip" "https://github.com/BtbN/FFmpeg-Builds/releases/latest/download/ffmpeg-master-latest-win64-gpl.zip"
if not exist "%TEMP_DIR%\ffmpeg.zip" (
    echo.
    echo ERROR: Failed to download ffmpeg.
    echo Check your internet connection and try again.
    pause
    exit /b 1
)

echo Extracting ffmpeg...
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
echo ============================================
echo   Installation complete!
echo   yt-dlp and ffmpeg are ready in: %BIN_DIR%
echo   You can now run ytmp3.bat
echo ============================================
echo.
pause
