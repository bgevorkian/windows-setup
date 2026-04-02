@echo off
echo.
echo  --- Claude Code Config ---
echo.

set "CLAUDE_DIR=%USERPROFILE%\.claude"
if not exist "%CLAUDE_DIR%" mkdir "%CLAUDE_DIR%"

set "TEMP_CLONE=%TEMP%\claude-config-clone"
if exist "%TEMP_CLONE%" rmdir /s /q "%TEMP_CLONE%"

REM Refresh PATH so git installed in module 01 is available
set "PATH=%PROGRAMFILES%\Git\cmd;%PATH%"

echo Cloning claude-config from GitHub...
git clone https://github.com/bgevorkian/claude-config.git "%TEMP_CLONE%" 2>nul

if not exist "%TEMP_CLONE%\CLAUDE.md" (
    echo [ERROR] Failed to clone claude-config repo.
    exit /b 1
)

copy "%TEMP_CLONE%\CLAUDE.md" "%CLAUDE_DIR%\CLAUDE.md" >nul
echo   Copied CLAUDE.md

copy "%TEMP_CLONE%\settings.json" "%CLAUDE_DIR%\settings.json" >nul
echo   Copied settings.json

xcopy "%TEMP_CLONE%\commands" "%CLAUDE_DIR%\commands\" /E /I /Y >nul
echo   Copied commands/

xcopy "%TEMP_CLONE%\skills" "%CLAUDE_DIR%\skills\" /E /I /Y >nul
echo   Copied skills/

copy "%TEMP_CLONE%\mcp\prefectum.mcp.json" "%CLAUDE_DIR%\mcp.json" >nul
echo   Copied MCP template to %CLAUDE_DIR%\mcp.json

rmdir /s /q "%TEMP_CLONE%" 2>nul
echo Claude Code config installed.
