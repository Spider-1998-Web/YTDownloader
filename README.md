# IT Downloader v1.1

IT Downloader is a Windows desktop application designed to download supported online videos and audio using a simple graphical interface.

Version 1.1 begins the migration from the previous PowerShell/PS2EXE implementation to a native C++ Windows application.

## Version 1.1 Status

This version Complete

The native C++ application has been successfully created and compiled using Visual Studio. The first test build confirms that the Windows GUI application and C++ development environment are working correctly.

## Current Progress

- [x] Visual Studio C++ development environment installed
- [x] Native Windows C++ project created
- [x] Windows GUI application successfully compiled
- [x] `WinMain()` entry point configured
- [x] First native C++ EXE successfully launched
- [ ] Command-line URL support
- [ ] Main downloader interface
- [ ] MP4 and MP3 format selection
- [ ] Playlist selection
- [ ] Download-folder selection
- [ ] `yt-dlp.exe` integration
- [ ] `ffmpeg.exe` integration
- [ ] Live download progress
- [ ] Download completion dialog
- [ ] Chrome extension integration
- [ ] Release build and testing

## Technology

The new application is being developed with:

- C++
- Native Windows API (Win32)
- Microsoft Visual Studio Community
- Windows SDK
- `yt-dlp`
- FFmpeg

## Project Structure

```text
IT-Downloader/
│
├── YTDownloaderCpp/
│   ├── main.cpp
│   ├── YTDownloaderCpp.sln
│   └── Additional C++ source files
│
├── Chrome-Extension/
│   ├── manifest.json
│   ├── background.js
│   ├── content.js
│   ├── popup.html
│   ├── popup.js
│   └── icons/
│
├── yt-dlp.exe
├── ffmpeg.exe
├── ffprobe.exe
└── README.md