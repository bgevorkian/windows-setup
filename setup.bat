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
    echo [0] winget not found — installing with dependencies...
    powershell -NoProfile -Command ^
        "$ProgressPreference='SilentlyContinue'; " ^
        "irm https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile $env:TEMP\vclibs.appx; " ^
        "Add-AppxPackage $env:TEMP\vclibs.appx; " ^
        "irm https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile $env:TEMP\xaml.appx; " ^
        "Add-AppxPackage $env:TEMP\xaml.appx; " ^
        "irm https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile $env:TEMP\winget.msixbundle; " ^
        "Add-AppxPackage $env:TEMP\winget.msixbundle"
    set "PATH=%LOCALAPPDATA%\Microsoft\WindowsApps;%PATH%"
    where winget >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Failed to install winget. Install manually from https://aka.ms/getwinget
        pause
        exit /b 1
    )
    echo winget installed successfully.
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
