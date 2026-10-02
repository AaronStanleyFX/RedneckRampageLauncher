@echo off
rem Alternative to the .exe : starts the launcher with PowerShell
start "" powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -STA -File "%~dp0Launcher\RR_Launcher.ps1"
