@echo off
setlocal EnableDelayedExpansion

REM =====================================================================
REM Windows Setup — modular one-click installer
REM Run as Administrator for best results
REM
REM Each module in modules/ is independent and can be run separately.
REM This script runs them all in order.
REM =====================================================================

echo.
echo  ========================================
echo   Windows Fresh Setup
echo  ========================================
echo.

REM --- Check and install winget ---
where winget >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [0] winget not found -- installing via official Microsoft script...
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "$ProgressPreference='SilentlyContinue'; irm https://raw.githubusercontent.com/asheroto/winget-install/master/winget-install.ps1 | iex"
)

REM Refresh PATH and locate winget (may be in WindowsApps or Program Files)
set "PATH=%LOCALAPPDATA%\Microsoft\WindowsApps;%PROGRAMFILES%\WinGet\Links;%PATH%"
where winget >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install winget. Install manually from https://aka.ms/getwinget
    pause
    exit /b 1
)

set "SCRIPT_DIR=%~dp0"

call "%SCRIPT_DIR%modules\01-core-apps.bat"
call "%SCRIPT_DIR%modules\02-dev-tools.bat"
call "%SCRIPT_DIR%modules\03-terminal-tools.bat"
call "%SCRIPT_DIR%modules\04-npm-tools.bat"
call "%SCRIPT_DIR%modules\05-git-config.bat"
call "%SCRIPT_DIR%modules\06-powershell-profile.bat"
call "%SCRIPT_DIR%modules\07-windows-terminal.bat"
call "%SCRIPT_DIR%modules\08-claude-config.bat"

echo.
echo  ========================================
echo   Setup complete!
echo  ========================================
echo.
echo  To sync secrets: pwsh -File setup-secrets.ps1
echo.
echo  Next: close this window, open Windows Terminal
echo.
pause
