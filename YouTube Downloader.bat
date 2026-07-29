::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCmDJGqH5ksgPAhoVRDPOGeqOqwI5fiooeOErS0=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCmDJGqH5ksgPAhoVRDPOGeqOowT/dzu7e/KhkIKWu4wfIrJlLGWJYA=
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
title YouTube Downloader v1.1
color 0A

:: Use a local "bin" folder (next to this script) for dependencies like
:: yt-dlp.exe and ffmpeg.exe, in addition to anything already in PATH.
set "SCRIPT_DIR=%~dp0"
set "BIN_DIR=%SCRIPT_DIR%bin"
set "PATH=%BIN_DIR%;%PATH%"

:: Check for yt-dlp
where yt-dlp >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: yt-dlp.exe not found.
    echo Run install.bat first to download dependencies automatically,
    echo or place yt-dlp.exe manually in "%BIN_DIR%".
    pause
    exit
)

:: Check for ffmpeg (needed for MP3 conversion, thumbnails, metadata)
where ffmpeg >nul 2>&1
if errorlevel 1 (
    echo.
    echo WARNING: ffmpeg.exe not found.
    echo MP3 conversion, thumbnails, and metadata embedding will fail.
    echo Run install.bat first to download dependencies automatically,
    echo or place ffmpeg.exe manually in "%BIN_DIR%".
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

echo.
echo Press Enter to use your Downloads folder.
set /p FOLDER=Download folder: 

if "%FOLDER%"=="" set "FOLDER=%USERPROFILE%\Downloads"

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
call :GETINFO
yt-dlp --no-playlist -f "bv*+ba/b" ^
-o "%FOLDER%\%%(title)s.%%(ext)s" ^
"%URL%"
pause
goto MENU

:SINGLE_MP3
call :GETINFO
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
call :GETINFO
yt-dlp ^
-f "bv*+ba/b" ^
-o "%FOLDER%\%%(playlist_index)s - %%(title)s.%%(ext)s" ^
"%URL%"
pause
goto MENU

:PLAYLIST_MP3
call :GETINFO
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