@echo off
title YouTube Downloader v1.1
color 0F

:: Use a local "bin" folder (next to this script) for dependencies like
:: yt-dlp.exe and ffmpeg.exe, in addition to anything already in PATH.
set "SCRIPT_DIR=%~dp0"
set "BIN_DIR=%SCRIPT_DIR%bin"
set "PATH=%BIN_DIR%;%PATH%"

:: First-run setup: if dependencies aren't in the bin folder yet,
:: run the installer automatically. Later runs skip this instantly.
if not exist "%BIN_DIR%\yt-dlp.exe" goto FIRSTRUN
if not exist "%BIN_DIR%\ffmpeg.exe" goto FIRSTRUN
goto CHECKS

:FIRSTRUN
if not exist "%SCRIPT_DIR%install.bat" (
    echo.
    echo ERROR: Dependencies are missing and install.bat was not found
    echo in "%SCRIPT_DIR%".
    pause
    exit
)
echo.
echo First run detected - setting up dependencies, please wait...
echo.
call "%SCRIPT_DIR%install.bat" /silent

:CHECKS
:: Check for yt-dlp
where yt-dlp >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: yt-dlp.exe not found.
    echo Run install.bat manually to download dependencies,
    echo or place yt-dlp.exe in "%BIN_DIR%".
    pause
    exit
)

:: Check for ffmpeg (needed for MP3 conversion, thumbnails, metadata)
where ffmpeg >nul 2>&1
if errorlevel 1 (
    echo.
    echo WARNING: ffmpeg.exe not found.
    echo MP3 conversion, thumbnails, and metadata embedding will fail.
    echo Run install.bat manually to download dependencies,
    echo or place ffmpeg.exe in "%BIN_DIR%".
    echo.
    pause
)

:MENU
cls
echo ============================================
echo           YouTube Downloader v1.1
echo ============================================
echo.
echo 1. Download Single Video
echo 2. Download Playlist
echo 3. Exit
echo.
set /p MODE=Select an option: 

if "%MODE%"=="1" goto FORMAT_SINGLE
if "%MODE%"=="2" goto FORMAT_PLAYLIST
if "%MODE%"=="3" exit

echo.
echo Invalid choice.
timeout /t 2 >nul
goto MENU

:FORMAT_SINGLE
cls
echo ================================
echo Single Video
echo ================================
echo.
echo 1. MP4 Video
echo 2. MP3 Audio
echo.
set /p FORMAT=Choose format: 

if "%FORMAT%"=="1" goto SINGLE_MP4
if "%FORMAT%"=="2" goto SINGLE_MP3

echo Invalid choice.
timeout /t 2 >nul
goto FORMAT_SINGLE

:FORMAT_PLAYLIST
cls
echo ================================
echo Playlist
echo ================================
echo.
echo 1. MP4 Video
echo 2. MP3 Audio
echo.
set /p FORMAT=Choose format: 

if "%FORMAT%"=="1" goto PLAYLIST_MP4
if "%FORMAT%"=="2" goto PLAYLIST_MP3

echo Invalid choice.
timeout /t 2 >nul
goto FORMAT_PLAYLIST

:GETINFO
echo.
set /p URL=Paste YouTube URL: 

set "DEFAULT_FOLDER=%USERPROFILE%\Downloads\%~1"

echo.
echo Press Enter to use your Downloads\%~1 folder.
set /p FOLDER=Download folder: 

if "%FOLDER%"=="" set "FOLDER=%DEFAULT_FOLDER%"

if not exist "%FOLDER%\" (
    echo.
    echo Folder does not exist, creating it...
    mkdir "%FOLDER%" 2>nul
    if errorlevel 1 (
        echo.
        echo ERROR: Could not create folder "%FOLDER%".
        echo Check that the drive letter/path is correct.
        pause
        goto MENU
    )
)

echo.
echo Downloading...
echo.

goto :eof

:SINGLE_MP4
call :GETINFO Video
yt-dlp --no-playlist -f "bv*+ba/b" ^
-o "%FOLDER%\%%(title)s.%%(ext)s" ^
"%URL%"
pause
goto MENU

:SINGLE_MP3
call :GETINFO Music
yt-dlp ^
--no-playlist ^
--extract-audio ^
--audio-format mp3 ^
--audio-quality 0 ^
--embed-thumbnail ^
--add-metadata ^
-o "%FOLDER%\%%(title)s.%%(ext)s" ^
"%URL%"
pause
goto MENU

:PLAYLIST_MP4
call :GETINFO Video
yt-dlp ^
-f "bv*+ba/b" ^
-o "%FOLDER%\%%(playlist_index)s - %%(title)s.%%(ext)s" ^
"%URL%"
pause
goto MENU

:PLAYLIST_MP3
call :GETINFO Music
yt-dlp ^
--extract-audio ^
--audio-format mp3 ^
--audio-quality 0 ^
--embed-thumbnail ^
--add-metadata ^
-o "%FOLDER%\%%(playlist_index)s - %%(title)s.%%(ext)s" ^
"%URL%"
pause
goto MENU