@echo off
echo.
echo  --- NPM Tools (Claude Code MCP) ---
echo.

set "PATH=%PROGRAMFILES%\nodejs;%APPDATA%\npm;%PATH%"
call npm install -g @sarmadparvez/postgresql-mcp
call npm install -g @iforge.it/mssql-mcp
