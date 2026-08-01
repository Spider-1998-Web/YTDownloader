param(
    [Parameter(Position = 0)][string]$RawArg
)

Add-Type -AssemblyName System.Windows.Forms

if ([string]::IsNullOrWhiteSpace($RawArg)) {
    [System.Windows.Forms.MessageBox]::Show("No video URL was received.", "YT Downloader") | Out-Null
    exit 1
}

# Strip the "ytdlp://" scheme and decode the URL that was passed in
$encoded = $RawArg -replace '^ytdlp://', ''
$videoUrl = [System.Uri]::UnescapeDataString($encoded)

# Locate bin\yt-dlp.exe relative to this script (repo\browser-bridge\..\bin)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$BinDir = Join-Path $RepoRoot "bin"
$YtDlp = Join-Path $BinDir "yt-dlp.exe"

if (-not (Test-Path $YtDlp)) {
    [System.Windows.Forms.MessageBox]::Show(
        "yt-dlp.exe was not found in:`n$BinDir`n`nRun install.bat in the main project folder first.",
        "YT Downloader"
    ) | Out-Null
    exit 1
}

$choice = [System.Windows.Forms.MessageBox]::Show(
    "Download this video as MP3 audio instead of MP4 video?`n`nYes = MP3 audio`nNo = MP4 video`nCancel = don't download",
    "YT Downloader",
    [System.Windows.Forms.MessageBoxButtons]::YesNoCancel,
    [System.Windows.Forms.MessageBoxIcon]::Question
)

if ($choice -eq [System.Windows.Forms.DialogResult]::Cancel) {
    exit 0
}

if ($choice -eq [System.Windows.Forms.DialogResult]::Yes) {
    $formatArgs = '--extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata'
    $downloadsFolder = Join-Path $env:USERPROFILE "Downloads\Music"
} else {
    $formatArgs = '-f "bv*+ba/b"'
    $downloadsFolder = Join-Path $env:USERPROFILE "Downloads\Video"
}

if (-not (Test-Path $downloadsFolder)) {
    New-Item -ItemType Directory -Path $downloadsFolder -Force | Out-Null
}

# Write the yt-dlp command to a small helper .bat so quoting stays simple,
# and so the user sees yt-dlp's own live progress bar in a normal console
# window. This file is overwritten (not deleted) on each run.
$tempBat = Join-Path $env:TEMP "ytdlp_browser_request.bat"

$batContent = @"
@echo off
title YT Downloader - Browser Request
color 0F
"$YtDlp" --no-playlist $formatArgs -o "$downloadsFolder\%%(title)s.%%(ext)s" "$videoUrl"
echo.
echo Done. You can close this window.
pause >nul
"@

Set-Content -Path $tempBat -Value $batContent -Encoding ASCII
Start-Process -FilePath $tempBat