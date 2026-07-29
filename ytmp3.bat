@echo off
title YouTube Downloader v1.1
color 0A

:: Check for yt-dlp
where yt-dlp >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: yt-dlp is not installed or not in PATH.
    pause
    exit
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

echo.
echo Downloading...
echo.

goto :eof

:SINGLE_MP4
call :GETINFO
yt-dlp -f "bv*+ba/b" ^
-o "%FOLDER%\%%(title)s.%%(ext)s" ^
"%URL%"
pause
goto MENU

:SINGLE_MP3
call :GETINFO
yt-dlp ^
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