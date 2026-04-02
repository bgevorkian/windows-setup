@echo off
REM Wrapper: launches setup.ps1 with elevated PowerShell
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1"
pause
