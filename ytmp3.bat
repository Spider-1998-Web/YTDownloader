@echo off
title YouTube Playlist to MP3 Downloader
echo ============================================
echo   YouTube Playlist to MP3 Downloader
echo   Powered by yt-dlp + ffmpeg
echo ============================================
echo.

:: Ask for playlist URL
set /p url=Enter the YouTube playlist URL: 

:: Ask for download folder
set /p folder=Enter the download location (e.g. C:\Music): 

:: If nothing entered, default to Downloads
if "%folder%"=="" set folder=%USERPROFILE%\Downloads

:: Create folder if it doesn't exist
if not exist "%folder%" (
    mkdir "%folder%"
)

echo.
echo Downloading playlist...

yt-dlp -f "bestaudio[ext=m4a]/bestaudio" ^
--extract-audio ^
--audio-format mp3 ^
--audio-quality 0 ^
--add-metadata ^
--embed-thumbnail ^
--no-playlist-reverse ^
--compat-options no-youtube-unavailable-videos ^
-o "%folder%\%%(playlist_index)s - %%(title)s.%%(ext)s" ^
"%url%"

echo.
echo Done! All files saved in: %folder%
pause